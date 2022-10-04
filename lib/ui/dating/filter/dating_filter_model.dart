import 'package:flutter/cupertino.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/ui/base/base_model.dart';

class DatingFilterModel extends BaseModel {
  TextEditingController careerController = TextEditingController();

  List<KeyValue>? listCareer;
  List<Zodiac>? listZodiac;
  List<City>? listCityFilter;
  List<KeyValue>? listCareerFilter;

  final commonRepository = locator<CommonRepository>();
  List<FilterRequestItem>? filters;

  List<Sogiesc> sogiescsValue = [];
  List<KeyValue> careerValue = [];
  List<Literacy> listLiteracy = [];
  List<Literacy> selectedChoicesLiteracy = [];
  List<Zodiac> selectedChoicesZodiac = [];
  double _valueRange = Constants.MAX_RANGE;
  double _valueMinAge = Constants.minAge;
  double _valueMaxAge = Constants.maxAge;
  City? _valueCity;
  bool? _valueVerifyAccount;
  bool? _valueVerifyAccountInit;

  ValueNotifier<Object?> resetFilter = ValueNotifier(null);

  final user = User.fromJson(locator<UserModel>().user!.toJson());

  init(List<FilterRequestItem>? filters) {
    commonRepository.getConstantList();
    listLiteracy = commonRepository.listLiteracy ?? [];
    listCareer = commonRepository.listCareer;
    listZodiac = commonRepository.listZodiac;
    listCityFilter = commonRepository.listCity;
    listCareerFilter = commonRepository.listCareer;
    _valueVerifyAccountInit = false;
    _valueVerifyAccount = false;
    this.filters = filters;
    // check old data
    if (filters?.isNotEmpty == true) {
      filters?.forEach((itemFilter) {
        //literacy
        if (itemFilter.key == 'literacy') {
          final listLiteracyIds = itemFilter.getArrayDataValues();
          listLiteracyIds.forEach((element) {
            listLiteracy.forEach((itemListLiteracy) {
              if (element == itemListLiteracy.id) {
                selectedChoicesLiteracy.add(itemListLiteracy);
              }
            });
          });
        }

        //zodiac
        if (itemFilter.key == 'zodiac') {
          final listZodiacIds = itemFilter.getArrayDataValues();
          listZodiacIds.forEach((element) {
            listZodiac?.forEach((itemListZodiac) {
              if (element == itemListZodiac.id) {
                selectedChoicesZodiac.add(itemListZodiac);
              }
            });
          });
        }
        //age
        if (itemFilter.key == 'age') {
          _valueMinAge = double.parse(itemFilter.value[0]);
          _valueMaxAge = double.parse(itemFilter.value[1]);
        }

        //distance
        if (itemFilter.key == 'distance') {
          _valueRange = itemFilter.value;
        }

        //careers
        if (itemFilter.key == 'careers') {
          final listCareersIds = itemFilter.getArrayDataValues();
          listCareersIds.forEach((element) {
            listCareer?.forEach((itemListCareer) {
              if (element == itemListCareer.id) {
                careerValue.add(itemListCareer);
              }
            });
          });
        }
        //province
        if (itemFilter.key == 'province') {
          listCityFilter?.forEach((itemCity) {
            if (itemFilter.value == itemCity.id) _valueCity = itemCity;
          });
        }

        //isVerify
        if (itemFilter.key == 'datingStatus') {
          _valueVerifyAccount = true;
        }
      });
    }
  }

  @override
  ViewState get initState => ViewState.loaded;

  List<FilterRequestItem> getResultFilter() {
    filters?.clear();
    filters = [];
    //age
    if (_valueMinAge != Constants.minAge || _valueMaxAge != Constants.maxAge) {
      List<String> age = [];
      age.add(_valueMinAge.toInt().toString());
      age.add(_valueMaxAge.toInt().toString());
      filters?.add(FilterRequestItem(key: 'age', value: age));
    }

    //literacy
    if (selectedChoicesLiteracy.isNotEmpty) {
      List<String> listId =
          selectedChoicesLiteracy.map((e) => e.id!).map((id) => id).toList();
      filters?.add(
        ArrayData(key: "literacy", values: listId).toFilterRequestItem(),
      );
    }

    //zodiac
    if (selectedChoicesZodiac.isNotEmpty) {
      List<String> listId =
          selectedChoicesZodiac.map((e) => e.id!).map((id) => id).toList();
      filters?.add(
        ArrayData(key: "zodiac", values: listId).toFilterRequestItem(),
      );
    }

    //province
    if (_valueCity != null) {
      filters?.add(FilterRequestItem(key: 'province', value: _valueCity?.id));
    }

    //careers
    if (careerValue.isNotEmpty) {
      List<String> listId =
          careerValue.map((e) => e.id!).map((id) => id).toList();
      filters?.add(
        ArrayData(key: "careers", values: listId).toFilterRequestItem(),
      );
    }
    //distance
    if (_valueRange != Constants.MAX_RANGE) {
      filters?.add(FilterRequestItem(key: 'distance', value: _valueRange));
    }

    //datingStatus
    if (_valueVerifyAccount != _valueVerifyAccountInit) {
      filters?.add(
          FilterRequestItem(key: 'datingStatus', value: Constants.ID_VERIFY));
    }

    return filters!;
  }

  filterDataToHashMap(List<String> listInput) {
    final data = {"\$in": listInput};
    return data;
  }

  void reset() {
    resetFilter.value = Object();
    careerController.text = "";
    careerValue.clear();
    selectedChoicesLiteracy.clear();
    selectedChoicesZodiac.clear();
    _valueCity = null;
    _valueRange = 500.0;
    _valueMinAge = Constants.minAge;
    _valueMaxAge = Constants.maxAge;
    _valueVerifyAccount = false;
    notifyListeners();
  }

  setValueListLiteracy(List<Literacy> value) => selectedChoicesLiteracy = value;

  getValueListLiteracy() => selectedChoicesLiteracy;

  setValueListZodiac(List<Zodiac> value) => selectedChoicesZodiac = value;

  getValueListZodiac() => selectedChoicesZodiac;

  setValueCity(City value) => _valueCity = value;

  getValueCity() => _valueCity;

  setValueRange(double value) => _valueRange = value;

  getValueRange() => _valueRange;

  setValueMinAge(double value) => _valueMinAge = value;

  setValueMaxAge(double value) => _valueMaxAge = value;

  getValueMinAge() => _valueMinAge;

  getValueMaxAge() => _valueMaxAge;

  setValueVerifyAccount(bool value) => _valueVerifyAccount = value;

  getValueVerifyAccount() => _valueVerifyAccount;

  void printData() {}

  @override
  void dispose() {
    super.dispose();
  }
}
