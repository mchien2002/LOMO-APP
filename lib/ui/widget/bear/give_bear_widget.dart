import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget_model.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/util/common_utils.dart';

class GiveBearWidget extends StatefulWidget {
  Widget? childGive;
  Widget? childGave;
  double size;
  bool isBear; //false chưa tặng,true đã tặng
  String userId;
  double width;
  double height;

  GiveBearWidget(
    this.userId,
    this.isBear, {
    this.childGive,
    this.childGave,
    this.size = 32.0,
    this.width = 60.0,
    this.height = 60.0,
  });

  @override
  _GiveBearWidgetState createState() => _GiveBearWidgetState();
}

class _GiveBearWidgetState
    extends BaseState<GiveBearWidgetModel, GiveBearWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    model.init(widget.userId, widget.isBear);
  }

  @override
  Widget buildContentView(BuildContext context, GiveBearWidgetModel model) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.size),
      ),
      child: !model.isBear
          ? widget.childGive != null
              ? widget.childGive
              : _giveDefault()
          : widget.childGave != null
              ? widget.childGave
              : _gaveDefault(),
      onTap: () async {
        if (model.isBear) {
          //Da tang gau trong ngay

        } else if (locator<UserModel>().user!.numberOfCandy! > 0 &&
            !model.isBear) {
          model.loadingSubject.sink.add(true);
          await model.sendBear(model.userId);
          if (model.progressState == ProgressState.success) {
            setState(() {
              model.isBear = true;
            });
            showToast(Strings.sentBearSuccess.localize(context));
          } else {
            model.isBear = false;
          }
          model.updateBear();
          model.loadingSubject.sink.add(false);
        } else {
          showError(Strings.notEnoughCandy.localize(context));
          model.loadingSubject.sink.add(false);
        }
      },
    );
  }

  Widget _giveDefault() {
    return Container(
      height: widget.width,
      width: widget.height,
      decoration: BoxDecoration(
        color: getColor().colorPrimary,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 2,
        //     offset: Offset(0, 2), // changes position of shadow
        //   ),
        // ],
        borderRadius: BorderRadius.circular(widget.width),
      ),
      child: Center(
          child: Stack(
        children: [
          Center(
            child: Image.asset(
              DImages.iconBearV2,
              width: widget.size,
              height: widget.size,
            ),
          ),
          Center(
            child: StreamBuilder<bool>(
                stream: model.loadingSubject,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: snapshot.data != null && snapshot.data!,
                    child: LoadingWidget(
                      radius: 16,
                      activeColor: DColors.orangeColor,
                      inactiveColor: DColors.yellowffDcolor,
                    ),
                  );
                }),
          )
        ],
      )),
    );
  }

  Widget _gaveDefault() {
    return Container(
      height: widget.width,
      width: widget.height,
      child: Image.asset(
        DImages.bear,
      ),
    );
  }
}
