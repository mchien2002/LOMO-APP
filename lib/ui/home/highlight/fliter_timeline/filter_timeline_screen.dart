import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/home/highlight/fliter_timeline/filter_timeline_model.dart';
import 'package:lomo/ui/widget/button_widgets.dart';
import 'package:lomo/ui/widget/dating_filter/filter_range_widget.dart';
import 'package:lomo/ui/widget/filter_highlight/filter_sort_widget.dart';
import 'package:lomo/ui/widget/sogiesc_list_widget.dart';
import 'package:lomo/util/constants.dart';

class FilterTimelineScreen extends StatefulWidget {
  final GetQueryParam? postFilters;

  FilterTimelineScreen(this.postFilters);

  @override
  State<StatefulWidget> createState() => _FilterTimelineScreenState();
}

class _FilterTimelineScreenState
    extends BaseState<FilterTimelineModel, FilterTimelineScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.postFilters);
  }

  List<Literacy> selectedReportList = [];
  List<Zodiac> selectedReportZodiacList = [];

  @override
  Widget buildContentView(BuildContext context, FilterTimelineModel model) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          backgroundColor: getColor().white,
          elevation: 0,
          leading: InkWell(
            onTap: () async {
              Navigator.of(context).maybePop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: Dimens.size25,
              color: getColor().colorDart,
            ),
          ),
          title: Text(
            Strings.filter.localize(context),
            style: textTheme(context).text19.bold.colorDart.fontGoogleSans,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _buildContent(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: _buildButtonFooter(),
        ));
  }

  _buildContent() {
    return ListView(
      children: [
        Divider(
          height: 2,
        ),
        // _buildSortWidget(),
        _buildPostTypeWidget(),
        Divider(
          thickness: 0.5,
        ),
        _buildDistanceWidget(),
        _buildSogiesc(),
      ],
    );
  }

  _buildSortWidget() {
    List<KeyValue> listSort = [
      KeyValue(
          id: FilterHighlight.newKey, name: Strings.latest.localize(context)),
      KeyValue(
          id: FilterHighlight.hotKey, name: Strings.hotTop.localize(context))
    ];

    return SizedBox(
      child: FilterSortWidget(
          model.getValueSort() == FilterHighlight.newKey
              ? listSort.first
              : listSort[1],
          listSort, (itemSort) {
        print("${itemSort.name}");
        model.setValueSort(itemSort.id!);
      }, Strings.sortBy.localize(context), model.resetFilter),
    );
  }

  _buildPostTypeWidget() {
    List<KeyValue> listSort = [
      KeyValue(
          id: FilterHighlight.forYouKey,
          name: Strings.forYou.localize(context)),
      KeyValue(
          id: FilterHighlight.followKey, name: Strings.forFan.localize(context))
    ];
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.size30, right: Dimens.size30),
      child: SizedBox(
        child: FilterSortWidget(
            model.getValuePostType() == false ? listSort.first : listSort[1],
            listSort, (itemPostType) {
          print("${itemPostType.name}");
          itemPostType.id == FilterHighlight.forYouKey
              ? model.setValuePostType(false)
              : model.setValuePostType(true);
        }, Strings.postType.localize(context), model.resetFilter),
      ),
    );
  }

  _buildDistanceWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.size30, right: Dimens.size30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimens.spacing20,
          ),
          Row(
            children: [
              Text(
                Strings.range.localize(context),
                style: textTheme(context).text13.bold.colorDart,
              ),
              Spacer(),
              Text(
                "> ${Strings.rangeLimit.localize(context)}",
                style: textTheme(context).text13.captionNormal.colorDart,
              ),
            ],
          ),
          SizedBox(
            height: Dimens.size5,
          ),
          FilterRangeWidget((data) {
            model.setValueDistance(data);
          }, model.resetFilter, model.getValueDistance()),
        ],
      ),
    );
  }

  Widget _buildSogiesc() {
    return Padding(
      padding: const EdgeInsets.only(left: Dimens.size30, right: Dimens.size30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimens.size20,
          ),
          Text(
            Strings.sogiescLabel.localize(context),
            style: textTheme(context).text13.bold.fontGoogleSans,
          ),
          SizedBox(
            height: Dimens.spacing16,
          ),
          SogiescListWidget(
            model.selectedGender,
            setSelectAll: model.setSelectAllSogiesc,
            initSogiescSelected: model.selectedSogiescList,
            onSogiescSelected: (sogiesc) {
              print('${sogiesc!.length}');
              model.setValueListSogiesc(sogiesc);
            },
          ),
          SizedBox(
            height: Dimens.spacing10,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonFooter() {
    return SizedBox(
      height: Dimens.size100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: Dimens.size5, left: Dimens.size20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: BorderButton(
                text: Strings.reset.localize(context),
                radius: Dimens.cornerRadius6,
                color: getColor().white,
                borderColor: getColor().colorPrimary,
                textStyle:
                    textTheme(context).text17.bold.colorPrimary.fontGoogleSans,
                onPressed: () {
                  model.resetData();
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: Dimens.size5, right: Dimens.size20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: BorderButton(
                  text: Strings.filterNow.localize(context),
                  radius: Dimens.cornerRadius6,
                  color: getColor().violet,
                  borderColor: getColor().colorPrimary,
                  textStyle:
                      textTheme(context).text17.bold.colorWhite.fontGoogleSans,
                  onPressed: () async {
                    locator<TrackingManager>().trackFilterFeed();
                    Navigator.pop(context, model.getResultFilter());
                  }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
