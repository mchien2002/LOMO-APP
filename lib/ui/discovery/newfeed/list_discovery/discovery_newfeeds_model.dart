import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/ui/base/base_model.dart';

class DiscoveryNewFeedsModel extends BaseModel {
  List<NewFeed> items = [];
  Future<NewFeedResponse>? Function(int page, int pageSize)? getData;

  @override
  ViewState get viewState => ViewState.loaded;

  getNewFeeds() async {
    await callApi(doSomething: () async {
      var response = await getData!(1, 10);
      items.clear();
      if (response?.items.isNotEmpty == true) {
        items.addAll(response!.items);
      }
      notifyListeners();
    });
  }

  init(Future<NewFeedResponse> Function(int page, int pageSize) getData) async {
    this.getData = getData;
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await getNewFeeds();
    });
    getNewFeeds();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
