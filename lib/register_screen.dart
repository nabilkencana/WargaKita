import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_latihan1/social_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  DateTime? selectedDate;
  String? selectedCity;
  File? uploadedFile;

  // 📅 Pilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // 📂 Pilih file dari storage
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        uploadedFile = File(result.files.single.path!);
      });
    }
  }

  // 🔍 Validasi apakah semua field terisi
  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        nikController.text.isNotEmpty &&
        selectedDate != null &&
        selectedCity != null &&
        uploadedFile != null && 
        agree;
  }

  // 🔁 Update tombol setiap kali field berubah
  void _updateState() => setState(() {});

  @override
  void initState() {
    super.initState();
    nameController.addListener(_updateState);
    nikController.addListener(_updateState);
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SocialScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              // 🔹 Header
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

              // 🔹 Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepDot(true),
                  _buildStepDot(false),
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

              // 🔹 Checkbox
              Row(
                children: [
                  Checkbox(
                    activeColor: const Color(0xFF0066FF),
                    value: agree,
                    onChanged: (v) => setState(() => agree = v ?? false),
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

              // 🔹 Form
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
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0066FF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: nikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "NIK",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0066FF), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),

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
                onChanged: (v) => setState(() => selectedCity = v),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: UnderlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Upload Foto KK
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        uploadedFile == null
                            ? "Upload Foto KK"
                            : "Foto KK: ${uploadedFile!.path.split('/').last}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text(
                        "Upload",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 🔹 Tombol lanjut
              Center(
                child: SizedBox(
                  width: 180,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: isFormValid
                        ? () => Navigator.of(context).push(createRoute())
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isFormValid
                            ? const Color(0xFF0066FF)
                            : Colors.grey,
                      ),
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
