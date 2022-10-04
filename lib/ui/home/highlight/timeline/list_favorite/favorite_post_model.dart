import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/follow_user_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class FavoritePostModel extends BaseListModel<User> {
  final _newUserRepository = locator<UserRepository>();
  String? id;

  final user = User.fromJson(locator<UserModel>().user!.toJson());

  init(String? idPost) {
    this.id = idPost;
    eventBus.on<FollowUserEvent>().listen((event) async {
      // items.removeWhere((element) => element.id == event.userId);
      notifyListeners();
    });
  }

  @override
  ViewState get initState => ViewState.loading;

  @override
  Future<List<User>> getData({params, bool isClear = false}) async {
    return _newUserRepository.getFavoriteListUser(id ?? "", page, pageSize);
  }
}
