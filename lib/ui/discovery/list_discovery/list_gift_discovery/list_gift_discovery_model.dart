import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListGiftDiscoveryModel extends BaseModel {
  List<Gift> items = [];
  Future<List<Gift>>? Function(int page, int pageSize)? getData;

  @override
  ViewState get viewState => ViewState.loaded;

  getListGiftItem() async {
    await callApi(doSomething: () async {
      var response = await getData!(1, 10);
      items.clear();
      if (response?.isNotEmpty == true) {
        items.addAll(response!);
      }
      notifyListeners();
    });
  }

  init(Future<List<Gift>> Function(int page, int pageSize) getData) async {
    this.getData = getData;
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await getListGiftItem();
    });
    getListGiftItem();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
