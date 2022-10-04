import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class TopicListModel extends BaseListModel<TopictItem> {
  ValueNotifier<bool> validatedInfo = ValueNotifier(false);
  ValueNotifier<int> totalCountInfo = ValueNotifier(0);
  String textSearch = "";
  int limit = 3;
  late List<TopictItem> currentTopics;

  init(List<TopictItem>? topics) {
    currentTopics = topics ?? [];
    totalCountInfo.value = currentTopics.length;
    notifyListeners();
  }

  @override
  Future<List<TopictItem>> getData({params, bool isClear = false}) async {
    if (isClear) {
      validatedInfo.value = false;
      totalCountInfo.value = currentTopics.length;
    }
    var response = await locator<CommonRepository>()
        .getSearchTopic(textSearch, page, limit: PAGE_SIZE);
    if (currentTopics.length > 0 && response.length > 0)
      currentTopics.forEach((element) {
        response.forEach((element1) {
          if (element.id == element1.id) {
            element1.isCheck = true;
            return;
          }
        });
      });
    return response;
  }

  changeValue(int index, bool isCheck) {
    if (!isLimited() || !isCheck) {
      isCheck ? totalCountInfo.value += 1 : totalCountInfo.value -= 1;
      items[index].isCheck = isCheck;
    }
    validatedInfo.value = totalCountInfo.value > 0 ? true : false;
    notifyListeners();
  }

  bool isLimited() {
    return totalCountInfo.value == limit;
  }

  List<TopictItem> listSelected() {
    return items.where((element) => element.check).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
