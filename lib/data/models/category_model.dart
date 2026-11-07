class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final String imageUrl;
  final int serviceCount;
  final int color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.imageUrl,
    required this.serviceCount,
    required this.color,
  });

  factory CategoryModel.mockElectrician() => const CategoryModel(
        id: 'CAT001',
        name: 'Electrician',
        iconName: 'flash_on',
        imageUrl: 'assets/images/categories/electrician.png',
        serviceCount: 18,
        color: 0xFFFFA726,
      );

  factory CategoryModel.mockPlumbing() => const CategoryModel(
        id: 'CAT002',
        name: 'Plumbing',
        iconName: 'water_drop',
        imageUrl: 'assets/images/categories/plumbing.png',
        serviceCount: 14,
        color: 0xFF42A5F5,
      );

  factory CategoryModel.mockACRepair() => const CategoryModel(
        id: 'CAT003',
        name: 'AC Repair',
        iconName: 'ac_unit',
        imageUrl: 'assets/images/categories/ac_repair.png',
        serviceCount: 12,
        color: 0xFF66BB6A,
      );

  factory CategoryModel.mockCleaning() => const CategoryModel(
        id: 'CAT004',
        name: 'Cleaning',
        iconName: 'cleaning_services',
        imageUrl: 'assets/images/categories/cleaning.png',
        serviceCount: 9,
        color: 0xFFAB47BC,
      );

  factory CategoryModel.mockPainting() => const CategoryModel(
        id: 'CAT005',
        name: 'Painting',
        iconName: 'format_paint',
        imageUrl: 'assets/images/categories/painting.png',
        serviceCount: 11,
        color: 0xFFEF5350,
      );

  factory CategoryModel.mockCarpenter() => const CategoryModel(
        id: 'CAT006',
        name: 'Carpenter',
        iconName: 'handyman',
        imageUrl: 'assets/images/categories/carpenter.png',
        serviceCount: 8,
        color: 0xFF8D6E63,
      );

  factory CategoryModel.mockApplianceRepair() => const CategoryModel(
        id: 'CAT007',
        name: 'Appliance Repair',
        iconName: 'kitchen',
        imageUrl: 'assets/images/categories/appliance.png',
        serviceCount: 10,
        color: 0xFF26C6DA,
      );

  factory CategoryModel.mockPestControl() => const CategoryModel(
        id: 'CAT008',
        name: 'Pest Control',
        iconName: 'bug_report',
        imageUrl: 'assets/images/categories/pest_control.png',
        serviceCount: 6,
        color: 0xFF7E57C2,
      );

  factory CategoryModel.mockBeauty() => const CategoryModel(
        id: 'CAT009',
        name: 'Beauty',
        iconName: 'face',
        imageUrl: 'assets/images/categories/beauty.png',
        serviceCount: 22,
        color: 0xFFEC407A,
      );

  factory CategoryModel.mockSalon() => const CategoryModel(
        id: 'CAT010',
        name: 'Salon',
        iconName: 'content_cut',
        imageUrl: 'assets/images/categories/salon.png',
        serviceCount: 16,
        color: 0xFF5C6BC0,
      );

  factory CategoryModel.mockCarWash() => const CategoryModel(
        id: 'CAT011',
        name: 'Car Wash',
        iconName: 'local_car_wash',
        imageUrl: 'assets/images/categories/car_wash.png',
        serviceCount: 7,
        color: 0xFF29B6F6,
      );

  factory CategoryModel.mockMore() => const CategoryModel(
        id: 'CAT012',
        name: 'More',
        iconName: 'more_horiz',
        imageUrl: 'assets/images/categories/more.png',
        serviceCount: 25,
        color: 0xFF78909C,
      );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    String? imageUrl,
    int? serviceCount,
    int? color,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        imageUrl: imageUrl ?? this.imageUrl,
        serviceCount: serviceCount ?? this.serviceCount,
        color: color ?? this.color,
      );
}
