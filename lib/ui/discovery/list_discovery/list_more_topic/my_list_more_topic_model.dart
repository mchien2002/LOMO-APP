import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/ui/base/base_list_model.dart';

class MyListMoreTopicModel extends BaseListModel<TopictItem> {
  late Future<List<TopictItem>> Function(int page, int pageSize) getTopics;
  @override
  Future<List<TopictItem>?> getData({params, bool isClear = false}) async {
    return getTopics(page, pageSize);
  }

  init(Future<List<TopictItem>> getTopics(int page, int pageSize)) {
    this.getTopics = getTopics;
  }
}
