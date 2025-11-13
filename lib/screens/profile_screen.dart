// profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.purple.shade100],
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.purple.shade600,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name ?? 'Nama Pengguna',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    // Menu Profil
                    _buildMenuSection('Akun Saya', [
                      _buildMenuTile(
                        Icons.person_outline,
                        'Edit Profil',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                      _buildMenuTile(
                        Icons.security_outlined,
                        'Keamanan',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                      _buildMenuTile(
                        Icons.notifications_outlined,
                        'Notifikasi',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Lainnya
                    _buildMenuSection('Lainnya', [
                      _buildMenuTile(
                        Icons.help_outline,
                        'Bantuan & Dukungan',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                      _buildMenuTile(
                        Icons.privacy_tip_outlined,
                        'Kebijakan Privasi',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                      _buildMenuTile(
                        Icons.description_outlined,
                        'Syarat & Ketentuan',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                      _buildMenuTile(
                        Icons.star_outline,
                        'Beri Rating',
                        Icons.arrow_forward_ios,
                        () {},
                      ),
                    ]),
                    const SizedBox(height: 40),
                    // Logout Button
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () => _showLogoutDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Keluar'),
                          ],
                        ),
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

  Widget _buildMenuSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(child: Column(children: children)),
      ],
    );
  }

  Widget _buildMenuTile(
    IconData leadingIcon,
    String title,
    IconData trailingIcon,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(leadingIcon, color: Colors.purple.shade600),
          title: Text(title),
          trailing: Icon(trailingIcon, size: 16, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        if (title != 'Beri Rating')
          Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementasi logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
