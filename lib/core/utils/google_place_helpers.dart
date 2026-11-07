import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_servicehub/core/constants/google_places_config.dart';

class GooglePlaceHelpers {
  GooglePlaceHelpers._();

  static Future<Map<String, dynamic>?> getPlaceDetailsFromPlaceId(
    String placeId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId&key=${GooglePlacesConfig.apiKey}',
        ),
      );

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);
      if (data['status'] != 'OK') return null;

      return data['result'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  static ParsedAddress parsePlaceComponents(
    Map<String, dynamic> detail,
  ) {
    final components =
        (detail['address_components'] as List?) ?? [];

    String street = '';
    String city = '';
    String state = '';
    String pincode = '';
    String country = '';

    for (final component in components) {
      final types = (component['types'] as List?) ?? [];
      final longName = (component['long_name'] as String?) ?? '';

      if (types.contains('street_number') ||
          types.contains('route')) {
        if (street.isNotEmpty && longName.isNotEmpty) {
          street = '$street $longName';
        } else if (longName.isNotEmpty) {
          street = longName;
        }
      }

      if (city.isEmpty) {
        if (types.contains('locality')) {
          city = longName;
        } else if (types.contains('sublocality') ||
            types.contains('sublocality_level_1')) {
          city = longName;
        } else if (types
            .contains('administrative_area_level_2')) {
          city = longName;
        }
      }

      if (types.contains('administrative_area_level_1')) {
        state = longName;
      }

      if (types.contains('postal_code')) {
        pincode = longName;
      }

      if (types.contains('country')) {
        country = longName;
      }
    }

    final latitude =
        (detail['geometry']?['location']?['lat'] as num?)
            ?.toDouble() ??
        0.0;
    final longitude =
        (detail['geometry']?['location']?['lng'] as num?)
            ?.toDouble() ??
        0.0;

    return ParsedAddress(
      street: street.trim(),
      city: city.trim(),
      state: state.trim(),
      pincode: pincode.trim(),
      country: country.trim(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  static CityMatchResult findMatchingCity(
    String googleCityName,
    List<dynamic> cities,
  ) {
    if (googleCityName.isEmpty) {
      return const CityMatchResult(matched: false);
    }

    final normalizedGoogle = _normalize(googleCityName);

    for (final city in cities) {
      final cityName = _normalize(city.name);
      if (cityName == normalizedGoogle) {
        return CityMatchResult(matched: true, city: city);
      }
    }

    for (final city in cities) {
      final cityName = _normalize(city.name);
      if (cityName.contains(normalizedGoogle) ||
          normalizedGoogle.contains(cityName)) {
        return CityMatchResult(matched: true, city: city);
      }
    }

    return const CityMatchResult(matched: false);
  }

  static AreaMatchResult findMatchingArea(
    String googleAreaName,
    List<dynamic> areas,
  ) {
    if (googleAreaName.isEmpty) {
      return const AreaMatchResult(matched: false);
    }

    final normalizedGoogle = _normalize(googleAreaName);

    for (final area in areas) {
      final areaName = _normalize(area.name);
      if (areaName == normalizedGoogle) {
        return AreaMatchResult(matched: true, area: area);
      }
    }

    for (final area in areas) {
      final areaName = _normalize(area.name);
      if (areaName.contains(normalizedGoogle) ||
          normalizedGoogle.contains(areaName)) {
        return AreaMatchResult(matched: true, area: area);
      }
    }

    return const AreaMatchResult(matched: false);
  }

  static String _normalize(String value) {
    return value.toLowerCase().trim();
  }
}

class ParsedAddress {
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final double latitude;
  final double longitude;

  const ParsedAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  bool get hasCoordinates => latitude != 0.0 && longitude != 0.0;
}

class CityMatchResult {
  final bool matched;
  final dynamic city;

  const CityMatchResult({required this.matched, this.city});
}

class AreaMatchResult {
  final bool matched;
  final dynamic area;

  const AreaMatchResult({required this.matched, this.area});
}
