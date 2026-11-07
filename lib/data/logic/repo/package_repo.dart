import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/package_service_locator.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';
import 'package:user_servicehub/data/models/package_details_model.dart';
import 'package:user_servicehub/data/models/service_model.dart';

class PackageRepo {
  final PackageService _packageService;

  PackageRepo(this._packageService);

  FutureResult<List<PopularPackage>> getPackagesByService({
    required String serviceId,
  }) async {
    try {
      var response = await _packageService.getPackagesByService(
        serviceId: serviceId,
      );

      final List<PopularPackage> packages =
          (response.data['data'] as List? ?? [])
              .map((x) => PopularPackage.fromJson(x as Map<String, dynamic>))
              .toList();

      return right(packages);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<PackageDetailsResponse> getPackageDetails({
    required String packageId,
  }) async {
    try {
      final response = await _packageService.getPackageDetails(
        packageId: packageId,
      );

      final details = PackageDetailsResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return right(details);
    } on DioException catch (e) {
      final error = CustomDioExceptions.handleError(e);
      return left(error);
    } catch (e) {
      final error = CustomError(
        statusCode: 0,
        message: 'Unable to load package details',
        error: e.toString(),
      );
      return left(error);
    }
  }

  FutureResult<dynamic> timeSlot() async {
    try {
      var response = await _packageService.timeSlot();
      return right(response);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<List<ServiceModel>> getAllPackages() async {
    try {
      var response = await _packageService.getAllPackages();

      final List<PopularPackage> packages =
          (response.data['data'] as List? ?? [])
              .map((x) => PopularPackage.fromJson(x as Map<String, dynamic>))
              .toList();

      final List<ServiceModel> services = packages
          .map((p) => ServiceModel.fromPopularPackage(p))
          .toList();

      return right(services);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    } catch (e) {
      return left(
        CustomError(
          statusCode: 0,
          message: 'Unable to load packages',
          error: e.toString(),
        ),
      );
    }
  }

  FutureResult<dynamic> creatBookings(data) async 
  {
    try {
      var response = await _packageService.creatBookings(data);
      return right(response);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<dynamic> getMyBookings(body) async {
    try {
      var response = await _packageService.getMyBookings(body);
      return right(response);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<dynamic> getBookingById(String id) async {
    try {
      var response = await _packageService.getBookingById(id);
      return right(response);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<dynamic> cancelBooking(String id, [Map<String, dynamic>? reason]) async {
    try {
      var response = await _packageService.cancelBooking(id, reason);
      return right(response);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }
}
