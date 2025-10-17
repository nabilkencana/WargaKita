import 'package:flutter/material.dart';
import 'package:flutter_latihan1/homepage.dart';

// ==================== HALAMAN 1 ==================== //
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final emailController = TextEditingController(text: "");
  final phoneController = TextEditingController(text: "");
  final instagramController = TextEditingController(text: "");
  final facebookController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Info Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: const [
                  Icon(Icons.house_rounded, color: Color(0xFF0066FF), size: 40),
                  SizedBox(width: 8),
                  Text(
                    "WARGA KITA",
                    style: TextStyle(
                      color: Color(0xFF0066FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepDot(true),
                  _buildStepDot(true),
                  _buildStepDot(false),
                ],
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Info Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Isi data untuk profil. Ini akan memakan waktu beberapa menit. Anda hanya perlu KTP / KK.",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              const Divider(height: 32, thickness: 1),

              const Text(
                "Data Pribadi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Sebutkan persis seperti di KTP / KK Anda",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  hintText: "Masukkan email anda",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: Colors.grey),
                  hintText: "Masukkan nomor telepon",
                  border: UnderlineInputBorder(),
                ),
              ),
              const Divider(height: 32, thickness: 1),

              const Text(
                "Media Sosial",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Tunjukkan metode komunikasi yang diinginkan",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: instagramController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black54,
                  ),
                  hintText: "@username",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: facebookController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.facebook, color: Colors.black54),
                  hintText: "@profile",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Color(0xFF0066FF)),
                label: const Text(
                  "Tambahkan Lainnya",
                  style: TextStyle(color: Color(0xFF0066FF)),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: 160,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => const InfoAlamatPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position:
                                      Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text(
                      "Lanjut",
                      style: TextStyle(color: Colors.white),
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

  static Widget _buildStepDot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0066FF) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

// ==================== HALAMAN 2 ==================== //
class InfoAlamatPage extends StatefulWidget {
  const InfoAlamatPage({super.key});

  @override
  State<InfoAlamatPage> createState() => _InfoAlamatPageState();
}

class _InfoAlamatPageState extends State<InfoAlamatPage> {
  final alamatController = TextEditingController(text: "");
  final kodePosController = TextEditingController(text: "");
  final rtRwController = TextEditingController();
  String selectedKota = "Malang";
  String selectedNegara = "Indonesia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Info Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: const [
                  Icon(Icons.house_rounded, color: Color(0xFF0066FF), size: 40),
                  SizedBox(width: 8),
                  Text(
                    "WARGA KITA",
                    style: TextStyle(
                      color: Color(0xFF0066FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepDot(true),
                  _buildStepDot(true),
                  _buildStepDot(true),
                ],
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Info Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Isi data untuk profil. Ini akan memakan waktu beberapa menit. Anda hanya perlu KTP / KK.",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              const Divider(height: 32, thickness: 1),

              const Text(
                "Alamat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Digunakan untuk data alamat anda.",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedKota,
                decoration: const InputDecoration(labelText: "Kota"),
                items: const [
                  DropdownMenuItem(value: "Malang", child: Text("Malang")),
                  DropdownMenuItem(value: "Surabaya", child: Text("Surabaya")),
                  DropdownMenuItem(value: "Jakarta", child: Text("Jakarta")),
                ],
                onChanged: (value) => setState(() => selectedKota = value!),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedNegara,
                      decoration: const InputDecoration(labelText: "Negara"),
                      items: const [
                        DropdownMenuItem(
                          value: "Indonesia",
                          child: Text("Indonesia"),
                        ),
                        DropdownMenuItem(
                          value: "Malaysia",
                          child: Text("Malaysia"),
                        ),
                        DropdownMenuItem(
                          value: "Singapura",
                          child: Text("Singapura"),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedNegara = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: kodePosController,
                      decoration: const InputDecoration(labelText: "Kode pos"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: rtRwController,
                decoration: const InputDecoration(labelText: "RT / RW"),
              ),
              const SizedBox(height: 32),

              Center(
                child: SizedBox(
                  width: 160,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigasi ke HomePage dengan animasi slide dari kanan
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const HomePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                final tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  static Widget _buildStepDot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0066FF) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
