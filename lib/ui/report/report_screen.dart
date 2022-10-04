import 'package:flutter/material.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/report/report_model.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:provider/provider.dart';

import '../../data/api/models/new_feed.dart';
import '../../data/api/models/user.dart';
import '../../res/dimens.dart';
import '../../res/images.dart';
import '../widget/button_widgets.dart';

class ReportScreenArgs {
  final User user;
  final NewFeed? newFeed;
  ReportScreenArgs({required this.user, this.newFeed});
}

class ReportScreen extends StatefulWidget {
  final ReportScreenArgs args;
  ReportScreen(this.args);

  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends BaseState<ReportModel, ReportScreen> {
  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor().white,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                DImages.closex,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: buildContent(),
    );
  }

  @override
  Widget buildContentView(BuildContext context, ReportModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountReported(),
            SizedBox(
              height: 20,
            ),
            Text(
              Strings.issueReport.localize(context),
              style: textTheme(context).text14.bold.darkTextColor,
            ),
            SizedBox(
              height: 20,
            ),
            _buildIssues(),
            SizedBox(
              height: 20,
            ),
            _buildContentIssue(),
            SizedBox(
              height: 20,
            ),
            _buildPickImages(),
            SizedBox(
              height: 40,
            ),
            _buildBottomButton(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentIssue() {
    return ValueListenableProvider.value(
      value: model.showOtherContent,
      child: Consumer<bool>(
        builder: (context, isShowContent, child) => isShowContent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.content.localize(context),
                    style: textTheme(context).text14.bold.darkTextColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.only(
                        left: Dimens.size10,
                        right: Dimens.size10,
                        bottom: Dimens.size10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: getColor().f8f8faColor),
                    child: TextField(
                      controller: model.tecContent,
                      style: textTheme(context).text13.colorDart,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      maxLength: 1000,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Strings.describeReport.localize(context),
                        counterStyle: textTheme(context).text13.colorHint,
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                height: 0,
              ),
      ),
    );
  }

  Widget _buildPickImages() {
    return ValueListenableProvider.value(
      value: model.attachFiles,
      child: Consumer<List<PhotoInfo>>(
        builder: (context, files, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(width: 1, color: getColor().colorDivider)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.attachImage.localize(context),
                      style: textTheme(context).text14.darkTextColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      DImages.image,
                      height: 20,
                      width: 20,
                    )
                  ],
                ),
              ),
              onTap: () async {
                model.pickImages(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            if (files.isNotEmpty)
              SizedBox(
                height: 106,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => SizedBox(
                          width: 106,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.memory(
                                  files[index].u8List!,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      model.removeImage(index);
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: getColor().primaryColor),
                                      child: Icon(
                                        Icons.close,
                                        color: getColor().white,
                                        size: 18,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemCount: files.length),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountReported() {
    return Row(
      children: [
        Image.asset(
          DImages.reportIcon,
          height: 36,
          width: 36,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.accountReported.localize(context),
              style: textTheme(context).text13.bold.darkTextColor,
            ),
            Text(
              widget.args.user.name ?? "",
              style: textTheme(context).text15.colorPrimary,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildIssues() {
    return Wrap(
      spacing: 5,
      runSpacing: 10,
      children: model.issues
          .map(
            (e) => IssueButton(e, (isCheck) {
              model.validateData();
            }),
          )
          .toList(),
    );
  }

  Widget _buildBottomButton() {
    return PrimaryButton(
      text: Strings.reportNow.localize(context),
      onPressed: () {
        callApi(callApiTask: () async {
          await model.report(context, widget.args.user.id!,
              newFeedId: widget.args.newFeed?.id);
        }, onSuccess: () {
          showDialog(
            context: context,
            builder: (context) => OneButtonDialogWidget(
              description: Strings.reportSuccess.localize(context),
              onConfirmed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
      },
      enable: model.enableButton,
    );
  }
}

class IssueButton extends StatefulWidget {
  final ReportIssue issue;
  final Function(bool) onCheckChanged;
  IssueButton(this.issue, this.onCheckChanged);
  @override
  State<StatefulWidget> createState() => _IssueButtonState();
}

class _IssueButtonState extends State<IssueButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.issue.isChoose = !widget.issue.isChoose;
          widget.onCheckChanged(widget.issue.isChoose);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.issue.isChoose
                ? getColor().primaryColor
                : getColor().gray2eaColor),
        child: Text(
          widget.issue.title.localize(context),
          style: widget.issue.isChoose
              ? textTheme(context).text13.colorWhite
              : textTheme(context).text13.darkTextColor,
        ),
      ),
    );
  }
}
