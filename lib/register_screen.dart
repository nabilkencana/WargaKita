import 'package:flutter/material.dart';
import 'package:flutter_latihan1/social_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;
  final TextEditingController nameController = TextEditingController(
    text: "",
  );
  final TextEditingController nikController = TextEditingController(
    text: "",
  );
  DateTime? selectedDate = DateTime(1992, 5, 12);
  String? selectedCity = "Kedungkandang, Malang";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SocialScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // dari kanan ke kiri
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // 🔹 Tambahkan AppBar dengan tombol kembali
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman main.dart
          },
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
              // Logo dan judul
              Row(
                children: [
                  const Icon(
                    Icons.house_rounded,
                    color: Color(0xFF0066FF),
                    size: 40,
                  ),
                  const SizedBox(width: 8),
                  const Text(
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

              // Progress indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepDot(true),
                  _buildStepDot(false),
                  _buildStepDot(false),
                ],
              ),
              const SizedBox(height: 20),

              // Info Profile
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

              // Checkbox
              Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xFF0066FF),
                    value: agree,
                    onChanged: (v) {
                      setState(() => agree = v ?? false);
                    },
                  ),
                  const Text("Saya setuju dengan "),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Syarat penggunaan",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32, thickness: 1),

              // Data Pribadi
              const Text(
                "Data Pribadi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Sebutkan persis seperti di KTP / KK Anda",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Nama Lengkap
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0066FF),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Nama Lengkap
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 500),
                child: TextField(
                  controller: nikController,
                  decoration: const InputDecoration(
                    labelText: "NIK",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0066FF),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Tanggal Lahir
              const Text("Tanggal Lahir"),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: const UnderlineInputBorder(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      hintText: selectedDate != null
                          ? "${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}"
                          : "Pilih tanggal",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tempat Lahir
              const Text("Tempat Lahir"),
              DropdownButtonFormField<String>(
                initialValue: selectedCity,
                items: const [
                  DropdownMenuItem(
                    value: "Kedungkandang, Malang",
                    child: Text("Kedungkandang, Malang"),
                  ),
                  DropdownMenuItem(
                    value: "Lowokwaru, Malang",
                    child: Text("Lowokwaru, Malang"),
                  ),
                  DropdownMenuItem(
                    value: "Blimbing, Malang",
                    child: Text("Blimbing, Malang"),
                  ),
                ],
                onChanged: (v) {
                  setState(() => selectedCity = v);
                },
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: UnderlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 24),

              // Upload Foto KK
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Upload Foto KK",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.upload,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Upload",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tombol lanjut
              Center(
                child: SizedBox(
                  width: 180,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: agree
                        ? () {
                            Navigator.of(context).push(createRoute());
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Lanjut"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepDot(bool active) {
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
