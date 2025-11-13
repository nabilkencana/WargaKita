// models/sos_model.dart
class Emergency {
  final int id;
  final String type;
  final String? details;
  final String? location;
  final String? latitude;
  final String? longitude;
  final bool needVolunteer;
  final int volunteerCount;
  final String status;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Volunteer> volunteers;

  Emergency({
    required this.id,
    required this.type,
    this.details,
    this.location,
    this.latitude,
    this.longitude,
    required this.needVolunteer,
    required this.volunteerCount,
    required this.status,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.volunteers,
  });

  factory Emergency.fromJson(Map<String, dynamic> json) {
    return Emergency(
      id: json['id'],
      type: json['type'],
      details: json['details'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      needVolunteer: json['needVolunteer'] ?? false,
      volunteerCount: json['volunteerCount'] ?? 0,
      status: json['status'],
      userId: json['userId']?.toString(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      volunteers:
          (json['volunteers'] as List<dynamic>?)
              ?.map((v) => Volunteer.fromJson(v))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'details': details,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'needVolunteer': needVolunteer,
      'volunteerCount': volunteerCount,
      'userId': userId,
    };
  }
}

class Volunteer {
  final int id;
  final int emergencyId;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final String? skills;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Volunteer({
    required this.id,
    required this.emergencyId,
    this.userId,
    this.userName,
    this.userPhone,
    this.skills,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      emergencyId: json['emergencyId'],
      userId: json['userId']?.toString(),
      userName: json['userName'],
      userPhone: json['userPhone'],
      skills: json['skills'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergencyId': emergencyId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'skills': skills,
    };
  }
}

class EmergencyStats {
  final int total;
  final int active;
  final int resolved;
  final int needVolunteers;

  EmergencyStats({
    required this.total,
    required this.active,
    required this.resolved,
    required this.needVolunteers,
  });

  factory EmergencyStats.fromJson(Map<String, dynamic> json) {
    return EmergencyStats(
      total: json['total'],
      active: json['active'],
      resolved: json['resolved'],
      needVolunteers: json['needVolunteers'],
    );
  }
}

class CreateSOSRequest {
  final String type;
  final String? details;
  final String? location;
  final String? latitude;
  final String? longitude;
  final bool needVolunteer;
  final int volunteerCount;
  final String? userId;

  CreateSOSRequest({
    required this.type,
    this.details,
    this.location,
    this.latitude,
    this.longitude,
    this.needVolunteer = false,
    this.volunteerCount = 0,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'details': details,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'needVolunteer': needVolunteer,
      'volunteerCount': volunteerCount,
      'userId': userId,
    };
  }
}

class RegisterVolunteerRequest {
  final String? userId;
  final String? userName;
  final String? skills;

  RegisterVolunteerRequest({this.userId, this.userName, this.skills});

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'userName': userName, 'skills': skills};
  }
}
