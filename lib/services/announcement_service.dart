// services/announcement_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement_model.dart';

class AnnouncementService {
  static const String baseUrl =
      'http://localhost:3000'; // Ganti dengan URL API Anda

  // Get semua pengumuman
  static Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/announcements'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Announcement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching announcements: $e');
      throw Exception('Failed to load announcements');
    }
  }

  // Get detail pengumuman by ID
  static Future<Announcement> getAnnouncementById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/announcements/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Announcement.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Pengumuman tidak ditemukan');
      } else {
        throw Exception('Failed to load announcement: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching announcement: $e');
      throw Exception('Failed to load announcement');
    }
  }
}
