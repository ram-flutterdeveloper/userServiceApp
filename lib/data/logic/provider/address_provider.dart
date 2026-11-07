import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/address_repo.dart';
import 'package:user_servicehub/data/models/area_model.dart';
import 'package:user_servicehub/data/models/city_model.dart';
import 'package:user_servicehub/data/models/user_address_model.dart';
import 'package:user_servicehub/core/utils/google_place_helpers.dart';

class AddressProvider with ChangeNotifier {
  final _addressRepo = getIt<AddressRepo>();

  List<CityModel> _cities = [];
  List<AreaModel> _areas = [];
  List<UserAddressModel> _addresses = [];

  bool _isLoadingCities = false;
  bool _isLoadingAreas = false;
  bool _isLoadingAddresses = false;
  bool _isCreatingAddress = false;
  bool _isDeletingAddress = false;

  String? _error;
  String? _selectedCityId;
  String? _selectedAreaId;

  final TextEditingController addressSearchController =
      TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  String _addressType = 'HOME';
  bool _isDefault = false;
  bool _isFetchingPlaceDetails = false;

  List<CityModel> get cities => _cities;
  List<AreaModel> get areas => _areas;
  List<UserAddressModel> get addresses => _addresses;

  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingAreas => _isLoadingAreas;
  bool get isLoadingAddresses => _isLoadingAddresses;
  bool get isCreatingAddress => _isCreatingAddress;
  bool get isDeletingAddress => _isDeletingAddress;

  String? get error => _error;
  String? get selectedCityId => _selectedCityId;
  String? get selectedAreaId => _selectedAreaId;

  String get addressType => _addressType;
  bool get isDefault => _isDefault;
  bool get isFetchingPlaceDetails => _isFetchingPlaceDetails;

  CityModel? get selectedCity =>
      _cities.where((c) => c.id == _selectedCityId).firstOrNull;

  AreaModel? get selectedArea =>
      _areas.where((a) => a.id == _selectedAreaId).firstOrNull;

  void setSelectedCity(String? cityId) {
    _selectedCityId = cityId;
    _selectedAreaId = null;
    _areas = [];
    notifyListeners();
    if (cityId != null) fetchAreasByCity(cityId);
  }

  void setSelectedArea(String? areaId) {
    _selectedAreaId = areaId;
    notifyListeners();
  }

  void setAddressType(String type) {
    _addressType = type;
    notifyListeners();
  }

  void setIsDefault(bool value) {
    _isDefault = value;
    notifyListeners();
  }

  void setFetchingPlaceDetails(bool value) {
    _isFetchingPlaceDetails = value;
    notifyListeners();
  }

  void clearControllers() {
    addressSearchController.clear();
    houseNoController.clear();
    buildingNameController.clear();
    floorController.clear();
    streetController.clear();
    landmarkController.clear();
    addressLineController.clear();
    contactPersonController.clear();
    contactNumberController.clear();
    latitudeController.clear();
    longitudeController.clear();
  }

  void resetForm() {
    _addressType = 'HOME';
    _isDefault = false;
    _selectedCityId = null;
    _selectedAreaId = null;
    _areas = [];
    _error = null;
    clearControllers();
    notifyListeners();
  }

  Future<void> fetchCities() async {
    _isLoadingCities = true;
    _error = null;
    notifyListeners();

    final result = await _addressRepo.fetchCities();

    if (result.isLeft()) {
      _isLoadingCities = false;
      _error = result.getLeft().toNullable()?.message ?? 'Failed to load cities';
      notifyListeners();
      return;
    }

    _cities = result.getRight().toNullable()?.data ?? [];
    _isLoadingCities = false;
    notifyListeners();
  }

  Future<void> fetchAreasByCity(String cityId) async {
    _isLoadingAreas = true;
    _error = null;
    notifyListeners();

    final result = await _addressRepo.fetchAreasByCity(cityId);

    if (result.isLeft()) {
      _isLoadingAreas = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load areas';
      notifyListeners();
      return;
    }

    _areas = result.getRight().toNullable()?.data ?? [];
    _isLoadingAreas = false;
    notifyListeners();
  }

  Future<void> fetchAddresses() async {
    _isLoadingAddresses = true;
    _error = null;
    notifyListeners();

    final result = await _addressRepo.fetchAddresses();

    if (result.isLeft()) {
      _isLoadingAddresses = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load addresses';
      notifyListeners();
      return;
    }

    _addresses = result.getRight().toNullable()?.data ?? [];
    _isLoadingAddresses = false;
    notifyListeners();
  }

  Future<bool> createAddress(Map<String, dynamic> data) async {
    _isCreatingAddress = true;
    _error = null;
    notifyListeners();

    final result = await _addressRepo.createAddress(data);

    if (result.isLeft()) {
      _isCreatingAddress = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to create address';
      notifyListeners();
      return false;
    }

    final newAddress = result.getRight().toNullable();
    if (newAddress != null) {
      _addresses.insert(0, newAddress);
    }
    _isCreatingAddress = false;
    notifyListeners();
    return true;
  }

  Future<bool> deleteAddress(String addressId) async {
    _isDeletingAddress = true;
    _error = null;
    notifyListeners();

    final result = await _addressRepo.deleteAddress(addressId);

    if (result.isLeft()) {
      _isDeletingAddress = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to delete address';
      notifyListeners();
      return false;
    }

    _addresses.removeWhere((a) => a.id == addressId);
    _isDeletingAddress = false;
    notifyListeners();
    return true;
  }

  void resetSelection() {
    _selectedCityId = null;
    _selectedAreaId = null;
    _areas = [];
  }

  void autoSelectCityAndArea(ParsedAddress parsed) {
    if (_cities.isEmpty) return;

    final cityResult = GooglePlaceHelpers.findMatchingCity(
      parsed.city,
      _cities,
    );

    if (cityResult.matched && cityResult.city != null) {
      final matchedCity = cityResult.city as CityModel;
      setSelectedCity(matchedCity.id);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final areaResult = GooglePlaceHelpers.findMatchingArea(
          parsed.street,
          _areas,
        );
        if (areaResult.matched && areaResult.area != null) {
          setSelectedArea((areaResult.area as AreaModel).id);
        }
      });
    }
  }

  Map<String, dynamic> buildAddressData() {
    final lat = double.tryParse(latitudeController.text.trim());
    final lng = double.tryParse(longitudeController.text.trim());
    return {
      'cityId': _selectedCityId,
      'areaId': _selectedAreaId,
      'houseNo': houseNoController.text.trim(),
      'buildingName': buildingNameController.text.trim(),
      'floor': floorController.text.trim(),
      'street': streetController.text.trim(),
      'landmark': landmarkController.text.trim(),
      'addressLine': addressLineController.text.trim(),
      'latitude': lat,
      'longitude': lng,
      'contactPerson': contactPersonController.text.trim(),
      'contactNumber': contactNumberController.text.trim(),
      'addressType': _addressType,
      'isDefault': _isDefault,
    };
  }
}
