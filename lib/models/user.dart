class User {
  int? id;
  String name;
  String nik;
  String birthDate;
  String city;
  String? kkPhotoPath;

  User({
    this.id,
    required this.name,
    required this.nik,
    required this.birthDate,
    required this.city,
    this.kkPhotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'birthDate': birthDate,
      'city': city,
      'kkPhotoPath': kkPhotoPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      nik: map['nik'],
      birthDate: map['birthDate'],
      city: map['city'],
      kkPhotoPath: map['kkPhotoPath'],
    );
  }
}
