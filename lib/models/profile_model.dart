// models/profile_model.dart
class Profile {
  final int id;
  final String namaLengkap;
  final String email;
  final String? nik;
  final String? tanggalLahir;
  final String? tempatLahir;
  final String? nomorTelepon;
  final String? instagram;
  final String? facebook;
  final String? alamat;
  final String? kota;
  final String? negara;
  final String? kodePos;
  final String? rtRw;
  final String role;
  final bool isVerified;
  final String? kkFile;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.namaLengkap,
    required this.email,
    this.nik,
    this.tanggalLahir,
    this.tempatLahir,
    this.nomorTelepon,
    this.instagram,
    this.facebook,
    this.alamat,
    this.kota,
    this.negara,
    this.kodePos,
    this.rtRw,
    required this.role,
    required this.isVerified,
    this.kkFile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      namaLengkap: json['namaLengkap'],
      email: json['email'],
      nik: json['nik'],
      tanggalLahir: json['tanggalLahir'],
      tempatLahir: json['tempatLahir'],
      nomorTelepon: json['nomorTelepon'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      alamat: json['alamat'],
      kota: json['kota'],
      negara: json['negara'],
      kodePos: json['kodePos'],
      rtRw: json['rtRw'],
      role: json['role'],
      isVerified: json['isVerified'],
      kkFile: json['kkFile'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Factory constructor untuk convert dari User
  factory Profile.fromUser(Map<String, dynamic> userData) {
    return Profile(
      id: userData['id'],
      namaLengkap: userData['namaLengkap'] ?? userData['name'] ?? 'User',
      email: userData['email'],
      nik: userData['nik'],
      tanggalLahir: userData['tanggalLahir'],
      tempatLahir: userData['tempatLahir'],
      nomorTelepon: userData['nomorTelepon'] ?? userData['phone'],
      instagram: userData['instagram'],
      facebook: userData['facebook'],
      alamat: userData['alamat'],
      kota: userData['kota'],
      negara: userData['negara'],
      kodePos: userData['kodePos'],
      rtRw: userData['rtRw'],
      role: userData['role'] ?? 'user',
      isVerified: userData['isVerified'] ?? false,
      kkFile: userData['kkFile'],
      createdAt: userData['createdAt'] != null
          ? DateTime.parse(userData['createdAt'])
          : DateTime.now(),
      updatedAt: userData['updatedAt'] != null
          ? DateTime.parse(userData['updatedAt'])
          : DateTime.now(),
    );
  }

  // Helper methods untuk kompatibilitas
  String get name => namaLengkap;
  String get phone => nomorTelepon ?? '-';
  String get address => alamat ?? '-';
  String get city => kota ?? '-';

  // Format tanggal untuk display
  String get formattedTanggalLahir {
    if (tanggalLahir == null) return '-';
    try {
      final date = DateTime.parse(tanggalLahir!);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return tanggalLahir!;
    }
  }

  // Status verifikasi
  String get verificationStatus =>
      isVerified ? 'Terverifikasi' : 'Belum Terverifikasi';

  // Method untuk konversi ke Map (untuk update)
  Map<String, dynamic> toJson() {
    return {
      'namaLengkap': namaLengkap,
      'email': email,
      'nik': nik,
      'tanggalLahir': tanggalLahir,
      'tempatLahir': tempatLahir,
      'nomorTelepon': nomorTelepon,
      'instagram': instagram,
      'facebook': facebook,
      'alamat': alamat,
      'kota': kota,
      'negara': negara,
      'kodePos': kodePos,
      'rtRw': rtRw,
    };
  }

  // Method untuk copy dengan data baru
  Profile copyWith({
    int? id,
    String? namaLengkap,
    String? email,
    String? nik,
    String? tanggalLahir,
    String? tempatLahir,
    String? nomorTelepon,
    String? instagram,
    String? facebook,
    String? alamat,
    String? kota,
    String? negara,
    String? kodePos,
    String? rtRw,
    String? role,
    bool? isVerified,
    String? kkFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      alamat: alamat ?? this.alamat,
      kota: kota ?? this.kota,
      negara: negara ?? this.negara,
      kodePos: kodePos ?? this.kodePos,
      rtRw: rtRw ?? this.rtRw,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      kkFile: kkFile ?? this.kkFile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validasi data profil
  bool get isProfileComplete {
    return namaLengkap.isNotEmpty &&
        email.isNotEmpty &&
        nik != null &&
        nik!.isNotEmpty &&
        tanggalLahir != null &&
        tempatLahir != null &&
        nomorTelepon != null &&
        nomorTelepon!.isNotEmpty &&
        alamat != null &&
        alamat!.isNotEmpty;
  }

  // Persentase kelengkapan profil
  double get profileCompletionPercentage {
    int totalFields =
        7; // namaLengkap, email, nik, tanggalLahir, tempatLahir, nomorTelepon, alamat
    int completedFields = 2; // namaLengkap dan email selalu ada

    if (nik != null && nik!.isNotEmpty) completedFields++;
    if (tanggalLahir != null) completedFields++;
    if (tempatLahir != null && tempatLahir!.isNotEmpty) completedFields++;
    if (nomorTelepon != null && nomorTelepon!.isNotEmpty) completedFields++;
    if (alamat != null && alamat!.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }
}
