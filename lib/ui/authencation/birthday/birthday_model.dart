import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/ui/base/base_model.dart';

class BirthdayModel extends BaseModel {
  ValueNotifier<bool> confirmEnable = ValueNotifier(false);
  ValueNotifier<DateTime?> confirmDate = ValueNotifier(null);
  late User user;

  init(User user) {
    this.user = user;
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    confirmDate.dispose();
    confirmEnable.dispose();

    super.dispose();
  }
}
