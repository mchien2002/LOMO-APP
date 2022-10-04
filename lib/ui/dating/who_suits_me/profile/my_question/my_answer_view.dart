import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/who_suits_me_answer.dart';
import 'package:lomo/data/eventbus/edit_answer_event.dart';
import 'package:lomo/data/eventbus/validate_question_event.dart';
import 'package:lomo/data/eventbus/who_suitme_answer_event.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/common_utils.dart';

class MyAnswerView extends StatefulWidget {
  final int answerIndex;
  final int questionIndex;
  final bool isEdit;
  final WhoSuitsMeAnswer whoSuitsMeAnswer;
  final TextEditingController? answerController;
  final bool isNewItem;

  MyAnswerView(
      {required this.whoSuitsMeAnswer,
      required this.answerIndex,
      required this.questionIndex,
      this.isEdit = true,
      this.answerController,
      this.isNewItem = false});

  @override
  State<StatefulWidget> createState() => _MyAnswerViewState();
}

class _MyAnswerViewState extends State<MyAnswerView> {
  late double width;
  bool isInputError = false;
  static const MAX_LENGTH = 50;
  static const MIN_LENGTH = 1;

  @override
  void initState() {
    super.initState();
    eventBus.on<WhoSuitMeAnswerEvent>().listen((event) async {
      //Thay doi gia tri cua chinh cau tra loi
      if (widget.questionIndex == event.questionIndex &&
          widget.answerIndex == event.answerIndex) {
        widget.whoSuitsMeAnswer.isTrue = event.isTrue;
        eventBus.fire(ValidateQuestionEvent(
            questionIndex: event.questionIndex,
            answerIndex: event.answerIndex,
            isTrue: event.isTrue));
        if (mounted) setState(() {});
      }
      // Remove het nhung item khac da chon lam cau tra loi
      if (widget.questionIndex == event.questionIndex &&
          widget.answerIndex != event.answerIndex &&
          event.isTrue) {
        widget.whoSuitsMeAnswer.isTrue = false;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border.all(
              color: isInputError ? Colors.red : getColor().gray6ebColor,
            ),
            color: getColor().gray6ebColor,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                enableInteractiveSelection: widget.isEdit,
                focusNode: !widget.isEdit ? AlwaysDisabledFocusNode() : null,
                controller: widget.answerController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                  hintText:
                      "${Strings.answerNumber.localize(context)} ${widget.answerIndex + 1}",
                  counterText: "",
                  hintStyle: textTheme(context).text15.colorGray,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLength: MAX_LENGTH,
                maxLines: 2,
                minLines: 1,
                textAlignVertical: TextAlignVertical.bottom,
                style: textTheme(context).text15.babbceColor,
                onChanged: (text) {
                  widget.whoSuitsMeAnswer.name = text;
                  if (!widget.isNewItem)
                    eventBus.fire(EditAnswerEvent(
                        questionIndex: widget.questionIndex,
                        answerIndex: widget.answerIndex,
                        data: text));
                  final error = checkInputError(text);
                  if (error != isInputError) {
                    setState(() {
                      isInputError = error;
                    });
                  }
                },
                onSubmitted: (content) {
                  print(content);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _btnAnswerQuestion()
          ],
        ),
      ),
    );
  }

  bool checkInputError(String text) {
    return text.length >= MIN_LENGTH ? false : true;
  }

  Widget _btnAnswerQuestion() {
    return InkWell(
      child: Container(
        height: 32,
        width: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.whoSuitsMeAnswer.isTrue
              ? getColor().blue37DColor
              : getColor().white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: widget.whoSuitsMeAnswer.isTrue
            ? Image.asset(
                DImages.questionCheck,
                color: getColor().white,
                width: 18,
                height: 18,
              )
            : null,
      ),
      onTap: () {
        if (widget.isEdit) {
          if (widget.answerController!.text.length >= MIN_LENGTH) {
            eventBus.fire(WhoSuitMeAnswerEvent(
                questionIndex: widget.questionIndex,
                answerIndex: widget.answerIndex,
                isTrue: !widget.whoSuitsMeAnswer.isTrue));
          } else {
            showToast(Strings.answerError.localize(context));
          }
        }
      },
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
