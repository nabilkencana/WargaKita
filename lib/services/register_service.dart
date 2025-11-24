// services/register_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/register_model.dart';

class RegisterService {
  static const String baseUrl =
      'https://wargakita.canadev.my.id'; // iOS simulator

  Future<RegisterResponse> register(
    RegisterRequest request, {
    String? filePath,
  }) async {
    try {
      print('🚀 Starting registration process...');

      var uri = Uri.parse('$baseUrl/users/register');
      var requestHttp = http.MultipartRequest('POST', uri);

      // Add form fields
      requestHttp.fields.addAll({
        'namaLengkap': request.namaLengkap,
        'nik': request.nik,
        'tanggalLahir': request.tanggalLahir,
        'tempatLahir': request.tempatLahir,
        'email': request.email,
        'nomorTelepon': request.nomorTelepon,
        'alamat': request.alamat,
        'kota': request.kota,
        'negara': request.negara,
        'kodePos': request.kodePos,
        'rtRw': request.rtRw,
      });

      // Add optional social media fields
      if (request.instagram != null) {
        requestHttp.fields['instagram'] = request.instagram!;
      }
      if (request.facebook != null) {
        requestHttp.fields['facebook'] = request.facebook!;
      }

      // Add file if exists
      if (filePath != null && filePath.isNotEmpty) {
        try {
          var file = await http.MultipartFile.fromPath(
            'kkFile',
            filePath,
            contentType: MediaType('image', 'jpeg'),
          );
          requestHttp.files.add(file);
          print('📎 File attached: $filePath');
        } catch (e) {
          print('⚠️ Failed to attach file: $e');
          // Continue without file if there's an error
        }
      }

      print('📤 Sending registration data...');
      print('   👤 Nama: ${request.namaLengkap}');
      print('   📧 Email: ${request.email}');
      print('   🔢 NIK: ${request.nik}');
      print('   📞 Telp: ${request.nomorTelepon}');

      var streamedResponse = await requestHttp.send().timeout(
        const Duration(seconds: 30),
      );
      var response = await http.Response.fromStream(streamedResponse);

      print('📡 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Registration successful!');
        return RegisterResponse.fromJson(responseData);
      } else {
        final error = json.decode(response.body);
        final errorMessage =
            error['message'] ??
            'Gagal mendaftar (Error ${response.statusCode})';
        print('❌ Registration failed: $errorMessage');

        // Handle specific error cases
        if (response.statusCode == 409) {
          throw Exception(errorMessage); // Conflict - email/NIK sudah terdaftar
        } else if (response.statusCode == 400) {
          throw Exception(errorMessage); // Bad request
        } else if (response.statusCode == 500) {
          throw Exception('Server error. Silakan coba lagi nanti.');
        } else {
          throw Exception(errorMessage);
        }
      }
    } on http.ClientException catch (e) {
      print('🌐 Network error: $e');
      throw Exception('Koneksi internet bermasalah. Periksa koneksi Anda.');
    } on TimeoutException {
      print('⏰ Request timeout');
      throw Exception('Timeout - server tidak merespons. Silakan coba lagi.');
    } catch (e) {
      print('💥 Registration error: $e');
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Validasi format tanggal untuk backend (YYYY-MM-DD)
  String formatDateForBackend(String date) {
    try {
      // Convert from DD.MM.YYYY to YYYY-MM-DD
      final parts = date.split('.');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return date;
    } catch (e) {
      print('⚠️ Error formatting date: $e');
      return date;
    }
  }

  // Validasi NIK (16 digit)
  bool isValidNik(String nik) {
    return nik.length == 16 && RegExp(r'^[0-9]+$').hasMatch(nik);
  }

  // Validasi email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
