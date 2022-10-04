import 'package:hive/hive.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/database/db_constants.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  init() async {
    final document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    initAdapter();
  }

  initAdapter() {
    Hive.registerAdapter(NewFeedAdapter());
    Hive.registerAdapter(SogiescAdapter());
    Hive.registerAdapter(GenderAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(PhotoModelAdapter());
    Hive.registerAdapter(TopictItemAdapter());
  }

  clearAll() {
    Hive.box(TABLE_NEWFEED).clear();
  }

  addNewFeeds(List<NewFeed> newFeeds) async {
    var box = await Hive.openBox<NewFeed>(TABLE_NEWFEED);
    box.clear();
    box.addAll(newFeeds);
  }

  Future<List<NewFeed>> getNewFeeds() async {
    var box = await Hive.openBox<NewFeed>(TABLE_NEWFEED);
    var newFeeds = box.values.toList();
    return newFeeds;
  }
}
