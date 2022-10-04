import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/exceptions/api_exception.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/eventbus/read_quiz_event.dart';
import 'package:lomo/data/eventbus/submit_answer_quiz_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/dialog_widget.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/result_quiz_dialog.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';

import 'button_widgets.dart';

class WhoSuitsMeButton extends StatefulWidget {
  final User user;
  final String? text;
  final bool isCircle;

  WhoSuitsMeButton(this.user, {this.text, this.isCircle = false});

  @override
  State<StatefulWidget> createState() => _WhoSuitsMeButtonState();
}

class _WhoSuitsMeButtonState extends State<WhoSuitsMeButton> {
  Widget? _loadingDialog;

  @override
  void initState() {
    super.initState();
    eventBus.on<ReadQuizEvent>().listen((event) async {
      if (event.userId == widget.user.id)
        setState(() {
          widget.user.isReadQuiz = true;
        });
    });
    eventBus.on<SubmitAnswerQuizEvent>().listen((event) async {
      if (event.userId == widget.user.id)
        setState(() {
          widget.user.isQuiz = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCircle ? _buildCircleButton() : _buildRadiusButton();
  }

  Widget _buildCircleButton() {
    return SizedBox(
      height: widget.user.isReadQuiz ? 44 : 48,
      width: widget.user.isReadQuiz ? 44 : 52,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: widget.user.isReadQuiz
                ? EdgeInsets.all(0)
                : EdgeInsets.only(top: 4, right: 8),
            child: IconButton(
                iconSize: Dimens.size44,
                padding: EdgeInsets.all(0),
                onPressed: onClicked,
                icon: Container(
                  height: Dimens.size44,
                  width: Dimens.size44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !widget.user.isQuiz
                        ? getColor().btnBackgroundColor
                        : getColor().grayf1f6aColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Image.asset(
                    !widget.user.isQuiz
                        ? DImages.suitableMe
                        : DImages.suitableMeDisable,
                    width: 20,
                    height: 20,
                  ),
                )),
          ),
          if (!widget.user.isReadQuiz)
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: getColor().colorRedFf6388),
              child: Text(
                Strings.newQuiz.localize(context),
                style: textTheme(context).text10.bold.colorWhite,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildRadiusButton() {
    return SizedBox(
      height: widget.user.isReadQuiz ? 44 : 48,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: widget.user.isReadQuiz
                ? EdgeInsets.all(0)
                : EdgeInsets.only(top: 4),
            child: RoundedButton(
              padding: EdgeInsets.only(left: 0, right: 0),
              height: Dimens.size44,
              suffixIcon: Image.asset(
                !widget.user.isQuiz
                    ? DImages.suitableMe
                    : DImages.suitableMeDisable,
                height: 20,
                width: 20,
              ),
              color: !widget.user.isQuiz
                  ? getColor().pinkf3eefc
                  : getColor().grayf1f6aColor,
              text: widget.text ?? Strings.whoSuitableMe.localize(context),
              textStyle: !widget.user.isQuiz
                  ? textTheme(context).text15.colorPrimary.bold
                  : textTheme(context).text15.colorGrayBorder.bold,
              onPressed: onClicked,
            ),
          ),
          if (!widget.user.isReadQuiz)
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: getColor().colorRedFf6388),
              child: Text(
                Strings.newQuiz.localize(context),
                style: textTheme(context).text10.bold.colorWhite,
              ),
            )
        ],
      ),
    );
  }

  readQuiz() async {
    try {
      locator<UserRepository>().readQuiz(widget.user.id!);
    } catch (e) {
      print(e);
    }
  }

  onClicked() async {
    // nếu lỗi 404 tức là bộ câu hỏi quiz chưa được tạo
    // percent !=null là đã trả lời câu hỏi
    // còn lại là chưa trả lời
    try {
      if (!widget.user.isReadQuiz) {
        readQuiz();
      }
      WhoSuitsMeQuestionGroup questionGroup = await locator<UserRepository>()
          .getWhoSuitsMeQuestions(widget.user.id!);
      if (questionGroup.percent != null) {
        showModalBottomSheet(
          backgroundColor: getColor().transparent,
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          builder: (context) => ResultQuizDialog(
            user: widget.user,
            percent: questionGroup.percent!,
          ),
        );
      } else {
        Navigator.pushNamed(context, Routes.relyWhoSuitsMeQuestion,
            arguments: RelyQuestionArgument(user: widget.user));
      }
      locator<TrackingManager>()
          .trackWhoSuitsMeButton(widget.user.id!, quizId: questionGroup.id);
    } catch (error) {
      locator<TrackingManager>().trackWhoSuitsMeButton(widget.user.id!);
      // nếu lỗi 404
      if (error is ApiException && error.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) => OneButtonDialogWidget(
            title: Strings.noQuizYet.localize(context),
            description: Strings.noQuizYetStatus.localize(context),
            textConfirm: Strings.understood.localize(context),
          ),
        );
      }
    }
  }

  showLoading({BuildContext? dialogContext}) {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog();
      showDialog(
          barrierDismissible: false,
          context: dialogContext ?? context,
          builder: (_) =>
              _loadingDialog ??
              Container(
                color: Colors.transparent,
              ));
    }
  }

  hideLoading({BuildContext? dialogContext}) {
    Navigator.pop(dialogContext ?? context);
    _loadingDialog = null;
  }
}
