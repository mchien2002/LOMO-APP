
import 'package:flutter/cupertino.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/checkin.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListCheckinModel extends BaseListModel<Checkin> {
  final _commonRepository = locator<CommonRepository>();
  ValueNotifier<bool> checkinEnable = ValueNotifier(false);

  ViewState get initState => ViewState.loading;

  @override
  Future<List<Checkin>> getData({params, bool isClear = false}) async {
    var data = await _commonRepository.getListCheckin();
    checkinEnable.value = checkEnableButton(data);
    notifyListeners();
    return data;
  }

  Color getBorderColor(int type) {
    if (type == 2) {
      return DColors.violetColor;
    } else {
      return DColors.grayD9Color;
    }
  }

  Future<Checkin?> checkin() async {
    var item = getCheckinItem();
    await callApi(doSomething: () async {
      await _commonRepository.checkin().then((value) {
        item!.check = 1;
        locator<UserModel>().user!.numberOfCandy =
            locator<UserModel>().user!.numberOfCandy! + item.candy!;
        checkinEnable.value = checkEnableButton(items);
        locator<UserModel>().notifyListeners();
      });
    });
    notifyListeners();
    return item;
  }

  Checkin? getCheckinItem() {
    for (Checkin item in items) {
      if (item.check == 2) return item;
    }
    return null;
  }

  bool checkEnableButton(List<Checkin> items) {
    for (Checkin item in items) {
      if (item.check == 2) return true;
    }
    return false;
  }

  @override
  void dispose() {
    checkinEnable.dispose();
    super.dispose();
  }
}
