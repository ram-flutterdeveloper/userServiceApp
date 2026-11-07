import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:user_servicehub/core/utils/custom_dio_exception.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';
import 'package:user_servicehub/data/logic/services/address_service_locator.dart';
import 'package:user_servicehub/data/models/area_model.dart';
import 'package:user_servicehub/data/models/city_model.dart';
import 'package:user_servicehub/data/models/user_address_model.dart';

class AddressRepo {
  final AddressService _addressService;

  AddressRepo(this._addressService);

  FutureResult<CityResponse> fetchCities() async {
    try {
      final response = await _addressService.fetchCities();
      final model = CityResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<AreaResponse> fetchAreasByCity(String cityId) async {
    try {
      final response = await _addressService.fetchAreasByCity(cityId);
      final model = AreaResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<UserAddressResponse> fetchAddresses() async {
    try {
      final response = await _addressService.fetchAddresses();
      final model = UserAddressResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<UserAddressModel> createAddress(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _addressService.createAddress(data);
      final model = UserAddressModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      return right(model);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }

  FutureResult<bool> deleteAddress(String addressId) async {
    try {
      await _addressService.deleteAddress(addressId);
      return right(true);
    } on DioException catch (e) {
      var error = CustomDioExceptions.handleError(e);
      return left(error);
    }
  }
}
