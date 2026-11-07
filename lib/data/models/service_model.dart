import 'package:user_servicehub/data/models/home_response_model.dart';

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String imageUrl;
  final String providerName;
  final String providerId;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final String responseTime;
  final String experience;
  final double price;
  final double discountPercentage;
  final String duration;
  final bool isVerified;
  final double distance;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.providerName,
    required this.providerId,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    required this.responseTime,
    required this.experience,
    required this.price,
    required this.discountPercentage,
    required this.duration,
    required this.isVerified,
    required this.distance,
  });

  factory ServiceModel.fromPopularPackage(PopularPackage package) {
    final defaultPrice = double.tryParse(package.defaultPrice) ?? 0;
    final offerPrice = double.tryParse(package.offerPrice) ?? defaultPrice;
    final discount = defaultPrice > 0
        ? ((defaultPrice - offerPrice) / defaultPrice * 100)
              .clamp(0, 100)
              .toDouble()
        : 0.0;
    return ServiceModel(
      id: package.id,
      title: package.name,
      description: package.description ?? '',
      categoryId: package.subCategoryId,
      categoryName: _inferCategoryName(package.name),
      imageUrl: package.image ?? '',
      providerName: 'Verified Professional',
      providerId: package.serviceId,
      rating: 4.5,
      reviewCount: 0,
      completedJobs: 0,
      responseTime: 'Quick response',
      experience: '',
      price: defaultPrice,
      discountPercentage: discount,
      duration: _formatDuration(package.durationMinutes),
      isVerified: false,
      distance: 0.0,
    );
  }

  static String _formatDuration(int minutes) {
    if (minutes <= 0) return '1 hr';
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '$h hr${h > 1 ? 's' : ''}';
    return '$h hr $m min';
  }

  static String _inferCategoryName(String name) {
    final n = name.toLowerCase();
    if (n.contains('clean')) return 'Cleaning';
    if (n.contains('electri')) return 'Electrical';
    if (n.contains('plumb')) return 'Plumbing';
    if (n.contains('salon') || n.contains('beauty') || n.contains('hair')) {
      return 'Salon';
    }
    if (n.contains('paint')) return 'Painting';
    if (n.contains('repair')) return 'Repair';
    if (n.contains('ac')) return 'AC Service';
    return '';
  }

  factory ServiceModel.mockElectrician() => const ServiceModel(
        id: 'SV001',
        title: 'Electrician Services',
        description:
            'Expert electrical repairs, wiring, switchboard installation, and circuit troubleshooting for homes and offices.',
        categoryId: 'CAT001',
        categoryName: 'Electrician',
        imageUrl: 'assets/images/services/electrician.jpg',
        providerName: 'Amit Sharma',
        providerId: 'PRF001',
        rating: 4.8,
        reviewCount: 342,
        completedJobs: 1250,
        responseTime: '30 mins',
        experience: '8 years',
        price: 199.0,
        discountPercentage: 20.0,
        duration: '1-2 hrs',
        isVerified: true,
        distance: 1.2,
      );

  factory ServiceModel.mockPlumber() => const ServiceModel(
        id: 'SV002',
        title: 'Plumbing Services',
        description:
            'Professional plumbing solutions including pipe repairs, tap installation, drainage cleaning, and water heater setup.',
        categoryId: 'CAT002',
        categoryName: 'Plumbing',
        imageUrl: 'assets/images/services/plumbing.jpg',
        providerName: 'Vikram Singh',
        providerId: 'PRF002',
        rating: 4.7,
        reviewCount: 289,
        completedJobs: 980,
        responseTime: '25 mins',
        experience: '6 years',
        price: 179.0,
        discountPercentage: 15.0,
        duration: '1-3 hrs',
        isVerified: true,
        distance: 2.5,
      );

  factory ServiceModel.mockACRepair() => const ServiceModel(
        id: 'SV003',
        title: 'AC Repair & Service',
        description:
            'Complete AC maintenance, gas refilling, compressor repair, and installation for split, window, and inverter ACs.',
        categoryId: 'CAT003',
        categoryName: 'AC Repair',
        imageUrl: 'assets/images/services/ac_repair.jpg',
        providerName: 'Priya Verma',
        providerId: 'PRF003',
        rating: 4.9,
        reviewCount: 512,
        completedJobs: 2100,
        responseTime: '20 mins',
        experience: '10 years',
        price: 349.0,
        discountPercentage: 25.0,
        duration: '2-4 hrs',
        isVerified: true,
        distance: 0.8,
      );

  factory ServiceModel.mockCleaning() => const ServiceModel(
        id: 'SV004',
        title: 'Home Cleaning',
        description:
            'Deep cleaning for homes and offices including kitchen, bathroom, sofa, carpet, and window cleaning.',
        categoryId: 'CAT004',
        categoryName: 'Cleaning',
        imageUrl: 'assets/images/services/cleaning.jpg',
        providerName: 'Sneha Patel',
        providerId: 'PRF004',
        rating: 4.6,
        reviewCount: 178,
        completedJobs: 750,
        responseTime: '40 mins',
        experience: '4 years',
        price: 249.0,
        discountPercentage: 10.0,
        duration: '3-5 hrs',
        isVerified: true,
        distance: 3.1,
      );

  factory ServiceModel.mockPainting() => const ServiceModel(
        id: 'SV005',
        title: 'Painting Services',
        description:
            'Interior and exterior painting with premium quality paints. Wall textures, waterproofing, and wood polishing.',
        categoryId: 'CAT005',
        categoryName: 'Painting',
        imageUrl: 'assets/images/services/painting.jpg',
        providerName: 'Rajan Gupta',
        providerId: 'PRF005',
        rating: 4.7,
        reviewCount: 201,
        completedJobs: 620,
        responseTime: '45 mins',
        experience: '12 years',
        price: 499.0,
        discountPercentage: 18.0,
        duration: '2-5 days',
        isVerified: true,
        distance: 4.0,
      );

  factory ServiceModel.mockCarpenter() => const ServiceModel(
        id: 'SV006',
        title: 'Carpenter Services',
        description:
            'Furniture assembly, repair, custom woodwork, door and window fitting, and modular kitchen installation.',
        categoryId: 'CAT006',
        categoryName: 'Carpenter',
        imageUrl: 'assets/images/services/carpenter.jpg',
        providerName: 'Mohammad Idris',
        providerId: 'PRF006',
        rating: 4.8,
        reviewCount: 156,
        completedJobs: 490,
        responseTime: '35 mins',
        experience: '9 years',
        price: 299.0,
        discountPercentage: 12.0,
        duration: '2-4 hrs',
        isVerified: true,
        distance: 2.8,
      );

  factory ServiceModel.mockApplianceRepair() => const ServiceModel(
        id: 'SV007',
        title: 'Appliance Repair',
        description:
            'Repair services for washing machines, refrigerators, microwaves, ovens, and other home appliances.',
        categoryId: 'CAT007',
        categoryName: 'Appliance Repair',
        imageUrl: 'assets/images/services/appliance_repair.jpg',
        providerName: 'Deepak Yadav',
        providerId: 'PRF007',
        rating: 4.5,
        reviewCount: 134,
        completedJobs: 410,
        responseTime: '30 mins',
        experience: '7 years',
        price: 249.0,
        discountPercentage: 15.0,
        duration: '1-3 hrs',
        isVerified: true,
        distance: 1.9,
      );

  factory ServiceModel.mockPestControl() => const ServiceModel(
        id: 'SV008',
        title: 'Pest Control',
        description:
            'Complete pest management for cockroaches, termites, mosquitoes, rodents, and bed bugs with safe chemicals.',
        categoryId: 'CAT008',
        categoryName: 'Pest Control',
        imageUrl: 'assets/images/services/pest_control.jpg',
        providerName: 'Arun Kumar',
        providerId: 'PRF008',
        rating: 4.6,
        reviewCount: 98,
        completedJobs: 320,
        responseTime: '1 hour',
        experience: '5 years',
        price: 399.0,
        discountPercentage: 20.0,
        duration: '2-3 hrs',
        isVerified: true,
        distance: 3.5,
      );

  factory ServiceModel.mockBeautyParler() => const ServiceModel(
        id: 'SV009',
        title: 'Beauty & Parlour',
        description:
            'Salon services at home including facials, waxing, manicure, pedicure, makeup, and hairstyling.',
        categoryId: 'CAT009',
        categoryName: 'Beauty',
        imageUrl: 'assets/images/services/beauty.jpg',
        providerName: 'Neha Kapoor',
        providerId: 'PRF009',
        rating: 4.9,
        reviewCount: 267,
        completedJobs: 890,
        responseTime: '30 mins',
        experience: '6 years',
        price: 399.0,
        discountPercentage: 25.0,
        duration: '1-2 hrs',
        isVerified: true,
        distance: 2.2,
      );

  factory ServiceModel.mockSalon() => const ServiceModel(
        id: 'SV010',
        title: 'Salon for Men',
        description:
            'Premium grooming services including haircut, beard trim, facial, head massage, and spa treatments.',
        categoryId: 'CAT010',
        categoryName: 'Salon',
        imageUrl: 'assets/images/services/salon.jpg',
        providerName: 'Rohit Malhotra',
        providerId: 'PRF010',
        rating: 4.7,
        reviewCount: 198,
        completedJobs: 670,
        responseTime: '25 mins',
        experience: '5 years',
        price: 199.0,
        discountPercentage: 10.0,
        duration: '45-90 mins',
        isVerified: true,
        distance: 1.5,
      );

  factory ServiceModel.mockCarWash() => const ServiceModel(
        id: 'SV011',
        title: 'Car Wash & Detailing',
        description:
            'Professional car cleaning, waxing, polishing, interior vacuuming, and engine bay cleaning at your doorstep.',
        categoryId: 'CAT011',
        categoryName: 'Car Wash',
        imageUrl: 'assets/images/services/car_wash.jpg',
        providerName: 'Suresh Reddy',
        providerId: 'PRF011',
        rating: 4.6,
        reviewCount: 145,
        completedJobs: 530,
        responseTime: '40 mins',
        experience: '4 years',
        price: 299.0,
        discountPercentage: 15.0,
        duration: '1-2 hrs',
        isVerified: true,
        distance: 4.5,
      );

  factory ServiceModel.mockMore() => const ServiceModel(
        id: 'SV012',
        title: 'Packers & Movers',
        description:
            'Reliable packing, loading, transportation, and unloading services for local and interstate moves.',
        categoryId: 'CAT012',
        categoryName: 'More',
        imageUrl: 'assets/images/services/movers.jpg',
        providerName: 'Rajesh Tiwari',
        providerId: 'PRF012',
        rating: 4.4,
        reviewCount: 89,
        completedJobs: 280,
        responseTime: '1 hour',
        experience: '11 years',
        price: 999.0,
        discountPercentage: 10.0,
        duration: '4-8 hrs',
        isVerified: true,
        distance: 6.0,
      );

  ServiceModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    String? providerName,
    String? providerId,
    double? rating,
    int? reviewCount,
    int? completedJobs,
    String? responseTime,
    String? experience,
    double? price,
    double? discountPercentage,
    String? duration,
    bool? isVerified,
    double? distance,
  }) =>
      ServiceModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        imageUrl: imageUrl ?? this.imageUrl,
        providerName: providerName ?? this.providerName,
        providerId: providerId ?? this.providerId,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        completedJobs: completedJobs ?? this.completedJobs,
        responseTime: responseTime ?? this.responseTime,
        experience: experience ?? this.experience,
        price: price ?? this.price,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        duration: duration ?? this.duration,
        isVerified: isVerified ?? this.isVerified,
        distance: distance ?? this.distance,
      );
}
