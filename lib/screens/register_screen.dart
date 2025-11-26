import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/register_service.dart';
import '../models/register_model.dart';

class RegisterScreen extends StatefulWidget {
  final String? prefilledEmail;

  const RegisterScreen({super.key, this.prefilledEmail});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterService _registerService = RegisterService();
  final ImagePicker _picker = ImagePicker();

  int _currentStep = 0;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  File? _kkFile;
  String _selectedCountry = 'Indonesia';

  // Data pribadi
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();

  // Kontak
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  // Alamat
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Daftar negara
  final List<String> _countries = [
    'Indonesia',
    'Malaysia',
    'Singapore',
    'Thailand',
    'Vietnam',
    'Philippines',
    'Brunei',
    'Cambodia',
    'Laos',
    'Myanmar',
    'East Timor',
    'China',
    'Japan',
    'South Korea',
    'India',
    'Australia',
    'United States',
    'United Kingdom',
    'Canada',
    'Germany',
    'France',
    'Netherlands',
    'Other',
  ];

  // List untuk media sosial tambahan
  final List<Map<String, dynamic>> _additionalSocialMedia = [];

  @override
  void initState() {
    super.initState();
    _prefillEmail();
  }

  // 🎯 METHOD BARU: Prefill email jika ada dari login screen
  void _prefillEmail() {
    if (widget.prefilledEmail != null && widget.prefilledEmail!.isNotEmpty) {
      _emailController.text = widget.prefilledEmail!;

      // Auto-focus ke field berikutnya setelah email terisi
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Bisa tambahkan auto-focus ke field berikutnya jika diperlukan
        print('📧 Email prefilled: ${widget.prefilledEmail}');
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _tempatLahirController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _alamatController.dispose();
    _kotaController.dispose();
    _kodePosController.dispose();
    _rtRwController.dispose();
    super.dispose();
  }

  Future<void> _pickKKFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _kkFile = File(result.files.single.path!);
        });
        _showSuccess("File KK berhasil dipilih");
      }
    } catch (e) {
      _showError("Error memilih file: $e");
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF0D6EFD),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D6EFD),
              onPrimary: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      setState(() {
        _tanggalLahirController.text = formattedDate;
      });
    }
  }

  Future<void> _selectCountry() async {
    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Negara',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D6EFD),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                return ListTile(
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6EFD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.flag,
                      color: const Color(0xFF0D6EFD),
                      size: 18,
                    ),
                  ),
                  title: Text(
                    country,
                    style: TextStyle(
                      fontWeight: country == _selectedCountry
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: country == _selectedCountry
                          ? const Color(0xFF0D6EFD)
                          : Colors.black87,
                    ),
                  ),
                  trailing: country == _selectedCountry
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0D6EFD),
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context, country);
                  },
                );
              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });
    }
  }

  void _addSocialMedia() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Media Sosial'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LinkedIn
            if (!_isSocialMediaAdded('LinkedIn'))
              ListTile(
                leading: _buildSocialMediaIcon('LinkedIn'),
                title: const Text('LinkedIn'),
                onTap: () {
                  _addSocialMediaField('LinkedIn');
                  Navigator.pop(context);
                },
              ),

            // Twitter
            if (!_isSocialMediaAdded('Twitter'))
              ListTile(
                leading: _buildSocialMediaIcon('Twitter'),
                title: const Text('Twitter'),
                onTap: () {
                  _addSocialMediaField('Twitter');
                  Navigator.pop(context);
                },
              ),

            // TikTok
            if (!_isSocialMediaAdded('TikTok'))
              ListTile(
                leading: _buildSocialMediaIcon('TikTok'),
                title: const Text('TikTok'),
                onTap: () {
                  _addSocialMediaField('TikTok');
                  Navigator.pop(context);
                },
              ),

            if (_isAllSocialMediaAdded())
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Semua media sosial sudah ditambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Method untuk build icon dengan asset image dan fallback ke icon
  Widget _buildSocialMediaIcon(String platform) {
    String assetPath;
    IconData fallbackIcon;
    Color color;

    switch (platform) {
      case 'LinkedIn':
        assetPath = 'assets/images/linkedin.png';
        fallbackIcon = Icons.business_center;
        color = Colors.blue.shade700;
        break;
      case 'Twitter':
        assetPath = 'assets/images/twitter.png';
        fallbackIcon = Icons.chat;
        color = Colors.lightBlue;
        break;
      case 'TikTok':
        assetPath = 'assets/images/tiktok.png';
        fallbackIcon = Icons.music_note;
        color = Colors.black;
        break;
      default:
        assetPath = 'assets/images/link.png';
        fallbackIcon = Icons.link;
        color = const Color(0xFF0D6EFD);
    }

    return Image.asset(
      assetPath,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        // Fallback ke Material Icon jika asset tidak ditemukan
        return Icon(fallbackIcon, color: color, size: 30);
      },
    );
  }

  // Method untuk mengecek apakah social media sudah ditambahkan
  bool _isSocialMediaAdded(String platform) {
    return _additionalSocialMedia.any((item) => item['platform'] == platform);
  }

  // Method untuk mengecek apakah semua social media sudah ditambahkan
  bool _isAllSocialMediaAdded() {
    final List<String> allPlatforms = ['LinkedIn', 'Twitter', 'TikTok'];
    return allPlatforms.every((platform) => _isSocialMediaAdded(platform));
  }

  // Update method _addSocialMediaField dengan menyimpan asset path
  void _addSocialMediaField(String platform) {
    setState(() {
      _additionalSocialMedia.add({
        'platform': platform,
        'controller': TextEditingController(),
        'color': _getPlatformColor(platform),
        'assetPath': _getPlatformAssetPath(platform), // Simpan path asset
      });
    });
  }

  // Method untuk mendapatkan path asset berdasarkan platform
  String _getPlatformAssetPath(String platform) {
    switch (platform) {
      case 'LinkedIn':
        return 'assets/images/linkedin.png';
      case 'Twitter':
        return 'assets/images/twitter.png';
      case 'TikTok':
        return 'assets/images/tiktok.png';
      default:
        return 'assets/images/link.png';
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'LinkedIn':
        return Colors.blue.shade700;
      case 'Twitter':
        return Colors.lightBlue;
      case 'TikTok':
        return Colors.black;
      default:
        return const Color(0xFF0D6EFD);
    }
  }

  // Method untuk mendapatkan icon berdasarkan platform (untuk digunakan di form)
  Widget _getSocialMediaFormIcon(String platform, [String? assetPath]) {
    // Coba gunakan asset path yang diberikan, jika tidak ada gunakan default
    String path = assetPath ?? _getPlatformAssetPath(platform);

    return Image.asset(
      path,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        // Fallback ke Material Icon jika asset tidak ditemukan
        IconData fallbackIcon;
        Color color;

        switch (platform) {
          case 'LinkedIn':
            fallbackIcon = Icons.business_center;
            color = Colors.blue.shade700;
            break;
          case 'Twitter':
            fallbackIcon = Icons.chat;
            color = Colors.lightBlue;
            break;
          case 'TikTok':
            fallbackIcon = Icons.music_note;
            color = Colors.black;
            break;
          default:
            fallbackIcon = Icons.link;
            color = const Color(0xFF0D6EFD);
        }

        return Icon(fallbackIcon, color: color, size: 24);
      },
    );
  }

  void _removeSocialMedia(int index) {
    setState(() {
      _additionalSocialMedia.removeAt(index);
    });
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        _submitRegistration();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_agreeToTerms) {
      _showError('Anda harus menyetujui Syarat penggunaan');
      return;
    }

    if (_kkFile == null) {
      _showError('Harap upload foto KK terlebih dahulu');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedDate = _registerService.formatDateForBackend(
        _tanggalLahirController.text,
      );

      final registerRequest = RegisterRequest(
        namaLengkap: _namaController.text.trim(),
        nik: _nikController.text.trim(),
        tanggalLahir: formattedDate,
        tempatLahir: _tempatLahirController.text.trim(),
        email: _emailController.text.trim(),
        nomorTelepon: _phoneController.text.trim(),
        instagram: _instagramController.text.trim().isNotEmpty
            ? _instagramController.text.trim()
            : null,
        facebook: _facebookController.text.trim().isNotEmpty
            ? _facebookController.text.trim()
            : null,
        alamat: _alamatController.text.trim(),
        kota: _kotaController.text.trim(),
        negara: _selectedCountry,
        kodePos: _kodePosController.text.trim(),
        rtRw: _rtRwController.text.trim(),
      );

      final response = await _registerService.register(
        registerRequest,
        filePath: _kkFile?.path,
      );

      _showSuccess('${response.message}! Mengarahkan ke login...');

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Step
            _buildStepHeader(
              icon: Icons.person_add_alt_1,
              title: 'Data Pribadi',
              subtitle: 'Langkah 1/3 - Isi data diri sesuai KTP/KK',
            ),

            const SizedBox(height: 32),

            // 🎯 INFO EMAIL PREFILLED (jika ada)
            if (widget.prefilledEmail != null &&
                widget.prefilledEmail!.isNotEmpty)
              _buildPrefilledEmailInfo(),

            // Form Fields
            _buildModernTextField(
              controller: _namaController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap sesuai KTP',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap harus diisi';
                }
                if (value.length < 3) {
                  return 'Nama lengkap minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // NIK dengan counter
            _buildTextFieldWithCounter(
              controller: _nikController,
              label: 'NIK',
              hint: '350165163316516',
              icon: Icons.credit_card,
              maxLength: 16,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK harus diisi';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'NIK harus berupa angka';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Tanggal Lahir
            _buildDateField(),

            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _tempatLahirController,
              label: 'Tempat Lahir',
              hint: 'Masukkan kota tempat lahir',
              icon: Icons.place_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat lahir harus diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            // Upload KK Section
            _buildFileUploadSection(),

            const SizedBox(height: 20),

            // Terms and Conditions
            _buildTermsSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Step
            _buildStepHeader(
              icon: Icons.contact_phone,
              title: 'Kontak & Media Sosial',
              subtitle: 'Langkah 2/3 - Informasi kontak Anda',
            ),

            const SizedBox(height: 32),

            // Kontak Section
            _buildSectionHeader(
              title: 'Informasi Kontak',
              subtitle: 'Pastikan email dan nomor telepon aktif',
            ),

            const SizedBox(height: 24),

            // Email Field - SUDAH TERISI OTOMATIS
            _buildContactField(
              controller: _emailController,
              label: 'Email',
              hint: 'contoh@gmail.com',
              icon: Icons.email_outlined,
              iconColor: const Color(0xFF0D6EFD),
              isPrefilled:
                  widget.prefilledEmail != null, // 🎯 Tandai sebagai prefilled
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email harus diisi';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Phone Field
            _buildContactField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hint: '+62 812-3456-7890',
              icon: Icons.phone_iphone,
              iconColor: Colors.green,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon harus diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Media Sosial Section
            _buildSectionHeader(
              title: 'Media Sosial (Opsional)',
              subtitle: 'Tautan media sosial untuk terhubung',
            ),

            const SizedBox(height: 24),

            // Instagram Field
            _buildSocialMediaField(
              controller: _instagramController,
              label: 'Instagram',
              hint: '@username',
              icon: Image.asset(
                'assets/images/instagram.png',
                width: 30,
                height: 30,
              ),
              iconColor: Colors.pink,
              isOptional: true,
            ),

            const SizedBox(height: 20),

            // Facebook Field
            _buildSocialMediaField(
              controller: _facebookController,
              label: 'Facebook',
              hint: 'nama.profile',
              icon: Image.asset(
                'assets/images/facebook.png',
                width: 30,
                height: 30,
              ),
              iconColor: Colors.blue,
              isOptional: true,
            ),
            const SizedBox(height: 20),

            // Additional Social Media
            ..._additionalSocialMedia.asMap().entries.map((entry) {
              final index = entry.key;
              final social = entry.value;

              if (social['controller'] is TextEditingController &&
                  social['platform'] is String) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildRemovableSocialMediaField(
                    controller: social['controller'],
                    label: social['platform'],
                    hint: 'Masukkan ${social['platform']}',
                    icon: _getSocialMediaFormIcon(
                      social['platform'],
                      social['assetPath'],
                    ),
                    iconColor: social['color'],
                    onRemove: () => _removeSocialMedia(index),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),

            const SizedBox(height: 20),

            // Add More Button
            _buildAddSocialMediaButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Step
            _buildStepHeader(
              icon: Icons.home_work,
              title: 'Alamat Tempat Tinggal',
              subtitle: 'Langkah 3/3 - Alamat sesuai domisili',
            ),

            const SizedBox(height: 32),

            // Alamat Section
            _buildSectionHeader(
              title: 'Detail Alamat',
              subtitle: 'Isi alamat lengkap tempat tinggal Anda',
            ),

            const SizedBox(height: 24),

            // Alamat Fields
            _buildModernTextField(
              controller: _alamatController,
              label: 'Alamat Lengkap',
              hint: 'Masukkan jalan, nomor rumah, dusun, dll.',
              icon: Icons.home_outlined,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat harus diisi';
                }
                if (value.length < 10) {
                  return 'Alamat terlalu pendek';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _kotaController,
              label: 'Kota/Kabupaten',
              hint: 'Masukkan kota atau kabupaten',
              icon: Icons.location_city_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kota harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Negara Field
            _buildCountryField(),

            const SizedBox(height: 20),

            // Kode Pos dengan counter
            _buildTextFieldWithCounter(
              controller: _kodePosController,
              label: 'Kode Pos',
              hint: '12345',
              icon: Icons.markunread_mailbox_outlined,
              maxLength: 5,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kode pos harus diisi';
                }
                if (value.length != 5) {
                  return 'Kode pos harus 5 digit';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildModernTextField(
              controller: _rtRwController,
              label: 'RT/RW',
              hint: 'Contoh: 001/002',
              icon: Icons.numbers_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'RT/RW harus diisi';
                }
                if (!RegExp(r'^[0-9]{3}/[0-9]{3}$').hasMatch(value)) {
                  return 'Format: 001/002 (3 digit RT dan RW)';
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            // Info penting
            _buildInfoSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🎯 WIDGET BARU: Info email prefilled
  Widget _buildPrefilledEmailInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D6EFD).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0D6EFD).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: const Color(0xFF0D6EFD), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email sudah terisi otomatis',
                  style: TextStyle(
                    color: const Color(0xFF0D6EFD),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lanjutkan mengisi data lainnya untuk menyelesaikan pendaftaran',
                  style: TextStyle(
                    color: const Color(0xFF0D6EFD).withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 UPDATE: Contact field dengan support prefilled
  Widget _buildContactField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool isPrefilled = false, // 🎯 Parameter baru
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isPrefilled) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EFD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Terisi otomatis',
                  style: TextStyle(
                    color: const Color(0xFF0D6EFD),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrefilled
                  ? const Color(0xFF0D6EFD).withOpacity(0.5)
                  : Colors.grey.shade400,
              width: isPrefilled ? 1.5 : 1,
            ),
            color: isPrefilled
                ? const Color(0xFF0D6EFD).withOpacity(0.05)
                : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: isPrefilled ? const Color(0xFF0D6EFD) : iconColor,
                  size: 22,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
                  style: TextStyle(
                    fontSize: 16,
                    color: isPrefilled
                        ? const Color(0xFF0D6EFD)
                        : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: isPrefilled
                          ? const Color(0xFF0D6EFD).withOpacity(0.6)
                          : Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Reusable Widget Components (tetap sama seperti sebelumnya)
  Widget _buildStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0D6EFD).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D6EFD),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: maxLines > 1 ? 70 : 50,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 16),
                child: Icon(icon, color: Colors.grey.shade600, size: 20),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
                  maxLines: maxLines,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithCounter({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int maxLength,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              '${controller.text.length}/$maxLength',
              style: TextStyle(
                fontSize: 12,
                color: controller.text.length == maxLength
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.grey.shade600, size: 20),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  buildCounter:
                      (
                        BuildContext context, {
                        int? currentLength,
                        int? maxLength,
                        bool? isFocused,
                      }) => null,
                  validator: validator,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _tanggalLahirController,
                    enabled: false,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'DD.MM.YYYY',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade500,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EFD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF0D6EFD),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dokumen KK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Format: PDF, JPG, JPEG, PNG (Maks. 5MB)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickKKFile,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _kkFile != null
                      ? const Color(0xFF0D6EFD)
                      : Colors.grey.shade400,
                  width: _kkFile != null ? 2 : 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
                color: _kkFile != null
                    ? const Color(0xFF0D6EFD).withOpacity(0.05)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _kkFile != null
                        ? Icons.check_circle
                        : Icons.cloud_upload_outlined,
                    size: 48,
                    color: _kkFile != null
                        ? const Color(0xFF0D6EFD)
                        : Colors.grey.shade500,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _kkFile != null
                        ? 'File Berhasil Diupload'
                        : 'Klik untuk Upload KK',
                    style: TextStyle(
                      color: _kkFile != null
                          ? const Color(0xFF0D6EFD)
                          : Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_kkFile != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Tap untuk mengganti file',
                      style: TextStyle(
                        color: const Color(0xFF0D6EFD).withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0D6EFD)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Theme(
              data: ThemeData(unselectedWidgetColor: Colors.transparent),
              child: Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
                activeColor: const Color(0xFF0D6EFD),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Saya setuju dengan '),
                  TextSpan(
                    text: 'Syarat & Ketentuan ',
                    style: TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: 'yang berlaku'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSocialMediaField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Widget icon, // Ubah dari IconData ke Widget
    Color? iconColor, // Opsional sekarang
    required bool isOptional,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isOptional)
              const Text(
                ' (Opsional)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: icon,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemovableSocialMediaField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Widget icon,
    Color? iconColor,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                child: icon,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddSocialMediaButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0D6EFD), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _addSocialMedia,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 20, color: const Color(0xFF0D6EFD)),
              const SizedBox(width: 8),
              Text(
                'Tambah Media Sosial Lainnya',
                style: TextStyle(
                  color: const Color(0xFF0D6EFD),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Negara',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectCountry,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCountry,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pastikan semua data yang diisi sudah benar dan sesuai dengan dokumen resmi',
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Warga Kita dengan gradient biru
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D6EFD), Color(0xFF0A58CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D6EFD).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/Vector.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                color: Colors.white, // Opsional: force color putih jika perlu
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'WARGA KITA',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: () {
              // Akan diimplementasikan fungsi help
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : Column(
              children: [
                // Progress Bar
                _buildProgressBar(),

                // Step Indicators
                _buildStepIndicators(),

                // Content
                Expanded(
                  child: IndexedStack(
                    index: _currentStep,
                    children: [_buildStep1(), _buildStep2(), _buildStep3()],
                  ),
                ),

                // Navigation Buttons
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Mendaftarkan akun...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah ${_currentStep + 1} dari 3',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${((_currentStep + 1) / 3 * 100).round()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D6EFD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey.shade300,
            color: const Color(0xFF0D6EFD),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStepIndicator(0, 'Data Pribadi'),
          _buildStepIndicator(1, 'Kontak'),
          _buildStepIndicator(2, 'Alamat'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF0D6EFD)
                : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: (isActive || isCompleted)
                ? [
                    BoxShadow(
                      color: const Color(0xFF0D6EFD).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    (stepIndex + 1).toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF0D6EFD) : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Kembali',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentStep == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == 2 ? 'Selesai' : 'Lanjut',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_currentStep < 2) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help, color: Color(0xFF0D6EFD)),
            SizedBox(width: 8),
            Text('Bantuan Pendaftaran'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panduan Pengisian Form:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Pastikan data sesuai dengan dokumen resmi'),
            Text('• NIK harus 16 digit angka'),
            Text('• Upload foto KK yang jelas dan terbaca'),
            Text('• Email dan nomor telepon harus aktif'),
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
}
