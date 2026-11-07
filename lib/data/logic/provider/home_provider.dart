import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/data/logic/repo/discovery_repo.dart';
import 'package:user_servicehub/data/models/home_response_model.dart'
    hide Location;
import 'package:user_servicehub/data/models/searched_place.dart';

class HomeProvider with ChangeNotifier {
  final _discoveryRepo = getIt<DiscoveryRepo>();

  static const double _defaultLatitude = 26.8467;
  static const double _defaultLongitude = 80.9462;

  bool _isLoading = false;
  bool _isLocating = false;
  bool _isSearching = false;
  String? _error;
  HomeData? _homeData;

  double _latitude = _defaultLatitude;
  double _longitude = _defaultLongitude;
  String? _cityName;
  String? _apiLocationLabel;
  String? _gpsLabel;
  String? _selectedLabel;
  bool _usedFallbackLocation = false;

  List<SearchedPlace> _searchResults = [];

  bool get isLoading => _isLoading;
  bool get isLocating => _isLocating;
  bool get isSearching => _isSearching;
  String? get error => _error;
  HomeData? get homeData => _homeData;

  double get latitude => _latitude;
  double get longitude => _longitude;
  String? get cityName => _cityName;
  String get locationLabel =>
      _selectedLabel ?? _apiLocationLabel ?? _gpsLabel ?? 'Set your location';
  bool get usedFallbackLocation => _usedFallbackLocation;
  List<SearchedPlace> get searchResults => _searchResults;

  Future<void> fetchHome({double? latitude, double? longitude}) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (latitude != null && longitude != null) {
      _latitude = latitude;
      _longitude = longitude;
      _usedFallbackLocation = false;
    } else {
      await resolveCurrentLocation();
    }

    final result = await _discoveryRepo.getHomeData(
      latitude: _latitude,
      longitude: _longitude,
    );

    if (result.isLeft()) {
      _isLoading = false;
      _error =
          result.getLeft().toNullable()?.message ?? 'Failed to load home data';
      notifyListeners();
      return;
    }

    _isLoading = false;
    _homeData = result.getRight().toNullable()?.data;
    _updateApiLocationInfo();
    notifyListeners();
  }

  Future<void> searchPlaces(String query) async {
    final q = query.trim();

    if (q.length < 3) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final locations = await locationFromAddress(q);

      // Remove duplicate coordinates and limit results
      final uniqueLocations = <String, Location>{};

      for (final location in locations) {
        final key =
            '${location.latitude.toStringAsFixed(6)},'
            '${location.longitude.toStringAsFixed(6)}';

        uniqueLocations[key] = location;
      }

      final limitedLocations = uniqueLocations.values.take(5).toList();

      _searchResults = await Future.wait(
        limitedLocations.map((location) async {
          String label = q;
          String locality = '';

          try {
            final placemarks = await placemarkFromCoordinates(
              location.latitude,
              location.longitude,
            );

            if (placemarks.isNotEmpty) {
              final p = placemarks.first;

              final parts =
                  [p.name, p.street, p.subLocality, p.locality]
                      .whereType<String>()
                      .where((e) => e.trim().isNotEmpty)
                      .map((e) => e.trim())
                      .toSet()
                      .toList();

              if (parts.isNotEmpty) {
                label = parts.join(', ');
              }

              final localityParts =
                  [p.locality, p.administrativeArea, p.country]
                      .whereType<String>()
                      .where((e) => e.trim().isNotEmpty)
                      .map((e) => e.trim())
                      .toSet()
                      .toList();

              locality = localityParts.join(', ');
            }
          } catch (e) {
            debugPrint('Reverse geocoding error: $e');
          }

          return SearchedPlace(
            label: label,
            locality: locality,
            latitude: location.latitude,
            longitude: location.longitude,
          );
        }),
      );

      debugPrint('Location results: ${_searchResults.length}');
    } catch (e) {
      debugPrint('Location search error: $e');
      _searchResults = [];
    }

    _isSearching = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  /// User picked a searched address -> send its lat/lng to API.
  Future<void> selectPlace(SearchedPlace place) async {
    _selectedLabel = place.label;
    notifyListeners();
    await fetchHome(latitude: place.latitude, longitude: place.longitude);
  }

  /// User tapped "Use current location" -> GPS coords to API.
  Future<void> useCurrentLocation() async {
    _selectedLabel = null;
    notifyListeners();
    await fetchHome();
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> resolveCurrentLocation() async {
    _isLocating = true;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useFallback();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _useFallback();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;
      _usedFallbackLocation = false;
      await _reverseGeocode(position.latitude, position.longitude);
    } catch (_) {
      _useFallback();
    } finally {
      _isLocating = false;
      notifyListeners();
    }
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return;
      final p = placemarks.first;
      final parts = [
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].whereType<String>().where((s) => s.isNotEmpty);
      final label = parts.join(', ');
      if (_selectedLabel == null && label.isNotEmpty) {
        _gpsLabel = label;
        _cityName = p.locality ?? '';
        notifyListeners();
      }
    } catch (_) {
      // ignore - label stays from API response
    }
  }

  void _useFallback() {
    _latitude = _defaultLatitude;
    _longitude = _defaultLongitude;
    _usedFallbackLocation = true;
  }

  void _updateApiLocationInfo() {
    final location = _homeData?.location;

    final city = location?.city.name;
    final state = location?.city.state;
    final areas = location?.areas ?? const <Area>[];

    if (city != null && city.isNotEmpty) {
      _cityName = city;
      _apiLocationLabel =
          state != null && state.isNotEmpty ? '$city, $state' : city;
    } else if (areas.isNotEmpty) {
      _cityName = areas.first.name;
      _apiLocationLabel = areas.first.name;
    } else {
      _apiLocationLabel = null;
    }
  }

  void clear() {
    _homeData = null;
    _error = null;
  }
}
