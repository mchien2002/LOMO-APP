import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListTopicHotModel extends BaseModel {
  List<TopictItem> items = [];
  Future<List<TopictItem>>? Function(int page, int pageSize)? getData;

  @override
  ViewState get viewState => ViewState.loaded;

  getListTopicItem() async {
    await callApi(doSomething: () async {
      var response = await getData!(1, 10);
      items.clear();
      if (response?.isNotEmpty == true) {
        items.addAll(response!);
      }
      notifyListeners();
    });
  }

  init(
      Future<List<TopictItem>> Function(int page, int pageSize) getData) async {
    this.getData = getData;
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await getListTopicItem();
    });
    getListTopicItem();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
