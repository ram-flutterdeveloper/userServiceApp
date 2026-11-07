import 'dart:convert';

UserAddressResponse userAddressResponseFromJson(String str) =>
    UserAddressResponse.fromJson(json.decode(str));

String userAddressResponseToJson(UserAddressResponse data) =>
    json.encode(data.toJson());

class UserAddressResponse {
  final bool success;
  final String message;
  final List<UserAddressModel> data;

  UserAddressResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserAddressResponse.fromJson(Map<String, dynamic> json) {
    return UserAddressResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map(
            (x) => UserAddressModel.fromJson(
              x as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class UserAddressModel {
  final String id;
  final String userId;
  final String cityId;
  final String areaId;
  final String houseNo;
  final String buildingName;
  final String floor;
  final String street;
  final String landmark;
  final String addressLine;
  final double latitude;
  final double longitude;
  final String contactPerson;
  final String contactNumber;
  final String addressType;
  final bool isDefault;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  // Nested API objects
  final AddressLocation? city;
  final AddressLocation? area;

  UserAddressModel({
    required this.id,
    required this.userId,
    required this.cityId,
    required this.areaId,
    required this.houseNo,
    required this.buildingName,
    required this.floor,
    required this.street,
    required this.landmark,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    required this.contactPerson,
    required this.contactNumber,
    required this.addressType,
    required this.isDefault,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.city,
    this.area,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      cityId: json['cityId'] ?? '',
      areaId: json['areaId'] ?? '',
      houseNo: json['houseNo'] ?? '',
      buildingName: json['buildingName'] ?? '',
      floor: json['floor'] ?? '',
      street: json['street'] ?? '',
      landmark: json['landmark'] ?? '',
      addressLine: json['addressLine'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      contactPerson: json['contactPerson'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      addressType: json['addressType'] ?? 'HOME',
      isDefault: json['isDefault'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'],

      city: json['city'] != null
          ? AddressLocation.fromJson(
              json['city'] as Map<String, dynamic>,
            )
          : null,

      area: json['area'] != null
          ? AddressLocation.fromJson(
              json['area'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cityId': cityId,
      'areaId': areaId,
      'houseNo': houseNo,
      'buildingName': buildingName,
      'floor': floor,
      'street': street,
      'landmark': landmark,
      'addressLine': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'addressType': addressType,
      'isDefault': isDefault,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
      'city': city?.toJson(),
      'area': area?.toJson(),
    };
  }

  /// City name from nested city object
  String? get cityName => city?.name;

  /// Area name from nested area object
  String? get areaName => area?.name;

  /// Complete address for displaying in UI
  String get fullDisplayAddress {
    final parts = <String>[
      if (houseNo.isNotEmpty) houseNo,
      if (buildingName.isNotEmpty) buildingName,
      if (street.isNotEmpty) street,
      if (areaName != null && areaName!.isNotEmpty) areaName!,
      if (cityName != null && cityName!.isNotEmpty) cityName!,
    ];

    return parts.join(', ');
  }
}

class AddressLocation {
  final String id;
  final String? cityId;
  final String name;
  final String slug;
  final String googlePlaceId;
  final double latitude;
  final double longitude;
  final String? pincode;
  final String status;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? state;
  final String? country;
  final dynamic image;

  AddressLocation({
    required this.id,
    this.cityId,
    required this.name,
    required this.slug,
    required this.googlePlaceId,
    required this.latitude,
    required this.longitude,
    this.pincode,
    required this.status,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.state,
    this.country,
    this.image,
  });

  factory AddressLocation.fromJson(Map<String, dynamic> json) {
    return AddressLocation(
      id: json['id'] ?? '',
      cityId: json['cityId'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      pincode: json['pincode'],
      status: json['status'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'],
      state: json['state'],
      country: json['country'],
      image: json['image'],
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
      'state': state,
      'country': country,
      'image': image,
    };
  }
}