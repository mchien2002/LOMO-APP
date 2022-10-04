import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class SearchHashTagModel extends BaseListModel<HashTag> {
  late ValueNotifier<String> textSearch;

  init(ValueNotifier<String> textSearch) {
    this.textSearch = textSearch;
  }

  @override
  Future<List<HashTag>?> getData({params, bool isClear = false}) async {
    return await locator<CommonRepository>()
        .searchHashTag(textSearch.value, page);
  }

  @override
  void dispose() {
    textSearch.dispose();
    super.dispose();
  }
}
