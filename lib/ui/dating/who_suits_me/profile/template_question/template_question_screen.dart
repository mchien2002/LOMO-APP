
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/my_question/my_question_item.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import 'template_question_model.dart';

class TemplateQuestionScreen extends StatefulWidget {
  final QuestionAgrument? agrument;

  TemplateQuestionScreen({this.agrument});

  @override
  State<StatefulWidget> createState() => _TemplateQuestionScreenState();
}

class _TemplateQuestionScreenState extends BaseListState<WhoSuitsMeQuestion,
        TemplateQuestionModel, TemplateQuestionScreen>
    with AutomaticKeepAliveClientMixin<TemplateQuestionScreen> {
  List<TextEditingController> _questionController = [];

  @override
  void initState() {
    super.initState();
    model.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Image.asset(DImages.closex)),
        ),
        centerTitle: true,
        backgroundColor: getColor().white,
        elevation: 0,
        title: Text(
          Strings.sampleQuestion.localize(context),
          style: textTheme(context).text19.bold.darkTextColor,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          // InkWell(
          //   child: Center(
          //     child: Text(Strings.reset.localize(context),
          //         style: textTheme(context).text15.text757788Color),
          //   ),
          //   onTap: () {},
          // ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Divider(
            height: 3,
            color: getColor().underlineClearTextField,
          ),
          Expanded(child: super.buildContent()),
        ],
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, WhoSuitsMeQuestion item, int index) {
    _questionController.add(TextEditingController());
    _questionController[index].text = item.name;
    return Container(
        color: getColor().white,
        padding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 3),
        child: Stack(children: [
          Container(
              margin: EdgeInsets.all(8),
              child: MyQuestionItem(
                item,
                index,
                isEdit: false,
                questionController: _questionController[index],
              )),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(right: 8),
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: getColor().blue37DColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.add,
                  color: getColor().white,
                ),
              ),
              onTap: () async {
                widget.agrument?.callback!(widget.agrument!.index, item);
                Navigator.pop(context);
              },
            ),
          ),
          ChangeNotifierProvider.value(
            value: model.loadingValue,
            child: Center(
                child: model.loadingValue.value
                    ? LoadingWidget()
                    : SizedBox(
                        width: 0,
                        height: 0,
                      )),
          )
        ]));
  }

  @override
  bool get autoLoadData => false;

  @override
  bool get wantKeepAlive => true;
}

class QuestionAgrument {
  final int index;
  final Function(int, WhoSuitsMeQuestion)? callback;

  QuestionAgrument({required this.index, this.callback});
}
