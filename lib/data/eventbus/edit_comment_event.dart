import 'package:lomo/data/api/models/comments.dart';

class EditCommentEvent {
  final Comments data;


  @override
  String toString() {
    return 'EditCommentEvent{data: $data}';
  }

  EditCommentEvent({required this.data});
}
