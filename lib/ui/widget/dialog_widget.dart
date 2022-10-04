import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DialogWidget extends StatelessWidget {
  final String? title;
  final dynamic description;
  final String? image;

  DialogWidget({this.title, this.description = "", this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: Dimens.avatarRadius,
            bottom: Dimens.padding + 10,
            left: Dimens.padding,
            right: Dimens.padding,
          ),
          margin: EdgeInsets.only(top: Dimens.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Dimens.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Center(
                    child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: textTheme(context).text22.bold.colorDart,
                )),
              if (title != null)
                SizedBox(
                  height: 18.0,
                ),
              description is Widget
                  ? description
                  : Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textTheme(context).text15.colorBlack4B,
                    ),
              SizedBox(
                height: 24.0,
              ),
              buildBottomButton(context),
            ],
          ),
        ),
        Positioned(
            left: Dimens.padding,
            right: Dimens.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.avatarRadius)),
                child: image != null
                    ? Image.asset(image!)
                    : SvgPicture.asset("assets/icons/ic_logo.svg"),
              ),
              radius: Dimens.avatarRadius,
            )),
      ],
    );
  }

  Widget buildBottomButton(BuildContext context) {
    return Container();
  }
}

class LoadingDialogWidget extends DialogWidget {
  final String? title;
  final String? description;

  LoadingDialogWidget({this.title, this.description})
      : super(title: title, description: description);

  @override
  Widget buildBottomButton(BuildContext context) {
    return LoadingWidget();
  }
}

class NoButtonDialogWidget extends DialogWidget {
  final String? title;
  final dynamic description;

  NoButtonDialogWidget({this.title, required this.description})
      : super(title: title, description: description);

  @override
  Widget buildBottomButton(BuildContext context) {
    return SizedBox(
      height: 0,
    );
  }
}

class OneButtonDialogWidget extends DialogWidget {
  final String? title;
  final dynamic description;
  final String? textConfirm;
  final Function? onConfirmed;
  final bool autoCloseAfterConfirm;

  OneButtonDialogWidget(
      {this.title,
      required this.description,
      this.textConfirm,
      this.onConfirmed,
      this.autoCloseAfterConfirm = true})
      : super(title: title, description: description);

  @override
  Widget buildBottomButton(BuildContext context) {
    return Center(
      child: RoundedButton(
        text: textConfirm ?? Strings.confirm.localize(context),
        radius: Dimens.cornerRadius,
        textStyle: textTheme(context).text15.bold.colorWhite,
        height: 36,
        onPressed: () {
          if (autoCloseAfterConfirm) Navigator.pop(context);
          if (onConfirmed != null) onConfirmed!();
        },
      ),
    );
  }
}

class TwoButtonDialogWidget extends DialogWidget {
  final String? title;
  final dynamic description;
  final String? textConfirm;
  final Function? onConfirmed;
  final String? textCancel;
  final Function? onCanceled;
  final String? image;

  TwoButtonDialogWidget(
      {this.title,
      this.description,
      this.textConfirm,
      this.onConfirmed,
      this.textCancel,
      this.onCanceled,
      this.image})
      : super(title: title, description: description, image: image);

  @override
  Widget buildBottomButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RoundedButton(
            text: textCancel ?? Strings.cancel.localize(context),
            radius: Dimens.cornerRadius,
            height: 36,
            color: getColor().backgroundCancel,
            textStyle: textTheme(context).text15.bold.colorBlack4B,
            onPressed: () {
              Navigator.pop(context);
              if (onCanceled != null) onCanceled!();
            },
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: RoundedButton(
            color: DColors.violetColor,
            text: textConfirm ?? Strings.confirm.localize(context),
            radius: Dimens.cornerRadius,
            textStyle: textTheme(context).text15.bold.colorWhite,
            height: 36,
            onPressed: () {
              Navigator.pop(context);
              if (onConfirmed != null) onConfirmed!();
            },
          ),
        ),
      ],
    );
  }
}

class TwoButtonDialogAwaitConfirmWidget extends DialogWidget {
  final String? title;
  final String? description;
  final String? textConfirm;
  final Function? onConfirmed;
  final String? textCancel;
  final Function? onCanceled;
  final bool? onFixErrorCallAPI;

  TwoButtonDialogAwaitConfirmWidget(
      {this.title,
      this.description,
      this.textConfirm,
      this.onConfirmed,
      this.textCancel,
      this.onFixErrorCallAPI,
      this.onCanceled})
      : super(title: title, description: description);

  @override
  Widget buildBottomButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RoundedButton(
            text: textCancel ?? Strings.cancel.localize(context),
            radius: Dimens.cornerRadius,
            height: 36,
            width: 125,
            color: getColor().backgroundCancel,
            textStyle: textTheme(context).text15.bold.colorBlack4B,
            onPressed: () {
              Navigator.pop(context);
              if (onCanceled != null) onCanceled!();
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: RoundedButton(
            color: DColors.violetColor,
            text: textConfirm ?? Strings.confirm.localize(context),
            radius: Dimens.cornerRadius,
            textStyle: textTheme(context).text15.bold.colorWhite,
            height: 36,
            width: 125,
            onPressed: () async {
              if (onFixErrorCallAPI != true) {
                if (onConfirmed != null) await onConfirmed!();
                Navigator.pop(context);
              } else {
                if (onConfirmed != null) await onConfirmed!();
              }
            },
          ),
        ),
      ],
    );
  }
}

class LoadingPercentDialogWidget extends StatefulWidget {
  final String? title;
  final String? image;
  final ValueNotifier<double> percent;

  LoadingPercentDialogWidget({this.title, this.image, required this.percent});

  @override
  State<StatefulWidget> createState() => _LoadingPercentDialogWidgetState();
}

class _LoadingPercentDialogWidgetState
    extends State<LoadingPercentDialogWidget> {
  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: Dimens.avatarRadius,
            bottom: 10,
            left: Dimens.padding,
            right: Dimens.padding,
          ),
          margin: EdgeInsets.only(top: Dimens.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Dimens.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title ?? "",
                style: textTheme(context).text18.bold.colorPrimary,
              ),
              SizedBox(
                height: 25,
              ),
              ValueListenableProvider.value(
                value: widget.percent,
                child: Consumer<double>(
                  builder: (_, percent, child) => LinearPercentIndicator(
                    animation: false,
                    lineHeight: 10.0,
                    percent: percent < 0.02 ? 0.02 : percent,
                    progressColor: getColor().primaryColor,
                    backgroundColor: getColor().colorBackGroundGrayUseItem,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
            left: Dimens.padding,
            right: Dimens.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.avatarRadius)),
                child: widget.image != null
                    ? Image.asset(widget.image!)
                    : SvgPicture.asset("assets/icons/ic_logo.svg"),
              ),
              radius: Dimens.avatarRadius,
            )),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.percent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
