import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/list_more_discovery/list_more_discovery_model.dart';
import 'package:lomo/ui/widget/empty_widget.dart';
import 'package:lomo/ui/widget/laze_load_scrollview_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/res/strings.dart';

class ListMoreDiscoveryArguments {
  final Future<List<User>> Function(int page, int pageSize) getUsers;
  final Widget Function(List<User>) childOfList;
  final String title;

  ListMoreDiscoveryArguments(this.title, this.getUsers, this.childOfList);
}

class ListMoreDiscoveryScreen extends StatefulWidget {
  final ListMoreDiscoveryArguments args;

  ListMoreDiscoveryScreen(this.args);

  @override
  _ListMoreDiscoveryScreenState createState() =>
      _ListMoreDiscoveryScreenState();
}

class _ListMoreDiscoveryScreenState
    extends BaseState<ListMoreDiscoveryModel, ListMoreDiscoveryScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ListMoreDiscoveryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    model.getListMore();
  }

  @override
  Widget buildContentView(BuildContext context, ListMoreDiscoveryModel model) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: getColor().white,
        automaticallyImplyLeading: false,
        title: Text(
          widget.args.title.localize(context),
          style: textTheme(context).text19.bold.colorDart,
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<User>>(
        stream: model.listStreamController.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data?.isNotEmpty == true
                  ? Stack(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        _bodyContent(snapshot.data!),
                        StreamBuilder(
                            initialData: false,
                            stream: model.streamLazyController.stream,
                            builder: (context, lazy) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Visibility(
                                  visible: lazy.hasData,
                                  child: LoadingWidget(
                                    radius: 15,
                                  ),
                                ),
                              );
                            }),
                      ],
                    )
                  : EmptyWidget()
              : Align(
                  alignment: Alignment.topCenter,
                  child: LoadingWidget(
                    radius: 15,
                  ),
                );
        },
      ),
    );
  }

  Widget _bodyContent(List<User> listItems) {
    return LazyLoadScrollView(
      scrollOffset: 500,
      onEndOfPage: model.getMore,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: getColor().textHint,
        onRefresh: refresh,
        child: widget.args.childOfList(listItems),
        // child: GridView.count(
        //   childAspectRatio: (widthList / 3) / (widthList / 3 / 0.65 + 50),
        //   scrollDirection: Axis.vertical,
        //   crossAxisCount: 3,
        //   padding: EdgeInsets.all(Dimens.spacing8),
        //   children: List.generate(listItems.length, (index) {
        //     if (widget.args.item.id == 0) {
        //       return UserLocationWidget(
        //         width: widthList / 3,
        //         height: widthList / (3 * 0.65),
        //         user: listItems[index],
        //       );
        //     } else if (widget.args.item.id == 1) {
        //       return UserFeelingWidget(
        //         width: widthList / 3,
        //         height: widthList / (3 * 0.65),
        //         user: listItems[index],
        //       );
        //     } else {
        //       return UserHotBearWidget(
        //         width: widthList / 3,
        //         height: widthList / (3 * 0.65),
        //         user: listItems[index],
        //       );
        //     }
        //   }),
        // ),
      ),
    );
  }

  Future<void> refresh() async {
    print('123123');
    model.refresh();
  }

  @override
  ListMoreDiscoveryModel createModel() {
    return ListMoreDiscoveryModel(widget.args.getUsers);
  }
}
