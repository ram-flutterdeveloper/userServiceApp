import 'package:user_servicehub/data/models/review_model.dart';

class PackageReviewsResponse {
  final bool success;
  final String message;
  final ReviewSummary? summary;
  final List<ReviewModel> reviews;
  final ReviewPagination? pagination;

  PackageReviewsResponse({
    this.success = false,
    this.message = '',
    this.summary,
    this.reviews = const [],
    this.pagination,
  });

  factory PackageReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final summaryJson = data?['summary'] as Map<String, dynamic>?;
    final paginationJson = data?['pagination'] as Map<String, dynamic>?
        ?? (json['pagination'] as Map<String, dynamic>?);
    final reviewList = <ReviewModel>[];
    final rawReviews = data?['reviews'] as List? ?? [];
    for (final item in rawReviews) {
      reviewList.add(
        ReviewModel.fromJson(Map<String, dynamic>.from(item)),
      );
    }
    return PackageReviewsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      summary: summaryJson != null ? ReviewSummary.fromJson(summaryJson) : null,
      reviews: reviewList,
      pagination: paginationJson != null
          ? ReviewPagination.fromJson(paginationJson)
          : null,
    );
  }
}

class ReviewSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingCounts;

  ReviewSummary({
    this.averageRating = 0,
    this.totalReviews = 0,
    this.ratingCounts = const {},
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    final counts = <int, int>{};
    final raw = json['ratingCounts'] as Map<String, dynamic>? ?? {};
    raw.forEach((key, value) {
      final k = int.tryParse(key) ?? 0;
      final v = (value as num?)?.toInt() ?? 0;
      counts[k] = v;
    });
    return ReviewSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      ratingCounts: counts,
    );
  }

  double distributionFor(int star) {
    if (totalReviews == 0) return 0;
    return (ratingCounts[star] ?? 0) / totalReviews;
  }
}

class ReviewPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  ReviewPagination({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 0,
  });

  factory ReviewPagination.fromJson(Map<String, dynamic> json) {
    return ReviewPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
    );
  }
}