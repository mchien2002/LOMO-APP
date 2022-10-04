import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/result/who_suits_me_result_model.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/platform_channel.dart';

class WhoSuitsMeResultScreen extends StatefulWidget {
  WhoSuitsMeResultScreen({required this.user});
  final User user;

  @override
  State<StatefulWidget> createState() => _WhoSuitsMeResultScreenState();
}

class _WhoSuitsMeResultScreenState extends BaseListState<WhoSuitsMeHistory,
        WhoSuitsMeResultModel, WhoSuitsMeResultScreen>
    with AutomaticKeepAliveClientMixin<WhoSuitsMeResultScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: Dimens.size70,
            child: Center(
              child: Text(
                Strings.list_participants.localize(context),
                style: textTheme(context).text15.text757788Color,
              ),
            )),
        Divider(),
        Expanded(child: buildContent()),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, WhoSuitsMeHistory item, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.reviewQuizResultScreen,
            arguments: item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing16),
        child: Container(
          height: Dimens.size60,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profile,
                            arguments: UserInfoAgrument(item.user!));
                      },
                      child: CircleNetworkImage(
                        url: item.user!.avatar,
                        size: Dimens.size40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.profile,
                                  arguments: UserInfoAgrument(item.user!));
                            },
                            child: Text(
                              item.user!.name ?? "",
                              style: textTheme(context).text15.bold.colorDart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${readTimeStampByDayHour(item.quiz!.createdAt)}",
                            style: textTheme(context).text13.colorGray77,
                          ),
                        ],
                      ),
                    ),
                    item.percent > 66
                        ? Text(
                            "${item.percent}" + "%",
                            style: textTheme(context).text18.bold.f2cd1c6Color,
                          )
                        : item.percent < 34
                            ? Text(
                                "${item.percent}" + "%",
                                style:
                                    textTheme(context).text18.bold.f49349Color,
                              )
                            : Text(
                                "${item.percent}" + "%",
                                style:
                                    textTheme(context).text18.bold.colorPink88,
                              ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  locator<PlatformChannel>()
                      .openChatWithUser(locator<UserModel>().user!, item.user!);
                },
                child: Container(
                  width: Dimens.size40,
                  child: Image.asset(DImages.chatv2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // !item.user!.isMe

  @override
  bool get autoLoadData => false;

  @override
  double get itemSpacing => 1;

  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  bool get wantKeepAlive => true;
}
