import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/NewFeedResponse.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class DiscoveryNewFeedsMoreModel extends BaseListModel<NewFeed> {
  late Future<NewFeedResponse> Function(int page, int pageSize) getPosts;

  init(Future<NewFeedResponse> Function(int page, int pageSize) getPosts) {
    this.getPosts = getPosts;
  }

  @override
  Future<List<NewFeed>?> getData({params, bool isClear = false}) async {
    final response = await getPosts(page, pageSize);
    return response.items;
  }
}
