import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class DisplayNameModel extends BaseModel {
  ValueNotifier<bool> confirmEnable = ValueNotifier(false);

  User user = locator<UserModel>().user!;

  init() {
    locator<UserRepository>().setTimeInitProfile(DateTime.now());
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    confirmEnable.dispose();
    super.dispose();
  }
}
