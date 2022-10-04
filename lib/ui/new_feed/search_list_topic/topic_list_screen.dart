import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/new_feed/search_list_topic/topic_list_model.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

class TopicListScreen extends StatefulWidget {
  final Function(List<TopictItem>)? onTopicsSelected;
  final List<TopictItem>? topics;

  TopicListScreen({this.topics, this.onTopicsSelected});

  @override
  State<StatefulWidget> createState() => _TopicListScreen();
}

class _TopicListScreen
    extends BaseGridState<TopictItem, TopicListModel, TopicListScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.topics!);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      isFull: false,
      contentWidget: _content(),
      left: _leftWidget(),
      right: _rightWidget(),
      appbarColor: DColors.whiteColor,
      title: Strings.topic.localize(context),
      subTitle: _subTitle(),
      appbarHeight: 65.0,
      titleStyle: textTheme(context).text19.bold.colorDart,
      isRadius: true,
    );
  }

  Widget _subTitle() {
    return ValueListenableProvider.value(
        value: model.totalCountInfo,
        child: Consumer<int>(
            builder: (context, totalCount, child) => Text(
                "($totalCount/${model.limit})",
                style: textTheme(context).text13.darkTextColor)));
  }

  Widget _content() {
    return Column(
      children: [
        SizedBox(
          height: Dimens.spacing15,
        ),
        Container(
          padding:
              EdgeInsets.only(left: Dimens.spacing16, right: Dimens.spacing16),
          child: SearchBarWidget(
            autoFocus: false,
            hint: Strings.search_on_lomo.localize(context),
            onTextChanged: (text) {
              model.textSearch = text;
              model.refresh();
            },
          ),
        ),
        SizedBox(
          height: Dimens.spacing20,
        ),
        Expanded(
          child: buildContent(),
        )
      ],
    );
  }

  Widget _leftWidget() {
    return InkWell(
      child: Icon(
        Icons.close,
        size: Dimens.size32,
        color: getColor().colorDart,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _rightWidget() {
    return ValueListenableProvider.value(
      value: model.validatedInfo,
      child: Consumer<bool>(
          builder: (context, isValidate, child) => InkWell(
                child: Text(
                  Strings.done.localize(context),
                  style: isValidate
                      ? textTheme(context).text14Bold.colorPrimary
                      : textTheme(context).text14Bold.colorGray,
                ),
                onTap: () async {
                  if (model.totalCountInfo.value > 0) {
                    var data = model.listSelected();
                    widget.onTopicsSelected!(data);
                    Navigator.of(context).pop();
                  }
                },
              )),
    );
  }

  @override
  Widget buildItem(BuildContext context, TopictItem item, int index) {
    return InkWell(
      onTap: () {
        var checked = !item.check;
        model.changeValue(index, checked);
      },
      child: Container(
        margin: EdgeInsets.all(!item.check ? 0 : 1),
        decoration: BoxDecoration(
            color: !item.check ? getColor().white : getColor().f3eefcColor,
            border: Border(
              top: BorderSide(
                width: 1.0,
                color:
                    !item.check ? getColor().pinkF2F5Color : getColor().white,
              ),
              left: BorderSide(
                width: 0.5,
                color:
                    !item.check ? getColor().pinkF2F5Color : getColor().white,
              ),
              right: BorderSide(
                width: 0.5,
                color:
                    !item.check ? getColor().pinkF2F5Color : getColor().white,
              ),
              bottom: model.items.length == 1 || model.items.length == 2
                  ? BorderSide(
                      width: 1,
                      color: !item.check
                          ? getColor().pinkF2F5Color
                          : getColor().white,
                    )
                  : index == model.items.length - 1 ||
                          index == model.items.length - 2
                      ? BorderSide(
                          width: 1,
                          color: !item.check
                              ? getColor().pinkF2F5Color
                              : getColor().white,
                        )
                      : BorderSide(
                          width: 0,
                          color: getColor().white,
                        ),
            )),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: Dimens.size12,
              ),
              RoundNetworkImage(
                width: Dimens.size32,
                height: Dimens.size32,
                url: item.image,
                radius: 4,
              ),
              SizedBox(
                width: Dimens.size12,
              ),
              Expanded(
                child: Text(
                  item.name!,
                  style: !item.check
                      ? textTheme(context).text15.bold.darkTextColor
                      : textTheme(context).text15.bold.colorPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: Dimens.size10,
              ),
              Container(
                width: 18,
                height: 18,
                child: !item.check ? _iconUnCheck() : _iconCheck(),
              ),
              SizedBox(
                width: Dimens.size12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconCheck() {
    return Container(
      height: Dimens.size18,
      width: Dimens.size18,
      child: Image.asset(DImages.checked),
    );
  }

  Widget _iconUnCheck() {
    return Container(
      height: Dimens.size18,
      width: Dimens.size18,
    );
  }

  @override
  double get childAspectRatio => 187 / 60;
  @override
  double get rangeLoadMore => 200;
  @override
  bool get autoLoadData => true;
}
