class User {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? role;
  final String? otpCode;
  final DateTime? otpExpire;
  final String? profilePicture;

  User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.role,
    this.otpCode,
    this.otpExpire,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing User from JSON: $json');

    // Handle berbagai kemungkinan field names
    final id =
        json['id']?.toString() ?? json['userId']?.toString() ?? 'unknown_id';

    final email = json['email']?.toString() ?? '';

    final name =
        json['name']?.toString() ??
        json['namaLengkap']?.toString() ??
        json['nama']?.toString();

    final role = json['role']?.toString() ?? 'user';

    print('✅ Parsed User:');
    print('   ID: $id');
    print('   Email: $email');
    print('   Name: $name');
    print('   Role: $role');

    return User(
      id: id,
      email: email,
      name: name,
      role: role,
      otpCode: json['otpCode']?.toString(),
      otpExpire: json['otpExpire'] != null
          ? DateTime.tryParse(json['otpExpire'].toString())
          : null,
      profilePicture:
          json['picture']?.toString() ?? json['fotoProfil']?.toString(),
    );
  }

  get address => null;

  get alamat => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'otpCode': otpCode,
      'otpExpire': otpExpire?.toIso8601String(),
      'picture': profilePicture,
    };
  }
}

class AuthResponse {
  final String message;
  final User? user;
  final String? accessToken;

  AuthResponse({required this.message, this.user, this.accessToken});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
      'access_token': accessToken,
    };
  }
}

class OtpResponse {
  final String message;

  OtpResponse({required this.message});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message']?.toString() ?? 'OTP sent successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
