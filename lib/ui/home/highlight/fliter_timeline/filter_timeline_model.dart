import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/util/constants.dart';

class FilterTimelineModel extends BaseModel {
  final commonRepository = locator<CommonRepository>();
  List<Sogiesc> selectedSogiescList = [];
  late List<Sogiesc>? sogiescList;
  ValueNotifier<SelectAllEvent?>? setSelectAllSogiesc = ValueNotifier(null);
  ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  ValueNotifier<Object?> resetFilter = ValueNotifier(null);
  late User user;
  String _valueSort = 'createdAt';
  bool _valuePostType = false;
  GetQueryParam? postFilters;
  double _valueDistance = Constants.MAX_RANGE;

  init(GetQueryParam? postFilters) async {
    user = User.fromJson(locator<UserModel>().user!.toJson());
    selectedGender.value = GENDERS[2];
    commonRepository.getConstantList();
    sogiescList = commonRepository.listSogiesc!;

    this.postFilters = postFilters ?? null;

    //check old value filter
    if (postFilters != null) {
      //sort
      if (postFilters.sorts?.isNotEmpty == true) {
        postFilters.sorts?.forEach((dataSort) {
          if (dataSort.key == 'createdAt') {
            _valueSort = dataSort.key;
          }

          if (dataSort.key == 'numberOfFavorite') {
            _valueSort = dataSort.key;
          }
        });
      }

      //filters
      if (postFilters.filters?.isNotEmpty == true) {
        postFilters.filters?.forEach((dataFilter) {
          if (dataFilter.key == 'isFollowing') {
            _valuePostType = true;
          }
          if (dataFilter.key == 'distance') {
            _valueDistance = dataFilter.value;
          }
        });

        List<String?> listId = [];
        for (var i = 0; i < postFilters.filters!.length; i++) {
          if (postFilters.filters![i].key.contains("sogiescs")) {
            listId.addAll(postFilters.filters![i].getArrayDataValues());
          }
        }
        listId.forEach((element) {
          sogiescList?.forEach((itemListsogiesc) {
            if (element == itemListsogiesc.id) {
              selectedSogiescList.add(itemListsogiesc);
            }
          });
        });
      }
    }
  }

  List<Sogiesc> findSogiescListFromListSogiescId(List<Sogiesc> sogiescList) {
    List<String> sogiescIdList = [];
    sogiescList.forEach((data) {
      sogiescIdList.add(data.id!);
    });
    List<Sogiesc> result = [];
    if (sogiescIdList.isNotEmpty == true) {
      sogiescIdList.forEach((id) {
        commonRepository.listSogiesc?.forEach((element) {
          if (element.id == id) {
            result.add(element);
          }
        });
      });
    }
    return result;
  }

  resetData() {
    _valueSort = 'createdAt';
    _valuePostType = false;
    selectedSogiescList.clear();
    resetFilter.value = Object();
    _valueDistance = Constants.MAX_RANGE;
    notifyListeners();
  }

  GetQueryParam getResultFilter() {
    postFilters = GetQueryParam();
    postFilters!.sorts = <FilterRequestItem>[];
    postFilters!.filters = <FilterRequestItem>[];
    //sort
    postFilters!.sorts!.add(FilterRequestItem(key: _valueSort, value: '-1'));
    //post type
    if (_valuePostType)
      postFilters!.filters!
          .add(FilterRequestItem(key: 'isFollowing', value: _valuePostType));

    //sogiesc
    if (selectedSogiescList.isNotEmpty == true) {
      List<String?> listId =
          selectedSogiescList.map((e) => e.id).map((id) => id).toList();
      postFilters!.filters!.add(
        ArrayData(key: "sogiescs", values: listId).toFilterRequestItem(),
      );
    }
    //distance
    if (getValueDistance() != Constants.MAX_RANGE) {
      postFilters!.filters!
          .add(FilterRequestItem(key: 'distance', value: getValueDistance()));
    }

    // check value isDefault
    if (_valueSort == 'createdAt' &&
        selectedSogiescList.isEmpty &&
        _valueDistance == Constants.MAX_RANGE &&
        _valuePostType == false)
      postFilters!.isDefault = true;
    else
      postFilters!.isDefault = false;

    print("CheckDataDis$postFilters");

    return postFilters!;
  }

  setValueSort(String value) => _valueSort = value;

  setValuePostType(bool value) => _valuePostType = value;

  setValueListSogiesc(List<Sogiesc> value) => selectedSogiescList = value;

  getValueSort() => _valueSort;

  getValuePostType() => _valuePostType;

  setValueDistance(double value) => _valueDistance = value;

  getValueDistance() => _valueDistance;

  filterDataToHashMap(List<String?> listInput) {
    final data = {"\$in": listInput};
    return data;
  }

  @override
  ViewState get initState => ViewState.loaded;
}
