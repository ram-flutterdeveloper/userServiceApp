import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/auth_service_locator.dart';
import 'package:user_servicehub/data/models/login_response.dart';

class AuthRepo {
  final AuthServices _authServices;

  AuthRepo(this._authServices);

  FutureResult<LoginResponse> loginWithPhone(String mobile) async {
    try {
      var response = await _authServices.loginWithPhone({"mobile": mobile});

      final LoginResponse model = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<LoginResponse> verifyOTP(String mobile, String otp) async {
    try {
      var response = await _authServices.verifyOtp({
        "mobile": mobile,
        "otp": otp,
      });
      final LoginResponse model = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<LoginResponse> refreshToken(String refreshToken) async {
    try {
      var response = await _authServices.refreshToken(refreshToken);
      final LoginResponse model = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }
}
