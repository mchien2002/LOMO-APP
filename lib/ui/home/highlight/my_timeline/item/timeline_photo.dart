// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';

class TimeLinePhotoItem extends StatelessWidget {
  TimeLinePhotoItem({Key? key, required this.newFeed}) : super(key: key);
  final NewFeed newFeed;

  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    switch (newFeed.images!.length) {
      case 1:
        return onePhotosLayout(context);
      case 2:
        return twoPhotosLayout(context);
      case 3:
        return threePhotosLayout(context);
      case 4:
        return fourPhotosLayout(context);
      default:
        return fivePhotosLayout(context);
    }
  }

  Widget onePhotosLayout(BuildContext context) {
    final itemWidth = width;
    late double itemHeight;
    final ratio = newFeed.images![0].ratio ?? 0;
    itemHeight = ratio != 0
        ? itemWidth / ratio
        : newFeed.images![0].isVertical
            ? itemWidth * 4 / 3
            : itemWidth * 3 / 4;
    return photoItem(context, height: itemHeight, width: itemWidth, index: 0);
  }

  Widget twoPhotosLayout(BuildContext context) {
    return Container();
  }

  Widget threePhotosLayout(BuildContext context) {
    return Container();
  }

  Widget fourPhotosLayout(BuildContext context) {
    return Container();
  }

  Widget fivePhotosLayout(BuildContext context) {
    return Container();
  }

  Widget photoItem(BuildContext context,
      {required double height, required double width, required int index}) {
    return InkWell(
      onTap: () {},
      child: RoundNetworkImage(
        height: height,
        width: width,
        url: newFeed.images![index].link,
        placeholder: ImageRectangleShimmer(
          height: height,
          width: width,
        ),
      ),
    );
  }
}
