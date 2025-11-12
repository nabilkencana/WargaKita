import 'package:flutter/material.dart';
import 'package:flutter_latihan1/screens/register_screen.dart';
import '../services/auth_service.dart';
import 'verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Prefill dengan email contoh dari gambar
    _emailController.text = 'BudiStyawan22@gmail.com';
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

    setState(() {
      _isLoading = true;
    });

    try {
      // LANGSUNG NAVIGATE KE VERIFY OTP SCREEN TANPA MENUNGGU RESPONSE
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(email: email),
        ),
      );

      // Kirim OTP di background setelah navigate
      _authService.sendOtp(email).then((_) {
        // Success handling bisa dilakukan di VerifyOtpScreen
      }).catchError((error) {
        // Error handling juga bisa dilakukan di VerifyOtpScreen
        print('Error sending OTP: $error');
      });
      
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Masuk ke Akun Anda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'Masukkan dengan Email atau daftarkan akun anda',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Google Login Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Implement Google login
                  },
                  icon: Image.asset(
                    'assets/images/google.png',
                    width: 20,
                    height: 20,
                  ),
                  label: const Text(
                    'Lanjutkan dengan Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Divider dengan text "Atau login menggunakan"
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade300),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Atau login menggunakan',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // Remember Me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Ingat saya'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Kirim OTP Button - LANGSUNG NAVIGATE SAAT DI-TAP
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Kirim OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to register screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.blue.shade400),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Footer text
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to register screen
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Tidak mempunyai Akun? ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Daftar Sekarang!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}