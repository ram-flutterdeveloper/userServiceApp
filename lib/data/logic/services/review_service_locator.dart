import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class ReviewService extends ApiService {
  Future getReviewsByPackage({required String packageId}) async {
    var response = await api.get(
      APIURL.reviewsByPackage(packageId),
      queryParameters: {},
      data: {},
    );
    return response;
  }
}