import 'package:lomo/libraries/geocoder/services/base.dart';
import 'package:lomo/libraries/geocoder/services/distant_google.dart';
import 'package:lomo/libraries/geocoder/services/local.dart';

export 'model.dart';

class Geocoder {
  static final Geocoding local = LocalGeocoding();

  static Geocoding google(String apiKey, {required String language}) =>
      GoogleGeocoding(apiKey, language: language);
}
