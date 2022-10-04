import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';

import 'item_list_user_hot.dart';

class ItemUserHot extends StatelessWidget {
  final User user;
  final int index;
  final ListUserSubTitleType? subTitleType;
  final Function(User)? onItemClicked;

  ItemUserHot(
      {Key? key,
      required this.user,
      required this.index,
      this.onItemClicked,
      this.subTitleType = ListUserSubTitleType.bear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 150;
    double height = 180;
    return InkWell(
      onTap: () {
        if (onItemClicked != null) {
          onItemClicked!(user);
        }
        Navigator.pushNamed(context, Routes.profile,
            arguments: UserInfoAgrument(user));
      },
      child: Container(
        decoration: BoxDecoration(
          color: DColors.whiteColor,
          borderRadius: BorderRadius.circular(6),
        ),
        width: width,
        height: height > 180 ? height : 180,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 60,
              child: Image.asset(
                DImages.decorItemUserDescovery,
                height: 60,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 13,
                  ),
                  CircleAvatar(
                      radius: 34,
                      backgroundColor: DColors.primaryColor,
                      child: CircleNetworkImage(
                        url: user.avatar ?? "",
                        size: 60,
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    user.name ?? "",
                    style: textTheme(context).text13.bold.ff261744Color,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  getSubTitle(context),
                  SizedBox(
                    height: 12,
                  ),
                  FollowUserCheckBox(
                    user,
                    followedWidget: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profile,
                            arguments: UserInfoAgrument(user));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: Dimens.size32,
                        decoration: BoxDecoration(
                            color: getColor().primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          Strings.view_profile.localize(context),
                          style: textTheme(context).text13.bold.colorWhite,
                        ),
                      ),
                    ),
                    followWidget: (!user.isMe)
                        ? Container(
                            height: Dimens.size32,
                            decoration: BoxDecoration(
                                color: getColor().primaryColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  DImages.addFollow,
                                  height: 32,
                                  width: 32,
                                  color: DColors.whiteColor,
                                ),
                                Text(
                                  Strings.btn_follow.localize(context),
                                  style:
                                      textTheme(context).text13.bold.colorWhite,
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.profile,
                                  arguments: UserInfoAgrument(user));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: Dimens.size32,
                              decoration: BoxDecoration(
                                  color: getColor().primaryColor,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                Strings.view_profile.localize(context),
                                style:
                                    textTheme(context).text13.bold.colorWhite,
                              ),
                            ),
                          ),
                    isUnfollowAction: false,
                  ),
                ],
              ),
            ),
            subTitleType == ListUserSubTitleType.bear
                ? Positioned(right: 0, top: 0, child: getRanking(index))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget getSubTitle(BuildContext context) {
    Widget result;
    switch (subTitleType) {
      case ListUserSubTitleType.bear:
        result = Text(
          "${user.numberOfBear ?? 0}" +
              " " +
              Strings.bearGiftsInWeek.localize(context).toLowerCase(),
          style: textTheme(context).text11.colorGray77,
        );
        break;

      case ListUserSubTitleType.follow:
        result = Text(
          "${user.numberOfFollower ?? 0}" +
              " " +
              Strings.follow.localize(context).toLowerCase(),
          style: textTheme(context).text11.colorGray77,
        );
        break;

      case ListUserSubTitleType.distance:
        result = Text(
          user.distance ?? "",
          style: textTheme(context).text11.colorGray77,
        );
        break;
      default:
        result = Text(
          "${user.numberOfBear ?? 0}" +
              " " +
              Strings.bearGiftsInWeek.localize(context).toLowerCase(),
          style: textTheme(context).text11.colorGray77,
        );
        break;
    }
    return result;
  }

  Widget getRanking(int index) {
    Widget result;
    switch (index) {
      case 0:
        result = Image.asset(
          DImages.hotMemberOne,
          height: 36,
          width: 36,
        );
        break;
      case 1:
        result = Image.asset(
          DImages.hotMemberTwo,
          height: 36,
          width: 36,
        );
        break;

      case 2:
        result = Image.asset(
          DImages.hotMemberThree,
          height: 36,
          width: 36,
        );
        break;

      default:
        result = Container();
        break;
    }
    return result;
  }
}
