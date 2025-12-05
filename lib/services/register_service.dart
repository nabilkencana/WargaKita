// services/register_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/register_model.dart';

class RegisterService {
  static const String baseUrl =
      'https://wargakita.canadev.my.id'; // Ganti dengan URL backend Anda

  Future<RegisterResponse> register(
    RegisterRequest request, {
    required String? filePath,
  }) async {
    try {
      print('🚀 Starting registration process...');

      var uri = Uri.parse('$baseUrl/users/register');
      var requestMultipart = http.MultipartRequest('POST', uri);

      // Add headers
      requestMultipart.headers['Accept'] = 'application/json';

      // Add form fields - SESUAI DENGAN BACKEND NESTJS
      requestMultipart.fields.addAll({
        'namaLengkap': request.namaLengkap,
        'nik': request.nik,
        'tanggalLahir': request.tanggalLahir, // Format: YYYY-MM-DD
        'tempatLahir': request.tempatLahir,
        'email': request.email,
        'nomorTelepon': request.nomorTelepon,
        'alamat': request.alamat,
        'kota': request.kota,
        'negara': request.negara,
        'kodePos': request.kodePos,
        'rtRw': request.rtRw,
      });

      // Add optional social media fields - handle null values
      if (request.instagram != null && request.instagram!.isNotEmpty) {
        requestMultipart.fields['instagram'] = request.instagram!;
      }
      if (request.facebook != null && request.facebook!.isNotEmpty) {
        requestMultipart.fields['facebook'] = request.facebook!;
      }

      // 🎯 ADD FILE UPLOAD TO CLOUDINARY
      if (filePath != null && await File(filePath).exists()) {
        try {
          final file = File(filePath);
          final fileStream = http.ByteStream(file.openRead());
          final fileLength = await file.length();

          // Determine content type based on file extension
          final contentType = _getContentType(filePath);

          var multipartFile = http.MultipartFile(
            'kkFile', // 🎯 SESUAI DENGAN FIELD NAME DI BACKEND
            fileStream,
            fileLength,
            filename: _generateFileName(request.nik, filePath),
            contentType: contentType,
          );

          requestMultipart.files.add(multipartFile);
          print(
            '📎 File attached: ${file.path} (${(fileLength / 1024 / 1024).toStringAsFixed(2)} MB)',
          );
        } catch (e) {
          print('⚠️ Failed to attach file: $e');
          throw Exception('Gagal mengupload file KK: $e');
        }
      } else {
        print('📎 No file attached or file not found');
      }

      // Debug print request data
      print('📤 Sending registration data to: $uri');
      print('   👤 Nama: ${request.namaLengkap}');
      print('   📧 Email: ${request.email}');
      print('   🔢 NIK: ${request.nik}');
      print('   📞 Telp: ${request.nomorTelepon}');
      print('   🎂 Tanggal Lahir: ${request.tanggalLahir}');
      print('   📍 Tempat Lahir: ${request.tempatLahir}');
      print('   🏠 Alamat: ${request.alamat}');
      print('   🏙️ Kota: ${request.kota}');
      print('   🇮🇩 Negara: ${request.negara}');
      print('   📮 Kode Pos: ${request.kodePos}');
      print('   🏘️ RT/RW: ${request.rtRw}');
      print('   📷 Instagram: ${request.instagram ?? "Tidak diisi"}');
      print('   👥 Facebook: ${request.facebook ?? "Tidak diisi"}');

      // Send request with timeout
      var streamedResponse = await requestMultipart.send().timeout(
        const Duration(seconds: 60), // Increase timeout for file upload
      );

      // Get response
      var response = await http.Response.fromStream(streamedResponse);

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      // Handle response
      if (response.statusCode.toString().startsWith('2')) {
        final responseData = json.decode(response.body);
        print('✅ Registration successful!');
        return RegisterResponse.fromJson(responseData);
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ??
            errorResponse['error'] ??
            'Gagal mendaftar (Error ${response.statusCode})';

        print('❌ Registration failed: $errorMessage');

        // Handle specific HTTP status codes
        switch (response.statusCode) {
          case 400:
            throw Exception(errorMessage); // Bad Request
          case 409:
            throw Exception(
              errorMessage,
            ); // Conflict - email/NIK sudah terdaftar
          case 413:
            throw Exception(
              'File terlalu besar. Maksimal 5MB.',
            ); // Payload Too Large
          case 415:
            throw Exception(
              'Format file tidak didukung. Gunakan JPG, PNG, atau PDF.',
            ); // Unsupported Media Type
          case 500:
            throw Exception('Server error. Silakan coba lagi nanti.');
          case 502:
            throw Exception(
              'Server sedang maintenance. Silakan coba lagi nanti.',
            );
          default:
            throw Exception(errorMessage);
        }
      }
    } on http.ClientException catch (e) {
      print('🌐 Network error: $e');
      throw Exception(
        'Koneksi internet bermasalah. Periksa koneksi Anda dan coba lagi.',
      );
    } on TimeoutException catch (e) {
      print('⏰ Request timeout: $e');
      throw Exception('Timeout - server tidak merespons. Silakan coba lagi.');
    } on SocketException catch (e) {
      print('🔌 Socket error: $e');
      throw Exception(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } catch (e) {
      print('💥 Unexpected error: $e');
      throw Exception('Terjadi kesalahan tidak terduga: ${e.toString()}');
    }
  }

  // 🎯 Helper method to generate filename for Cloudinary
  String _generateFileName(String nik, String filePath) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = filePath.split('.').last.toLowerCase();
    return 'KK_${nik}_$timestamp.$extension';
  }

  // 🎯 Helper method to get content type
  MediaType _getContentType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  // 🎯 Validasi file sebelum upload
  String? validateFile(File? file) {
    if (file == null) {
      return 'File KK harus diupload';
    }

    // Check file size (max 5MB)
    const maxSize = 5 * 1024 * 1024; // 5MB in bytes
    final fileSize = file.lengthSync();
    if (fileSize > maxSize) {
      return 'Ukuran file maksimal 5MB. File Anda: ${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }

    // Check file extension
    final allowedExtensions = ['.pdf', '.jpg', '.jpeg', '.png'];
    final fileExtension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains('.$fileExtension')) {
      return 'Format file harus PDF, JPG, JPEG, atau PNG';
    }

    return null;
  }

  // 🎯 Format tanggal dari DD.MM.YYYY ke YYYY-MM-DD untuk backend
  String formatDateForBackend(String date) {
    try {
      // Handle various date formats
      if (date.contains('.')) {
        // Format: DD.MM.YYYY
        final parts = date.split('.');
        if (parts.length == 3) {
          final day = parts[0].padLeft(2, '0');
          final month = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$year-$month-$day';
        }
      } else if (date.contains('/')) {
        // Format: DD/MM/YYYY
        final parts = date.split('/');
        if (parts.length == 3) {
          final day = parts[0].padLeft(2, '0');
          final month = parts[1].padLeft(2, '0');
          final year = parts[2];
          return '$year-$month-$day';
        }
      }
      // If already in YYYY-MM-DD format or other, return as is
      return date;
    } catch (e) {
      print('⚠️ Error formatting date: $e');
      return date;
    }
  }

  // 🎯 Validasi NIK (16 digit angka)
  bool isValidNik(String nik) {
    if (nik.length != 16) return false;
    return RegExp(r'^[0-9]+$').hasMatch(nik);
  }

  // 🎯 Validasi email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // 🎯 Validasi nomor telepon
  bool isValidPhone(String phone) {
    // Basic phone validation - adjust based on your requirements
    final cleanedPhone = phone.replaceAll(RegExp(r'[+\-\s]'), '');
    return RegExp(r'^[0-9]{9,15}$').hasMatch(cleanedPhone);
  }

  // 🎯 Validasi kode pos (5 digit)
  bool isValidPostalCode(String postalCode) {
    return RegExp(r'^[0-9]{5}$').hasMatch(postalCode);
  }

  // 🎯 Validasi RT/RW format (001/002)
  bool isValidRtRw(String rtRw) {
    return RegExp(r'^[0-9]{3}/[0-9]{3}$').hasMatch(rtRw);
  }
}
