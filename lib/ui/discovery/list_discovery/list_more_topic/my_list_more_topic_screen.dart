import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_grid_state.dart';
import 'package:lomo/ui/discovery/list_discovery/list_more_topic/my_list_more_topic_model.dart';

import '../../../widget/image_widget.dart';

class MyListMoreTopicScreen extends StatefulWidget {
  final MyListMoreTopicArguments arguments;

  MyListMoreTopicScreen(this.arguments);
  @override
  State<MyListMoreTopicScreen> createState() => _MyListMoreTopicScreenState();
}

class _MyListMoreTopicScreenState extends BaseGridState<TopictItem,
    MyListMoreTopicModel, MyListMoreTopicScreen> {
  double paddingC = 16;
  double spaceItem = 11;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor().pinkF2F5Color,
      appBar: AppBar(
        backgroundColor: getColor().white,
        elevation: 0,
        title: Text(widget.arguments.title.localize(context),
            style: textTheme(context).text20.colorDart.bold),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
      ),
      body: buildContent(),
    );
  }

  @override
  void initState() {
    super.initState();
    // LOAD DATA CHO TOPIC ITEM
    model.init(widget.arguments.getData);
    model.loadData();
  }

  @override
  Widget buildItem(BuildContext context, TopictItem item, int index) {
    double widthItem =
        (MediaQuery.of(context).size.width - 2 * paddingC - spaceItem) / 2;
    double heightItem = widthItem * childAspectRatio;
    return InkWell(
        onTap: () {},
        child: Container(
          height: heightItem,
          width: widthItem,
          decoration: BoxDecoration(
              color: getColor().black4B,
              borderRadius: BorderRadius.circular(Dimens.spacing10)),
          child: Stack(
            children: [
              item.imageLocal != null
                  ? ClipRRect(
                      child: Image.asset(
                        item.imageLocal!,
                        height: heightItem,
                        width: widthItem,
                      ),
                    )
                  : RoundNetworkImage(
                      height: heightItem,
                      width: widthItem,
                      url: item.image ?? '',
                      radius: Dimens.spacing8,
                      boxFit: BoxFit.cover,
                    ),
            ],
          ),
        ));
  }

  @override
  EdgeInsets get paddingGrid =>
      EdgeInsets.symmetric(horizontal: paddingC, vertical: paddingC);
  @override
  double get childAspectRatio => 166 / 97;
  @override
  bool get autoLoadData => false;
  @override
  double get mainAxisSpacing => spaceItem;
  @override
  double get crossAxisSpacing => spaceItem;
}

class MyListMoreTopicArguments {
  final Future<List<TopictItem>> Function(int page, int pageSize) getData;
  final String title;
  MyListMoreTopicArguments(this.title, this.getData);
}
