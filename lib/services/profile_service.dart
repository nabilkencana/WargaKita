// services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileService {
  static const String baseUrl =
      'https://apiwarga.digicodes.my.id/users'; // Ganti dengan URL backend

  // Get user profile by ID
  static Future<Profile> getProfile(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil data profil: ${response.statusCode}');
    }
  }

  // Update user profile
  static Future<Profile> updateProfile(
    int userId,
    Map<String, dynamic> updateData,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$userId/profile'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return Profile.fromJson(responseData['user']);
    } else {
      throw Exception('Gagal mengupdate profil: ${response.statusCode}');
    }
  }

  // Upload profile picture
  static Future<String> uploadAvatar(int userId, String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$userId/upload-avatar'),
    );

    request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));

    // request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      return jsonResponse['avatarUrl'];
    } else {
      throw Exception('Gagal mengupload foto profil');
    }
  }

  // Change password
  static Future<void> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$userId/change-password'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah password: ${response.statusCode}');
    }
  }

  // Get user statistics (jika ada)
  static Future<Map<String, dynamic>> getUserStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats'),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil statistik user');
    }
  }
}
