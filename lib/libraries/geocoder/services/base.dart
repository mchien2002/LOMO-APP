import 'dart:async';

import 'package:lomo/libraries/geocoder/model.dart';


abstract class Geocoding {

  /// Search corresponding addresses from given [coordinates].
  Future<List<Address>> findAddressesFromCoordinates(Coordinates coordinates);

  /// Search for addresses that matches que given [address] query.
  Future<List<Address>> findAddressesFromQuery(String address);
}