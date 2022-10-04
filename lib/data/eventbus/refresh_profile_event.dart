import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';

class RefreshProfileEvent {
  String userId;
  User? user;

  RefreshProfileEvent(this.userId, {this.user});
}

class RefreshWhenCreatePostEvent {
  User user;
  NewFeed? newFeed;

  RefreshWhenCreatePostEvent(this.user, {this.newFeed});
}
