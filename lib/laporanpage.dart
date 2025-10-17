import 'package:flutter/material.dart';
import 'package:flutter_latihan1/profile_page.dart';
import 'package:flutter_latihan1/sos_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_latihan1/homepage.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String? selectedReport = "Sampah Menumpuk";
  File? _selectedImage;

  // 🔹 Fungsi untuk pilih gambar
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 🔹 Fungsi untuk kirim laporan
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // agar tidak tertutup jika diklik di luar
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon centang hijau
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.check, color: Colors.green, size: 60),
                ),
                const SizedBox(height: 24),

                // Teks utama
                const Text(
                  "Laporan Anda Sudah Terkirim",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol merah
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Ketuk untuk Tutup",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 Bottom navigation bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.blue.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: "Home",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const _NavItem(
              icon: Icons.report_rounded,
              label: "Laporan",
              active: true,
            ),
            _NavItem(
              icon: Icons.sos_rounded,
              label: "Darurat",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SOSPage()),
                );
              },
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: "Profil",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),

      // 🔹 Body
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Laporan Warga",
                style: TextStyle(
                  color: Color(0xFF004AAD),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Laporkan kejadian di Lingkungan / Di desa.",
                style: TextStyle(color: Colors.blueGrey),
              ),
              const Divider(height: 30, thickness: 0.8),

              // 🔸 Dropdown Pelaporan
              const Text(
                "Pelaporan",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedReport,
                    items: const [
                      DropdownMenuItem(
                        value: "Sampah Menumpuk",
                        child: Text("Sampah Menumpuk"),
                      ),
                      DropdownMenuItem(
                        value: "Jalan Rusak",
                        child: Text("Jalan Rusak"),
                      ),
                      DropdownMenuItem(
                        value: "Lampu Mati",
                        child: Text("Lampu Mati"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedReport = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔸 Deskripsi
              const Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Tumpukan sampah di pos ronda...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔸 Lampiran
              const Text(
                "Lampiran",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorderBox(image: _selectedImage),
              ),
              const SizedBox(height: 25),

              // 🔸 Tombol Kirim
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showSuccessDialog(context),
                  icon: const Icon(Icons.upload_rounded, color: Colors.white),
                  label: const Text(
                    "Kirim Laporan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
}

// 🔹 Widget untuk item navigasi bawah
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? const Color(0xFF0066FF) : Colors.grey.shade600,
              size: active ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xFF0066FF) : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔸 Kotak lampiran (gambar)
class DottedBorderBox extends StatefulWidget {
  final File? image;
  const DottedBorderBox({super.key, this.image});

  @override
  State<DottedBorderBox> createState() => _DottedBorderBoxState();
}

class _DottedBorderBoxState extends State<DottedBorderBox> {
  File? _image;

  // Fungsi untuk pilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _image = widget.image;
    return GestureDetector(
      onTap: _pickImage, // 👈 tekan untuk pilih gambar
      child: Container(
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200, width: 1.2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.withOpacity(0.03),
          ),
          child: Center(
            child: _image == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(height: 4),
                      Text("Gambar", style: TextStyle(color: Colors.blueGrey)),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
