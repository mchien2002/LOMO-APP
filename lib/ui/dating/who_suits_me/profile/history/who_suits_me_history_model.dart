import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class WhoSuitsMeHistoryModel extends BaseListModel<WhoSuitsMeHistory> {
  final _userRepository = locator<UserRepository>();
  late User user;

  init(User user) {
    this.user = user;
    loadData();
  }

  @override
  ViewState get initState => ViewState.loading;

  @override
  Future<List<WhoSuitsMeHistory>> getData(
      {params, bool isClear = false}) async {
    return await _userRepository.getWhoSuitsMeHistory(user.id!, page: page);
  }
}
