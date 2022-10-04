import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/my_question/my_question_item.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/template_question/template_question_screen.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:provider/provider.dart';

import 'my_question_model.dart';

class MyQuestionScreen extends StatefulWidget {
  final Function(int) questionCountCalback;

  MyQuestionScreen({required this.questionCountCalback});

  @override
  State<StatefulWidget> createState() => _MyQuestionScreenState();
}

class _MyQuestionScreenState
    extends BaseState<MyQuestionModel, MyQuestionScreen>
    with AutomaticKeepAliveClientMixin<MyQuestionScreen> {
  List<TextEditingController> _questionController = [];

  @override
  void initState() {
    super.initState();
    model.init(widget.questionCountCalback);
    model.getData();
  }

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  Widget buildContentView(BuildContext context, MyQuestionModel model) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ChangeNotifierProvider.value(
          value: model.whoSuitsMeQuestionGroupValue,
          child: Consumer<MyQuestionModel>(
            builder: (context, myModel, child) => model.totalQuestion > 0
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      _questionController.add(TextEditingController());
                      var item = model
                          .whoSuitsMeQuestionGroupValue.value!.questions[index];
                      _questionController[index].text = item.name;
                      _questionController[index].selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _questionController[index].text.length));
                      return index != 0
                          ? Container(
                              color: Colors.transparent,
                              child: _item(item, index),
                              margin: EdgeInsets.only(bottom: 9),
                            )
                          : Container(
                              child: Column(
                                children: [_header(), _item(item, index)],
                              ),
                            );
                    },
                    itemCount:
                        model.whoSuitsMeQuestionGroupValue.value != null &&
                                model.whoSuitsMeQuestionGroupValue.value!
                                        .questions.length >
                                    0
                            ? model.whoSuitsMeQuestionGroupValue.value!
                                .questions.length
                            : 0,
                  )
                : _header(),
          ),
        ),
      ),
      bottomNavigationBar: _btnSubmitQuesion(),
      floatingActionButton: _btnAddQuestion(),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _header() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: textTheme(context).text16.text757788Color,
              children: [
                TextSpan(
                  text: Strings.createQuestionHeader.localize(context),
                  style: TextStyle(fontFamily: "Google Sans", fontSize: 16),
                ),
                TextSpan(
                  text: Strings.createQuestionHeader2.localize(context),
                  style: TextStyle(
                      fontFamily: "Google Sans",
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: Strings.createQuestionHeader3.localize(context),
                  style: TextStyle(fontFamily: "Google Sans", fontSize: 16),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: textTheme(context).text16.text757788Color,
              children: [
                TextSpan(
                  text: Strings.use1.localize(context) + " ",
                  style: TextStyle(fontFamily: "Google Sans", fontSize: 16),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Image.asset(
                    DImages.chooseQuestion,
                    width: 24,
                    height: 24,
                  ),
                  style: textTheme(context).text16.text757788Color,
                ),
                TextSpan(
                  text: " " + Strings.use2.localize(context),
                  style: TextStyle(fontFamily: "Google Sans", fontSize: 16),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _item(WhoSuitsMeQuestion item, int index) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.all(8),
            child: MyQuestionItem(
              item,
              index,
              questionController: _questionController[index],
              agrument: QuestionAgrument(
                  index: index,
                  callback: (index, question) {
                    model.setQuestionData(index, question);
                  }),
            )),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Color(0xff8a5adf),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.close,
                color: getColor().white,
                size: 16,
              ),
            ),
            onTap: () async {
              await model.deleteModelQuestion(index);
              showToast(Strings.removeQuestionSuccess.localize(context));
            },
          ),
        )
      ],
    );
  }

  Widget _btnSubmitQuesion() {
    return Container(
      margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
      height: 48,
      child: ChangeNotifierProvider.value(
        value: model.enable,
        child: PrimaryButton(
          text: model.totalQuestion > 2
              ? Strings.save.localize(context) +
                  " ${model.totalQuestion}/10 " +
                  Strings.myQuestion.localize(context).toLowerCase()
              : " ${model.totalQuestion}/10 ",
          enable: model.enable,
          onPressed: () async {
            if (model.whoSuitsMeQuestionGroupValue.value!.questions.length >=
                3) {
              FocusScope.of(context).requestFocus(new FocusNode());
              callApi(
                  callApiTask: model.sendModelGroupQuestion,
                  onSuccess: () {
                    _createQuestionResponseState();
                    //showToast(Strings.createQuestionSuccess.localize(context));
                  });
            }
          },
        ),
      ),
    );
  }

  Widget _btnAddQuestion() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: getColor().blue37DColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            DImages.addWhite,
            width: 32,
            height: 32,
          ),
        ),
        onTap: () {
          if (model.totalQuestion < 10) {
            model.createQuestionEmpty();
          } else {
            showToast(Strings.notiMaxQuestion.localize(context));
          }
        },
      ),
    );
  }

  _createQuestionResponseState() {
    showDialog(
      context: context,
      builder: (context) => TwoButtonDialogWidget(
        title: Strings.createQuestionSuccess.localize(context),
        description: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text:
                      "${Strings.createQuestionContent1.localize(context)}\n\n",
                  style: textTheme(context).text15.colorDart),
              TextSpan(
                  text: Strings.createQuestionContent2.localize(context),
                  style: textTheme(context).text15.colorDart),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        textConfirm: Strings.shareLink.localize(context),
        textCancel: Strings.shareTimeline.localize(context),
        onCanceled: () {
          final language = locator<AppModel>().locale.languageCode;
          final linkShare = model.getLinkDomainShare() +
              "/share/$language/quiz/" +
              locator<UserModel>().user!.id!;
          Navigator.pushNamed(context, Routes.createNewFeed,
              arguments: CreateNewFeedAgrument(linkShare: linkShare));
        },
        onConfirmed: () {
          locator<HandleLinkUtil>().shareQuiz(locator<UserModel>().user!.id!);
        },
        image: DImages.bearLogo,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
