import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/who_suits_me_answer.dart';
import 'package:lomo/data/api/models/who_suits_me_answers.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/constants.dart';
import 'package:provider/provider.dart';

class ReplyQuestionItemWidget extends StatefulWidget {
  ReplyQuestionItemWidget(
      {required this.question, required this.cancelQuestion});

  final WhoSuitsMeQuestion question;
  final Function(WhoSuitsMeAnswers) cancelQuestion;

  @override
  _ReplyQuestionItemWidgetState createState() =>
      _ReplyQuestionItemWidgetState();
}

class _ReplyQuestionItemWidgetState extends State<ReplyQuestionItemWidget> {
  ValueNotifier<Object?> rebuildItem = ValueNotifier(null);
  late int itemSelected = 0;
  late Timer _timer;
  int _startTime = 2;
  int _startTimeNewPage = 4;
  int _startTimeAnimation = 0;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: rebuildItem,
      child: Consumer<Object?>(builder: (context, reset, child) {
        return Expanded(
          child: ListView.builder(
              itemCount: widget.question.answers.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    //_buildBaseRow(widget.question.answers[index]),
                    if (widget.question.answers[index].status ==
                        WhoSuitsMeAnswerStatus.init)
                      _buildNoneSelectedRow(widget.question.answers[index])
                    else if (widget.question.answers[index].status ==
                        WhoSuitsMeAnswerStatus.check)
                      _buildSelectedFirstRow(widget.question.answers[index])
                    else
                      _buildSelectedVerifyRow(widget.question.answers[index]),
                    SizedBox(
                      height: Dimens.size32,
                    ),
                  ],
                );
              }),
        );
      }),
    );
  }

  Widget _buildSelectedVerifyRow(WhoSuitsMeAnswer answer) {
    return answer.isTrue == true
        ? _buildSelectedRightRow(answer)
        : _buildSelectedWrongRow(answer);
  }

  Widget _buildSelectedFirstRow(WhoSuitsMeAnswer? answer) {
    return Stack(
      children: [
        _baseRowReplyItem(getColor().pink693Color, answer!,
            textTheme(context).text18.bold.colorWhite),
        Container(
          padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: getColor().violet,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: getColor().violet, width: 1),
          ),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  readOnly: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                    hintText: "${answer.name ?? ""}",
                    counterText: "",
                    hintStyle: textTheme(context).text18.bold.colorWhite,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLength: 10,
                  maxLines: 2,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.top,
                  style: textTheme(context).text15.babbceColor,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              AnimatedCrossFade(
                firstChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  color: getColor().transparent,
                ),
                secondChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  color: getColor().transparent,
                ),
                crossFadeState: CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedWrongRow(WhoSuitsMeAnswer answer) {
    return Stack(
      children: [
        _baseRowReplyItem(getColor().colorRedE5597a, answer,
            textTheme(context).text18.bold.colorWhite),
        Container(
          padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: getColor().colorRedFf6388,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: getColor().colorRedFf6388, width: 1),
          ),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  readOnly: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                    hintText: "${answer.name ?? ""}",
                    counterText: "",
                    hintStyle: textTheme(context).text18.bold.colorWhite,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLength: 10,
                  maxLines: 2,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.top,
                  style: textTheme(context).text15.babbceColor,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              AnimatedCrossFade(
                firstChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  color: getColor().transparent,
                ),
                secondChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: getColor().white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getColor().transparent),
                  ),
                  child: Image.asset(
                    DImages.checkWrongQuiz,
                    width: Dimens.size25,
                    height: Dimens.size25,
                  ),
                ),
                crossFadeState:
                    flag ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedRightRow(WhoSuitsMeAnswer answer) {
    return Stack(
      children: [
        _baseRowReplyItem(getColor().colorBlue28bb, answer,
            textTheme(context).text18.bold.colorWhite),
        Container(
          padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: getColor().colorBlue2cd1,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: getColor().colorBlue2cd1, width: 1),
          ),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  readOnly: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                    hintText: "${answer.name ?? ""}",
                    counterText: "",
                    hintStyle: textTheme(context).text18.bold.colorWhite,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLength: 10,
                  maxLines: 2,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.top,
                  style: textTheme(context).text15.babbceColor,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              AnimatedCrossFade(
                firstChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  color: getColor().transparent,
                ),
                secondChild: Container(
                  height: Dimens.size32,
                  width: Dimens.size32,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: getColor().white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getColor().transparent),
                  ),
                  child: Image.asset(
                    DImages.checkRightQuiz,
                    width: Dimens.size25,
                    height: Dimens.size25,
                  ),
                ),
                crossFadeState:
                    flag ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void event(WhoSuitsMeAnswer answer) {
    if (itemSelected == 0) {
      answer.status = WhoSuitsMeAnswerStatus.check;
      onPressedItem(answer);
      // check time change UI
      timeForChangeProgress(answer);
      //
      itemSelected++;
      //
      // //check time callback
      timeForCancelQuestion(answer);
      //
      // // animation
      timeForAnimation();
    }
  }

  Widget _buildNoneSelectedRow(WhoSuitsMeAnswer answer) {
    return InkWell(
        onTap: () {
          event(answer);
        },
        splashColor: Colors.transparent,
        child: Stack(
          children: [
            _baseRowReplyItem(getColor().gray2eaColor, answer,
                textTheme(context).text18.colorDart),
            Container(
              padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: getColor().white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: getColor().gray2eaColor, width: 1),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: FocusScope(
                      child: Focus(
                        onFocusChange: (focus) => event(answer),
                        child: TextField(
                          readOnly: true,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                            hintText: "${answer.name ?? ""}",
                            counterText: "",
                            hintStyle: textTheme(context).text18.colorDart,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          maxLength: 10,
                          maxLines: 2,
                          minLines: 1,
                          textAlignVertical: TextAlignVertical.top,
                          style: textTheme(context).text15.babbceColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(
                      height: Dimens.size32,
                      width: Dimens.size32,
                      color: getColor().transparent,
                    ),
                    secondChild: Container(
                      height: Dimens.size32,
                      width: Dimens.size32,
                      color: getColor().transparent,
                    ),
                    crossFadeState: CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  timeForAnimation() {
    _startTimeAnimation = 500;
    _timer = new Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_startTimeAnimation == 0) {
        setState(() {
          flag = !flag;
        });
        timer.cancel();
      } else {
        _startTimeAnimation = _startTimeAnimation - 100;
      }
    });
  }

  timeForChangeProgress(WhoSuitsMeAnswer answer) {
    _startTime = 500;
    _timer = new Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_startTime == 0) {
        answer.status = WhoSuitsMeAnswerStatus.verify;
        onPressedItem(answer);
        timer.cancel();
      } else {
        _startTime = _startTime - 100;
      }
    });
  }

  timeForCancelQuestion(WhoSuitsMeAnswer answer) {
    _startTimeNewPage = 1700;
    _timer = new Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_startTimeNewPage == 0) {
        widget.cancelQuestion(WhoSuitsMeAnswers(
            idQuestion: widget.question.id, idAnswer: answer.id));
        timer.cancel();
      } else {
        _startTimeNewPage = _startTimeNewPage - 100;
      }
    });
  }

  onPressedItem(WhoSuitsMeAnswer answer) {
    rebuildItem.value = Object();
  }

  Widget _baseRowReplyItem(
      Color? color, WhoSuitsMeAnswer answer, TextStyle? hintStyle) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        padding: EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                  hintText: "${answer.name ?? ""}",
                  counterText: "",
                  hintStyle: hintStyle ?? textTheme(context).text18.colorTran,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                maxLines: 2,
                minLines: 1,
                textAlignVertical: TextAlignVertical.top,
                style: textTheme(context).text15.babbceColor,
              ),
            ),
            SizedBox(
              width: 6,
            ),
            AnimatedCrossFade(
              firstChild: Container(
                height: Dimens.size32,
                width: Dimens.size32,
                color: getColor().transparent,
              ),
              secondChild: Container(
                height: Dimens.size32,
                width: Dimens.size32,
                color: getColor().transparent,
              ),
              crossFadeState: CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
