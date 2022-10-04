import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class EventSliderModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loading;

  List<Event> events = [];

  getEventsSlider() async {
    callApi(doSomething: () async {
      final events = await locator<CommonRepository>().getSliderEvents();
      this.events.clear();
      if (events.length > 0) {
        this.events.addAll(events);
      }
      setState(ViewState.loaded);
    });
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
