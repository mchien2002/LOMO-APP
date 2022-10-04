import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/user_newfeed.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/profile/profile_timeline/time_line_model.dart';
import 'package:lomo/ui/widget/checkbox_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';

class TimeLineScreen extends StatefulWidget {
  final User user;
  final UserNewFeed userNewFeed;
  final NewFeed? newFeed;
  final Function(bool)? onCheckChanged;

  TimeLineScreen(
      {required this.user, required this.userNewFeed, this.onCheckChanged, this.newFeed});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends BaseListState<UserNewFeed, ProfileTimelineModel, TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.size20),
        child: buildContent(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.user);
    model.loadData();
  }

  @override
  Widget buildItem(BuildContext context, UserNewFeed item, int index) {
    var number = item.data!.length;
    return Container(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 1),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: DColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: number == 0 ? 0 : 20.0 + (110.0 * number),
                  width: 1,
                  color:
                      index == model.items.length - 1 ? DColors.whiteColor : DColors.primaryColor,
                ),
              ],
            ),
            // SizedBox(
            //   width: 5,
            // ),
            Container(
                margin: EdgeInsets.only(top: Dimens.size15),
                width: Dimens.size20,
                height: 1,
                color: DColors.primaryColor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 30),
                    width: Dimens.size80,
                    height: Dimens.size20,
                    decoration: BoxDecoration(
                        color: DColors.grayF1Color, borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      item.date!,
                      style: textTheme(context).text12.colorDart,
                    )),
                  ),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 0,
                            ),
                        itemCount: item.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return timeLine(item.data![index]);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeLine(NewFeed newFeed) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimens.size10, top: Dimens.size10),
      child: Container(
        height: Dimens.size100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            RoundNetworkImage(
              radius: 5,
              height: Dimens.size100,
              width: Dimens.size65,
              placeholder: DImages.logo,
              url: newFeed.images![0].link,
            ),
            SizedBox(
              width: Dimens.size20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(top: Dimens.size10),
                      child: Text(
                        "${newFeed.content ?? 0}",
                        textDirection: TextDirection.ltr,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context).text16.colorDart,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.size10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CheckBoxWidget(
                              height: Dimens.size20,
                              width: Dimens.size20,
                              initValue: newFeed.isFavorite,
                              onCheckChanged: (checked) async {
                                try {
                                  if (newFeed.isFavorite) {
                                    await locator<UserRepository>().unFavoritePost(newFeed.id!);
                                    newFeed.isFavorite = false;
                                  } else {
                                    await locator<UserRepository>().favoritePost(newFeed.id!);
                                    newFeed.isFavorite = true;
                                  }

                                  if (widget.onCheckChanged != null)
                                    widget.onCheckChanged!(checked);
                                } catch (e) {}
                                setState(() {
                                  checked ? newFeed.numberOfFavorite++ : newFeed.numberOfFavorite--;
                                });
                              },
                              checkedIcon: Image.asset(
                                DImages.favourite,
                                color: getColor().colorPrimary,
                                height: Dimens.size25,
                                width: Dimens.size25,
                              ),
                              unCheckedIcon: Image.asset(
                                DImages.disableHeart,
                                height: Dimens.size25,
                                width: Dimens.size25,
                              ),
                            ),
                            SizedBox(
                              width: Dimens.size5,
                            ),
                            Text(
                              "${newFeed.numberOfFavorite}",
                              style: textTheme(context).text12.colorGrayTime,
                            ),
                          ],
                        ),
                        Container(
                            child: Row(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                DIcons.messageGroup,
                                color: getColor().textTime,
                                height: Dimens.size25,
                                width: Dimens.size25,
                              ),
                            ),
                            SizedBox(
                              width: Dimens.size10,
                            ),
                            Text(
                              "${newFeed.numberOfComment}",
                              style: textTheme(context).text12.colorGrayTime,
                            ),
                          ],
                        )),
                        Container(
                          // margin: EdgeInsets.only(right: Dimens.size20),
                          child: SvgPicture.asset(
                            DIcons.menu,
                            color: getColor().textTime,
                            height: Dimens.size25,
                            width: Dimens.size25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimens.size10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;

  // @override
  // // TODO: implement itemSpacing
  // double get itemSpacing => 10;
  @override
  // TODO: implement autoLoadData
  bool get autoLoadData => false;
}
