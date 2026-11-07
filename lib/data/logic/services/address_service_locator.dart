import 'dart:convert';

import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/api_services.dart';

class AddressService extends ApiService {
  Future fetchCities() async {
    final response = await api.get(
      APIURL.cities,
      data: null,
    );
    return response;
  }

  Future fetchAreasByCity(String cityId) async {
    final response = await api.get(
      APIURL.areasByCity(cityId),
      data: null,
    );
    return response;
  }

  Future fetchAddresses() async {
    final response = await api.get(
      APIURL.profileAddresses,
      data: null,
    );
    return response;
  }

  Future createAddress(Map<String, dynamic> data) async {
    final response = await api.post(
      APIURL.profileAddresses,
      data: jsonEncode(data),
    );
    return response;
  }

  Future deleteAddress(String addressId) async {
    final response = await api.delete(
      APIURL.profileAddressById(addressId),
    );
    return response;
  }
}
