import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class ListMoreTopicModel extends BaseListModel<TopictItem> {
  late Future<List<TopictItem>> Function(int page, int pageSize) getTopics;

  init(Future<List<TopictItem>> getTopics(int page, int pageSize)) {
    this.getTopics = getTopics;
  }

  @override
  Future<List<TopictItem>> getData({params, bool isClear = false}) async {
    // GET page and pageSize
    return getTopics(page, pageSize);
  }
}
