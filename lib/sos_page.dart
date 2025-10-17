import 'package:flutter/material.dart';
import 'package:flutter_latihan1/laporanpage.dart';
import 'package:flutter_latihan1/profile_page.dart';
import 'homepage.dart'; // Sesuaikan path sesuai proyekmu// biar tombol "Laporan" bisa navigasi balik

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  bool needVolunteer = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 Bottom navigation bar (SAMA seperti di LaporanPage)
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
            _NavItem(
              icon: Icons.report_rounded,
              label: "Laporan",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LaporanPage()),
                );
              },
            ),
            const _NavItem(
              icon: Icons.sos_rounded,
              label: "Darurat",
              active: true,
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

      // 🔹 Body utama
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Judul & instruksi
              const Text(
                "Apakah kamu\nbutuh bantuan?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1B1C1E),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  text: "pencet ",
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "tombol sos 3 detik ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ", untuk meminta bantuan terdekat dari lokasi mu !",
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // 🔴 Tombol SOS besar
              GestureDetector(
                onLongPressStart: (_) {
                  setState(() => isPressed = true);
                  Future.delayed(const Duration(seconds: 3), () {
                    if (isPressed) {
                      setState(() => isPressed = false);
                      _showSentDialog(context);
                    }
                  });
                },
                onLongPressEnd: (_) => setState(() => isPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(isPressed ? 0.7 : 0.3),
                        blurRadius: isPressed ? 40 : 20,
                        spreadRadius: isPressed ? 8 : 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // 🔘 Switch Butuh Relawan
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Butuh Relawan",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      activeColor: Colors.red,
                      value: needVolunteer,
                      onChanged: (value) {
                        setState(() {
                          needVolunteer = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Pop-up setelah SOS terkirim
  void _showSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                "Sinyal Darurat Terkirim!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Relawan dan petugas terdekat akan segera menuju lokasi kamu.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }
}

// 🔹 Widget navigasi bawah (sama seperti di laporan page)
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
