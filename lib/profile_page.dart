import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'laporanpage.dart';
import 'sos_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;
  bool faceIdEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : const Color(0xFFF5F7FA),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            _buildSection(
              title: "Akun Saya",
              items: [
                _buildTile(
                  icon: Icons.person_outline_rounded,
                  label: "Edit Profil",
                  subtitle: "Perbarui data pribadi dan foto Anda",
                  onTap: () => _openEditProfile(context),
                ),
                _buildTile(
                  icon: Icons.settings_outlined,
                  label: "Kelola Akun",
                  subtitle: "Ubah email, password, dan keamanan",
                  onTap: () => _openManageAccount(context),
                ),
                _buildTile(
                  icon: Icons.fingerprint_rounded,
                  label: "Face ID / Touch ID",
                  trailing: CupertinoSwitch(
                    value: faceIdEnabled,
                    onChanged: (val) => setState(() => faceIdEnabled = val),
                  ),
                ),
                _buildTile(
                  icon: Icons.verified_user_outlined,
                  label: "Autentikasi 2 Faktor",
                  subtitle: "Tambahkan lapisan keamanan ekstra",
                  onTap: () => _showInfoDialog(context, "Autentikasi 2 Faktor"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSection(
              title: "Preferensi",
              items: [
                _buildTile(
                  icon: Icons.dark_mode_outlined,
                  label: "Mode Gelap",
                  trailing: CupertinoSwitch(
                    value: darkMode,
                    onChanged: (val) => setState(() => darkMode = val),
                  ),
                ),
                _buildTile(
                  icon: Icons.language_rounded,
                  label: "Bahasa",
                  subtitle: "Indonesia",
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSection(
              title: "Lainnya",
              items: [
                _buildTile(
                  icon: Icons.help_outline_rounded,
                  label: "Bantuan & Dukungan",
                  onTap: () => _showInfoDialog(context, "Bantuan & Dukungan"),
                ),
                _buildTile(
                  icon: Icons.info_outline_rounded,
                  label: "Tentang Aplikasi",
                  onTap: () => _showInfoDialog(context, "Tentang Aplikasi"),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Keluar Akun"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007BFF), Color(0xFF4FC3F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Budi Styawan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "budi.styawan@gmail.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openEditProfile(context),
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ===== SECTION BUILDER =====
  Widget _buildSection({required String title, required List<Widget> items}) {
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
            color: darkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  // ===== TILE BUILDER =====
  Widget _buildTile({
    required IconData icon,
    required String label,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing:
          trailing ??
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  // ===== NAVBAR =====
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
          _navItem(
            icon: Icons.home_rounded,
            label: "Home",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
          _navItem(
            icon: Icons.report_rounded,
            label: "Laporan",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LaporanPage()),
            ),
          ),
          _navItem(
            icon: Icons.sos_rounded,
            label: "Darurat",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SOSPage()),
            ),
          ),
          _navItem(icon: Icons.person_rounded, label: "Profil", active: true),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
    VoidCallback? onTap,
  }) {
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

  // ===== DIALOGS =====
  void _showInfoDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: const Text("Fitur ini akan segera tersedia."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pilih Bahasa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Indonesia"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("English"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Keluar Akun"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Anda telah keluar dari akun.")),
              );
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  void _openEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _EditProfilePage()),
    );
  }

  void _openManageAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _ManageAccountPage()),
    );
  }
}

// ===== HALAMAN EDIT PROFIL =====
class _EditProfilePage extends StatelessWidget {
  const _EditProfilePage();

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final usernameCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui")),
                );
              },
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== HALAMAN KELOLA AKUN =====
class _ManageAccountPage extends StatelessWidget {
  const _ManageAccountPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Akun")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("Ubah Email"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Ubah Password"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text("Login dengan Google"),
            subtitle: const Text("Hubungkan akun Google Anda"),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Login Google...")));
            },
          ),
        ],
      ),
    );
  }
}
