import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/constants.dart';

class PersonFollowModel extends BaseListModel<User> {
  final _newUserRepository = locator<UserRepository>();
  late User user;
  late FollowType type;
  String textSearch = "";

  @override
  void dispose() {
    super.dispose();
  }

  init(User user, FollowType type) {
    this.user = user;
    this.type = type;
    eventBus.on<FollowUserEvent>().listen((event) async {
      if (type == FollowType.following && user.isMe)
        items.removeWhere((element) => element.id == event.userId);
      notifyListeners();
    });
  }

  @override
  ViewState get initState => ViewState.loading;

  @override
  Future<List<User>> getData({params, bool isClear = false}) async {
    if (type == FollowType.follower) {
      return _newUserRepository.getFollowerUser(
          user.id!, textSearch, page, pageSize);
    } else {
      return await _newUserRepository.getFollowingUser(
          user.id!, textSearch, page, pageSize);
    }
  }
}
