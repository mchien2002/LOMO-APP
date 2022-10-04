import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/data/eventbus/edit_question_event.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/template_question/template_question_screen.dart';

import 'my_answer_view.dart';

class MyQuestionView extends StatefulWidget {
  final int index;
  final bool isEdit;
  final WhoSuitsMeQuestion whoSuitsMeQuestion;
  final TextEditingController? controller;
  final QuestionAgrument? agrument;

  MyQuestionView(
      {required this.index,
      this.isEdit = true,
      required this.whoSuitsMeQuestion,
      this.controller,
      this.agrument});

  @override
  State<StatefulWidget> createState() => _MyQuestionViewState();
}

class _MyQuestionViewState extends State<MyQuestionView> {
  late double width;
  bool isInputError = false;
  static const MAX_LENGTH = 50;
  static const MIN_LENGTH = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
        alignment: Alignment.centerLeft,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            border: isInputError
                ? Border.all(
                    color: Colors.red,
                  )
                : null,
            color: getColor().f3eefcColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6))),
        child: Row(
          children: [
            SizedBox(
              width: 7,
            ),
            if (widget.isEdit)
              InkWell(
                child: Image.asset(
                  DImages.chooseQuestion,
                  width: 24,
                  height: 24,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.sampleQuestion,
                      arguments: widget.agrument);
                },
              ),
            if (widget.isEdit)
              SizedBox(
                width: 5,
              ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                enableInteractiveSelection: widget.isEdit,
                focusNode: !widget.isEdit ? AlwaysDisabledFocusNode() : null,
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText:
                      "${Strings.questionNumber.localize(context)} ${widget.index + 1}",
                  counterText: "",
                  hintStyle: textTheme(context).text15.medium.text757788Color,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLength: MAX_LENGTH,
                maxLines: 2,
                minLines: 1,
                style: widget.isEdit?textTheme(context).text15.medium.text757788Color:textTheme(context).text15.medium.ff261744Color,
                onChanged: (text) {
                  widget.whoSuitsMeQuestion.name = text;
                  if (!widget.whoSuitsMeQuestion.isNewItem)
                    eventBus.fire(EditQuestionEvent(
                        questionIndex: widget.index, data: text));
                  final error = checkInputError(text);
                  if (error != isInputError) {
                    setState(() {
                      isInputError = error;
                    });
                  }
                },
              ),
            ),
          ],
        ));
  }

  bool checkInputError(String text) {
    return text.length >= MIN_LENGTH ? false : true;
  }
}
