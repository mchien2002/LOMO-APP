import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/favorite_newfeed_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/api/models/new_feed.dart';
import '../../../../data/api/models/user.dart';
import '../../../../di/locator.dart';

class MyTimeLineItemModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final commentSubject = BehaviorSubject<bool>();
  late NewFeed newFeed;

  init(NewFeed newFeed) {
    this.newFeed = newFeed;
    eventBus.on<FavoriteNewFeedEvent>().listen((event) async {
      if (this.newFeed.id == event.newfeedId) {
        this.newFeed.numberOfFavorite = event.isFavorite
            ? this.newFeed.numberOfFavorite++
            : this.newFeed.numberOfFavorite--;
        this.newFeed.isFavorite = event.isFavorite;
      }
      notifyListeners();
    });
  }

  unfolowUser(User user) {
    callApi(doSomething: () async {
      _userRepository.unFollowUser(user);
    });
  }

  @override
  void dispose() {
    commentSubject.close();
    super.dispose();
  }

  @override
  ViewState get initState => ViewState.loaded;
}
