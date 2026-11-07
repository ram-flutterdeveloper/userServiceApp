import 'dart:convert';

import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class AuthServices extends ApiService {
  Future loginWithPhone(data) async {
    var response = await api.post(
      APIURL.loginWithPhone,
      data: jsonEncode(data),
    );
    return response;
  }

  Future verifyOtp(data) async {
    var response = await api.post(
      APIURL.verifyPhoneOTP,
      data: jsonEncode(data),
    );
    return response;
  }

  Future refreshToken(String refreshToken) async {
    var response = await api.post(
      APIURL.refreshToken,
      data: jsonEncode({"refreshToken": refreshToken}),
    );
    return response;
  }
}
