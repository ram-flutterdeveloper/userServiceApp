import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/review_repo.dart';
import 'package:user_servicehub/data/models/package_reviews_model.dart';
import 'package:user_servicehub/data/models/review_model.dart';

class PackageReviewsProvider extends ChangeNotifier {
  final _reviewRepo = getIt<ReviewRepo>();

  bool _isLoading = false;
  String? _error;
  PackageReviewsResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  PackageReviewsResponse? get response => _response;

  List<ReviewModel> get reviews => _response?.reviews ?? [];
  ReviewSummary? get summary => _response?.summary;

  Future<void> fetchReviews({required String packageId}) async {
    if (packageId.isEmpty || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _reviewRepo.getReviewsByPackage(packageId: packageId);

    if (result.isLeft()) {
      _isLoading = false;
      _error = result.getLeft().toNullable()?.message ?? 'Unable to load reviews';
      notifyListeners();
      return;
    }

    _isLoading = false;
    _response = result.getRight().toNullable();
    notifyListeners();
  }
}