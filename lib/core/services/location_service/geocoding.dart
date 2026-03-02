import 'package:mis_mobile/core/models/maps/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class GeocodingService {
  Future<GeocodingModel> getGeoLocator(
      double latitude, double longitude) async {
    final response =
        await geocoding.placemarkFromCoordinates(latitude, longitude);

    return GeocodingModel.fromJson(response);
  }
}
