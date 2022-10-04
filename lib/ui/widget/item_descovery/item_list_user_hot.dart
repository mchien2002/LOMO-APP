import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';

class ListItemUserHot extends StatelessWidget {
  final User? user;
  final int? index;
  final ListUserSubTitleType? subTitleType;

  ListItemUserHot(
      {Key? key,
      this.user,
      this.index,
      this.subTitleType = ListUserSubTitleType.bear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.profile,
              arguments: UserInfoAgrument(user!));
        },
        child: Container(
          color: subTitleType == ListUserSubTitleType.bear
              ? getBackGroundColor(context, index!)
              : getColor().white,
          child: Container(
            height: 72,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (subTitleType == ListUserSubTitleType.bear)
                  getRanking(context, index!),
                SizedBox(
                  width: 16,
                ),
                subTitleType == ListUserSubTitleType.bear
                    ? getCircleAvatar(context, index!)
                    : CircleAvatar(
                        radius: 23,
                        backgroundColor: DColors.transparent00Color,
                        child: CircleNetworkImage(
                          url: user?.avatar ?? "",
                          size: 40,
                        ),
                      ),
                SizedBox(
                  width: 10,
                ),
                title(context),
                SizedBox(
                  width: 10,
                ),
                user!.isMe
                    ? Container(
                        width: 36,
                        height: 36,
                        //child: Image.asset(DImages.navigationRight),
                      )
                    : FollowUserCheckBox(
                        user!,
                        followedWidget: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.profile,
                                arguments: UserInfoAgrument(user!));
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            child: Image.asset(DImages.navigationRight),
                          ),
                        ),
                        followWidget: Container(
                          width: 36,
                          height: 36,
                          child: Image.asset(DImages.followUser),
                        ),
                        isUnfollowAction: false,
                      ),
              ],
            ),
          ),
        ));
  }

  Widget title(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: 20,
                    maxWidth: MediaQuery.of(context).size.width -
                        (!user!.isKol! ? 180 : 208)),
                child: Text(
                  user?.name ?? "",
                  style: textTheme(context).text15.bold.colorDart,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              user!.isKol!
                  ? Image.asset(
                      DImages.crown,
                      width: 28,
                      height: 28,
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            width: 4,
          ),
          getSubTitle(context)
        ],
      ),
    );
  }

  Widget getSubTitle(BuildContext context) {
    Widget result;
    switch (subTitleType) {
      case ListUserSubTitleType.bear:
        result = Text(
          "${user?.numberOfBear ?? 0}" +
              " " +
              Strings.bearGifts.localize(context).toLowerCase(),
          style: textTheme(context).text13.colorGray77,
        );
        break;
      case ListUserSubTitleType.distance:
        result = Text(
          user?.distance ?? "",
          style: textTheme(context).text13.colorGray77,
        );
        break;
      case ListUserSubTitleType.follow:
        result = Text(
          "${user?.numberOfFollower ?? 0}" +
              " " +
              Strings.follow.localize(context).toLowerCase(),
          style: textTheme(context).text13.colorGray77,
        );
        break;
      default:
        result = Text(
          "${user?.numberOfBear ?? 0}" +
              " " +
              Strings.bearGifts.localize(context).toLowerCase(),
          style: textTheme(context).text13.colorGray77,
        );
        break;
    }
    return result;
  }

  Widget getRanking(BuildContext context, int index) {
    Widget result;
    switch (index) {
      case 0:
        result = Container(
          height: 26,
          width: 26,
          child: Image.asset(
            DImages.hotMemberOne,
          ),
        );
        break;
      case 1:
        result = Container(
          height: 26,
          width: 26,
          child: Image.asset(
            DImages.hotMemberTwo,
          ),
        );
        break;

      case 2:
        result = Container(
          height: 26,
          width: 26,
          child: Image.asset(
            DImages.hotMemberThree,
          ),
        );
        break;

      default:
        result = CircleAvatar(
          backgroundColor: DColors.btnBackground,
          radius: 13,
          child: Center(
              child: Text(
            formatNumber(index + 1),
            style: textTheme(context).text13.bold.colorPrimary,
          )),
        );
        break;
    }
    return result;
  }

  Widget getCircleAvatar(BuildContext context, int index) {
    Widget result;
    switch (index) {
      case 0:
        result = CircleAvatar(
            radius: 23,
            backgroundColor: DColors.primaryColor,
            child: CircleNetworkImage(
              url: user?.avatar ?? "",
              size: 40,
            ));
        break;
      case 1:
        result = CircleAvatar(
            radius: 23,
            backgroundColor: DColors.primaryColor,
            child: CircleNetworkImage(
              url: user?.avatar ?? "",
              size: 40,
            ));
        break;

      case 2:
        result = CircleAvatar(
            radius: 23,
            backgroundColor: DColors.primaryColor,
            child: CircleNetworkImage(
              url: user?.avatar ?? "",
              size: 40,
            ));
        break;

      default:
        result = CircleAvatar(
          radius: 23,
          backgroundColor: DColors.transparent00Color,
          child: CircleNetworkImage(
            url: user?.avatar ?? "",
            size: 40,
          ),
        );
        break;
    }
    return result;
  }

  getBackGroundColor(BuildContext context, int index) {
    Color result;
    switch (index) {
      case 0:
        result = DColors.ff338a5adfColor;
        break;
      case 1:
        result = DColors.primaryColor2.withOpacity(0.14);
        break;

      case 2:
        result = DColors.primaryColor2.withOpacity(0.05);
        break;

      default:
        result = getColor().white;
        break;
    }
    return result;
  }
}

enum ListUserSubTitleType { bear, distance, follow }
