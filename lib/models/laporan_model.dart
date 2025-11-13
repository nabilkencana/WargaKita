// models/laporan_model.dart
class Laporan {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String? imageUrl;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Laporan({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    this.status = 'PENDING',
    this.imageUrl,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'] ?? 'PENDING',
      imageUrl: json['imageUrl'],
      userId: json['userId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
