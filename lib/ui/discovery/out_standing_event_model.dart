import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class OutStandingEventModel extends BaseModel {
  Future<List<Event>> Function(int page, int pageSize)? getData;

  @override
  ViewState get initState => ViewState.loaded;

  List<Event>? events;

  init(Future<List<Event>> Function(int page, int pageSize)? getData) async {
    this.getData = getData;
    getEvents();
  }

  getEvents() async {
    var events = await getData!(1, 10);
    if (this.events == null) this.events = [];
    if (events.length > 0) {
      this.events?.clear();
      this.events?.addAll(events);
    } else {
      this.events = [];
    }
    notifyListeners();
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
