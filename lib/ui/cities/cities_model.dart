import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class CitiesModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  final ValueNotifier<int?> citiesUpdateListener = ValueNotifier(null);
  late List<City> fullCities;
  late List<City> cities;

  ViewState get initState => ViewState.loading;

  getCities() async {
    fullCities = await _commonRepository.getCities();
    cities = fullCities;
    setState(ViewState.loaded);
  }

  searchCities(String keySearch) async {
    if (keySearch == "") {
      cities = fullCities;
      notifyCitiesListener();
    } else {
      cities = fullCities
          .where((element) => removeDiacritics(element.name.toLowerCase())
              .contains(removeDiacritics(keySearch.toLowerCase())))
          .toList();
      notifyCitiesListener();
    }
  }

  notifyCitiesListener() {
    citiesUpdateListener.value = DateTime.now().millisecondsSinceEpoch;
  }
}
