import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class FavouriteService extends ApiService {
  Future getFavourites() async {
    var response = await api.get(
      APIURL.favourites,
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future addFavourite(String packageId) async {
    var response = await api.post(
      APIURL.favouriteByPackageId(packageId),
      queryParameters: {},
    );
    return response;
  }

  Future deleteFavourite(String packageId) async {
    var response = await api.delete(
      APIURL.favouriteByPackageId(packageId),
      queryParameters: {},
    );
    return response;
  }
}
