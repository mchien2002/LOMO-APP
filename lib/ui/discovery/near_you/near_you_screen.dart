import 'package:flutter/material.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/discovery/near_you/near_you_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../di/locator.dart';
import '../../../res/strings.dart';
import '../../widget/item_descovery/item_list_user_hot.dart';
import '../list_discovery/list_hot_screen.dart';

class NearYouScreen extends StatefulWidget {
  final String title;

  NearYouScreen(this.title);

  @override
  State<StatefulWidget> createState() => _NearYouScreenstate();
}

class _NearYouScreenstate extends BaseState<NearYouModel, NearYouScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    model.checkGps();
    return ValueListenableProvider.value(
        value: model.hasGps,
        child: Consumer<bool>(
          builder: (context, hasGps, child) =>
              hasGps ? _buildGpsView() : _buildNotHaveGpsView(),
        ));
  }

  @override
  Widget buildContentView(BuildContext context, NearYouModel model) {
    return ValueListenableProvider.value(
      value: model.hasGps,
      child: Consumer<bool>(
        builder: (context, hasGps, child) => SizedBox(
          height: hasGps ? 200 : 90,
          child: buildContent(),
        ),
      ),
    );
  }

  Widget _buildNotHaveGpsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.title,
            style: textTheme(context).text15.bold.colorDart,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            Strings.pleaseEnableGps.localize(context),
            style: textTheme(context).text13.gray77,
          ),
          SizedBox(
            height: 10,
          ),
          RoundedButton(
            width: 100,
            height: 32,
            text: Strings.enable.localize(context),
            radius: 4,
            color: getColor().primaryColor,
            textStyle: textTheme(context).text13.bold.colorWhite,
            onPressed: () {
              locator<TrackingManager>().trackNearRequestLocationButton();
              model.requestGps();
            },
          )
        ],
      ),
    );
  }

  Widget _buildGpsView() {
    return ListHotScreen(
      title: widget.title,
      subTitleType: ListUserSubTitleType.distance,
      onRefresh: model.onRefresh,
      // getData: (page, pageSize) async => [],
      getData: (page, pageSize) => locator<UserRepository>()
          .getListNearUser(page: page, limit: pageSize),
      onViewMore: () {
        locator<TrackingManager>().trackNearViewMore();
      },
      noDataWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          Strings.noDataNearYou.localize(context),
          style: textTheme(context).text14.bold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      model.checkGps();
      model.onRefresh?.value = Object();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
