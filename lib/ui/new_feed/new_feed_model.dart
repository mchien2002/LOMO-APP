import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/common_utils.dart';

class NewFeedModel extends BaseListModel<NewFeed> {
  late Future<List<NewFeed>> Function(int page, int pageSize) getFeeds;

  init(Future<List<NewFeed>> Function(int page, int pageSize) getNewFeeds) {
    this.getFeeds = getNewFeeds;
    // eventBus.on<FollowUserEvent>().listen((event) async {
    //   items?.forEach((newFeed) {
    //     if (event.userId == newFeed.user.id) {
    //       newFeed.user.isFollow = event.isFollow;
    //     }
    //     notifyListeners();
    //   });
    // });
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  Future<List<NewFeed>?> getData({params,bool isClear = false}) async {
    final data = await getFeeds(page, pageSize);
    return shuffle(data);
  }
}
