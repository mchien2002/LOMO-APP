import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/eventbus/favorite_newfeed_event.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/widget/comment/group_comment_widget.dart';
import 'package:lomo/ui/widget/favorite_new_feed_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/date_time_utils.dart';

class ItemTypeDiscoveryView extends StatefulWidget {
  final NewFeed newFeed;
  final double width;

  ItemTypeDiscoveryView(this.newFeed, {this.width = 100});

  @override
  State<StatefulWidget> createState() => _ItemTypeDiscoveryViewState();
}

class _ItemTypeDiscoveryViewState extends State<ItemTypeDiscoveryView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    eventBus.on<FavoriteNewFeedEvent>().listen((event) async {
      if (widget.newFeed.id == event.newfeedId) {
        setState(() {
          widget.newFeed.numberOfFavorite = event.isFavorite
              ? widget.newFeed.numberOfFavorite++
              : widget.newFeed.numberOfFavorite--;

          widget.newFeed.isFavorite = event.isFavorite;
        });
      }
    });
  }

  Widget _buildContentNewFeed() {
    var totalImage = widget.newFeed.images?.length ?? 0;
    return InkWell(
      child: Container(
        width: widget.width,
        height: widget.width * 2,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: widget.width,
              padding: EdgeInsets.only(left: 1, right: 1),
              child: Stack(
                children: [
                  Visibility(
                    visible: totalImage > 0,
                    child: RoundNetworkImage(
                      width: widget.width,
                      height: widget.width,
                      radius: 0,
                      url: totalImage > 0 ? widget.newFeed.images![0].link : "",
                      placeholder: ImageRectangleShimmer(
                        width: widget.width,
                        height: widget.width,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: totalImage == 0,
                    child: Container(
                      width: widget.width,
                      height: widget.width,
                      color: Colors.black12,
                      child: Center(
                        child: Text(
                          widget.newFeed.content ?? "",
                          style: textTheme(context).text13.ff261744Color,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: widget.width,
                    height: widget.width,
                    color: Colors.black12,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FavoriteNewFeedCheckBox(
                            newFeed: widget.newFeed,
                            width: 20.0,
                            height: 20.0,
                            padding: 3.0,
                            isFormatTotal: true,
                            txtTheme: textTheme(context).text13.colorWhite,
                            iconFavorite: DImages.favoriteWhite,
                            iconFavoriteActive: DImages.favoriteWhite,
                            uncheckedColor: DColors.whiteColor,
                            isDisable: false,
                          ),
                          GroupCommentWidget(
                            widget.newFeed,
                            showFullTotalComment: false,
                          ),
                          totalImage > 1
                              ? Image.asset(
                                  DImages.multiplePhoto,
                                  height: 20.0,
                                  width: 20.0,
                                )
                              : SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildUserInfo()
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.postDetail,
            arguments: PostDetailAgrument(widget.newFeed));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildContentNewFeed());
  }

  Widget _buildUserInfo() {
    return Container(
      height: 63,
      width: widget.width,
      padding: EdgeInsets.only(left: Dimens.spacing12, right: Dimens.spacing12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: UserInfoWidget(
              widget.newFeed.user!,
              paddingAvatarName: 8,
              avatarSize: 24.0,
              titleStyle: textTheme(context).text13.bold.darkTextColor,
              subTitle: Text(
                widget.newFeed.createdAt != null
                    ? readTimeStampByDayHour(widget.newFeed.createdAt!)
                    : "",
                style: textTheme(context).text11.gray77,
              ),
              widgetHeight: (MediaQuery.of(context).size.width / 2) - 60,
            ),
          ),
        ],
      ),
    );
  }
}
