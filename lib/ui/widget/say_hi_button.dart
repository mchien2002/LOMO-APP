import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/say_hi_success_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/base/dialog_widget.dart';
import 'package:lomo/ui/dating/first_message/first_message_screen.dart';
import 'package:lomo/util/platform_channel.dart';

import 'button_widgets.dart';

class SayHiButton extends StatefulWidget {
  final User user;
  final String? text;

  SayHiButton(this.user, {this.text});

  @override
  State<StatefulWidget> createState() => _SayHiButtonState();
}

class _SayHiButtonState extends State<SayHiButton> {
  // ValueNotifier<bool> enableButtonSayHi = ValueNotifier(false);
  Widget? _loadingDialog;
  @override
  void initState() {
    super.initState();
    // enableButtonSayHi.value = !widget.user.isSayhi!;
    eventBus.on<SayHiSuccessEvent>().listen((event) async {
      if (widget.user.id == event.userId) {
        // enableButtonSayHi.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BorderButton(
      padding: EdgeInsets.only(left: 0, right: 0),
      height: Dimens.size44,
      radius: 24,
      // enable: enableButtonSayHi,
      onPressed: () async {
        showLoading();
        final isSayHi = await locator<PlatformChannel>()
            .checkGroupChatExist(widget.user.netAloId!);
        hideLoading();
        if (!isSayHi) {
          final isSentMessageSuccess = await Navigator.push(
            context,
            // Create the SelectionScreen in the next step.
            MaterialPageRoute(
                builder: (context) => FirstMessageScreen(widget.user)),
          );
          if (isSentMessageSuccess == true) {
            widget.user.isSayhi = true;
            sentFirstMessageSuccess();
            // enableButtonSayHi.value = false;
          }
        } else {
          locator<PlatformChannel>()
              .openChatWithUser(locator<UserModel>().user!, widget.user);
        }
      },
      suffixIcon: Image.asset(
        DImages.chatPrimary,
        height: 20,
        width: 20,
      ),
      text: widget.text ?? Strings.conversation.localize(context),
      textStyle: textTheme(context).text15.colorPrimary.bold,
    );
  }

  sentFirstMessageSuccess() async {
    try {
      locator<UserRepository>().sentSayHi(widget.user.id!);
    } catch (e) {
      print(e);
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
