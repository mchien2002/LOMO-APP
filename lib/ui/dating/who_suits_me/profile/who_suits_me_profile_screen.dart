import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/profile/who_suits_me_profile_model.dart';
import 'package:lomo/ui/widget/tabbar_widget.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:provider/provider.dart';

import 'history/who_suits_me_history_screen.dart';
import 'my_question/my_question_screen.dart';
import 'result/who_suits_me_result_screen.dart';

class WhoSuitsMeProfileScreen extends StatefulWidget {
  final int index;

  WhoSuitsMeProfileScreen({this.index = 0});

  @override
  State<StatefulWidget> createState() => _WhoSuitsMeProfileScreenState();
}

class _WhoSuitsMeProfileScreenState
    extends BaseState<WhoSuitsMeProfileModel, WhoSuitsMeProfileScreen>
    with SingleTickerProviderStateMixin {
  static const TAB_QUESTION = 0;
  static const TAB_RESULT = 1;
  static const TAB_HISTORY = 2;
  final List<DTabItem> tabs = [
    DTabItem(
      id: TAB_QUESTION,
      title: Strings.myQuestion,
    ),
    DTabItem(
      id: TAB_RESULT,
      title: Strings.result,
    ),
    DTabItem(
      id: TAB_HISTORY,
      title: Strings.history,
    )
  ];

  @override
  void initState() {
    super.initState();
    model.tabController =
        TabController(vsync: this, length: 3, initialIndex: widget.index);
    model.tabController.addListener(() {
      model.onTabChanged(model.tabController.index);
    });
  }

  @override
  Widget buildContentView(BuildContext context, WhoSuitsMeProfileModel model) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _grayLine(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: DTabBar(
                tabController: model.tabController,
                isScrollable: false,
                labelColor: getColor().darkTextColor,
                unselectedLabelColor: getColor().b6b6cbColor,
                textStyleSelected: textTheme(context).text15.bold.darkTextColor,
                textStyleUnSelected: textTheme(context).text13.bold.b6b6cbColor,
                paddingBottom: 8.0,
                items: tabs),
          ),
          _grayLine(),
          Expanded(
              child: TabBarView(
            //physics: const NeverScrollableScrollPhysics(),
            controller: model.tabController,
            children:
                tabs.map((item) => _getTabPage(tabs.indexOf(item))).toList(),
          )),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Padding(
        padding: EdgeInsets.only(
          left: 16,
        ),
        child: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: Dimens.size24,
            color: getColor().colorDart,
          ),
        ),
      ),
      elevation: 0,
      centerTitle: true,
      title: Text(
        Strings.whoSuitableMe.localize(context),
        style: textTheme(context).text18.bold.colorDart,
      ),
      actions: [_questionCountLayout()],
    );
  }

  Widget _questionCountLayout() {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 20),
        child: ChangeNotifierProvider.value(
          value: model,
          child: Consumer<WhoSuitsMeProfileModel>(
            builder: (context, myModel, child) =>
                myModel.shareQuestionValue.value
                    ? InkWell(
                        child: Text(
                          Strings.share.localize(context),
                          style: textTheme(context).text16.bold.colorPrimary,
                        ),
                        onTap: () {
                          locator<HandleLinkUtil>()
                              .shareQuiz(locator<UserModel>().user!.id!);
                        },
                      )
                    : SizedBox(
                        width: 0.0,
                        height: 0.0,
                      ),
          ),
        ));
  }

  Widget _grayLine() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 1.0,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: DColors.gray6ebColor),
      ),
    );
  }

  Widget _getTabPage(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return MyQuestionScreen(
          questionCountCalback: (questionCount) {
            model.setTotalQuestions(questionCount);
          },
        );
      case 1:
        return WhoSuitsMeResultScreen(
          user: locator<UserModel>().user!,
        );
      case 2:
        return WhoSuitsMeHistoryScreen(
          user: locator<UserModel>().user!,
        );
    }
    return MyQuestionScreen(questionCountCalback: (questionCount) {});
  }
}
