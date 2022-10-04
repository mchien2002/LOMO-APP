import 'package:flutter/cupertino.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/platform_channel.dart';

import '../../../app/user_model.dart';
import '../../../data/api/models/constant_list.dart';
import '../../../data/repositories/common_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../di/locator.dart';

class DeteleAccountModel extends BaseModel {
  final otherReasonId = "6295c9a99277f93d82ef202a";

  final _commonRepository = locator<CommonRepository>();
  List<ReasonDeleteAccountItem> reasonsDelete = [];
  ValueNotifier<Object?> buildListReason = ValueNotifier(null);
  ValueNotifier<bool> enableDelete = ValueNotifier(false);
  final tecOtherReasonDeleteAccount = TextEditingController();

  init() {
    getReasonDeleteAccount();
    tecOtherReasonDeleteAccount.addListener(() {
      reasonsDelete.forEach((element) {
        if (element.item.id == otherReasonId) {
          element.description = tecOtherReasonDeleteAccount.text;
        }
      });
      enableDelete.value = tecOtherReasonDeleteAccount.text.isNotEmpty;
    });
  }

  getReasonDeleteAccount() async {
    if (_commonRepository.listReasonDeleteAccount?.isNotEmpty == true) {
      setListItem(_commonRepository.listReasonDeleteAccount!);
    } else {
      callApi(doSomething: () async {
        await _commonRepository.getConstantList();
        if (_commonRepository.listReasonDeleteAccount?.isNotEmpty == true) {
          setListItem(_commonRepository.listReasonDeleteAccount!);
        }
      });
    }
  }

  setListItem(List<KeyValue> items) {
    reasonsDelete.clear();
    items.forEach((element) {
      reasonsDelete.add(ReasonDeleteAccountItem(element));
    });
    buildListReason.value = Object();
  }

  deleteAccount() async {
    ReasonDeleteAccountItem? itemDeleted;
    reasonsDelete.forEach((element) {
      if (element.isChecked) itemDeleted = element;
    });
    if (itemDeleted != null) {
      await callApi(doSomething: () async {
        final userModel = locator<UserModel>();
        locator<PlatformChannel>().deleteAccount(userModel.user!, itemDeleted!);
        await locator<UserRepository>().deleteAccount(itemDeleted!);
        await userModel.logout();
      });
    }
  }

  setCheckItemReason(int index, ReasonDeleteAccountItem item) {
    reasonsDelete.forEach((element) {
      if (element.item.id == item.item.id) {
        element.isChecked = true;
      } else {
        element.isChecked = false;
      }
    });
    buildListReason.value = Object();
    enableDelete.value =
        item.item.id == otherReasonId ? item.description.isNotEmpty : true;
  }

  @override
  void dispose() {
    buildListReason.dispose();
    enableDelete.dispose();
    tecOtherReasonDeleteAccount.dispose();
    super.dispose();
  }
}

class ReasonDeleteAccountItem {
  ReasonDeleteAccountItem(this.item);
  bool isChecked = false;
  String description = "";
  KeyValue item;
}
