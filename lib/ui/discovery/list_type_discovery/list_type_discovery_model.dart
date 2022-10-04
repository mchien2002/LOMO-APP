import 'package:flutter/cupertino.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/delete_post_event.dart';
import 'package:lomo/data/eventbus/lock_post_event.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class ListTypeDiscoveryModel extends BaseListModel<NewFeed> {
  final _newFeedRepository = locator<NewFeedRepository>();
  ValueNotifier<int> totalValue = ValueNotifier(0);
  List<FilterRequestItem>? dataFilter;

  init(List<FilterRequestItem> dataFilter) {
    this.dataFilter = dataFilter;
    //An bai dang khi CRM lock
    eventBus.on<LockPostEvent>().listen((event) {
      items.removeWhere((element) => element.id == event.postId);
      notifyListeners();
    });
    //Xoa bai dang khi owner xoa
    eventBus.on<DeletePostEvent>().listen((event) {
      items.removeWhere((element) => element.id == event.postId);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    totalValue.dispose();
    super.dispose();
  }

  @override
  Future<List<NewFeed>> getData({params, bool isClear = false}) async {
    var data = await _newFeedRepository.getPostsChoice(
        page: page, pageSize: PAGE_SIZE, filters: dataFilter ?? []);
    totalValue.value = data.total;
    notifyListeners();
    return data.items;
  }
}
