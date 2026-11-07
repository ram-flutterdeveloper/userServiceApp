class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final double rating;
  final String comment;
  final String date;
  final String serviceName;
  final List<String> images;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.serviceName,
    this.images = const [],
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['user'] != null
          ? (json['user']['firstName']?.toString() ?? '')
          : (json['userName']?.toString() ?? ''),
      userPhotoUrl: json['user']?['profileImage']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['review']?.toString() ?? '',
      date: json['createdAt']?.toString() ?? '',
      serviceName: json['package']?['name']?.toString() ?? '',
      images: ((json['images'] as List?) ?? []).cast<String>(),
    );
  }

  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    double? rating,
    String? comment,
    String? date,
    String? serviceName,
    List<String>? images,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        date: date ?? this.date,
        serviceName: serviceName ?? this.serviceName,
        images: images ?? this.images,
      );
}
