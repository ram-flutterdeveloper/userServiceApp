class AddressModel {
  final String id;
  final String type;
  final String fullAddress;
  final String city;
  final String pincode;
  final bool isDefault;
  final double lat;
  final double lng;

  const AddressModel({
    required this.id,
    required this.type,
    required this.fullAddress,
    required this.city,
    required this.pincode,
    required this.isDefault,
    required this.lat,
    required this.lng,
  });

  AddressModel copyWith({
    String? id,
    String? type,
    String? fullAddress,
    String? city,
    String? pincode,
    bool? isDefault,
    double? lat,
    double? lng,
  }) =>
      AddressModel(
        id: id ?? this.id,
        type: type ?? this.type,
        fullAddress: fullAddress ?? this.fullAddress,
        city: city ?? this.city,
        pincode: pincode ?? this.pincode,
        isDefault: isDefault ?? this.isDefault,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );
}
