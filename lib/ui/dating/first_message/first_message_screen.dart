import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/first_message/first_message_model.dart';
import 'package:lomo/ui/dating/first_message/first_message_tab_bar_view.dart';
import 'package:lomo/ui/dating/first_message/first_message_tab_bar.dart';
import 'package:lomo/ui/widget/bottom_shadow_button_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/stroke_state_button_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/platform_channel.dart';

class FirstMessageScreen extends StatefulWidget {
  final User receiver;
  FirstMessageScreen(this.receiver);
  @override
  State<StatefulWidget> createState() => _FirstMessageScreenState();
}

class _FirstMessageScreenState
    extends BaseState<FirstMessageModel, FirstMessageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    model.init();
    _tabController = TabController(
        vsync: this, length: model.listSampleMessageDating.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget buildContentView(BuildContext context, FirstMessageModel model) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: getColor().white,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          Strings.sayHi.localize(context),
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close,
                size: 28,
                color: getColor().colorDart,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 6, top: 10),
            child: ChangePhoneText(
              text: Strings.send.localize(context),
              enable: model.enableSend,
              onPressed: () async {
                final result = await locator<PlatformChannel>()
                    .sendMessage(widget.receiver, model.tecContentMessage.text);
                if (result == true) {
                  showToast(Strings.sendMessageSuccess.localize(context));
                  Navigator.pop(context, result);
                } else {
                  showToast(Strings.sendFailed.localize(context));
                }
              },
              textStyle: textTheme(context).text13.medium.colorPrimary,
              disableTextStyle: textTheme(context).text13.medium.colorGray,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimens.cornerRadius20)),
            color: getColor().white),
        height: MediaQuery.of(context).size.height - 57,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  height: 1,
                  color: getColor().grayBorder,
                ),
                SizedBox(
                  height: Dimens.spacing15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.size30),
                  child: _buildContentMessage(),
                ),
                SizedBox(
                  height: Dimens.spacing15,
                ),
                Container(
                  height: Dimens.spacing5,
                  color: getColor().gray2eaColor,
                ),
                SizedBox(
                  height: Dimens.spacing15,
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.size30),
                    child: _buildSampleMessage(),
                  ),
                ),
                BottomOneButton(
                  text: Strings.send.localize(context),
                  enable: model.enableButtonSend,
                  onPressed: () async {
                    final result = await locator<PlatformChannel>().sendMessage(
                        widget.receiver, model.tecContentMessage.text);
                    if (result == true) {
                      showToast(Strings.sendMessageSuccess.localize(context));
                      Navigator.pop(context, result);
                    } else {
                      showToast(Strings.sendFailed.localize(context));
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          Strings.suggested_acquaintance.localize(context),
          style: textTheme(context).text13.bold.colorDart,
        ),
        SizedBox(
          height: Dimens.spacing20,
        ),
        SizedBox(
          height: 30,
          child: TTabBar(
            tabController: _tabController,
            items: model.listSampleMessageDating,
          ),
        ),
        SizedBox(
          height: Dimens.spacing15,
        ),
        Expanded(
          child: TTabBarView(
            tabController: _tabController,
            items: model.listSampleMessageDating,
            onMessageSelected: (message) {
              if (model.tecContentMessage.text.length < 200 &&
                  model.tecContentMessage.text != message) {
                model.tecContentMessage.text = message;
              }

              model.tecContentMessage.selection = TextSelection.fromPosition(
                  TextPosition(offset: model.tecContentMessage.text.length));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              CircleNetworkImage(
                size: 40,
                url: widget.receiver.avatar,
              ),
              SizedBox(
                width: Dimens.spacing10,
              ),
              Text(
                widget.receiver.name ?? "",
                style: textTheme(context).text15.bold.colorDart,
              )
            ],
          ),
        ),
        SizedBox(
          height: Dimens.spacing10,
        ),
        Container(
          height: 150,
          padding: EdgeInsets.only(
              left: Dimens.size10, right: Dimens.size10, bottom: Dimens.size10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: getColor().f8f8faColor),
          child: TextField(
            controller: model.tecContentMessage,
            style: textTheme(context).text13.colorDart,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            maxLength: model.maxLengthMessage,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.get_acquainted.localize(context),
              counterStyle: textTheme(context).text13.colorHint,
            ),
          ),
        ),
      ],
    );
  }
}
