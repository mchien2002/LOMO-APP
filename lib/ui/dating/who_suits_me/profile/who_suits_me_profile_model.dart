import 'package:flutter/material.dart';
import 'package:lomo/ui/base/base_model.dart';

class WhoSuitsMeProfileModel extends BaseModel {
  ValueNotifier<bool> shareQuestionValue = ValueNotifier(false);
  ValueNotifier<bool> tabValue = ValueNotifier(true);
  late TabController tabController;

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    shareQuestionValue.dispose();
    tabController.dispose();
    super.dispose();
  }

  setTotalQuestions(int questionCount) {
    shareQuestionValue.value = questionCount >=3?true:false;
    notifyListeners();
  }

  onTabChanged(int index) {
    tabValue.value = index == 0 ? true : false;
    notifyListeners();
  }
}
