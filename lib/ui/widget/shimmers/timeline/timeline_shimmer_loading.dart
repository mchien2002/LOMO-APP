import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';

import 'action_shimmer.dart';
import 'user_shimmer.dart';

class TimelineShimmerLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimelineShimmerLoadingState();
}

class _TimelineShimmerLoadingState extends State<TimelineShimmerLoading> {
  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    var itemWidth = (width - (Dimens.spacing16 * 2));
    return Container(
      color: getColor().white,
      child: ListView.separated(
        itemCount: 3,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (_, index) => Container(
          color: getColor().white,
          child: Column(
            children: [
              Container(
                height: index == 0 ? 1 : 0,
                color: DColors.grayE0Color,
              ),
              SizedBox(
                height: 10,
              ),
              UserShimmer(),
              SizedBox(
                height: 15,
              ),
              ImageRectangleShimmer(
                width: itemWidth,
                height: itemWidth * 3 / 2,
              ),
              SizedBox(
                height: 15,
              ),
              ActionShimmer(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => buildSeparator(context, index),
      ),
    );
  }

  Widget buildSeparator(BuildContext context, int index) {
    return Container(
      height: 1,
      color: DColors.grayF0CColor,
    );
  }
}
