import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/exceptions/api_exception.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class TemplateQuestionModel extends BaseListModel<WhoSuitsMeQuestion> {
  final commonRepository = locator<CommonRepository>();
  ValueNotifier<bool> loadingValue = ValueNotifier(false);

  @override
  bool get disableLoadMore => true;

  @override
  Future<List<WhoSuitsMeQuestion>?> getData(
      {params, bool isClear = false}) async {
    try {
      final questions = await commonRepository.getQuizTemplate();
      viewState = ViewState.loaded;
      return questions;
    } catch (error) {
      errorMessage = (error as ApiException).message;
      viewState = ViewState.error;
      return [];
    }
  }

  Future<void> onShowHideLoading(bool isLoading) async {
    loadingValue.value = isLoading;
    notifyListeners();
  }
}
