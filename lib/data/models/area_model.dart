class AreaResponse {
  final bool success;
  final String message;
  final List<AreaModel> data;

  AreaResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    return AreaResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((x) => AreaModel.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AreaModel {
  final String id;
  final String cityId;
  final String name;
  final String slug;
  final String googlePlaceId;
  final double latitude;
  final double longitude;
  final String status;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  AreaModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.slug,
    required this.googlePlaceId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? '',
      cityId: json['cityId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
    );
  }
}
