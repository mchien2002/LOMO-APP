import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/eventbus/read_quiz_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/platform_channel.dart';

import '../../result_quiz_dialog.dart';

class WhoSuitsMeHistoryItem extends StatefulWidget {
  final WhoSuitsMeHistory item;
  WhoSuitsMeHistoryItem(this.item);

  @override
  State<StatefulWidget> createState() => _WhoSuitsMeHistoryItemState();
}

class _WhoSuitsMeHistoryItemState extends State<WhoSuitsMeHistoryItem> {
  @override
  void initState() {
    super.initState();
    eventBus.on<ReadQuizEvent>().listen((event) async {
      if (event.userId == widget.item.user?.id)
        setState(() {
          widget.item.user!.isReadQuiz = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                            arguments: UserInfoAgrument(widget.item.user!));
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: widget.item.user!.isReadQuiz
                                ? EdgeInsets.all(0)
                                : EdgeInsets.only(top: 4, right: 8),
                            child: CircleNetworkImage(
                              url: widget.item.user!.avatar,
                              size: Dimens.size40,
                            ),
                          ),
                          if (!widget.item.user!.isReadQuiz)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: getColor().colorRedFf6388),
                              child: Text(
                                Strings.newQuiz.localize(context),
                                style:
                                    textTheme(context).text10.bold.colorWhite,
                              ),
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: !widget.item.user!.isReadQuiz ? 2 : 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.profile,
                                  arguments:
                                      UserInfoAgrument(widget.item.user!));
                            },
                            child: Text(
                              widget.item.user!.name ?? "",
                              style: textTheme(context).text15.bold.colorDart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${readTimeStampByDayHour(widget.item.quiz!.createdAt)}",
                            style: textTheme(context).text13.colorGray77,
                          ),
                        ],
                      ),
                    ),
                    widget.item.percent > 66
                        ? Text(
                            "${widget.item.percent}" + "%",
                            style: textTheme(context).text18.bold.f2cd1c6Color,
                          )
                        : widget.item.percent < 34
                            ? Text(
                                "${widget.item.percent}" + "%",
                                style:
                                    textTheme(context).text18.bold.f49349Color,
                              )
                            : Text(
                                "${widget.item.percent}" + "%",
                                style:
                                    textTheme(context).text18.bold.colorPink88,
                              ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  locator<PlatformChannel>().openChatWithUser(
                      locator<UserModel>().user!, widget.item.user!);
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
      onTap: () async {
        // readQuiz();
        showModalBottomSheet(
            backgroundColor: getColor().transparent,
            enableDrag: false,
            context: context,
            isScrollControlled: true,
            builder: (context) => ResultQuizDialog(
                  user: widget.item.user!,
                  percent: widget.item.percent,
                ));
      },
    );
  }

  readQuiz() async {
    try {
      locator<UserRepository>().readQuiz(widget.item.user!.id!);
    } catch (e) {
      print(e);
    }
  }
}
