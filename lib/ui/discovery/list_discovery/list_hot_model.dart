import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListHotModel extends BaseModel {
  List<User> items = [];
  Future<List<User>>? Function(int page, int pageSize)? getData;
  bool isLoading = false;

  setLoading(bool isLoading) {
    this.isLoading = isLoading;
    viewState = isLoading ? ViewState.loading : ViewState.loaded;
  }

  getListUser() async {
    await callApi(doSomething: () async {
      var response = await getData!(1, 10);
      items.clear();
      if (response?.isNotEmpty == true) {
        items.addAll(response!);
      }
      viewState = ViewState.loaded;
      notifyListeners();
    });
  }

  init(Future<List<User>> Function(int page, int pageSize) getData) async {
    this.getData = getData;
    eventBus.on<RefreshDiscoveryListEvent>().listen((event) async {
      await getListUser();
    });
    getListUser();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
