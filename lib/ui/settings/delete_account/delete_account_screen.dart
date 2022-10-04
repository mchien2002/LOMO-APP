import 'package:flutter/material.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/checkbox_widget.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:provider/provider.dart';

import '../../../res/images.dart';
import '../../../res/strings.dart';
import '../../../res/theme/text_theme.dart';
import '../../../res/theme/theme_manager.dart';
import '../../profile/profile_candy/gradient_appbar.dart';
import 'delete_account_model.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState
    extends BaseState<DeteleAccountModel, DeleteAccountScreen> {
  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: getColor().white,
      // appBar: _buildAppBar(context),
      body: Column(
        children: [
          GradientAppBarColor(Strings.deleteAccount.localize(context)),
          Expanded(child: buildContent())
        ],
      ),
    );
  }

  @override
  Widget buildContentView(BuildContext context, DeteleAccountModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleDeleteAccount(),
          SizedBox(
            height: 30,
          ),
          Divider(
            color: getColor().colorDivider,
            height: 2,
          ),
          SizedBox(
            height: 15,
          ),
          _buildReasons(),
          SizedBox(
            height: 40,
          ),
          _buildDeleteButton(),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColor().white,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            DImages.backBlack,
            width: 32,
            height: 32,
          ),
        ),
      ),
      title: Text(
        Strings.deleteAccount.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
    );
  }

  Widget _buildRuleDeleteAccount() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.deleteAccountWillBe.localize(context),
              style: textTheme(context).text14.bold.darkTextColor,
            ),
            SizedBox(
              height: 10,
            ),
            _buildItemRule(Strings.deleteAccountRule1.localize(context)),
            SizedBox(
              height: 5,
            ),
            _buildItemRule(Strings.deleteAccountRule2.localize(context)),
            SizedBox(
              height: 5,
            ),
            _buildItemRule(Strings.deleteAccountRule3.localize(context)),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.note.localize(context),
              style: textTheme(context).text14.bold.darkTextColor,
            ),
            SizedBox(
              height: 10,
            ),
            _buildItemRule(Strings.deleteAccountNote1.localize(context)),
            SizedBox(
              height: 5,
            ),
            _buildItemRule(Strings.deleteAccountNote2.localize(context)),
            SizedBox(
              height: 5,
            ),
            _buildItemRule(Strings.deleteAccountNote3.localize(context)),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget _buildItemRule(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 6,
          width: 6,
          margin: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: getColor().grayBDBEColor),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: textTheme(context).text14.darkTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReasons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.reasonDeleteAccountStatus.localize(context),
            style: textTheme(context).text14.bold.darkTextColor,
          ),
          ValueListenableProvider.value(
            value: model.buildListReason,
            child: Consumer<Object?>(
              builder: (context, isBuild, child) => isBuild != null
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          model.reasonsDelete[index].item.id ==
                                  model.otherReasonId
                              ? _buildOtherReason(context, index)
                              : _buildItemReason(context, index),
                      separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: getColor().colorDivider,
                          ),
                      itemCount: model.reasonsDelete.length)
                  : SizedBox(
                      height: 0,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemReason(BuildContext context, int index) {
    return SizedBox(
      height: 50,
      child: InkWell(
        onTap: () {
          model.setCheckItemReason(index, model.reasonsDelete[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.reasonsDelete[index].item.name ?? "",
              style: textTheme(context).text14.darkTextColor,
            ),
            CheckBoxWidget(
              checkedIcon: Image.asset(
                DImages.checked,
                height: 20,
                width: 20,
              ),
              unCheckedIcon: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: getColor().black4B),
                ),
              ),
              initValue: model.reasonsDelete[index].isChecked,
              onCheckChanged: (isChecked) {
                model.setCheckItemReason(index, model.reasonsDelete[index]);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOtherReason(BuildContext context, int index) {
    return Column(
      children: [
        _buildItemReason(context, index),
        if (model.reasonsDelete[index].isChecked)
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: getColor().colorf0f1f5),
            child: TextField(
              controller: model.tecOtherReasonDeleteAccount,
              autofocus: false,
              style: textTheme(context).text14.colorDart,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Strings.yourReason.localize(context),
                counterStyle: textTheme(context).text14.colorHint,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: PrimaryButton(
        enable: model.enableDelete,
        text: Strings.deleteAccount.localize(context),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (_) => TwoButtonDialogWidget(
                    title: Strings.deleteAccount.localize(context),
                    description:
                        Strings.youConfirmDeleteAccount.localize(context),
                    textConfirm: Strings.deleteNow.localize(context),
                    onConfirmed: () async {
                      await callApi(callApiTask: () async {
                        await model.deleteAccount();
                      }, onSuccess: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      });
                    },
                  ));
        },
      ),
    );
  }
}
