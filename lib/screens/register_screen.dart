import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/register_service.dart';
import '../models/register_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    // Set default values untuk testing
    _emailController.text = 'BudiStyawan22@gmail.com';
    _phoneController.text = '+62 555 555-1234';
    _instagramController.text = '@Budi_22';
    _facebookController.text = '@profile';
    _alamatController.text = 'Jalan Danau Ranau II, Kedungkandang, Malang';
    _kotaController.text = 'Malang';
    _kodePosController.text = '66229';
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
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _kkFile = File(image.path);
        });
        _showSuccess('Foto KK berhasil diupload');

        // Debug info
        print('📁 File selected: ${image.path}');
        print('📁 File size: ${_kkFile?.lengthSync()} bytes');
      } else {
        print('⚠️ No file selected');
      }
    } catch (e) {
      print('❌ Error picking file: $e');
      _showError(
        'Gagal memilih file. Pastikan aplikasi memiliki izin akses storage.',
      );

      // Show more detailed error for debugging
      if (e.toString().contains('permission')) {
        _showError(
          'Izin akses storage ditolak. Silakan berikan izin di pengaturan aplikasi.',
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari negara...',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      // Bisa ditambahkan fungsi search jika diperlukan
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
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
              ],
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

    setState(() => _isLoading = true);

    try {
      // Format tanggal untuk backend (YYYY-MM-DD)
      final formattedDate = _registerService.formatDateForBackend(
        _tanggalLahirController.text,
      );

      // Prepare request data
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

      print('📤 Sending registration data to backend...');

      // Send registration request
      final response = await _registerService.register(
        registerRequest,
        filePath: _kkFile?.path,
      );

      _showSuccess('${response.message}! Mengarahkan ke login...');

      // Tunggu sebentar lalu kembali ke login
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

            // Info Section - Design lebih premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0D6EFD).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D6EFD).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                          Icons.info_outline,
                          color: Color(0xFF0D6EFD),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Info Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Isi data untuk profil. Ini akan memakan waktu beberapa menit. Anda hanya perlu KTP / KK.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0D6EFD),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0D6EFD)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.transparent,
                            ),
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF0D6EFD),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Saya setuju dengan Syarat penggunaan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Data Pribadi Section
            const Text(
              'Data Pribadi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sebutkan persis seperti di KTP / KK Anda',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 28),

            // Form Fields dengan design lebih baik
            _buildModernTextField(
              controller: _namaController,
              label: 'Nama Lengkap',
              hint: 'Budi Styawan',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _nikController,
              label: 'NIK',
              hint: '350165163316516',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK harus diisi';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Tanggal Lahir dengan Date Picker
            Column(
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
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: '12.05.1992',
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
            ),

            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _tempatLahirController,
              label: 'Tempat Lahir',
              hint: 'Kedungkandang, Malang',
              icon: Icons.place_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat lahir harus diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            // Upload KK Section - Design lebih premium
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Foto KK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Unggah foto KK yang jelas dan terbaca',
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                                : 'Klik untuk Upload',
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
            ),
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

            // Info Section - Design premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0D6EFD).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D6EFD).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                          Icons.info_outline,
                          color: Color(0xFF0D6EFD),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Info Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Isi data untuk profil. Ini akan memakan waktu beberapa menit. Anda hanya perlu KTP / KK.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0D6EFD),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Data Pribadi Section
            const Text(
              'Data Pribadi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sebutkan persis seperti di KTP / KK Anda',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 28),

            // Email Field dengan design lebih baik
            _buildContactField(
              controller: _emailController,
              label: 'Email',
              hint: 'BudiStyawan22@gmail.com',
              icon: Icons.email_outlined,
              iconColor: const Color(0xFF0D6EFD),
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

            // Phone Field dengan design lebih baik
            _buildContactField(
              controller: _phoneController,
              label: 'Nomor Telepon',
              hint: '+62 555 555-1234',
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
            const Text(
              'Media Sosial',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tunjukkan metode komunikasi yang diinginkan',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 28),

            // Instagram Field dengan design lebih baik
            _buildSocialMediaField(
              controller: _instagramController,
              label: 'Instagram',
              hint: '@Budi_22',
              icon: Icons.chat_bubble_outline,
              iconColor: Colors.purple,
              isOptional: true,
            ),

            const SizedBox(height: 20),

            // Facebook Field dengan design lebih baik
            _buildSocialMediaField(
              controller: _facebookController,
              label: 'Facebook',
              hint: '@profile',
              icon: Icons.link,
              iconColor: Colors.blue,
              isOptional: true,
            ),

            const SizedBox(height: 20),

            // Add More Button - Design lebih premium
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0D6EFD), width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: const Color(0xFF0D6EFD),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tambah Lainnya',
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
            ),
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

            // Info Section - Design premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F4FD), Color(0xFFF0F8FF)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0D6EFD).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D6EFD).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                          Icons.info_outline,
                          color: Color(0xFF0D6EFD),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Info Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Isi data untuk profil. Ini akan memakan waktu beberapa menit. Anda hanya perlu KTP / KK.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0D6EFD),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Divider - Design lebih baik
            Container(
              height: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),

            // Alamat Section
            const Text(
              'Alamat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Digunakan untuk data alamat anda.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 28),

            // Alamat Fields dengan design lebih baik
            _buildModernTextField(
              controller: _alamatController,
              label: 'Alamat',
              hint: 'Jalan Danau Ranau II, Kedungkandang, Malang',
              icon: Icons.home_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _kotaController,
              label: 'Kota',
              hint: 'Malang',
              icon: Icons.location_city_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kota harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Negara Field - Bisa dipilih
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
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

            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _kodePosController,
              label: 'Kode pos',
              hint: '66229',
              icon: Icons.markunread_mailbox_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kode pos harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildModernTextField(
              controller: _rtRwController,
              label: 'RT / RW',
              hint: '001/002',
              icon: Icons.numbers_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'RT/RW harus diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
                  validator: validator,
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

  Widget _buildContactField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 22),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
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

  Widget _buildSocialMediaField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    bool isOptional = false,
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
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 22),
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
        elevation: 0,
        title: const Text(
          'WARGA KITA',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Mendaftarkan akun...'),
                ],
              ),
            )
          : Column(
              children: [
                // Progress Indicator yang lebih modern
                Container(
                  height: 6,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Expanded(
                        flex: _currentStep + 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0D6EFD), Color(0xFF1E88E5)],
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3 - _currentStep,
                        child: Container(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Step Title - Design lebih baik
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStepIndicator(0, 'Data Pribadi'),
                      _buildStepIndicator(1, 'Kontak'),
                      _buildStepIndicator(2, 'Alamat'),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Content
                Expanded(
                  child: IndexedStack(
                    index: _currentStep,
                    children: [_buildStep1(), _buildStep2(), _buildStep3()],
                  ),
                ),

                // Navigation Buttons - Design lebih premium
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 15,
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
                            child: const Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
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
                            shadowColor: const Color(
                              0xFF0D6EFD,
                            ).withOpacity(0.3),
                          ),
                          child: Text(
                            _currentStep == 2 ? 'Simpan' : 'Lanjut →',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF0D6EFD)
                : Colors.grey.shade300,
            shape: BoxShape.circle,
            boxShadow: (isActive || isCompleted)
                ? [
                    BoxShadow(
                      color: const Color(0xFF0D6EFD).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    (stepIndex + 1).toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF0D6EFD) : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
