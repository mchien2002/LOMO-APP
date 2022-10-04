import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/dialog_widget.dart';
import 'package:lomo/ui/dating/first_message/first_message_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/circle_wave_widget.dart';
import 'package:lomo/util/platform_channel.dart';

class ResultQuizDialog extends StatelessWidget {
  final User user;
  final int percent;
  final Function? onSayHi;
  final Function? onCreateMyQuiz;
  final Function? onClosed;
  ResultQuizDialog(
      {required this.user,
      required this.percent,
      this.onSayHi,
      this.onCreateMyQuiz,
      this.onClosed});

  Widget? _loadingDialog;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: getColor().white,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  Strings.youMatchWith.localize(context),
                  style: textTheme(context).text20.ff514569Color,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.name ?? "",
                  style: textTheme(context).text20.bold.ff514569Color,
                ),
                SizedBox(
                  height: 45,
                ),
                CircleWaveWidget(
                  color: percent > 66
                      ? getColor().greenColor
                      : percent < 34
                          ? getColor().orangeColor
                          : getColor().pin88Color,
                  text: "$percent%",
                  size: 214,
                ),
                SizedBox(
                  height: 20,
                ),
                _buildStatus(context),
                SizedBox(
                  height: 30,
                ),
                _buildSayHi(context),
                SizedBox(
                  height: 26,
                ),
                _buildMyQuiz(context),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: (percent > 66
                    ? Strings.resultQuizLargeStatus1
                    : percent < 34
                        ? Strings.resultQuizLessStatus1
                        : Strings.resultQuizMediumStatus1)
                .localize(context),
            style: textTheme(context).text15.colorDart,
          ),
          TextSpan(
            text: user.name ?? "",
            style: textTheme(context).text15.bold.colorDart,
          ),
          TextSpan(
            text: (percent > 66
                    ? Strings.resultQuizLargeStatus2
                    : percent < 34
                        ? Strings.resultQuizLessStatus2
                        : Strings.resultQuizMediumStatus2)
                .localize(context),
            style: textTheme(context).text15.colorDart,
          ),
          TextSpan(
            text: user.name ?? "",
            style: textTheme(context).text15.bold.colorDart,
          ),
          TextSpan(
            text: (percent > 66
                    ? Strings.resultQuizLargeStatus3
                    : percent < 34
                        ? Strings.resultQuizLessStatus3
                        : Strings.resultQuizMediumStatus3)
                .localize(context),
            style: textTheme(context).text15.colorDart,
          ),
        ]),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15, top: 15, bottom: 5),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            if (onClosed != null) onClosed!();
          },
          child: Icon(
            Icons.close,
            color: getColor().colorDart,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildSayHi(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 67),
      child: SmallButton(
        height: 44,
        onPressed: () async {
          if (onSayHi != null) onSayHi!();
          showLoading(dialogContext: context);
          final isSayHi = await locator<PlatformChannel>()
              .checkGroupChatExist(user.netAloId!);
          hideLoading(dialogContext: context);
          Navigator.pop(context);
          if (!isSayHi) {
            final isSentMessageSuccess = await Navigator.push(
              context,
              // Create the SelectionScreen in the next step.
              MaterialPageRoute(builder: (context) => FirstMessageScreen(user)),
            );
            if (isSentMessageSuccess == true) {
              user.isSayhi = true;
              sentFirstMessageSuccess();
              // enableButtonSayHi.value = false;
            }
          } else {
            locator<PlatformChannel>()
                .openChatWithUser(locator<UserModel>().user!, user);
          }
        },
        suffixIcon: Image.asset(
          DImages.chatWhite,
          color: getColor().white,
          height: 24,
          width: 24,
        ),
        text: Strings.sayHiNow.localize(context),
        textStyle: textTheme(context).text15.colorWhite.bold,
      ),
    );
  }

  Widget _buildMyQuiz(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 67),
      child: SmallBorderButton(
        height: 46,
        suffixIcon: Image.asset(
          DImages.suitableMe,
          height: 24,
          width: 24,
        ),
        borderColor: getColor().pinkf3eefc,
        color: getColor().pinkf3eefc,
        text: Strings.createMyQuiz.localize(context),
        textStyle: textTheme(context).text15.colorPrimary.bold,
        onPressed: () {
          if (onCreateMyQuiz != null) onCreateMyQuiz!();
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            Routes.whoSuitsMeProfile,
          );
        },
      ),
    );
  }

  sentFirstMessageSuccess() async {
    try {
      locator<UserRepository>().sentSayHi(user.id!);
    } catch (e) {
      print(e);
    }
  }

  showLoading({required BuildContext dialogContext}) {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog();
      showDialog(
          barrierDismissible: false,
          context: dialogContext,
          builder: (_) =>
              _loadingDialog ??
              Container(
                color: Colors.transparent,
              ));
    }
  }

  hideLoading({required BuildContext dialogContext}) {
    Navigator.pop(dialogContext);
    _loadingDialog = null;
  }
}
