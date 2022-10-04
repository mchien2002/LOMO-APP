import '../new_feed.dart';

class NewFeedResponse {
  int total;
  List<NewFeed> items;

  NewFeedResponse(this.items, {this.total = 0});
}
