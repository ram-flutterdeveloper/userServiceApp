import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class DiscoveryService extends ApiService {
  Future getHomeData({
    required double latitude,
    required double longitude,
  }) async {
    var response = await api.get(
      APIURL.homeData,
      queryParameters: {
        "latitude": latitude,
        "longitude": longitude,
      },
      data: {},
    );
    return response;
  }
}
