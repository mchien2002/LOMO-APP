import 'package:lomo/data/api/models/new_feed.dart';

class RefreshTotalCommentEvent {
  bool isAddComment;
  NewFeed newFeed;
  RefreshTotalCommentEvent(this.newFeed, this.isAddComment);
}
