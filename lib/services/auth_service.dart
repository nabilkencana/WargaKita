// services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://wargakita.canadev.my.id';

  // Initialize Google Sign In
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Client ID akan auto-detected berdasarkan platform
  );

  // 🔐 OTP METHODS
  Future<OtpResponse> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode.toString().startsWith('2')) {
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
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/verify-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({'email': email, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 15));

      final responseData = json.decode(response.body);

      if (response.statusCode.toString().startsWith("2")) {
        return _parseAuthResponse(responseData);
      } else {
        final errorMessage =
            responseData['message'] ?? 'OTP verification failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // 🔐 REAL GOOGLE SIGN IN
  Future<AuthResponse> signInWithGoogle() async {
    try {
      print('🔐 Starting real Google Sign In...');

      // Sign out dulu untuk clear session sebelumnya
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in dibatalkan oleh user');
      }

      print('✅ Google user selected: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('🔑 Google auth completed');
      print('   ID Token: ${googleAuth.idToken != null ? '✓' : '✗'}');
      print('   Access Token: ${googleAuth.accessToken != null ? '✓' : '✗'}');

      // Send to backend dengan ID Token (recommended untuk security)
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/google/mobile'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'idToken':
                  googleAuth.idToken, // Gunakan ID Token untuk verification
              'accessToken': googleAuth.accessToken, // Backup
              'email': googleUser.email,
              'name': googleUser.displayName,
              'picture': googleUser.photoUrl,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 Backend response status: ${response.statusCode}');
      print('📦 Backend response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Real Google login successful');

        return _parseAuthResponse(responseData);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Gagal login dengan Google';
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('🌐 Network error: $e');
      throw Exception('Koneksi internet bermasalah');
    } on TimeoutException {
      print('⏰ Request timeout');
      throw Exception('Timeout - server tidak merespons');
    } catch (error) {
      print('💥 Real Google sign in error: $error');

      // Handle specific Google Sign In errors
      if (error.toString().contains('sign_in_failed')) {
        throw Exception(
          'Google Sign In gagal. Pastikan Google Play Services terinstall dan updated.',
        );
      } else if (error.toString().contains('network_error')) {
        throw Exception('Koneksi internet bermasalah');
      } else if (error.toString().contains('INVALID_ACCOUNT')) {
        throw Exception('Akun Google tidak valid');
      }

      throw Exception('Gagal login dengan Google: $error');
    }
  }

  // Check if user already signed in
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return await _googleSignIn.currentUser;
  }

  // Sign out from Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    print('✅ Signed out from Google');
  }

  // Method untuk parsing response
  AuthResponse _parseAuthResponse(Map<String, dynamic> responseData) {
    User? user;

    if (responseData['user'] != null &&
        responseData['user'] is Map<String, dynamic>) {
      try {
        user = User.fromJson(responseData['user']);
        print('✅ User data parsed: ${user.name}');
      } catch (e) {
        print('⚠️ Error parsing user data: $e');
        user = _createFallbackUser(responseData);
      }
    } else {
      user = _createFallbackUser(responseData);
    }

    String message = responseData['message'] ?? 'Login berhasil';
    String? accessToken =
        responseData['access_token'] ?? responseData['accessToken'];

    print('🔑 Access Token: ${accessToken != null ? '✓' : '✗'}');

    return AuthResponse(message: message, user: user, accessToken: accessToken);
  }

  User _createFallbackUser(Map<String, dynamic> responseData) {
    return User(
      id:
          responseData['userId']?.toString() ??
          'user_${DateTime.now().millisecondsSinceEpoch}',
      email: responseData['email']?.toString() ?? 'unknown@email.com',
      name: responseData['name']?.toString() ?? 'Google User',
      role: responseData['role']?.toString() ?? 'user',
    );
  }

  Future<void> resendOtp(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengirim ulang OTP');
      }
    } catch (e) {
      throw Exception('Gagal mengirim ulang OTP: $e');
    }
  }
}
