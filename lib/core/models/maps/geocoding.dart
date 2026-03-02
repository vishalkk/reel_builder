import 'package:geocoding/geocoding.dart';

class GeocodingModel {
  final String? street;
  final String? city;
  final String? country;

  GeocodingModel({
    required this.street,
    required this.city,
    required this.country,
  });

  factory GeocodingModel.fromJson(List<Placemark> placeMarks) => GeocodingModel(
        street: placeMarks[0].street,
        city: placeMarks[0].locality,
        country: placeMarks[0].country,
      );
}