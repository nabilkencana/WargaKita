// services/laporan_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/laporan_model.dart';

class LaporanService {
  static const String baseUrl =
      'https://wargakita.canadev.my.id/reports'; // Ganti dengan URL backend Anda

  // Create new report
  static Future<Laporan> createLaporan(Laporan laporan) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(laporan.toJson()),
    );

    if (response.statusCode == 201) {
      return Laporan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengirim laporan: ${response.statusCode}');
    }
  }

  // Get all reports
  static Future<List<Laporan>> getAllLaporan() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Laporan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data laporan');
    }
  }

  // Get report by ID
  static Future<Laporan> getLaporanById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Laporan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Laporan tidak ditemukan');
    }
  }

  // Update report
  static Future<Laporan> updateLaporan(int id, Laporan laporan) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(laporan.toJson()),
    );

    if (response.statusCode == 200) {
      return Laporan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengupdate laporan');
    }
  }

  // Delete report
  static Future<void> deleteLaporan(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus laporan');
    }
  }

  // Search reports by title
  static Future<List<Laporan>> searchLaporan(String keyword) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Laporan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mencari laporan');
    }
  }

  // Get reports by category
  static Future<List<Laporan>> getLaporanByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Laporan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil laporan berdasarkan kategori');
    }
  }
}
