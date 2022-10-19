import 'package:flutter/material.dart';

import '../../../../../data/api/models/new_feed.dart';
import '../../timeline/item/referral_item.dart';

class ContentItemWidget extends StatefulWidget {
  const ContentItemWidget(
      {Key? key,
      required this.topicsLayout,
      required this.actionLayout,
      required this.contentInfoLayout, required this.newFeed})
      : super(key: key);
  final NewFeed newFeed;
  final Widget topicsLayout;
  final Widget actionLayout;
  final Widget contentInfoLayout;
  @override
  State<ContentItemWidget> createState() => _ContentItemWidgetState();
}

class _ContentItemWidgetState extends State<ContentItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.newFeed.topics!.isNotEmpty)
            widget.topicsLayout,
          widget.contentInfoLayout,
          widget.actionLayout,
          SizedBox(
            height: 12,
          ),
          if (widget.newFeed.isReferral) ReferralItem()
        ],
      ),
    );
  }
}
