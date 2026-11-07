import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/review_service_locator.dart';
import 'package:user_servicehub/data/models/package_reviews_model.dart';

class ReviewRepo {
  final ReviewService _reviewService;

  ReviewRepo(this._reviewService);

  FutureResult<PackageReviewsResponse> getReviewsByPackage({
    required String packageId,
  }) async {
    try {
      final response = await _reviewService.getReviewsByPackage(
        packageId: packageId,
      );

      final data = PackageReviewsResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return right(data);
    } on DioException catch (e) {
      final error = CustomDioExceptions.handleError(e);
      return left(error);
    } catch (e) {
      final error = CustomError(
        statusCode: 0,
        message: 'Unable to load reviews',
        error: e.toString(),
      );
      return left(error);
    }
  }
}