class CityResponse {
  final bool success;
  final String message;
  final List<CityModel> data;

  CityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((x) => CityModel.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CityModel {
  final String id;
  final String name;
  final String slug;
  final String state;
  final String country;
  final String googlePlaceId;
  final double latitude;
  final double longitude;
  final String? image;
  final String status;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CityModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.state,
    required this.country,
    required this.googlePlaceId,
    required this.latitude,
    required this.longitude,
    this.image,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
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
