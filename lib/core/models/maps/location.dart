import 'package:location/location.dart';

class LocationModel {
  // String address;
  double? lat;
  double? lng;
  // String name;
  // String placeId;
  // String reference;
  // String scope;
  // String types;

  LocationModel({
    // required this.address,
    required this.lat,
    required this.lng,
    // required this.name,
    // required this.placeId,
    // required this.reference,
    // required this.scope,
    // required this.types,
  });

  factory LocationModel.fromJson(LocationData locationData) => LocationModel(
        // address: json["address"],
        lat: locationData.latitude,
        lng: locationData.longitude,
        // name: json["name"],
        // placeId: json["place_id"],
        // reference: json["reference"],
        // scope: json["scope"],
        // types: json["types"],
      );

  Map<String, dynamic> toJson() => {
        // "address": address,
        "lat": lat,
        "lng": lng,
        // "name": name,
        // "place_id": placeId,
        // "reference": reference,
        // "scope": scope,
        // "types": types,
      };
}
