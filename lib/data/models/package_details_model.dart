import 'dart:convert';

PackageDetailsResponse packageDetailsResponseFromJson(String str) =>
    PackageDetailsResponse.fromJson(json.decode(str));

String packageDetailsResponseToJson(PackageDetailsResponse data) =>
    json.encode(data.toJson());

class PackageDetailsResponse {
  final bool success;
  final String message;
  final PackageDetails data;

  PackageDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PackageDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PackageDetails.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class PackageDetails {
  final PackageInfo package;
  final String description;
  final String whyChooseUs;
  final List<PackageImage> images;
  final List<IncludedItem> included;
  final List<ExcludedItem> excluded;
  final List<HowItWorksStep> howItWorks;
  final List<Benefit> benefits;
  final List<FAQ> faqs;

  PackageDetails({
    required this.package,
    this.description = '',
    this.whyChooseUs = '',
    this.images = const [],
    this.included = const [],
    this.excluded = const [],
    this.howItWorks = const [],
    this.benefits = const [],
    this.faqs = const [],
  });

  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      package: PackageInfo.fromJson(json['package'] ?? {}),
      description: json['description'] ?? '',
      whyChooseUs: json['whyChooseUs'] ?? '',
      images:
          (json['images'] as List? ?? [])
              .map((x) => PackageImage.fromJson(x))
              .toList(),
      included:
          (json['included'] as List? ?? [])
              .map((x) => IncludedItem.fromJson(x))
              .toList(),
      excluded:
          (json['excluded'] as List? ?? [])
              .map((x) => ExcludedItem.fromJson(x))
              .toList(),
      howItWorks:
          (json['howItWorks'] as List? ?? [])
              .map((x) => HowItWorksStep.fromJson(x))
              .toList(),
      benefits:
          (json['benefits'] as List? ?? [])
              .map((x) => Benefit.fromJson(x))
              .toList(),
      faqs:
          (json['faqs'] as List? ?? [])
              .map((x) => FAQ.fromJson(x))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package': package.toJson(),
      'description': description,
      'whyChooseUs': whyChooseUs,
      'images': images.map((x) => x.toJson()).toList(),
      'included': included.map((x) => x.toJson()).toList(),
      'excluded': excluded.map((x) => x.toJson()).toList(),
      'howItWorks': howItWorks.map((x) => x.toJson()).toList(),
      'benefits': benefits.map((x) => x.toJson()).toList(),
      'faqs': faqs.map((x) => x.toJson()).toList(),
    };
  }
}

class PackageInfo {
  final String id;
  final String name;
  final String? image;
  final String description;
  final String defaultPrice;
  final String offerPrice;
  final int durationMinutes;

  PackageInfo({
    required this.id,
    this.name = '',
    this.image,
    this.description = '',
    this.defaultPrice = '0.00',
    this.offerPrice = '0.00',
    this.durationMinutes = 0,
  });

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    return PackageInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      defaultPrice: json['defaultPrice'] ?? '0.00',
      offerPrice: json['offerPrice'] ?? '0.00',
      durationMinutes: json['durationMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'defaultPrice': defaultPrice,
      'offerPrice': offerPrice,
      'durationMinutes': durationMinutes,
    };
  }
}

class PackageImage {
  final String id;
  final String packageId;
  final String image;
  final String title;
  final int sortOrder;

  PackageImage({
    required this.id,
    this.packageId = '',
    this.image = '',
    this.title = '',
    this.sortOrder = 0,
  });

  factory PackageImage.fromJson(Map<String, dynamic> json) {
    return PackageImage(
      id: json['id'] ?? '',
      packageId: json['packageId'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'image': image,
      'title': title,
      'sortOrder': sortOrder,
    };
  }
}

class IncludedItem {
  final String id;
  final String packageId;
  final String title;
  final String description;
  final String? image;
  final int sortOrder;

  IncludedItem({
    required this.id,
    this.packageId = '',
    this.title = '',
    this.description = '',
    this.image,
    this.sortOrder = 0,
  });

  factory IncludedItem.fromJson(Map<String, dynamic> json) {
    return IncludedItem(
      id: json['id'] ?? '',
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'title': title,
      'description': description,
      'image': image,
      'sortOrder': sortOrder,
    };
  }
}

class ExcludedItem {
  final String id;
  final String packageId;
  final String title;
  final String description;
  final String? image;
  final int sortOrder;

  ExcludedItem({
    required this.id,
    this.packageId = '',
    this.title = '',
    this.description = '',
    this.image,
    this.sortOrder = 0,
  });

  factory ExcludedItem.fromJson(Map<String, dynamic> json) {
    return ExcludedItem(
      id: json['id'] ?? '',
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'title': title,
      'description': description,
      'image': image,
      'sortOrder': sortOrder,
    };
  }
}

class HowItWorksStep {
  final String id;
  final int step;
  final String title;
  final String description;
  final String? image;

  HowItWorksStep({
    required this.id,
    this.step = 0,
    this.title = '',
    this.description = '',
    this.image,
  });

  factory HowItWorksStep.fromJson(Map<String, dynamic> json) {
    return HowItWorksStep(
      id: json['id'] ?? '',
      step: json['step'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'step': step,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}

class Benefit {
  final String id;
  final String title;
  final String description;
  final String? image;
  final int sortOrder;

  Benefit({
    required this.id,
    this.title = '',
    this.description = '',
    this.image,
    this.sortOrder = 0,
  });

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'sortOrder': sortOrder,
    };
  }
}

class FAQ {
  final String id;
  final String question;
  final String answer;
  final int sortOrder;

  FAQ({
    required this.id,
    this.question = '',
    this.answer = '',
    this.sortOrder = 0,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'sortOrder': sortOrder,
    };
  }
}
