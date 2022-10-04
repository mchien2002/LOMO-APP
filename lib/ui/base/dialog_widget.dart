import 'package:flutter/cupertino.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/widget/loading_widget.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingWidget(),
    );
  }
}

class InformDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? textConfirm;
  final Function? onConfirm;

  InformDialog({this.title, this.message, this.textConfirm, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title ?? "",
        style: textTheme(context).headline2!.colorDart,
      ),
      content: Text(
        message ?? "",
        style: textTheme(context).body.colorPrimary,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            textConfirm ?? Strings.ok.localize(context),
            style: textTheme(context).body.colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm!();
          },
        )
      ],
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? textConfirm;
  final Function? onConfirm;
  final String? textCancel;
  final Function? onCancel;

  ConfirmDialog(
      {this.title,
      this.message,
      this.textConfirm,
      this.onConfirm,
      this.textCancel,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title ?? "",
        style: textTheme(context).headline2!.colorDart,
      ),
      content: Text(
        message ?? "",
        style: textTheme(context).body.colorPrimary,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            textConfirm ?? Strings.cancel.localize(context),
            style: textTheme(context).body.colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (onCancel != null) onCancel!();
          },
        ),
        CupertinoDialogAction(
          child: Text(
            textConfirm ?? Strings.ok.localize(context),
            style: textTheme(context).body.colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm!();
          },
        )
      ],
    );
  }
}
