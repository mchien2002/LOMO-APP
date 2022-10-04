import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/location_manager.dart';
import 'package:rxdart/rxdart.dart';

class ListMoreDiscoveryModel extends BaseModel {
  ListMoreDiscoveryModel(this.getUsers);

  @override
  ViewState get viewState => ViewState.loaded;
  final listStreamController = BehaviorSubject<List<User>>();
  BehaviorSubject<bool> streamLazyController = BehaviorSubject<bool>();
  var discoveryRepository = locator<UserRepository>();
  var locationManager = locator<LocationManager>();
  int count = 0;
  bool stop = false;
  int page = 1;
  int pageSize = PAGE_SIZE;
  List<User>? listItems;

  Future<List<User>> Function(int page, int pageSize) getUsers;

  getListMore() async {
    await callApi(doSomething: () async {
      listItems = await getUsers(page, pageSize);
      listStreamController.sink.add(listItems ?? []);
    });
  }

  void getMore() async {
    if (!stop) {
      page = page + 1;
      startLazyLoad();
      List<User> response = [];
      response = await getUsers(page, pageSize);
      listItems?.addAll(response);
      listStreamController.sink.add(listItems ?? []);
      if (count == count + response.length) {
        stop = true;
        print('ending load more');
      } else {
        count = count + response.length;
      }
      stopLazyLoad();
    }
  }

  void startLazyLoad() {
    print('start');
    streamLazyController.sink.add(true);
  }

  void stopLazyLoad() {
    print('stop');
    streamLazyController.sink.add(false);
  }

  Future<void> refresh({dynamic params}) async {
    count = 0;
    page = 1;
    stop = false;
    listItems?.clear();
    getListMore();
  }

  @override
  void dispose() {
    super.dispose();
    streamLazyController.close();
    listStreamController.close();
  }
}
