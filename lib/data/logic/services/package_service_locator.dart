import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class PackageService extends ApiService {
  Future getPackagesByService({required String serviceId}) async {
    var response = await api.get(
      APIURL.packagesByService(serviceId),
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future getPackageDetails({required String packageId}) async {
    var response = await api.get(
      APIURL.packageDetails(packageId),
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future getAllPackages() async {
    var response = await api.get(
      APIURL.packages,
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future timeSlot() async {
    var response = await api.get(
      APIURL.timeSlot,
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future creatBookings(data) async {
    var response = await api.post(
      APIURL.creatBookings,
      queryParameters: {},
      data: data,
    );
    return response;
  }

  Future getMyBookings(body) async {
    var response = await api.get(
      APIURL.creatBookings,
      queryParameters: body,
      data: {},
    );
    return response;
  }

  Future getBookingById(String id) async {
    var response = await api.get(
      APIURL.bookingById(id),
      queryParameters: {},
      data: {},
    );
    return response;
  }

  Future cancelBooking(String id, [Map<String, dynamic>? reason]) async {
    var response = await api.patch(
      APIURL.cancelBookingById(id),
      queryParameters: {},
      data: reason ?? {},
    );
    return response;
  }
}
