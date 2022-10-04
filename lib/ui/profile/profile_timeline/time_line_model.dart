import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/user_newfeed.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ProfileTimelineModel extends BaseListModel<UserNewFeed> {
  final _newNewFeedRepository = locator<NewFeedRepository>();

  late User user;

  init(User user) {
    this.user = user;
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  Future<List<UserNewFeed>> getData({params,bool isClear = false}) async {
    return await _newNewFeedRepository.getUserNewFeedsOfUser(
        user.id!, page, pageSize);
  }
}
