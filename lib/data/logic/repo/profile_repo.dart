import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/profile_service_locator.dart';
import 'package:user_servicehub/data/models/profile_response_model.dart';

class ProfileRepo {
  final ProfileService _profileService;

  ProfileRepo(this._profileService);

  FutureResult<ProfileData> fetchProfile() async {
    try {
      final response = await _profileService.fetchProfile();
      final model = ProfileResponse.fromJson(response.data as Map<String, dynamic>);
      final data = model.data;
      if (data == null) {
        return left(CustomError(statusCode: 0, message: model.message ?? 'Profile not found'));
      }
      return right(data);
    } on DioException catch (e) {
      return left(CustomDioExceptions.handleError(e));
    }
  }

  FutureResult<ProfileData> updateProfile(FormData formData) async {
    try {
      final response = await _profileService.updateProfile(formData);
      final model = ProfileResponse.fromJson(response.data as Map<String, dynamic>);
      final data = model.data;
      if (data == null) {
        return left(CustomError(statusCode: 0, message: model.message ?? 'Update failed'));
      }
      return right(data);
    } on DioException catch (e) {
      return left(CustomDioExceptions.handleError(e));
    }
  }
}
