import 'package:flutter/material.dart';
import 'package:flutter_latihan1/screens/register_screen.dart';
import '../services/auth_service.dart';
import 'verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi card login (fade + slide dari bawah)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Jalankan animasi saat halaman dimuat
    _controller.forward();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Email tidak boleh kosong');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Format email tidak valid');
      return;
    }

    setState(() => _isLoading = true);

    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOtpScreen(email: email)),
      );
      _authService.sendOtp(email).catchError((error) {
        print('Error sending OTP: $error');
      });
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ===== HEADER DENGAN GRADIENT + GRID =====
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D6EFD), Color(0xFF1E88E5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.12,
                    child: Image.asset(
                      'assets/images/grid_pattern.png',
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Vector.png',
                              width: 70,
                              height: 70,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Masuk ke Akun Anda',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Masuk dengan Email atau daftar akun baru',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ===== FORM LOGIN CARD =====
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.08),
                          blurRadius: 25,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Tombol Google
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/google.png',
                              width: 20,
                            ),
                            label: const Text(
                              'Lanjutkan dengan Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                'atau login dengan email',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Input email
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukkan email anda',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 12),

                        // Checkbox Ingat Saya
                        Row(
                          children: [
                            Checkbox(
                              activeColor: const Color(0xFF0D6EFD),
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              'Ingat saya',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _sendOtp,
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: const Color(0xFF0D6EFD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0D6EFD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer teks
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Tidak mempunyai akun? ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Daftar Sekarang!',
                                  style: TextStyle(
                                    color: Color(0xFF0D6EFD),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
    super.dispose();
  }
}
