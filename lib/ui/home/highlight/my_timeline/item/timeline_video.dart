import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';

class TimeLineVideoItem extends StatefulWidget {
  const TimeLineVideoItem({Key? key, required this.photo, required this.willPlay})
      : super(key: key);
  final PhotoModel photo;
  final bool willPlay;
  @override
  State<TimeLineVideoItem> createState() => _TimeLineVideoItemState();
}

class _TimeLineVideoItemState extends State<TimeLineVideoItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
