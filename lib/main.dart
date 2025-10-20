import 'package:flutter/material.dart';
import 'package:flutter_latihan1/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (error) {
      print("Error login Google: $error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal login dengan Google')));
    }
  }

  void _handleLogin() {
    // Disini bisa tambahkan validasi email/password
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Bagian atas dengan gradient lembut + ilustrasi
            Container(
              width: double.infinity,
              height: 340,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF007BFF), Color(0xFF5AC8FA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/Vector.png',
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Selamat Datang Kembali!",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Masuk ke akun Anda untuk melanjutkan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 Card Login (Glassmorphism style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 🔘 Login Google
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _handleGoogleSignIn,
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                          height: 22,
                        ),
                        label: const Text(
                          "Masuk dengan Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.black12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    const Text(
                      "atau masuk menggunakan email",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 18),

                    // 📩 Input Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email Anda",
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔘 Ingat saya
                    Row(
                      children: [
                        Checkbox(
                          activeColor: const Color(0xFF007BFF),
                          value: rememberMe,
                          onChanged: (val) =>
                              setState(() => rememberMe = val ?? false),
                        ),
                        const Text(
                          "Ingat saya",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 🔹 Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          shadowColor: Colors.blueAccent.withOpacity(0.5),
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                          side: const BorderSide(color: Color(0xFF007BFF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Daftar Akun Baru",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007BFF),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔸 Teks bawah
                    const Text.rich(
                      TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Daftar Sekarang!",
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
