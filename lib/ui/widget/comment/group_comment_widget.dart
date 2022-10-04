import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/refresh_total_comment_event.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/animation/route/slide_bottom_to_top_route.dart';
import 'package:lomo/ui/comment/comment_screen.dart';
import 'package:lomo/util/constants.dart';

class GroupCommentWidget extends StatefulWidget {
  final NewFeed newFeed;
  final bool disableAction;
  final bool showFullTotalComment;
  final Widget? iconComment;
  final TextStyle? textTheme;

  GroupCommentWidget(this.newFeed,
      {this.iconComment,
      this.disableAction = false,
      this.showFullTotalComment = true,
      this.textTheme});

  @override
  State<StatefulWidget> createState() => _GroupCommentWidgetState();
}

class _GroupCommentWidgetState extends State<GroupCommentWidget> {
  @override
  void initState() {
    super.initState();
    eventBus.on<RefreshTotalCommentEvent>().listen((event) {
      if (event.newFeed.id == widget.newFeed.id)
        setState(() {
          widget.newFeed.numberOfComment = event.newFeed.numberOfComment;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Row(
          children: [
            widget.iconComment != null
                ? widget.iconComment!
                : Image.asset(
                    DImages.commentWhite,
                    width: 20,
                    height: 20,
                    color: getColor().white,
                  ),
            SizedBox(
              width: 3,
            ),
            Text(
                "${widget.newFeed.numberOfComment} ${widget.showFullTotalComment ? Strings.comments.localize(context).toLowerCase() : ""}",
                style: widget.textTheme != null
                    ? widget.textTheme
                    : textTheme(context).text13.colorWhite)
          ],
        ),
        onTap: () {
          if (!widget.disableAction)
            Navigator.push(
                context,
                SlideBottomToTopRoute(
                    page: CommentScreen(CommentType.post,
                        newFeed: widget.newFeed)));
        },
      ),
    );
  }
}
