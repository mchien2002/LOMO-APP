import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListMoreOutStandingModel extends BaseListModel<Event> {
  final _commonRepository = locator<CommonRepository>();
  Future<List<Event>> Function(int page, int pageSize)? getItems;

  @override
  ViewState get initState => ViewState.loading;

  init(Future<List<Event>> Function(int page, int pageSize)? getItems) {
    this.getItems = getItems;
  }

  @override
  Future<List<Event>> getData({params, bool isClear = false}) async {
    return getItems!(page, pageSize);
  }

  Future<NewFeed?> getNewFeed(String postId) async {
    try {
      final newFeed = await locator<UserRepository>().getDetailPost(postId);
      return newFeed;
    } catch (e) {
      errorMessage = getErrorMessage(e);
      print(e);
      return null;
    }
  }
}
