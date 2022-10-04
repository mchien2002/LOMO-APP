import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_item_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_model.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:provider/provider.dart';

import '../../../report/report_screen.dart';
import '../result_quiz_dialog.dart';

class ReplyQuestionScreen extends StatefulWidget {
  ReplyQuestionScreen({required this.argument});

  final RelyQuestionArgument argument;

  @override
  State<StatefulWidget> createState() => _ReplyQuestionScreenState();
}

class _ReplyQuestionScreenState
    extends BaseState<ReplyQuestionModel, ReplyQuestionScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.argument.user);
  }

  @override
  Widget buildContentView(BuildContext context, ReplyQuestionModel model) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: model.questionGroup?.questions.isNotEmpty == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  height: 2,
                ),
                Visibility(
                  visible: model.questionGroup?.dateJoinAt != 0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimens.size36,
                      ),
                      _buildHeaderCheckTime(),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: model.questionGroup!.questions.length,
                    allowImplicitScrolling: false,
                    scrollDirection: Axis.horizontal,
                    controller: model.controller,
                    onPageChanged: (index) {
                      model.currentPageIndex.value = index + 1;
                    },
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) =>
                        ReplyQuestionItemScreen(
                      question: model.questionGroup!.questions[index],
                      cancelQuestion: (data) {
                        model.answers.add(data);
                        print("$data");
                        if (index + 1 < model.questionGroup!.questions.length) {
                          model.controller.animateToPage(index + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutCirc);
                        } else {
                          checkResult();
                          // call API
                        }

                        //model.controller.jumpToPage(index + 1);
                      },
                      reportQuestion: () {
                        reportUser();
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pushNamed(context, Routes.report,
                        arguments: ReportScreenArgs(user: model.user));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        DImages.report,
                        color: getColor().text9094abColor,
                        width: Dimens.size32,
                        height: Dimens.size32,
                      ),
                      Text(
                        Strings.report.localize(context),
                        style: textTheme(context).text15.text9094abColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimens.size20,
                ),
              ],
            )
          : buildEmptyView(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: getColor().white,
      elevation: 0,
      title: model.questionGroup?.questions.isNotEmpty == true
          ? ValueListenableProvider.value(
              value: model.currentPageIndex,
              child: Consumer<int>(
                builder: (context, index, child) => Text(
                  "$index / ${model.questionGroup!.questions.length}",
                  style: textTheme(context).text18.colorDart,
                ),
              ),
            )
          : Container(),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: Dimens.size16),
            child: Image.asset(
              DImages.closex,
              color: Colors.black,
              width: Dimens.size32,
              height: Dimens.size32,
            ),
          ),
        )
      ],
    );
  }

  Widget buildEmptyView(BuildContext context) {
    return Scaffold(
      body: EmptyWidget(
        message: Strings.noQuizYet.localize(context),
      ),
    );
  }

  checkResult() async {
    callApi(callApiTask: () async {
      await model.sendAnswers();
    }, onSuccess: () {
      if (model.result != null)
        showModalBottomSheet(
            backgroundColor: getColor().transparent,
            context: context,
            isScrollControlled: true,
            enableDrag: false,
            builder: (context) => ResultQuizDialog(
                  user: model.user,
                  percent: model.result!.percent,
                  onClosed: () {
                    Navigator.pop(context);
                  },
                  onCreateMyQuiz: () {
                    Navigator.pop(context);
                  },
                  onSayHi: () {
                    Navigator.pop(context);
                  },
                ));
    });
  }

  reportUser() async {
    Navigator.pushNamed(context, Routes.report,
        arguments: ReportScreenArgs(user: model.questionGroup!.user!));
  }

  Widget _buildHeaderCheckTime() {
    return Container(
      margin: EdgeInsets.only(
          left: Dimens.size30, right: Dimens.size30, top: Dimens.size10),
      height: Dimens.size80,
      decoration: BoxDecoration(
        color: getColor().grayF8bColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: Dimens.size15, left: Dimens.size20, right: Dimens.size20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Strings.lastJoint.localize(context),
                  style: textTheme(context).text14.text9094abColor,
                ),
                Expanded(
                  child: Text(
                    " ${readTimeStampByHourDay(model.questionGroup!.dateJoinAt)}",
                    style: textTheme(context).text14.text9094abColor.medium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimens.spacing7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Strings.newCreated.localize(context),
                  style: textTheme(context).text14.text9094abColor,
                ),
                Expanded(
                  child: Text(
                    " ${readTimeStampByHourDay(model.questionGroup!.updatedAt)}",
                    style: textTheme(context).text14.text9094abColor.medium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RelyQuestionArgument {
  RelyQuestionArgument({required this.user, this.isReview = false});

  final User user;
  final bool isReview;
}
