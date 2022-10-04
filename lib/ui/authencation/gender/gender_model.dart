import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/ui/base/base_model.dart';

class GenderModel extends BaseModel {
  ValueNotifier<bool> confirmEnable = ValueNotifier(false);
  ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  late User user;

  init(User user) {
    this.user = user;
  }

  List<Sogiesc> selectedSogiescList = [];

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    confirmEnable.dispose();
    selectedGender.dispose();

    super.dispose();
  }
}
