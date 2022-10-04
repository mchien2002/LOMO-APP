import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class FirstMessageModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  ValueNotifier<bool> enableButtonSend = ValueNotifier(false);
  ValueNotifier<bool> enableSend = ValueNotifier(false);
  TextEditingController tecContentMessage = TextEditingController();
  late List<ModelItemSimple> listSampleMessageDating;

  final maxLengthMessage = 200;

  init() {
    if (_commonRepository.listSampleMessageDating.isNotEmpty == true) {
      listSampleMessageDating = _commonRepository.listSampleMessageDating;
    } else {
      getListSampleMessage();
    }

    tecContentMessage.addListener(() {
      enableButtonSend.value = tecContentMessage.text != "" &&
          tecContentMessage.text.length <= maxLengthMessage;
      enableSend.value = tecContentMessage.text != "" &&
          tecContentMessage.text.length <= maxLengthMessage;
    });
  }

  getListSampleMessage() async {
    await _commonRepository.getConstantList();
    listSampleMessageDating = _commonRepository.listSampleMessageDating;
    notifyListeners();
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    enableButtonSend.dispose();
    enableSend.dispose();
    tecContentMessage.dispose();
    super.dispose();
  }
}
