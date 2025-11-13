// laporan_screen.dart
import 'dart:io';
import 'dart:html' as html; // Untuk web
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../models/laporan_model.dart';
import '../services/laporan_service.dart';

class LaporanScreen extends StatefulWidget {
  final User user;

  const LaporanScreen({super.key, required this.user});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedKategori = 'Infrastruktur';
  bool _isLoading = false;
  File? _imageFile;
  String? _imageUrl; // Untuk web
  Uint8List? _imageBytes; // Untuk web preview

  final List<String> _kategoriList = [
    'Infrastruktur',
    'Kebersihan',
    'Keamanan',
    'Lingkungan',
    'Lainnya',
  ];

  List<Color> get _kategoriColors => [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.teal.shade50,
    Colors.purple.shade50,
  ];

  List<Color> get _kategoriBorderColors => [
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.orange.shade200,
    Colors.teal.shade200,
    Colors.purple.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    final hasImage = kIsWeb ? _imageBytes != null : _imageFile != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header hijau full lebar
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Card Container untuk form
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Section
                            _buildSectionTitle(
                              icon: Icons.description_outlined,
                              title: 'Informasi Laporan',
                              subtitle: 'Isi detail laporan Anda',
                            ),

                            const SizedBox(height: 24),

                            // Kategori dengan chips yang lebih menarik
                            _buildKategoriSection(),
                            const SizedBox(height: 24),

                            // Judul
                            _buildTextField(
                              controller: _judulController,
                              label: 'Judul Laporan',
                              hintText: 'Contoh: Jalan Rusak di RT 05',
                              icon: Icons.title,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 20),

                            // Deskripsi
                            _buildTextField(
                              controller: _deskripsiController,
                              label: 'Deskripsi Lengkap',
                              hintText:
                                  'Jelaskan masalah atau saran secara detail...\n\nContoh: Terdapat lubang besar di jalan utama RT 05 yang membahayakan pengendara, terutama pada malam hari.',
                              icon: Icons.description,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 24),

                            // Upload Foto dengan kompatibilitas web
                            _buildPhotoUploadSection(hasImage: hasImage),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit Button dengan animasi
                      _buildSubmitButton(),
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

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade800.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buat Laporan',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sampaikan keluhan atau saran Anda untuk perbaikan',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.green.shade700, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriSection() {
    final kategoriColors = _kategoriColors;
    final kategoriBorderColors = _kategoriBorderColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Laporan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_kategoriList.length, (index) {
            final kategori = _kategoriList[index];
            final isSelected = _selectedKategori == kategori;

            final color = index < kategoriColors.length
                ? kategoriColors[index]
                : Colors.grey.shade50;

            final borderColor = index < kategoriBorderColors.length
                ? kategoriBorderColors[index]
                : Colors.grey.shade300;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedKategori = kategori;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.grey.shade50,
                  border: Border.all(
                    color: isSelected ? borderColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: borderColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getKategoriIcon(kategori),
                      size: 16,
                      color: isSelected ? borderColor : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      kategori,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.black87
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Icon(icon, color: Colors.green.shade600, size: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field ini harus diisi';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection({required bool hasImage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Pendukung (Opsional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImageFromGallery,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: hasImage ? 200 : 120,
            decoration: BoxDecoration(
              color: hasImage ? Colors.green.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasImage ? Colors.green.shade300 : Colors.grey.shade300,
                width: hasImage ? 2 : 1,
              ),
            ),
            child: hasImage
                ? Stack(
                    children: [
                      // Preview gambar dengan kompatibilitas web
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.memory(
                                _imageBytes!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _imageFile!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                      // Overlay dengan informasi
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Foto Terpilih',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap untuk mengganti foto',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Tombol hapus
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _clearImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap untuk memilih foto',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dari galeri - Maks. 5MB',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        // Tombol untuk kamera (hanya untuk mobile)
        if (!kIsWeb) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImageFromCamera,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade600,
                    side: BorderSide(color: Colors.green.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.camera_alt, size: 18),
                  label: Text(
                    'Ambil Foto dengan Kamera',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isLoading
            ? []
            : [
                BoxShadow(
                  color: Colors.green.shade400.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitLaporan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          disabledBackgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Mengirim...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Kirim Laporan',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Infrastruktur':
        return Icons.construction;
      case 'Kebersihan':
        return Icons.clean_hands;
      case 'Keamanan':
        return Icons.security;
      case 'Lingkungan':
        return Icons.nature;
      case 'Lainnya':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        // Untuk Web
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((e) {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            final file = files[0];
            final reader = html.FileReader();

            reader.onLoadEnd.listen((e) {
              setState(() {
                _imageBytes = reader.result as Uint8List?;
                _imageUrl = null;
              });
            });

            reader.readAsArrayBuffer(file);
          }
        });
      } else {
        // Untuk Mobile
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      _showErrorDialog('Gagal memilih gambar dari galeri: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      // Hanya untuk mobile, web tidak support camera
      if (!kIsWeb) {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      _showErrorDialog('Gagal mengambil foto dengan kamera: $e');
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
      _imageBytes = null;
      _imageUrl = null;
    });
  }

  void _submitLaporan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Laporan laporanBaru = Laporan(
          title: _judulController.text,
          description: _deskripsiController.text,
          category: _selectedKategori,
          userId: widget.user.id,
        );

        // TODO: Upload gambar ke server (baik untuk web maupun mobile)
        if ((kIsWeb && _imageBytes != null) ||
            (!kIsWeb && _imageFile != null)) {
          // Implementasi upload gambar ke backend
          // String imageUrl = await uploadImageToServer(_imageFile! atau _imageBytes!);
          // laporanBaru.imageUrl = imageUrl;
        }

        await LaporanService.createLaporan(laporanBaru);
        _showSuccessDialog();
      } catch (e) {
        _showErrorDialog('Gagal mengirim laporan: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Laporan Terkirim!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Laporan Anda telah berhasil dikirim dan akan segera diproses oleh tim kami.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _clearForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Buat Laporan Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600),
            const SizedBox(width: 8),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: TextStyle(color: Colors.green.shade600),
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _judulController.clear();
    _deskripsiController.clear();
    setState(() {
      _selectedKategori = 'Infrastruktur';
      _imageFile = null;
      _imageBytes = null;
      _imageUrl = null;
    });
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}
