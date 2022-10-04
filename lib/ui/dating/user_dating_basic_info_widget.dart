import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:provider/provider.dart';

import '../report/report_screen.dart';
import 'user_dating_basic_info_model.dart';

class UserDatingBasicInfoWidget extends StatefulWidget {
  final User user;
  final double? size;
  final bool? isShowMenuButton;
  final Function(User user)? onUserInfoClicked;
  UserDatingBasicInfoWidget(this.user,
      {this.size, this.isShowMenuButton = true, this.onUserInfoClicked});
  @override
  State<StatefulWidget> createState() => _UserDatingBasicInfoWidgetState();
}

class _UserDatingBasicInfoWidgetState
    extends BaseState<UserDatingBasicInfoModel, UserDatingBasicInfoWidget> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget buildContentView(
      BuildContext context, UserDatingBasicInfoModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: _buildInfo()),
        if (widget.isShowMenuButton!) _buildFollowAndSettingButton(),
      ],
    );
  }

  Widget _buildInfo() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (widget.onUserInfoClicked != null) {
          widget.onUserInfoClicked!(widget.user);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleNetworkImage(
            size: widget.size ?? 40,
            url: widget.user.avatar,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.user.name ?? "",
                    style: textTheme(context).text15.colorDart.bold,
                  ),
                  SizedBox(
                    width: 0,
                  ),
                ],
              ),
              if (widget.user.birthday != null)
                Text(
                  "${getAgeFromDateTime(widget.user.birthday!)} ${Strings.age.localize(context)}${widget.user.province?.name != null ? ", ${widget.user.province?.name}" : ""}",
                  style: textTheme(context).text13.colorGray77,
                )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFollowAndSettingButton() {
    return Row(
      children: [
        ValueListenableProvider.value(
          value: model.follow,
          child: Consumer<bool>(
            builder: (context, isFollow, child) => isFollow
                ? SizedBox()
                : InkWell(
                    onTap: () async {
                      model.followUser(widget.user);
                    },
                    child: FollowUserCheckBox(widget.user),
                  ),
          ),
        ),
        _buildButtonMore(),
      ],
    );
  }

  Widget _buildButtonMore() {
    final menuItems =
        widget.user.isFollow ? menuMoreItems : menuMoreItems.toList();

    return BottomSheetMenuWidget(
      items: menuItems.map((e) => e.name.localize(context)).toList(),
      onItemClicked: (index) async {
        switch (menuItems[index]) {
          case DatingProfileMenu.report:
            Navigator.pushNamed(context, Routes.report,
                arguments: ReportScreenArgs(user: widget.user));
            break;
          case DatingProfileMenu.block:
            showDialog(
                context: context,
                builder: (context) => TwoButtonDialogWidget(
                      title: Strings.blockThisUser.localize(context),
                      description: Strings.blockedUserContent.localize(context),
                      onConfirmed: () {
                        callApi(callApiTask: () async {
                          await model.block(widget.user);
                          showToast(Strings.blockSuccess.localize(context));
                        });
                      },
                    ));
            break;
          // case DatingProfileMenu.sendMessage:
          //   locator<PlatformChannel>()
          //       .openChatWithUser(locator<UserModel>().user!, widget.user);
          //   break;
          case DatingProfileMenu.cancel:
            break;
        }
      },
      child: Image.asset(
        DImages.moreGray,
        height: 36,
        width: 36,
      ),
    );
  }

  final List<DatingProfileMenu> menuMoreItems = DatingProfileMenu.values;
}

enum DatingProfileMenu { report, block, cancel }

extension DatingProfileMenuExt on DatingProfileMenu {
  String get name {
    switch (this) {
      case DatingProfileMenu.report:
        return Strings.report;
      case DatingProfileMenu.block:
        return Strings.block;
      // case DatingProfileMenu.share:
      //   return Strings.share;
      // case DatingProfileMenu.sendMessage:
      //   return Strings.sendMessage;
      case DatingProfileMenu.cancel:
        return Strings.close;
    }
    return "";
  }
}
