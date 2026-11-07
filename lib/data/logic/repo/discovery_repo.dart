import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/discovery_service_locator.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';

class DiscoveryRepo {
  final DiscoveryService _discoveryService;

  DiscoveryRepo(this._discoveryService);

  FutureResult<HomeResponse> getHomeData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      var response = await _discoveryService.getHomeData(
        latitude: latitude,
        longitude: longitude,
      );

      final HomeResponse model = HomeResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }
}
