import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl =
      'http://localhost:3000'; // Ganti dengan URL backend Anda

  Future<OtpResponse> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengirim OTP');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<AuthResponse> verifyOtp(String email, String otp) async {
    try {
      print('🚀 Starting OTP verification...');
      print('📧 Email: $email');
      print('🔢 OTP: $otp');
      print('🌐 URL: $baseUrl/auth/verify-otp');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(const Duration(seconds: 15));

      print('📡 Response Status Code: ${response.statusCode}');
      print('📦 Response Headers: ${response.headers}');
      print('📦 Full Response Body: ${response.body}');

      // Parse response body terlebih dahulu
      final responseBody = response.body;
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        print('✅ OTP verification successful on server');
        
        // DEBUG: Print struktur response
        print('🔍 Response structure:');
        responseData.forEach((key, value) {
          print('   $key: $value (${value.runtimeType})');
        });

        // Handle berbagai kemungkinan struktur response
        return _parseAuthResponse(responseData);
      } else {
        final errorMessage = responseData['message'] ?? 
        responseData['error'] ?? 
        'OTP verification failed with status ${response.statusCode}';
        print('❌ OTP verification failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } on FormatException catch (e) {
      print('❌ JSON Format Error: $e');
      throw Exception('Format response tidak valid dari server');
    } on http.ClientException catch (e) {
      print('🌐 Network Error: $e');
      throw Exception('Koneksi internet bermasalah: $e');
    } on TimeoutException {
      print('⏰ Request Timeout');
      throw Exception('Timeout - server tidak merespons');
    } catch (e) {
      print('💥 Unexpected Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Method untuk parsing response yang flexible
  AuthResponse _parseAuthResponse(Map<String, dynamic> responseData) {
    print('🔄 Parsing auth response...');
    
    // Debug: print semua keys yang ada
    print('🔑 Available keys: ${responseData.keys.toList()}');

    // Handle berbagai kemungkinan struktur user data
    User? user;
    
    if (responseData['user'] != null) {
      if (responseData['user'] is Map<String, dynamic>) {
        try {
          user = User.fromJson(responseData['user']);
          print('✅ User data parsed successfully');
        } catch (e) {
          print('⚠️ Error parsing user data: $e');
          // Create fallback user
          user = _createFallbackUser(responseData);
        }
      } else {
        print('⚠️ User data is not a Map, creating fallback');
        user = _createFallbackUser(responseData);
      }
    } else {
      print('⚠️ No user data in response, creating fallback');
      user = _createFallbackUser(responseData);
    }

    // Handle message field
    String message = responseData['message'] ?? 
                    responseData['msg'] ?? 
                    'Login berhasil';

    // Handle access token
    String? accessToken = responseData['access_token'] ?? 
    responseData['accessToken'] ?? 
    responseData['token'];

    print('📝 Final parsed data:');
    print('   Message: $message');
    print('   Access Token: ${accessToken != null ? '✓' : '✗'}');
    print('   User: ${user != null ? '✓' : '✗'}');

    return AuthResponse(
      message: message,
      user: user,
      accessToken: accessToken,
    );
  }

  // Create fallback user jika parsing gagal
  User _createFallbackUser(Map<String, dynamic> responseData) {
    return User(
      id: responseData['userId']?.toString() ?? 
          responseData['id']?.toString() ?? 
          'user_${DateTime.now().millisecondsSinceEpoch}',
      email: responseData['email']?.toString() ?? 'unknown@email.com',
      name: responseData['name']?.toString() ?? 
            responseData['namaLengkap']?.toString() ?? 
            'User',
      role: responseData['role']?.toString() ?? 'user',
    );
  }

  Future<void> resendOtp(String email) async {
    try {
      print('🔄 Resending OTP to: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      ).timeout(const Duration(seconds: 15));

      print('📡 Resend OTP Response: ${response.statusCode}');
      print('📦 Resend OTP Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ OTP resent successfully');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengirim ulang OTP');
      }
    } catch (e) {
      print('❌ Resend OTP error: $e');
      throw Exception('Gagal mengirim ulang OTP: $e');
    }
  }
}

