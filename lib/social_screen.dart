import 'package:flutter/material.dart';
import 'package:flutter_latihan1/homepage.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final instagramController = TextEditingController();
  final facebookController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Logo
                Row(
                  children: const [
                    Icon(
                      Icons.house_rounded,
                      color: Color(0xFF0066FF),
                      size: 40,
                    ),
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

                // 🔹 Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepDot(true),
                    _buildStepDot(true),
                    _buildStepDot(false),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Header
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

                // 🔹 Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email wajib diisi";
                    }
                    if (!value.contains("@")) {
                      return "Masukkan email yang valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 🔹 Nomor Telepon
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.grey),
                    labelText: "Nomor Telepon",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nomor telepon wajib diisi";
                    }
                    if (value.length < 10) {
                      return "Nomor telepon tidak valid";
                    }
                    return null;
                  },
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

                TextFormField(
                  controller: instagramController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black54,
                    ),
                    labelText: "Instagram (Opsional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: facebookController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.facebook, color: Colors.black54),
                    labelText: "Facebook (Opsional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // 🔹 Tombol Lanjut
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder: (_, __, ___) =>
                                  const InfoAlamatPage(),
                              transitionsBuilder:
                                  (context, animation, secondary, child) {
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
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Lanjut",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
  final alamatController = TextEditingController();
  final kodePosController = TextEditingController();
  final rtRwController = TextEditingController();
  String selectedKota = "Malang";
  String selectedNegara = "Indonesia";

  final _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: const [
                    Icon(
                      Icons.house_rounded,
                      color: Color(0xFF0066FF),
                      size: 40,
                    ),
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

                TextFormField(
                  controller: alamatController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Alamat wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedKota,
                  decoration: const InputDecoration(labelText: "Kota"),
                  items: const [
                    DropdownMenuItem(value: "Malang", child: Text("Malang")),
                    DropdownMenuItem(
                      value: "Surabaya",
                      child: Text("Surabaya"),
                    ),
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
                        value: selectedNegara,
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
                      child: TextFormField(
                        controller: kodePosController,
                        decoration: const InputDecoration(
                          labelText: "Kode Pos",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: rtRwController,
                  decoration: const InputDecoration(labelText: "RT / RW"),
                  validator: (v) => v!.isEmpty ? "RT / RW wajib diisi" : null,
                ),
                const SizedBox(height: 32),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const HomePage(),
                              transitionsBuilder:
                                  (context, animation, _, child) {
                                    return SlideTransition(
                                      position: Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
