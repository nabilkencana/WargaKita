// models/announcement_model.dart
import 'package:flutter/material.dart';

class Announcement {
  final int id;
  final String title;
  final String description;
  final String targetAudience;
  final DateTime date;
  final String day;
  final DateTime createdAt;
  final Admin admin;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAudience,
    required this.date,
    required this.day,
    required this.createdAt,
    required this.admin,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetAudience: json['targetAudience'] ?? '',
      date: DateTime.parse(json['date']),
      day: json['day'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      admin: Admin.fromJson(json['admin']),
    );
  }

  // Helper method untuk format tanggal
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String get monthName {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[date.month - 1];
  }

  String get dayName {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    return days[date.weekday % 7];
  }

  // Method untuk menentukan warna berdasarkan hari dan kondisi khusus
  Color get dateColor {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final announcementDay = DateTime(date.year, date.month, date.day);

    // Jika hari ini adalah hari pengumuman
    if (announcementDay.isAtSameMomentAs(today)) {
      return const Color(0xFF0D6EFD); // Biru untuk hari ini
    }

    // Warna berdasarkan hari dalam seminggu
    switch (date.weekday) {
      case DateTime.friday: // Jumat - Hijau
        return const Color(0xFF10B981);
      case DateTime.saturday: // Sabtu - Orange
        return const Color(0xFFF59E0B);
      case DateTime.sunday: // Minggu - Merah (libur)
        return const Color(0xFFEF4444);
      default: // Senin-Kamis - Hitam/Abu-abu gelap
        return const Color(0xFF1F2937);
    }
  }

  // Method untuk menentukan warna background berdasarkan warna tanggal
  Color get backgroundColor {
    switch (dateColor.value) {
      case 0xFF0D6EFD: // Biru (hari ini)
        return const Color(0xFFEFF6FF);
      case 0xFF10B981: // Hijau (Jumat)
        return const Color(0xFFECFDF5);
      case 0xFFF59E0B: // Orange (Sabtu)
        return const Color(0xFFFFFBEB);
      case 0xFFEF4444: // Merah (Minggu)
        return const Color(0xFFFEF2F2);
      default: // Hitam (Senin-Kamis)
        return const Color(0xFFF9FAFB);
    }
  }

  // Method untuk menentukan warna border
  Color get borderColor {
    switch (dateColor.value) {
      case 0xFF0D6EFD: // Biru (hari ini)
        return const Color(0xFFDBEAFE);
      case 0xFF10B981: // Hijau (Jumat)
        return const Color(0xFFD1FAE5);
      case 0xFFF59E0B: // Orange (Sabtu)
        return const Color(0xFFFEF3C7);
      case 0xFFEF4444: // Merah (Minggu)
        return const Color(0xFFFECACA);
      default: // Hitam (Senin-Kamis)
        return const Color(0xFFE5E7EB);
    }
  }

  // Method untuk menentukan apakah hari libur nasional (contoh sederhana)
  bool get isHoliday {
    // Contoh hari libur nasional Indonesia
    final holidays = [
      DateTime(date.year, 1, 1), // Tahun Baru
      DateTime(date.year, 5, 1), // Hari Buruh
      DateTime(date.year, 8, 17), // Kemerdekaan
      DateTime(date.year, 12, 25), // Natal
    ];

    return holidays.any(
      (holiday) => holiday.day == date.day && holiday.month == date.month,
    );
  }

  // Method untuk icon berdasarkan hari
  IconData get dayIcon {
    switch (date.weekday) {
      case DateTime.monday:
        return Icons.calendar_today;
      case DateTime.tuesday:
        return Icons.calendar_today;
      case DateTime.wednesday:
        return Icons.calendar_today;
      case DateTime.thursday:
        return Icons.calendar_today;
      case DateTime.friday:
        return Icons.celebration;
      case DateTime.saturday:
        return Icons.weekend;
      case DateTime.sunday:
        return Icons.beach_access;
      default:
        return Icons.calendar_today;
    }
  }
}

class Admin {
  final int id;
  final String namaLengkap;
  final String email;

  Admin({required this.id, required this.namaLengkap, required this.email});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      namaLengkap: json['namaLengkap'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
