import 'package:flutter/material.dart';
import 'package:flutter_latihan1/models/user_model.dart';
import 'package:flutter_latihan1/screens/register_screen.dart';
import 'package:flutter_latihan1/screens/home_screen.dart';
import '../services/auth_service.dart';
import 'verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _rememberMe = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _headerScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingGoogleUser();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _headerScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  // 🎯 METHOD BARU: Cek apakah sudah ada user Google yang login
  Future<void> _checkExistingGoogleUser() async {
    try {
      final currentUser = await _authService.getCurrentGoogleUser();
      if (currentUser != null) {
        print('🔍 Found existing Google user: ${currentUser.email}');
        // Bisa tambahkan auto-login di sini jika diperlukan
      }
    } catch (e) {
      print('⚠️ Error checking existing Google user: $e');
    }
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    // Validasi email kosong
    if (email.isEmpty) {
      _showError('Email tidak boleh kosong');
      return;
    }

    // Validasi format email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Format email tidak valid');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Kirim OTP langsung - backend akan handle validasi email
      final otpResponse = await _authService.sendOtp(email);

      _showSuccess('OTP telah dikirim ke $email');

      // Navigate ke OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(
            email: email,
            onResendOtp: () => _resendOtp(email),
          ),
        ),
      );
    } catch (e) {
      // Handle error khusus untuk email tidak ditemukan
      if (e.toString().contains('Email tidak ditemukan')) {
        _showEmailNotRegisteredDialog(email);
      } else {
        _showError('Gagal mengirim OTP: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🎯 METHOD BARU: Resend OTP
  Future<void> _resendOtp(String email) async {
    try {
      await _authService.resendOtp(email);
      _showSuccess('OTP berhasil dikirim ulang');
    } catch (e) {
      _showError('Gagal mengirim ulang OTP: $e');
    }
  }

  // 🔐 GOOGLE SIGN IN - DENGAN VALIDASI EMAIL
  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      print('🎯 Starting Google sign in process...');

      final AuthResponse result = await _authService.signInWithGoogle();

      if (result.user != null) {
        print('✅ Google sign in successful!');
        print('👤 User: ${result.user?.name}');
        print('📧 Email: ${result.user?.email}');
        print('🔑 Token: ${result.accessToken != null ? '✓' : '✗'}');

        _showSuccess('Login dengan Google berhasil!');

        // Simpan data auth
        _saveAuthData(result);

        // Navigate ke home screen
        _navigateToHome(result);
      } else {
        throw Exception('User data tidak ditemukan dari backend');
      }
    } catch (e) {
      print('❌ Google sign in failed: $e');

      // Handle error spesifik untuk Google Sign In
      if (e.toString().contains('ApiException: 10')) {
        _showGooglePlayServicesError();
      } else {
        _showGoogleSignInError(e);
      }
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  // 🎯 METHOD BARU: Handle error Google Play Services
  void _showGooglePlayServicesError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.orange),
              SizedBox(width: 8),
              Text('Google Play Services Required'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Google Play Services tidak tersedia atau perlu diupdate.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text('Pastikan:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Google Play Services terinstall'),
              Text('• Koneksi internet stabil'),
              Text('• Device support Google Play'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Bisa tambahkan logika untuk membuka Play Store
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D6EFD),
              ),
              child: Text('Buka Play Store'),
            ),
          ],
        );
      },
    );
  }

  // 🎯 METHOD BARU: Dialog email tidak terdaftar
  void _showEmailNotRegisteredDialog(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add_alt_1, color: Colors.blue),
              SizedBox(width: 8),
              Text('Email Tidak Terdaftar'),
            ],
          ),
          content: Text(
            'Email $email belum terdaftar di sistem. Apakah Anda ingin mendaftar dengan email ini?',
            style: TextStyle(fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Coba Email Lain',
                style: TextStyle(color: const Color.fromARGB(255, 94, 94, 94)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToRegisterWithEmail(email);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D6EFD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Daftar Sekarang' , style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  // 🎯 METHOD BARU: Navigasi ke register dengan email yang sudah terisi
  void _navigateToRegisterWithEmail(String email) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(prefilledEmail: email),
      ),
    );
  }

  // 🎯 METHOD BARU: Handle error Google Sign In yang lebih spesifik
  void _showGoogleSignInError(dynamic error) {
    String errorMessage;

    if (error.toString().contains('sign_in_failed')) {
      errorMessage =
          'Google Sign-In gagal. Pastikan Google Play Services terinstall dan updated.';
    } else if (error.toString().contains('network_error') ||
        error.toString().contains('Koneksi internet bermasalah')) {
      errorMessage = 'Koneksi internet bermasalah. Periksa koneksi Anda.';
    } else if (error.toString().contains('Timeout')) {
      errorMessage = 'Server tidak merespons. Coba lagi nanti.';
    } else if (error.toString().contains('INVALID_ACCOUNT')) {
      errorMessage = 'Akun Google tidak valid.';
    } else if (error.toString().contains('dibatalkan')) {
      errorMessage = 'Login dengan Google dibatalkan.';
      return; // Tidak perlu show error untuk cancel
    } else if (error.toString().contains('Email tidak ditemukan')) {
      errorMessage =
          'Akun Google belum terdaftar. Silakan daftar terlebih dahulu.';
    } else {
      errorMessage =
          'Gagal login dengan Google: ${error.toString().replaceAll('Exception: ', '')}';
    }

    _showError(errorMessage);
  }

  void _saveAuthData(AuthResponse result) {
    // TODO: Implement penyimpanan token menggunakan SharedPreferences
    print('💾 Saving auth data...');
    print('   User ID: ${result.user?.id}');
    print('   User Email: ${result.user?.email}');
    print('   User Name: ${result.user?.name}');
    print('   User Role: ${result.user?.role}');
    print('   Access Token: ${result.accessToken}');

    // Simpan remember me preference
    if (_rememberMe) {
      print('💾 Remember me: true');
      // TODO: Simpan ke SharedPreferences
    }
  }

  void _navigateToHome(AuthResponse result) {
    if (result.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: result.user!)),
        (route) => false,
      );
    } else {
      _showError('Data user tidak valid');
    }
  }

  // 🎯 METHOD BARU: Validasi email sebelum login
  void _validateEmailAndProceed() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError('Email tidak boleh kosong');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Format email tidak valid');
      return;
    }

    _sendOtp();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D6EFD), Color(0xFF1E88E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ScaleTransition(
                    scale: _headerScaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/Vector.png',
                            width: 70,
                            height: 70,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Masuk ke Akun Anda',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Masuk dengan Email atau Google untuk memulai',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // FORM CARD
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.12),
                          blurRadius: 35,
                          spreadRadius: 3,
                          offset: const Offset(0, 15),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol Google - DENGAN ERROR HANDLING
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _isGoogleLoading
                                ? null
                                : _signInWithGoogle,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: _isGoogleLoading
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF0D6EFD),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google.png',
                                        width: 22,
                                        height: 22,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Lanjutkan dengan Google',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'atau login dengan email',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Input email
                        Text(
                          'Alamat Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _emailFocusNode.hasFocus
                                  ? Color(0xFF0D6EFD).withOpacity(0.8)
                                  : Colors.grey.shade300,
                              width: _emailFocusNode.hasFocus ? 2 : 1.5,
                            ),
                            boxShadow: _emailFocusNode.hasFocus
                                ? [
                                    BoxShadow(
                                      color: Color(
                                        0xFF0D6EFD,
                                      ).withOpacity(0.15),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Masukkan email anda',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: _emailFocusNode.hasFocus
                                    ? Color(0xFF0D6EFD)
                                    : Colors.grey.shade500,
                                size: 22,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                            onSubmitted: (_) => _validateEmailAndProceed(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Checkbox Ingat Saya
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.1,
                              child: Checkbox(
                                activeColor: const Color(0xFF0D6EFD),
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ingat saya',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D6EFD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 5,
                              shadowColor: Color(0xFF0D6EFD).withOpacity(0.4),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Masuk',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF0D6EFD),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D6EFD),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
