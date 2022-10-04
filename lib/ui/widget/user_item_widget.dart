import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';

import 'action_follow_avatar_widget.dart';

class UserItemWidget extends StatelessWidget {
  final User user;
  final double height;
  final double width;
  final Function(bool)? onFollowed;

  UserItemWidget(
      {required this.user,
      this.height = 100,
      this.width = 60,
      this.onFollowed});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(Dimens.spacing10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.profile,
                arguments: UserInfoAgrument(user));
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              RoundNetworkImage(
                height: height,
                width: width,
                url: user.cover ?? user.avatar,
                radius: Dimens.spacing10,
              ),
              Container(
                height: height / 2.5,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Dimens.spacing12),
                        bottomRight: Radius.circular(Dimens.spacing12)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        getColor().textTime,
                      ],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(0, 1),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )),
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(
                    top: 2,
                    left: Dimens.spacing5,
                    right: Dimens.spacing5,
                    bottom: Dimens.spacing12),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActionFollowAvatarWidget(
                    user: user,
                    onFollowed: onFollowed,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      if (!user.isMe)
                        Navigator.pushNamed(context, Routes.profile,
                            arguments: UserInfoAgrument(user));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        user.name ?? "",
                        style:
                            textTheme(context).text14Normal.semiBold.colorWhite,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.spacing12,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class UserFeelingWidget extends StatelessWidget {
  final User user;
  final double width;
  final double height;

  UserFeelingWidget(
      {required this.user, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(Dimens.spacing10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                RoundNetworkImage(
                  height: height,
                  width: width,
                  url: user.cover ?? user.avatar,
                  radius: Dimens.spacing10,
                ),
                Container(
                  height: height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimens.spacing12),
                          bottomRight: Radius.circular(Dimens.spacing12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          getColor().textTime,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(0, 1),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(
                      top: 2,
                      left: Dimens.spacing5,
                      right: Dimens.spacing5,
                      bottom: Dimens.spacing12),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      user.feeling != null
                          ? Image.asset(
                              getFeeling(user.feeling),
                              width: 32,
                              height: 32,
                            )
                          : SizedBox(),
                      SizedBox(
                        height: Dimens.size12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            user.name!,
            style: textTheme(context).text14Normal.colorDart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class UserLocationWidget extends StatelessWidget {
  final User user;
  final double width;
  final double height;

  UserLocationWidget(
      {required this.user, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(Dimens.spacing10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                RoundNetworkImage(
                  height: height,
                  width: width,
                  url: user.cover ?? user.avatar,
                  radius: Dimens.spacing10,
                ),
                Container(
                  height: height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimens.spacing12),
                          bottomRight: Radius.circular(Dimens.spacing12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          getColor().textTime,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(0, 1),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(
                      top: 2,
                      left: Dimens.spacing5,
                      right: Dimens.spacing5,
                      bottom: Dimens.spacing12),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.city ?? "",
                        style:
                            textTheme(context).text14Normal.semiBold.colorWhite,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        user.distance ?? "",
                        style: textTheme(context).text12.colorWhite,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Dimens.spacing12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            user.name!,
            style: textTheme(context).text14Normal.colorDart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class UserHotBearWidget extends StatelessWidget {
  final User? user;
  final double width;
  final double height;

  UserHotBearWidget({this.user, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(Dimens.spacing10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user!));
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                RoundNetworkImage(
                  height: height,
                  width: width,
                  url: user!.cover ?? user!.avatar,
                  radius: Dimens.spacing10,
                ),
                Container(
                  height: height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimens.spacing12),
                          bottomRight: Radius.circular(Dimens.spacing12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          getColor().textTime,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(0, 1),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(
                      top: 2,
                      left: Dimens.spacing5,
                      right: Dimens.spacing5,
                      bottom: Dimens.spacing12),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              DImages.bearWhite,
                              height: 18,
                              width: 18,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              formatNumberDivThousand(
                                  user != null ? user!.numberOfBear! : 0),
                              style: textTheme(context).text12.colorWhite,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimens.spacing12,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            user!.name!,
            style: textTheme(context).text14Normal.colorDart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class UserRequestFilterWidget extends StatelessWidget {
  final User user;
  final double width;
  final double height;

  UserRequestFilterWidget(
      {required this.user, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(Dimens.spacing10),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                RoundNetworkImage(
                  height: height,
                  width: width,
                  url: user.cover ?? user.avatar,
                  radius: Dimens.spacing10,
                ),
                Container(
                  height: height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimens.spacing12),
                          bottomRight: Radius.circular(Dimens.spacing12)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          getColor().textTime,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(0, 1),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(
                      top: 2,
                      left: Dimens.spacing5,
                      right: Dimens.spacing5,
                      bottom: Dimens.spacing12),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            user.name!,
            style: textTheme(context).text14Normal.colorDart,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
