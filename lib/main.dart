import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Bagian atas dengan gradient biru
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0066FF), Color(0xFF338AFF)],
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
                children: const [
                  Icon(Icons.home_rounded, color: Colors.white, size: 70),
                  SizedBox(height: 20),
                  Text(
                    "Masuk ke Akun Anda",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      "Masukkan dengan Email atau daftarkan akun anda",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 Card Form Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tombol Google
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                          height: 22,
                        ),
                        label: const Text(
                          "Lanjutkan dengan Google",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Atau login menggunakan",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 16),

                    // Input Email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email Anda",
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Ingat Saya
                    Row(
                      children: [
                        Checkbox(
                          activeColor: const Color(0xFF0066FF),
                          value: rememberMe,
                          onChanged: (val) =>
                              setState(() => rememberMe = val ?? false),
                        ),
                        const Text("Ingat saya"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: Colors.blueAccent.withOpacity(0.4),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tombol Daftar
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
                          side: const BorderSide(color: Color(0xFF0066FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Teks bawah
                    const Text.rich(
                      TextSpan(
                        text: "Tidak mempunyai Akun? ",
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: "Daftar Sekarang!",
                            style: TextStyle(
                              color: Color(0xFF0066FF),
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
