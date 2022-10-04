import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class ListMoreHotModel extends BaseListModel<User> {
  late Future<List<User>> Function(int page, int pageSize) getUsers;

  init(Future<List<User>> Function(int page, int pageSize) getUsers) {
    this.getUsers = getUsers;
    // eventBus.on<FollowUserEvent>().listen((event) async {
    //   items.forEach((element) {
    //     if (element.id == event.userId) element.isFollow = event.isFollow;
    //   });
    //   notifyListeners();
    // });
  }

  @override
  Future<List<User>> getData({params,bool isClear = false}) async {
    return getUsers(page, pageSize);
  }
}
