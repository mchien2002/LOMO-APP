import 'package:lomo/data/api/models/comments.dart';

class CommentReplyEvent {
  Comments comment;
  Comments? parent;
  CommentReplyEvent(this.comment, {this.parent});
}
