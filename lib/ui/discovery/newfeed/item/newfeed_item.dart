import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';

import '../../../../res/constant.dart';
import '../../../widget/shimmers/image/image_rectangle_shimmer.dart';

class NewFeedItem extends StatelessWidget {
  final NewFeed item;
  final int index;
  final double? width;
  final double? height;
  final Function(NewFeed)? onItemClicked;

  NewFeedItem(
      {required this.item,
      required this.index,
      this.onItemClicked,
      this.width = 150,
      this.height = 217});

  bool isVideoContent() {
    return item.images?.isNotEmpty == true &&
        item.images?[0].type == Constants.TYPE_VIDEO;
  }

  Widget _buildImageItem() {
    return RoundNetworkImage(
      width: width!,
      height: width!,
      url: item.images!.isNotEmpty ? item.images![0].link : item.user?.avatar,
      boxFit: BoxFit.cover,
      strokeColor: getColor().white,
    );
  }

  Widget _buildVideoItem() {
    return Stack(
      alignment: Alignment.center,
      children: [
        RoundNetworkImage(
          width: width!,
          height: width!,
          radius: 0,
          url: item.images?[0].thumb,
          placeholder: ImageRectangleShimmer(
            width: width!,
            height: width!,
          ),
          errorHolder: ImageRectangleShimmer(
            width: width!,
            height: width!,
          ),
        ),
        Image.asset(
          DImages.btnVideoPause,
          height: 40,
          width: 40,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, Routes.postDetail,
        //     arguments: PostDetailAgrument(item));
        if (isVideoContent()) {
          Navigator.pushNamed(context, Routes.postVideoDetail,
              arguments: PostDetailAgrument(item));
        } else {
          Navigator.pushNamed(context, Routes.postDetail,
              arguments: PostDetailAgrument(item));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: DColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: width,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimens.cornerRadius6)),
                child: isVideoContent() ? _buildVideoItem() : _buildImageItem(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.user?.name ?? "",
                    style: textTheme(context).text13.bold.darkTextColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      FavoriteNewFeedCheckBox(
                        newFeed: item,
                        width: 18.0,
                        height: 18.0,
                        padding: 3.0,
                        isFormatTotal: true,
                        txtTheme: textTheme(context).text11.text757788Color,
                        uncheckedColor: DColors.text757788Color,
                        isDisable: true,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GroupCommentWidget(
                        item,
                        iconComment: Image.asset(
                          DImages.comment,
                          width: 18,
                          height: 18,
                          color: DColors.text757788Color,
                        ),
                        showFullTotalComment: false,
                        disableAction: true,
                        textTheme: textTheme(context).text11.text757788Color,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
