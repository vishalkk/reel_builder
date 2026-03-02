import 'package:flutter/widgets.dart';
import 'package:mis_mobile/core/services/location_service/geocoding.dart';
import 'package:mis_mobile/core/services/location_service/location.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  LocationProvider(
    this._geocodingService,
    this._locationService,
  );

  Future<Map<String, dynamic>> getLocation() async {
    final location = await _locationService.getLocation();
    final geocoding = await _geocodingService.getGeoLocator(
      location.lat!,
      location.lng!,
    );
    return {
      'coordinates': location,
      'address': geocoding,
    };
  }
}
