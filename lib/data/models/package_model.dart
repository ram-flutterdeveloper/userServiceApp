class PackageModel {
  final String id;
  final String name;
  final String serviceId;
  final double price;
  final double originalPrice;
  final String duration;
  final int professionalsCount;
  final List<String> includes;
  final String warranty;
  final bool equipment;
  final bool material;
  final bool inspection;
  final String cancellationPolicy;
  final bool isRecommended;

  const PackageModel({
    required this.id,
    required this.name,
    required this.serviceId,
    required this.price,
    required this.originalPrice,
    required this.duration,
    required this.professionalsCount,
    this.includes = const [],
    required this.warranty,
    required this.equipment,
    required this.material,
    required this.inspection,
    required this.cancellationPolicy,
    required this.isRecommended,
  });

  factory PackageModel.electricianBasic() => const PackageModel(
        id: 'PKG_E001',
        name: 'Basic',
        serviceId: 'SV001',
        price: 199.0,
        originalPrice: 349.0,
        duration: '1 hour',
        professionalsCount: 1,
        includes: ['Basic electrical inspection', 'Minor repair (1 point)', 'Switchboard check', 'Tightening & fuse check'],
        warranty: '7 days',
        equipment: true,
        material: false,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 2 hours',
        isRecommended: false,
      );

  factory PackageModel.electricianStandard() => const PackageModel(
        id: 'PKG_E002',
        name: 'Standard',
        serviceId: 'SV001',
        price: 499.0,
        originalPrice: 799.0,
        duration: '2-3 hours',
        professionalsCount: 1,
        includes: [
          'Complete electrical inspection',
          'Repair up to 3 points',
          'Switchboard replacement',
          'Wiring check & fixing',
          'Fan regulator installation',
        ],
        warranty: '30 days',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 4 hours',
        isRecommended: true,
      );

  factory PackageModel.electricianPremium() => const PackageModel(
        id: 'PKG_E003',
        name: 'Premium',
        serviceId: 'SV001',
        price: 1299.0,
        originalPrice: 1999.0,
        duration: '4-6 hours',
        professionalsCount: 2,
        includes: [
          'Full house electrical audit',
          'Unlimited repairs & replacements',
          'Complete rewiring (1 room)',
          'MCB box installation',
          'Earthing check & fix',
          'Smart switch setup',
          '6-month warranty on all work',
        ],
        warranty: '6 months',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 12 hours',
        isRecommended: false,
      );

  factory PackageModel.plumbingBasic() => const PackageModel(
        id: 'PKG_P001',
        name: 'Basic',
        serviceId: 'SV002',
        price: 179.0,
        originalPrice: 299.0,
        duration: '1 hour',
        professionalsCount: 1,
        includes: ['Tap repair/replacement', 'Pipe joint fixing', 'Drain blockage check', 'Basic leak inspection'],
        warranty: '7 days',
        equipment: true,
        material: false,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 2 hours',
        isRecommended: false,
      );

  factory PackageModel.plumbingStandard() => const PackageModel(
        id: 'PKG_P002',
        name: 'Standard',
        serviceId: 'SV002',
        price: 499.0,
        originalPrice: 749.0,
        duration: '2-3 hours',
        professionalsCount: 1,
        includes: [
          'Pipe repair/replacement up to 3 points',
          'Tap & mixer installation',
          'Drainage cleaning',
          'Water heater installation',
          'Bathroom fitting check',
        ],
        warranty: '30 days',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 4 hours',
        isRecommended: true,
      );

  factory PackageModel.plumbingPremium() => const PackageModel(
        id: 'PKG_P003',
        name: 'Premium',
        serviceId: 'SV002',
        price: 1299.0,
        originalPrice: 1899.0,
        duration: '4-6 hours',
        professionalsCount: 2,
        includes: [
          'Complete plumbing overhaul',
          'Pipe replacement (up to 10 points)',
          'Full bathroom fitting set',
          'Water purifier installation',
          'Overhead tank cleaning',
          'Underground leakage detection',
        ],
        warranty: '6 months',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 12 hours',
        isRecommended: false,
      );

  factory PackageModel.acBasic() => const PackageModel(
        id: 'PKG_A001',
        name: 'Basic',
        serviceId: 'SV003',
        price: 349.0,
        originalPrice: 599.0,
        duration: '1-2 hours',
        professionalsCount: 1,
        includes: ['AC filter cleaning', 'Gas pressure check', 'Cooling performance test', 'Remote & thermostat check'],
        warranty: '7 days',
        equipment: true,
        material: false,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 2 hours',
        isRecommended: false,
      );

  factory PackageModel.acStandard() => const PackageModel(
        id: 'PKG_A002',
        name: 'Standard',
        serviceId: 'SV003',
        price: 999.0,
        originalPrice: 1499.0,
        duration: '2-3 hours',
        professionalsCount: 1,
        includes: [
          'Deep cleaning of AC unit',
          'Gas refilling (up to 50% needed)',
          'Coil cleaning & inspection',
          'Drain pipe cleaning',
          'Fan motor lubrication',
        ],
        warranty: '45 days',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 4 hours',
        isRecommended: true,
      );

  factory PackageModel.acPremium() => const PackageModel(
        id: 'PKG_A003',
        name: 'Premium',
        serviceId: 'SV003',
        price: 2499.0,
        originalPrice: 3499.0,
        duration: '3-5 hours',
        professionalsCount: 2,
        includes: [
          'Complete AC overhaul',
          'Full gas refilling',
          'Compressor diagnostics & repair',
          'PCB board check & repair',
          'Indoor & outdoor unit cleaning',
          'All replacement parts included',
          '1-year service warranty',
        ],
        warranty: '1 year',
        equipment: true,
        material: true,
        inspection: true,
        cancellationPolicy: 'Free cancellation within 12 hours',
        isRecommended: false,
      );

  PackageModel copyWith({
    String? id,
    String? name,
    String? serviceId,
    double? price,
    double? originalPrice,
    String? duration,
    int? professionalsCount,
    List<String>? includes,
    String? warranty,
    bool? equipment,
    bool? material,
    bool? inspection,
    String? cancellationPolicy,
    bool? isRecommended,
  }) =>
      PackageModel(
        id: id ?? this.id,
        name: name ?? this.name,
        serviceId: serviceId ?? this.serviceId,
        price: price ?? this.price,
        originalPrice: originalPrice ?? this.originalPrice,
        duration: duration ?? this.duration,
        professionalsCount: professionalsCount ?? this.professionalsCount,
        includes: includes ?? this.includes,
        warranty: warranty ?? this.warranty,
        equipment: equipment ?? this.equipment,
        material: material ?? this.material,
        inspection: inspection ?? this.inspection,
        cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
        isRecommended: isRecommended ?? this.isRecommended,
      );
}
