import 'package:user_servicehub/data/models/home_response_model.dart';

class Favourite {
  final String id;
  final String userId;
  final String packageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final PopularPackage package;

  const Favourite({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.package,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      packageId: json['packageId'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      deletedAt:
          json['deletedAt'] != null
              ? DateTime.tryParse(json['deletedAt'])
              : null,
      package: PopularPackage.fromJson(json['package'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'packageId': packageId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'package': package.toJson(),
    };
  }
}