import '../../../../app/lomo_app.dart';
import '../../../../data/api/models/topic_item.dart';
import '../../../../data/eventbus/refresh_discovery_list_event.dart';
import '../../../base/base_model.dart';

class ListKnowledgeModel extends BaseModel {
  @override
  ViewState get viewState => ViewState.loaded;
  List<TopictItem> items = [];
  Future<List<TopictItem>>? Function(int page, int pageSize)? getData;

  @override
  void dispose() {
    super.dispose();
  }

  getListKnowledgeItem() async {
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
      await getListKnowledgeItem();
    });
    getListKnowledgeItem();
  }
}
