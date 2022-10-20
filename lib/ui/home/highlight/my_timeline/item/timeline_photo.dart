// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/theme_manager.dart';
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
    List<PhotoModel> photos = newFeed.images!;
    var isVerticalPhoto1 = photos[0].isVertical;
    var isVerticalPhoto2 = photos[1].isVertical;
    late double itemWidth;
    late double itemHeight;

    if (!isVerticalPhoto1 && !isVerticalPhoto2) {
      itemWidth = width - Dimens.spacing3;
      itemHeight = width * (3 / 4);
      // Xếp theo bố cục dọc
      return Container(
        child: Column(
          children: [
            photoItem(context, height: itemHeight, width: itemWidth, index: 0),
            SizedBox(
              width: Dimens.spacing3,
            ),
            photoItem(context, height: itemHeight, width: itemWidth, index: 1),
          ],
        ),
      );
    } else {
      itemWidth = (width - Dimens.spacing3) / 2;
      itemHeight = width * (4 / 3);
      // Xếp theo bố cục ngang
      return Container(
        child: Row(
          children: [
            photoItem(context, height: itemHeight, width: itemWidth, index: 0),
            SizedBox(
              height: Dimens.spacing3,
            ),
            photoItem(context, height: itemHeight, width: itemWidth, index: 1),
          ],
        ),
      );
    }
  }

  Widget threePhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    late double maxItemWidth;
    late double minItemWidth;
    late double maxItemHeight;
    late double minItemHeight;
    var isVertical = photos[0].isVertical;
    if (isVertical) {
      // chiếm 2 phần trong 1 cột
      maxItemWidth = (width - Dimens.spacing3) * 2 / 3;
      maxItemHeight = maxItemWidth * (4 / 3);
      // chiếm 1 phần trong 1 cột
      minItemWidth = (width - Dimens.spacing3) / 3;
      minItemHeight = minItemWidth * (4 / 3);
      return Container(
          child: Row(
        children: [
          photoItem(context,
              height: maxItemHeight, width: maxItemWidth, index: 0),
          SizedBox(
            width: Dimens.spacing3,
          ),
          Column(
            children: [
              photoItem(context,
                  height: minItemHeight, width: minItemWidth, index: 1),
              SizedBox(
                height: Dimens.spacing3,
              ),
              photoItem(context,
                  height: minItemHeight, width: minItemWidth, index: 2),
            ],
          )
        ],
      ));
    } else {
      maxItemWidth = width;
      maxItemHeight = maxItemWidth * (3 / 4);

      minItemWidth = (width - Dimens.spacing3) / 2;
      minItemHeight = minItemWidth * (3 / 4);
      return Container(
        child: Column(
          children: [
            photoItem(context,
                height: maxItemHeight, width: maxItemWidth, index: 0),
            SizedBox(
              height: Dimens.spacing3,
            ),
            Row(
              children: [
                photoItem(context,
                    height: minItemHeight, width: minItemWidth, index: 1),
                SizedBox(
                  width: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemHeight, width: minItemWidth, index: 2),
              ],
            )
          ],
        ),
      );
    }
  }

  Widget fourPhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVertical = photos[0].isVertical;
    late double maxItemWidth;
    late double minItemWidth;
    if (isVertical) {
      maxItemWidth = (width - Dimens.spacing3) * 2 / 3;
      minItemWidth = maxItemWidth / 2;
      return Container(
        child: Row(
          children: [
            photoItem(context,
                height: maxItemWidth * (3 / 2) + Dimens.spacing3 * 2,
                width: maxItemWidth,
                index: 0),
            SizedBox(
              width: Dimens.spacing3,
            ),
            Column(
              children: [
                photoItem(context,
                    height: minItemWidth, width: minItemWidth, index: 1),
                SizedBox(
                  height: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidth, width: minItemWidth, index: 2),
                SizedBox(
                  height: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidth, width: minItemWidth, index: 3),
              ],
            )
          ],
        ),
      );
    } else {
      maxItemWidth = width;
      minItemWidth = (maxItemWidth - Dimens.spacing3 * 2) / 3;
      return Container(
          child: Column(
        children: [
          photoItem(context,
              height: maxItemWidth * 3 / 4, width: maxItemWidth, index: 0),
          SizedBox(
            height: Dimens.spacing3,
          ),
          Row(
            children: [
              photoItem(context,
                  height: minItemWidth, width: minItemWidth, index: 1),
              SizedBox(
                width: Dimens.spacing3,
              ),
              photoItem(context,
                  height: minItemWidth, width: minItemWidth, index: 2),
              SizedBox(
                width: Dimens.spacing3,
              ),
              photoItem(context,
                  height: minItemWidth, width: minItemWidth, index: 3),
            ],
          )
        ],
      ));
    }
  }

  Widget fivePhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVertical = photos[0].isVertical;
    double maxItemWidthHeight = (width - Dimens.spacing3) / 2;
    double minItemWidthHeight = (width - Dimens.spacing3 * 2) / 3;
    if (isVertical) {
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                photoItem(context,
                    height: maxItemWidthHeight,
                    width: maxItemWidthHeight,
                    index: 0),
                SizedBox(
                  width: Dimens.spacing3,
                ),
                photoItem(context,
                    height: maxItemWidthHeight,
                    width: maxItemWidthHeight,
                    index: 1),
              ],
            ),
            SizedBox(
              height: Dimens.spacing3,
            ),
            Row(
              children: [
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 2),
                SizedBox(
                  width: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 3),
                SizedBox(
                  width: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 4),
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Row(
          children: [
            Column(
              children: [
                photoItem(context,
                    height: maxItemWidthHeight,
                    width: maxItemWidthHeight,
                    index: 0),
                SizedBox(
                  height: Dimens.spacing3,
                ),
                photoItem(context,
                    height: maxItemWidthHeight,
                    width: maxItemWidthHeight,
                    index: 1)
              ],
            ),
            SizedBox(
              width: Dimens.spacing3,
            ),
            Column(
              children: [
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 2),
                SizedBox(
                  height: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 3),
                SizedBox(
                  height: Dimens.spacing3,
                ),
                photoItem(context,
                    height: minItemWidthHeight,
                    width: minItemWidthHeight,
                    index: 4),
              ],
            )
          ],
        ),
      );
    }
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
