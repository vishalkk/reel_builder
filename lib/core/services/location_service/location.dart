import 'package:location/location.dart';
import 'package:mis_mobile/core/models/maps/location.dart';

class LocationService {
  final _location = Location();
  Future<LocationModel> getLocation() async {
    final response = await _location.getLocation();
    return LocationModel.fromJson(response);
  }
}
