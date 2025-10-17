import 'package:flutter/material.dart';
import 'package:flutter_latihan1/homepage.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Bottom navigation bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
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
          children: const [
            _NavItem(icon: Icons.home_rounded, label: "Home"),
            _NavItem(
              icon: Icons.event_rounded,
              label: "Kegiatan",
              active: true,
            ),
            _NavItem(icon: Icons.menu_book_rounded, label: "Agenda"),
            _NavItem(icon: Icons.person_rounded, label: "Profil"),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

              // Dropdown pelaporan
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
                    value: "Sampah Menumpuk",
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
                    onChanged: (_) {},
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Deskripsi
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

              // Lampiran
              const Text(
                "Lampiran",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DottedBorderBox(),
              const SizedBox(height: 25),

              // Tombol Kirim
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
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

// Widget untuk item navigasi bawah
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Homepage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
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

// Kotak lampiran (gambar)
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade200,
          style: BorderStyle.solid,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withOpacity(0.03),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.blue,
              size: 28,
            ),
            SizedBox(height: 4),
            Text("Gambar", style: TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
