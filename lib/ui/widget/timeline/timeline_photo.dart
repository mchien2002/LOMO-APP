import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';

import '../photos_view_page.dart';

class TimelinePhoto extends StatelessWidget {
  final NewFeed newFeed;

  TimelinePhoto(this.newFeed);

  late double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    switch (newFeed.images!.length) {
      case 1:
        return _onePhotoLayout(context);
      case 2:
        return twoPhotosLayout(context);
      case 3:
        return threePhotosLayout(context);
      case 4:
        return fourPhotosLayout(context);
      case 5:
        return fivePhotosLayout(context);
      default:
        return fivePhotosLayout(context);
    }
  }

  Widget twoPhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVerticalPhoto1 = photos[0].isVertical;
    var isVerticalPhoto2 = photos[1].isVertical;

    if (isVerticalPhoto1 && isVerticalPhoto2) {
      var itemWidth = (width - Dimens.spacing3) / 2;
      return Container(
        child: Row(
          children: [
            photoItem(context, itemWidth, itemWidth * (4 / 3), 0),
            SizedBox(
              width: Dimens.spacing3,
            ),
            photoItem(context, itemWidth, itemWidth * (4 / 3), 1),
          ],
        ),
      );
    } else if (!isVerticalPhoto1 && !isVerticalPhoto2) {
      var itemWidth = (width - Dimens.spacing3);
      return Container(
        child: Column(
          children: [
            photoItem(context, itemWidth, itemWidth * 3 / 4, 0),
            SizedBox(
              height: Dimens.spacing3,
            ),
            photoItem(context, itemWidth, itemWidth * 3 / 4, 1),
          ],
        ),
      );
    } else {
      var itemWidth = (width - Dimens.spacing3) / 2;
      return Container(
        child: Row(
          children: [
            photoItem(context, itemWidth, itemWidth * 4 / 3, 0),
            SizedBox(
              width: Dimens.spacing3,
            ),
            photoItem(context, itemWidth, itemWidth * 4 / 3, 1),
          ],
        ),
      );
    }
  }

  Widget threePhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVertical = photos[0].isVertical;
    if (isVertical) {
      var maxItemWidthVertical = (width - Dimens.spacing3) * 2 / 3;
      var minItemWidthVertical = (width - Dimens.spacing3) / 3;
      return Container(
          child: Row(
        children: [
          photoItem(
              context, maxItemWidthVertical, maxItemWidthVertical * (4 / 3), 0),
          SizedBox(
            width: Dimens.spacing3,
          ),
          Column(
            children: [
              photoItem(context, minItemWidthVertical,
                  minItemWidthVertical * 4 / 3 - Dimens.spacing3 / 2, 1),
              SizedBox(
                height: Dimens.spacing3,
              ),
              photoItem(context, minItemWidthVertical,
                  minItemWidthVertical * 4 / 3 - Dimens.spacing3 / 2, 2),
            ],
          )
        ],
      ));
    } else {
      var maxItemWidthHorizontal = (width);
      var minItemWidthVertical = (width - Dimens.spacing3) / 2;
      return Container(
          child: Column(
        children: [
          photoItem(context, maxItemWidthHorizontal,
              maxItemWidthHorizontal * 3 / 4, 0),
          SizedBox(
            height: Dimens.spacing3,
          ),
          Row(
            children: [
              photoItem(context, minItemWidthVertical,
                  minItemWidthVertical * 3 / 4, 1),
              SizedBox(
                width: Dimens.spacing3,
              ),
              photoItem(context, minItemWidthVertical,
                  minItemWidthVertical * 3 / 4, 2),
            ],
          )
        ],
      ));
    }
  }

  Widget fourPhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVertical = photos[0].isVertical;
    if (isVertical) {
      var maxItemWidthVertical = (width - Dimens.spacing3) * 2 / 3;
      var minItemWidthVertical = maxItemWidthVertical / 2;
      return Container(
          child: Row(
        children: [
          photoItem(context, maxItemWidthVertical,
              maxItemWidthVertical * (3 / 2) + Dimens.spacing3 * 2, 0),
          SizedBox(
            width: Dimens.spacing3,
          ),
          Column(
            children: [
              photoItem(context, minItemWidthVertical, minItemWidthVertical, 1),
              SizedBox(
                height: Dimens.spacing3,
              ),
              photoItem(context, minItemWidthVertical, minItemWidthVertical, 2),
              SizedBox(
                height: Dimens.spacing3,
              ),
              photoItem(context, minItemWidthVertical, minItemWidthVertical, 3),
            ],
          )
        ],
      ));
    } else {
      var maxItemWidthHorizontal = (width);
      var minItemWidthHorizontal =
          (maxItemWidthHorizontal - Dimens.spacing3 * 2) / 3;
      return Container(
          child: Column(
        children: [
          photoItem(context, maxItemWidthHorizontal,
              maxItemWidthHorizontal * 3 / 4, 0),
          SizedBox(
            height: Dimens.spacing3,
          ),
          Row(
            children: [
              photoItem(
                  context, minItemWidthHorizontal, minItemWidthHorizontal, 1),
              SizedBox(
                width: Dimens.spacing3,
              ),
              photoItem(
                  context, minItemWidthHorizontal, minItemWidthHorizontal, 2),
              SizedBox(
                width: Dimens.spacing3,
              ),
              photoItem(
                  context, minItemWidthHorizontal, minItemWidthHorizontal, 3),
            ],
          )
        ],
      ));
    }
  }

  Widget fivePhotosLayout(BuildContext context) {
    List<PhotoModel> photos = newFeed.images!;
    var isVertical = photos[0].isVertical;
    var maxItemWidthHeight = (width - Dimens.spacing3) / 2;
    var minItemWidthHeight = (width - (Dimens.spacing3 * 2)) / 3;
    if (isVertical) {
      return Container(
          child: Column(
        children: [
          Row(
            children: [
              photoItem(context, maxItemWidthHeight, maxItemWidthHeight, 0),
              SizedBox(
                width: 3,
              ),
              photoItem(context, maxItemWidthHeight, maxItemWidthHeight, 1),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Row(
            children: [
              photoItem(context, minItemWidthHeight, minItemWidthHeight, 2),
              SizedBox(
                width: 3,
              ),
              photoItem(context, minItemWidthHeight, minItemWidthHeight, 3),
              SizedBox(
                width: 3,
              ),
              Stack(
                children: [
                  photoItem(context, minItemWidthHeight, minItemWidthHeight, 4),
                  Visibility(
                    visible: photos.length > 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black54,
                        width: minItemWidthHeight,
                        height: minItemWidthHeight,
                        child: Text(
                          "+${photos.length - 5}",
                          style: textTheme(context).text20.bold.colorWhite,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ));
    } else {
      return Container(
          child: Row(
        children: [
          Column(
            children: [
              photoItem(context, maxItemWidthHeight, maxItemWidthHeight, 0),
              SizedBox(
                height: 3,
              ),
              photoItem(context, maxItemWidthHeight, maxItemWidthHeight, 1),
            ],
          ),
          SizedBox(width: 3),
          Column(
            children: [
              photoItem(context, maxItemWidthHeight, minItemWidthHeight, 2),
              SizedBox(
                height: 3,
              ),
              photoItem(context, maxItemWidthHeight, minItemWidthHeight, 3),
              SizedBox(
                height: 3,
              ),
              Stack(
                children: [
                  photoItem(context, maxItemWidthHeight, minItemWidthHeight, 4),
                  InkWell(
                    child: Visibility(
                      visible: photos.length > 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black54,
                          width: maxItemWidthHeight,
                          height: minItemWidthHeight,
                          child: Text(
                            "+${photos.length - 5}",
                            style: textTheme(context).text20.bold.colorWhite,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, Routes.postDetail,
                        arguments: PostDetailAgrument(newFeed, photoIndex: 4)),
                  )
                ],
              )
            ],
          ),
        ],
      ));
    }
  }

  void slidePhotos(BuildContext context, List<PhotoModel> photos, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotosViewPage(
          images: photos.map((e) => e.link!).toList(),
          firstPage: index,
        ),
      ),
    );
  }

  Widget _onePhotoLayout(BuildContext context) {
    final itemWidth = (width);
    late double itemHeight;
    final ratio = newFeed.images![0].ratio ?? 0;
    //Sau version 1.1.13
    if (ratio != 0) {
      itemHeight = itemWidth / ratio;
    } else {
      //Version 1.1.13 tro ve truoc
      itemHeight =
          newFeed.images![0].isVertical ? itemWidth * 4 / 3 : itemWidth * 3 / 4;
    }
    return onePhotoItem(context, itemWidth, itemHeight, 0);
  }

  Widget onePhotoItem(
      BuildContext context, double width, double height, int index) {
    return InkWell(
      child: RoundNetworkImage(
        width: width,
        height: height,
        url: newFeed.images![index].link,
        placeholder: ImageRectangleShimmer(
          width: width,
          height: height,
        ),
      ),
      onTap: () => Navigator.pushNamed(context, Routes.postDetail,
          arguments: PostDetailAgrument(newFeed, photoIndex: index)),
    );
  }

  Widget photoItem(
      BuildContext context, double width, double height, int index) {
    return InkWell(
      child: RoundNetworkImage(
        width: width,
        height: height,
        url: newFeed.images![index].link,
        placeholder: ImageRectangleShimmer(
          width: width,
          height: height,
        ),
      ),
      onTap: () => Navigator.pushNamed(context, Routes.postDetail,
          arguments: PostDetailAgrument(newFeed, photoIndex: index)),
    );
  }
}
