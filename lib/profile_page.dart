import 'package:flutter/material.dart';
import 'package:flutter_latihan1/sos_page.dart';
import 'homepage.dart';
import 'laporanpage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Header Profil
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0066FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://1.bp.blogspot.com/-mFWPriC5yZM/VUx-jyHRCEI/AAAAAAAAITM/zfCUzS4Y2wM/s1600/gambar+monyet+(17).jpg',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Budi Styawan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "@Budi_22",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bagian Akun
              _buildSection(
                context,
                title: "Akun Saya",
                items: [
                  _ProfileItem(
                    icon: Icons.person_outline_rounded,
                    label: "Data Diri Saya",
                    subtitle: "Ketuk untuk mengganti data diri Anda",
                    alert: true,
                    onTap: () {
                      _showEditDialog(context, "Data Diri Saya");
                    },
                  ),
                  _ProfileItem(
                    icon: Icons.settings_outlined,
                    label: "Kelola Akun",
                    subtitle: "Kelola akun yang tersimpan",
                    onTap: () {
                      _showEditDialog(context, "Kelola Akun");
                    },
                  ),
                  _ProfileItem(
                    icon: Icons.fingerprint_rounded,
                    label: "Face ID / Touch ID",
                    subtitle: "Kunci aplikasi Anda",
                    hasSwitch: true,
                  ),
                  _ProfileItem(
                    icon: Icons.verified_user_outlined,
                    label: "Autentifikasi 2 Faktor",
                    subtitle: "Amankan akun Anda lebih lanjut",
                    onTap: () {
                      _showEditDialog(context, "Autentifikasi 2 Faktor");
                    },
                  ),
                  _ProfileItem(
                    icon: Icons.logout_rounded,
                    label: "Keluar",
                    subtitle: "Keluar dari akun Anda",
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bagian Lainnya
              _buildSection(
                context,
                title: "Lainnya",
                items: [
                  _ProfileItem(
                    icon: Icons.help_outline_rounded,
                    label: "Bantuan & Dukungan",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Menu Bantuan diklik")),
                      );
                    },
                  ),
                  _ProfileItem(
                    icon: Icons.info_outline_rounded,
                    label: "Tentang Aplikasi",
                    onTap: () {
                      _showEditDialog(context, "Tentang Aplikasi");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
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
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
          _NavItem(
            icon: Icons.report_rounded,
            label: "Laporan",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LaporanPage()),
            ),
          ),
          _NavItem(
            icon: Icons.sos_rounded,
            label: "Darurat",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SOSPage()),
            ),
          ),
          const _NavItem(
            icon: Icons.person_rounded,
            label: "Profil",
            active: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String fieldName) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $fieldName"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Masukkan $fieldName"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$fieldName berhasil diupdate!")),
              );
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Anda telah logout")),
              );
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }
}

// Profile Item & NavItem sama seperti sebelumnya
class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool alert;
  final bool hasSwitch;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.alert = false,
    this.hasSwitch = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: hasSwitch ? null : onTap,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blue.withOpacity(0.05),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 12))
          : null,
      trailing: hasSwitch
          ? Switch(value: false, onChanged: (_) {})
          : alert
          ? const Icon(Icons.error_outline_rounded, color: Colors.red)
          : const Icon(Icons.chevron_right_rounded),
    );
  }
}

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
