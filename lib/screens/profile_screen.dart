// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_latihan1/screens/login_screen.dart';
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.role ?? 'Warga',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                        () => _showEditProfileDialog(context),
                      ),
                      _buildMenuTile(
                        Icons.security_outlined,
                        'Keamanan',
                        Icons.arrow_forward_ios,
                        () => _showSecuritySettings(context),
                      ),
                      _buildMenuTile(
                        Icons.notifications_outlined,
                        'Notifikasi',
                        Icons.arrow_forward_ios,
                        () => _showNotificationSettings(context),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    // Lainnya
                    _buildMenuSection('Lainnya', [
                      _buildMenuTile(
                        Icons.help_outline,
                        'Bantuan & Dukungan',
                        Icons.arrow_forward_ios,
                        () => _showHelpSupport(context),
                      ),
                      _buildMenuTile(
                        Icons.privacy_tip_outlined,
                        'Kebijakan Privasi',
                        Icons.arrow_forward_ios,
                        () => _showPrivacyPolicy(context),
                      ),
                      _buildMenuTile(
                        Icons.description_outlined,
                        'Syarat & Ketentuan',
                        Icons.arrow_forward_ios,
                        () => _showTermsConditions(context),
                      ),
                      _buildMenuTile(
                        Icons.star_outline,
                        'Beri Rating',
                        Icons.arrow_forward_ios,
                        () => _showRatingDialog(context),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
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
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(leadingIcon, color: Colors.purple.shade600, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Icon(trailingIcon, size: 16, color: Colors.grey.shade400),
          onTap: onTap,
        ),
        if (title != 'Beri Rating')
          Divider(
            height: 1,
            color: Colors.grey.shade200,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  // === FUNGSI UNTUK SEMUA TOMBOL ===

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: user.name ?? '');
    final emailController = TextEditingController(text: user.email);

    // Cek property yang tersedia di model User
    final phoneController = TextEditingController(
      text: user.phone ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person, color: Colors.purple),
            SizedBox(width: 8),
            Text('Edit Profil'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade100,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.purple.shade600,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulasi update profile
              _showSuccessSnackbar(context, 'Profil berhasil diperbarui');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pengaturan Keamanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSecurityOption(
                        Icons.lock_outline,
                        'Ubah Password',
                        'Perbarui kata sandi Anda secara berkala',
                        () => _showChangePasswordDialog(context),
                      ),
                      const SizedBox(height: 16),
                      _buildSecurityOption(
                        Icons.fingerprint,
                        'Autentikasi Biometrik',
                        'Gunakan sidik jari atau wajah untuk login',
                        () => _showBiometricSettings(context),
                      ),
                      const SizedBox(height: 16),
                      _buildSecurityOption(
                        Icons.phone_android,
                        'Verifikasi 2 Langkah',
                        'Tambah keamanan ekstra dengan OTP',
                        () => _showTwoFactorAuth(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecurityOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.purple.shade600, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Switch(
          value: title == 'Autentikasi Biometrik' ? false : true,
          onChanged: (value) {},
          activeThumbColor: Colors.purple,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.purple),
            SizedBox(width: 8),
            Text('Ubah Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Saat Ini',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                _showSuccessSnackbar(context, 'Password berhasil diubah');
                Navigator.pop(context);
              } else {
                _showErrorSnackbar(context, 'Password konfirmasi tidak cocok');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Ubah Password'),
          ),
        ],
      ),
    );
  }

  void _showBiometricSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autentikasi Biometrik'),
        content: const Text(
          'Fitur ini memungkinkan Anda login menggunakan sidik jari atau pengenalan wajah. Aktifkan fitur ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              _showSuccessSnackbar(context, 'Autentikasi biometrik diaktifkan');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Aktifkan'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorAuth(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verifikasi 2 Langkah'),
        content: const Text(
          'Dengan verifikasi 2 langkah, Anda akan menerima kode OTP via email setiap kali login.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              _showSuccessSnackbar(context, 'Verifikasi 2 langkah diaktifkan');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Aktifkan'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pengaturan Notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildNotificationOption('Notifikasi Umum', true),
                      _buildNotificationOption('Pengumuman', true),
                      _buildNotificationOption('Laporan', true),
                      _buildNotificationOption('Kegiatan', false),
                      _buildNotificationOption('Email Notifikasi', true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationOption(String title, bool value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: (newValue) {},
          activeThumbColor: Colors.purple,
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Bantuan & Dukungan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHelpOption(
                        Icons.contact_support,
                        'Hubungi Kami',
                        'Kontak customer service',
                        () => _showContactDialog(context),
                      ),
                      const SizedBox(height: 12),
                      _buildHelpOption(
                        Icons.chat_bubble_outline,
                        'Chat Langsung',
                        'Dapatkan bantuan instan',
                        () => _showLiveChat(context),
                      ),
                      const SizedBox(height: 12),
                      _buildHelpOption(
                        Icons.help_center,
                        'FAQ',
                        'Pertanyaan yang sering diajukan',
                        () => _showFAQ(context),
                      ),
                      const SizedBox(height: 12),
                      _buildHelpOption(
                        Icons.bug_report,
                        'Laporkan Masalah',
                        'Kirim laporan bug atau masalah',
                        () => _showReportProblem(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.purple.shade600, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hubungi Kami'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Service: 1500-123'),
            SizedBox(height: 8),
            Text('Email: support@communityapp.com'),
            SizedBox(height: 8),
            Text('WhatsApp: +62 812-3456-7890'),
            SizedBox(height: 16),
            Text('Jam Operasional:'),
            Text('Senin - Jumat: 08.00 - 17.00 WIB'),
            Text('Sabtu: 08.00 - 12.00 WIB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLiveChat(BuildContext context) {
    _showSuccessSnackbar(context, 'Membuka chat langsung...');
  }

  void _showFAQ(BuildContext context) {
    _showSuccessSnackbar(context, 'Membuka FAQ...');
  }

  void _showReportProblem(BuildContext context) {
    final problemController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Laporkan Masalah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Jelaskan masalah yang Anda alami:'),
            const SizedBox(height: 12),
            TextField(
              controller: problemController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Deskripsikan masalah Anda...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (problemController.text.isNotEmpty) {
                _showSuccessSnackbar(
                  context,
                  'Laporan masalah berhasil dikirim',
                );
                Navigator.pop(context);
              } else {
                _showErrorSnackbar(context, 'Harap isi deskripsi masalah');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Kirim Laporan'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    _showInfoDialog(
      context,
      'Kebijakan Privasi',
      'Aplikasi Community App menghargai privasi Anda. Data yang kami kumpulkan digunakan untuk:'
          '\n\n• Memperbaiki pengalaman pengguna'
          '\n• Menyediakan layanan yang diminta'
          '\n• Komunikasi penting terkait layanan'
          '\n• Analisis dan pengembangan fitur'
          '\n\nKami tidak akan membagikan data pribadi Anda kepada pihak ketiga tanpa persetujuan.'
          '\n\nTerakhir diperbarui: 1 Desember 2024',
    );
  }

  void _showTermsConditions(BuildContext context) {
    _showInfoDialog(
      context,
      'Syarat & Ketentuan',
      'Dengan menggunakan aplikasi Community App, Anda menyetujui:'
          '\n\n• Menggunakan aplikasi sesuai dengan peraturan yang berlaku'
          '\n• Tidak menyebarkan konten yang melanggar hukum'
          '\n• Bertanggung jawab atas konten yang diunggah'
          '\n• Menghormati privasi pengguna lain'
          '\n• Mengikuti panduan komunitas yang telah ditetapkan'
          '\n\nPelanggaran terhadap syarat dan ketentuan dapat mengakibatkan pembatasan akses.'
          '\n\nTerakhir diperbarui: 1 Desember 2024',
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('Beri Rating'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bagaimana pengalaman Anda menggunakan aplikasi?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2, 3, 4, 5].map((star) {
                return IconButton(
                  icon: Icon(Icons.star, color: Colors.amber, size: 30),
                  onPressed: () {
                    _showSuccessSnackbar(
                      context,
                      'Terima kasih atas rating $star bintang!',
                    );
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Keluar'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _performLogout(context); // Lakukan logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    // Tutup dialog konfirmasi
    Navigator.pop(context);

    // Tampilkan loading indicator cepat
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Sedang keluar...'),
          ],
        ),
      ),
    );

    // Proses logout yang lebih cepat (500ms saja)
    await Future.delayed(const Duration(milliseconds: 500));

    // Tutup loading dan navigasi
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => true,
    );
  }
  
  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 2,
        ), // Pastikan durasi tidak terlalu lama
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
