import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/who_suits_me_answers.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_item_model.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_item_widget.dart';

class ReplyQuestionItemScreen extends StatefulWidget {
  ReplyQuestionItemScreen(
      {required this.question, required this.cancelQuestion, required this.reportQuestion});

  final WhoSuitsMeQuestion question;
  final Function(WhoSuitsMeAnswers) cancelQuestion;
  final Function() reportQuestion;

  @override
  State<StatefulWidget> createState() => _ReplyQuestionItemScreenState();
}

class _ReplyQuestionItemScreenState
    extends BaseState<ReplyQuestionItemModel, ReplyQuestionItemScreen> {
  @override
  Widget buildContentView(BuildContext context, ReplyQuestionItemModel model) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: Dimens.size30, right: Dimens.size30, top: Dimens.size50),
      child: Column(
        children: [
          _buildQuestionTitle(widget.question.name),
          SizedBox(
            height: Dimens.size40,
          ),
          Visibility(
            visible: widget.question.answers.isNotEmpty,
            child: ReplyQuestionItemWidget(
              question: widget.question,
              cancelQuestion: (answer) {
                widget.cancelQuestion(answer);
              },
            ),
          ),
          SizedBox(
            height: Dimens.size20,
          ),
        ],
      ),
    ));
  }

  Widget _buildQuestionTitle(String? question) {
    return Center(
      child: Text(
        question ?? "",
        style: textTheme(context).text20.bold.ff514569Color,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ReplyItemScreen extends StatefulWidget {
  ReplyItemScreen({required this.question, required this.cancelQuestion});

  final WhoSuitsMeQuestion question;
  final Function(WhoSuitsMeAnswers) cancelQuestion;

  @override
  State<StatefulWidget> createState() => _ReplyQuestionItemScreenState();
}

class _ReplyItemScreenState
    extends BaseState<ReplyQuestionItemModel, ReplyItemScreen> {
  @override
  Widget buildContentView(BuildContext context, ReplyQuestionItemModel model) {
    return Container(
        height: 200,
        child: Column(
          children: [
            _buildQuestionTitle(widget.question.name),
            SizedBox(
              height: Dimens.size40,
            ),
            ReplyQuestionItemWidget(
              question: widget.question,
              cancelQuestion: (answer) {
                print("ket qua $answer");
                widget.cancelQuestion(answer);
              },
            ),
          ],
        ));
  }

  Widget _buildQuestionTitle(String? question) {
    return Center(
      child: Text(
        question ?? "",
        style: textTheme(context).text20.bold.colorDart,
        textAlign: TextAlign.center,
      ),
    );
  }
}
