import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/filter_dating_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_snap_list_state.dart';
import 'package:lomo/ui/dating/dating_list/dating_list_item_screen.dart';
import 'package:lomo/ui/dating/dating_list/dating_list_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/empty/empty_filter_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:provider/provider.dart';

class DatingListScreen extends StatefulWidget {
  final ValueNotifier<dynamic> refreshData;

  DatingListScreen({required this.refreshData});

  @override
  State<StatefulWidget> createState() => _DatingListScreenState();
}

class _DatingListScreenState
    extends BaseSnapListState<User, DatingListModel, DatingListScreen>
    with AutomaticKeepAliveClientMixin<DatingListScreen> {
  late ScrollController gridController;

  @override
  void initState() {
    super.initState();
    model.init();
    gridController = new ScrollController()..addListener(_scrollGridListener);
    widget.refreshData.addListener(() {
      if (model.items.isNotEmpty == true) {
        if (controller.position.pixels == 0.0) {
          showRefreshIndicator();
        } else {
          jumpToTop();
        }
      }
    });
    eventBus.on<FilterDatingEvent>().listen((event) async {
      final result = await Navigator.pushNamed(context, Routes.datingFilter,
          arguments: model.filters);
      if (result != null) {
        model.filters = result as List<FilterRequestItem>?;
        model.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Divider(
          height: 1,
          color: DColors.pinkF2F5,
        ),
        Expanded(
          child: super.buildContent(),
        )
      ],
    );
  }

  @override
  Widget buildContentView(BuildContext context, DatingListModel model) {
    return Scaffold(
      backgroundColor: getColor().white,
      body: ChangeNotifierProvider.value(
        value: locator<UserModel>(),
        child: Consumer<UserModel>(
          builder: (context, userModel, child) =>
              userModel.user!.hasDatingProfile
                  ? model.isShowGrid
                      ? _buildGrid(context)
                      : super.buildContentView(context, model)
                  : _buildNoneProfileDating(),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return model.items.isNotEmpty
        ? RefreshIndicator(
            onRefresh: onRefresh,
            key: refreshIndicatorKey,
            child: GridView.count(
              crossAxisCount: 2,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              controller: gridController,
              scrollDirection: Axis.vertical,
              childAspectRatio: 165 / 213,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: model.items
                  .map((e) => _buildItemGrid(e, model.items.indexOf(e)))
                  .toList(),
            ),
          )
        : _buildEmpty(context);
  }

  Widget _buildItemGrid(User user, int index) {
    double itemWidth = (MediaQuery.of(context).size.width - 2 * 16 - 14) / 2;
    double itemHeight = itemWidth * 213 / 165;
    return SizedBox(
      height: itemHeight,
      width: itemWidth,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.datingUserDetail,
              arguments: user);
        },
        child: Material(
          elevation: 1,
          color: getColor().transparent,
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              RoundNetworkImage(
                width: itemWidth,
                height: itemHeight,
                url: user.datingImages![0].link,
                radius: 8,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  alignment: Alignment.bottomCenter,
                  height: 74,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [getColor().blackB3, getColor().transparent],
                      begin: const FractionalOffset(0.5, 1.0),
                      end: const FractionalOffset(0.5, 0.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name ?? "",
                        style: textTheme(context).text15.bold.colorWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (user.birthday != null)
                            Text(
                              "${getAgeFromDateTime(user.birthday!)} ${Strings.age.localize(context)}",
                              style: textTheme(context).text13.colorWhite,
                            ),
                          if (user.province != null)
                            Text(
                              ", ${user.province?.name ?? ""}",
                              style: textTheme(context).text13.colorWhite,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (user.datingImages![0].isVerify)
                Positioned(
                    top: 5,
                    right: 5,
                    child: Image.asset(
                      DImages.datingCheck,
                      height: 24,
                      width: 24,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, User user, int index) {
    return DatingListItemScreen(user);
  }

  Widget _buildNoneProfileDating() {
    double widthImageNoneProfileDating =
        MediaQuery.of(context).size.width * 200 / 375.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Strings.todayAlone.localize(context),
            style: textTheme(context).text22.bold.colorDart,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Strings.youAlreadyFindAHalf.localize(context),
            style: textTheme(context).text17.colorGray77,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Image.asset(
            DImages.noneProfileDating,
            width: widthImageNoneProfileDating,
            height: widthImageNoneProfileDating * 120 / 200.0,
          ),
          SizedBox(
            height: 50,
          ),
          PrimaryButton(
            text: Strings.createProfileDating.localize(context),
            onPressed: () {
              Navigator.pushNamed(
                  context, Routes.reviewInformationCreateDatingProfile);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget buildSeparator(BuildContext context, int index) {
    return SizedBox(
      height: 0,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get autoLoadData => locator<UserModel>().user!.hasDatingProfile;

  void _scrollGridListener() {
    print("${gridController.position.extentAfter}");
    if (gridController.position.extentAfter < rangeLoadMore) {
      model.loadMoreData();
    }
  }

  @override
  Widget buildEmptyView(BuildContext context) {
    return _buildEmpty(context);
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyFilterWidget(
      btnTitle: Strings.textBtnEmptyDating.localize(context),
      emptyImage: DImages.emptyDatingItem,
      message: Strings.emptyDatingText.localize(context),
      onClicked: () {
        eventBus.fire(FilterDatingEvent());
      },
    );
  }

  @override
  void dispose() {
    gridController.removeListener(_scrollGridListener);
    super.dispose();
  }
}
