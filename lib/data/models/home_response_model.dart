import 'dart:convert';

HomeResponse homeResponseFromJson(String str) =>
    HomeResponse.fromJson(json.decode(str));

String homeResponseToJson(HomeResponse data) => json.encode(data.toJson());

class HomeResponse {
  final bool success;
  final String message;
  final HomeData data;

  HomeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: HomeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class HomeData {
  final Location location;
  final List<dynamic> banners;
  final List<Category> categories;
  final List<Service> featuredServices;
  final List<PopularPackage> popularPackages;
  final List<Service> recommendedServices;

  HomeData({
    required this.location,
    required this.banners,
    required this.categories,
    required this.featuredServices,
    required this.popularPackages,
    required this.recommendedServices,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      location: Location.fromJson(json['location'] ?? {}),
      banners: List<dynamic>.from(json['banners'] ?? []),

      categories:
          (json['categories'] as List? ?? [])
              .map((x) => Category.fromJson(x))
              .toList(),

      featuredServices:
          (json['featuredServices'] as List? ?? [])
              .map((x) => Service.fromJson(x))
              .toList(),

      popularPackages:
          (json['popularPackages'] as List? ?? [])
              .map((x) => PopularPackage.fromJson(x))
              .toList(),

      recommendedServices:
          (json['recommendedServices'] as List? ?? [])
              .map((x) => Service.fromJson(x))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'banners': banners,
      'categories': categories.map((x) => x.toJson()).toList(),
      'featuredServices': featuredServices.map((x) => x.toJson()).toList(),
      'popularPackages': popularPackages.map((x) => x.toJson()).toList(),
      'recommendedServices':
          recommendedServices.map((x) => x.toJson()).toList(),
    };
  }
}

// ============================================================
// CATEGORY
// ============================================================

class Category {
  final String id;
  final String name;
  final String slug;
  final String? image;
  final String? icon;
  final String? description;
  final int sortOrder;
  final bool isFeatured;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  final List<Service> services;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.icon,
    this.description,
    required this.sortOrder,
    required this.isFeatured,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.services,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'],
      icon: json['icon'],
      description: json['description'],
      sortOrder: json['sortOrder'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      status: json['status'] ?? '',
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

      services:
          (json['services'] as List? ?? [])
              .map((x) => Service.fromJson(x))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'icon': icon,
      'description': description,
      'sortOrder': sortOrder,
      'isFeatured': isFeatured,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'services': services.map((x) => x.toJson()).toList(),
    };
  }
}

// ============================================================
// SERVICE
// ============================================================

class Service {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? image;
  final String? icon;
  final String? description;
  final int sortOrder;
  final bool isFeatured;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Service({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.image,
    this.icon,
    this.description,
    required this.sortOrder,
    required this.isFeatured,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'],
      icon: json['icon'],
      description: json['description'],
      sortOrder: json['sortOrder'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      status: json['status'] ?? '',
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'slug': slug,
      'image': image,
      'icon': icon,
      'description': description,
      'sortOrder': sortOrder,
      'isFeatured': isFeatured,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}

// ============================================================
// LOCATION
// ============================================================

class Location {
  final double latitude;
  final double longitude;
  final City city;
  final int cityDistance;
  final List<Area> areas;

  Location({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.cityDistance,
    required this.areas,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,

      city: City.fromJson(json['city'] ?? {}),

      // FIX: API may return int or double
      cityDistance: (json['cityDistance'] as num?)?.toInt() ?? 0,

      areas:
          (json['areas'] as List? ?? [])
              .map((x) => Area.fromJson(x as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city.toJson(),
      'cityDistance': cityDistance,
      'areas': areas.map((x) => x.toJson()).toList(),
    };
  }
}
// ============================================================
// AREA
// ============================================================

class Area {
  final String id;
  final String cityId;
  final String name;
  final String slug;
  final String googlePlaceId;
  final double latitude;
  final double longitude;
  final String pincode;
  final String status;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Area({
    required this.id,
    required this.cityId,
    required this.name,
    required this.slug,
    required this.googlePlaceId,
    required this.latitude,
    required this.longitude,
    required this.pincode,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] ?? '',
      cityId: json['cityId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      pincode: json['pincode'] ?? '',
      status: json['status'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityId': cityId,
      'name': name,
      'slug': slug,
      'googlePlaceId': googlePlaceId,
      'latitude': latitude,
      'longitude': longitude,
      'pincode': pincode,
      'status': status,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}

// ============================================================
// CITY
// ============================================================

class City {
  final String id;
  final String name;
  final String state;

  City({required this.id, required this.name, required this.state});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'state': state};
  }
}

// ============================================================
// POPULAR PACKAGE
// ============================================================

class PopularPackage {
  final String id;
  final String subCategoryId;
  final String name;
  final String slug;
  final String? description;
  final String? image;
  final String defaultPrice;
  final String offerPrice;
  final int durationMinutes;
  final int sortOrder;
  final bool isFeatured;
  final String status;
  final String serviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  PopularPackage({
    required this.id,
    required this.subCategoryId,
    required this.name,
    required this.slug,
    this.description,
    this.image,
    required this.defaultPrice,
    required this.offerPrice,
    required this.durationMinutes,
    required this.sortOrder,
    required this.isFeatured,
    required this.status,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory PopularPackage.fromJson(Map<String, dynamic> json) {
    return PopularPackage(
      id: json['id'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      image: json['image'],
      defaultPrice: json['defaultPrice'] ?? '0.00',
      offerPrice: json['offerPrice'] ?? '0.00',
      durationMinutes: json['durationMinutes'] ?? 0,
      sortOrder: json['sortOrder'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      status: json['status'] ?? '',
      serviceId: json['serviceId'] ?? '',

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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subCategoryId': subCategoryId,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'defaultPrice': defaultPrice,
      'offerPrice': offerPrice,
      'durationMinutes': durationMinutes,
      'sortOrder': sortOrder,
      'isFeatured': isFeatured,
      'status': status,
      'serviceId': serviceId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}
