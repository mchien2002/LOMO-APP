import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class PersonMessageModel extends BaseListModel<User> {
  final _newUserRepository = locator<UserRepository>();
  late User user;

  init(User user) {
    this.user = user;
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  Future<List<User>> getData({params,bool isClear = false}) async {
    return _newUserRepository.getFavoritorUser(user.id!, page, pageSize);
  }
}
