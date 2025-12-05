// models/register_model.dart
class RegisterRequest {
  final String namaLengkap;
  final String nik;
  final String tanggalLahir;
  final String tempatLahir;
  final String email;
  final String nomorTelepon;
  final String? instagram;
  final String? facebook;
  final String alamat;
  final String kota;
  final String negara;
  final String kodePos;
  final String rtRw;

  RegisterRequest({
    required this.namaLengkap,
    required this.nik,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.email,
    required this.nomorTelepon,
    this.instagram,
    this.facebook,
    required this.alamat,
    required this.kota,
    required this.negara,
    required this.kodePos,
    required this.rtRw,
  });

  Map<String, dynamic> toJson() => {
    'namaLengkap': namaLengkap,
    'nik': nik,
    'tanggalLahir': tanggalLahir,
    'tempatLahir': tempatLahir,
    'email': email,
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

class RegisterResponse {
  final String message;
  final User user;

  RegisterResponse({required this.message, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String namaLengkap;
  final String email;
  final String nik;
  final String nomorTelepon;
  final String role;
  final bool isVerified;
  final String? kkFile;
  final DateTime createdAt;

  User({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nik,
    required this.nomorTelepon,
    required this.role,
    required this.isVerified,
    this.kkFile,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      namaLengkap: json['namaLengkap'],
      email: json['email'],
      nik: json['nik'],
      nomorTelepon: json['nomorTelepon'],
      role: json['role'],
      isVerified: json['isVerified'],
      kkFile: json['kkFile'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
