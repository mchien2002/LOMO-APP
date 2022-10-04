import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/review/review_question_item.dart';
import 'package:lomo/ui/widget/circle_wave_widget.dart';
import 'package:provider/provider.dart';

import 'review_quiz_result_model.dart';

class ReviewQuizResultScreen extends StatefulWidget {
  ReviewQuizResultScreen({required this.result});

  final WhoSuitsMeHistory result;

  @override
  State<StatefulWidget> createState() => _ReviewQuizResultScreenState();
}

class _ReviewQuizResultScreenState
    extends BaseState<ReviewQuizResultModel, ReviewQuizResultScreen> {
  List<TextEditingController> _questionController = [];
  @override
  void initState() {
    super.initState();
    model.init(widget.result);
  }

  @override
  Widget buildContentView(BuildContext context, ReviewQuizResultModel model) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Divider(),
          SizedBox(
            height: Dimens.size25,
          ),
          Center(
            child: Text(
              Strings.youMatchWith.localize(context),
              style: textTheme(context).text20.colorDart,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: Dimens.size10,
          ),
          Center(
            child: Text(
              model.result.user?.name ?? "",
              style: textTheme(context).text20.bold.ff514569Color,
            ),
          ),
          SizedBox(
            height: Dimens.size25,
          ),
          Center(
            child: CircleWaveWidget(
              color: model.result.percent > 66
                  ? getColor().greenColor
                  : model.result.percent < 34
                      ? getColor().orangeColor
                      : getColor().pin88Color,
              text: "${model.result.percent}%",
              textStyle: textTheme(context).text24.bold.colorWhite,
              size: Dimens.size160,
            ),
          ),
          SizedBox(
            height: Dimens.size25,
          ),
          model.result.quiz!.questions.isNotEmpty == true
              ? ValueListenableProvider.value(
                  value: model.currentPageIndex,
                  child: Consumer<int>(
                    builder: (context, index, child) => Center(
                      child: Text(
                        "$index / ${model.result.quiz!.questions.length}",
                        style: textTheme(context).text18.colorDart,
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: Dimens.size20,
          ),
          buildPageView(context)
        ],
      ),
    );
  }

  Widget buildPageView(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
        child: PageView.builder(
            itemCount: model.result.quiz!.questions.length,
            allowImplicitScrolling: false,
            scrollDirection: Axis.horizontal,
            controller: model.controller,
            onPageChanged: (index) {
              model.currentPageIndex.value = index + 1;
            },
            itemBuilder: (BuildContext context, int index) {
              var item = model.result.quiz!.questions[index];
              _questionController.add(TextEditingController());
              _questionController[index].text = item.name;
              return SingleChildScrollView(
                child:
                    ReviewQuestionItem(item, index, _questionController[index]),
              );
            }),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: getColor().white,
      elevation: 0,
      title: Text(
        Strings.result_details.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: Dimens.size16),
            child: Image.asset(
              DImages.closex,
              color: Colors.black,
              width: Dimens.size32,
              height: Dimens.size32,
            ),
          ),
        )
      ],
    );
  }
}

class ReviewArgument {
  ReviewArgument({required this.result, required this.user});
  final User user;
  final WhoSuitsMeHistory result;
}
