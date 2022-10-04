import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class ListMoreTopicModel extends BaseListModel<TopictItem> {
  late Future<List<TopictItem>> Function(int page, int pageSize) getTopics;

  init(Future<List<TopictItem>> Function(int page, int pageSize) getTopics) {
    this.getTopics = getTopics;
  }

  @override
  Future<List<TopictItem>> getData({params,bool isClear = false}) async {
    return getTopics(page, pageSize);
  }
}
