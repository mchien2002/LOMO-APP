import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/my_question/my_answer_view.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/my_question/my_question_view.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/template_question/template_question_screen.dart';

class MyQuestionItem extends StatefulWidget {
  final WhoSuitsMeQuestion item;
  final int index;
  final bool isEdit;
  final TextEditingController? questionController;
  final QuestionAgrument? agrument;

  MyQuestionItem(this.item, this.index,
      {this.isEdit = true, this.questionController, this.agrument});

  @override
  State<StatefulWidget> createState() => _MyQuestionItemState();
}

class _MyQuestionItemState extends State<MyQuestionItem> {
  late double width;
  List<TextEditingController> _answerController = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: Column(
        children: [
          MyQuestionView(
            whoSuitsMeQuestion: widget.item,
            index: widget.index,
            isEdit: widget.isEdit,
            controller: widget.questionController,
            agrument: widget.agrument,
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              final name = widget.item.answers[index].name ?? "";
              _answerController.add(new TextEditingController());
              _answerController[index].text = name;
              _answerController[index].selection = TextSelection.fromPosition(
                  TextPosition(offset: _answerController[index].text.length));
              return MyAnswerView(
                whoSuitsMeAnswer: widget.item.answers[index],
                answerIndex: index,
                questionIndex: widget.index,
                isEdit: widget.isEdit,
                answerController: _answerController[index],
                isNewItem: widget.item.isNewItem,
              );
            },
            itemCount: widget.item.answers.length,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: getColor().white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: getColor().f3eefcColor,
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
