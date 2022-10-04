import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class SearchThemeModel extends BaseListModel<TopictItem> {
  int skip = 0;
  bool isFirst = true;
  late ValueNotifier<String> textSearch;

  init(ValueNotifier<String> textSearch) {
    this.textSearch = textSearch;
  }

  @override
  Future<List<TopictItem>> getData({params, bool isClear = false}) async {
    final response = await locator<CommonRepository>()
        .searchTopicAdvance(textSearch.value, skip, isFirst);
    skip = response.skip;
    isFirst = response.isFirst;
    return response.list;
  }

  @override
  Future<void> refresh({params}) {
    isFirst = true;
    return super.refresh();
  }

  @override
  void dispose() {
    textSearch.dispose();
    super.dispose();
  }
}
