import 'package:dio/dio.dart';
import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class ProfileService extends ApiService {
  Future fetchProfile() async {
    final response = await api.get(
      APIURL.profile,
      data: null,
    );
    return response;
  }

  Future updateProfile(FormData formData) async {
    final response = await api.put(
      APIURL.profile,
      data: formData,
    );
    return response;
  }
}
