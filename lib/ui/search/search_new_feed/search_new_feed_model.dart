import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class SearchNewFeedModel extends BaseListModel<NewFeed> {
  int skip = 0;
  bool isFirst = true;
  late ValueNotifier<String> textSearch;

  init(ValueNotifier<String> textSearch) {
    this.textSearch = textSearch;
  }

  final _newFeedRepository = locator<NewFeedRepository>();
  List<FilterRequestItem>? dataFilter;

  @override
  void dispose() {
    textSearch.dispose();
    super.dispose();
  }

  @override
  Future<void> refresh({params}) {
    isFirst = true;
    return super.refresh();
  }

  @override
  Future<List<NewFeed>> getData({params, bool isClear = false}) async {
    final response = await locator<CommonRepository>()
        .searchPostAdvance(textSearch.value, skip, isFirst);
    skip = response.skip;
    isFirst = response.isFirst;
    return response.list;
  }
}
