import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/profile/person/person_message/person_message_model.dart';
import 'package:lomo/ui/widget/icon_name_item_widegt.dart';
import 'package:lomo/ui/widget/image_widget.dart';

class PersonMessageArguments {
  User user;
  bool isHome;
  PersonMessageArguments(this.user, this.isHome);
}

class PersonMessageScreen extends StatefulWidget {
  final User user;

  const PersonMessageScreen({Key? key, required this.user}) : super(key: key);
  @override
  _PersonMessageScreenState createState() => _PersonMessageScreenState();
}

class _PersonMessageScreenState
    extends BaseListState<User, PersonMessageModel, PersonMessageScreen> {
  @override
  void initState() {
    super.initState();
    model.init(widget.user);
    model.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.friendLiked.localize(context),
          style: textTheme(context).text18.bold.colorDart,
        ),
        iconTheme: IconThemeData(color: getColor().colorDart),
        backgroundColor: getColor().white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.size20, vertical: Dimens.size10),
        child: buildContent(),
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, User item, int index) {
    // TODO: implement buildItem
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: IconNameItem(
        imageWidget: RoundNetworkImage(
          radius: 20,
          height: Dimens.size40,
          width: Dimens.size40,
          placeholder: DImages.logo,
          url: item.avatar ?? "",
        ),
        textName: item.name ?? "",
        widget: GestureDetector(
          onTap: () {},
          child: Container(
            height: Dimens.size30,
            width: Dimens.size30,
            child: Image.asset(DImages.message),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement itemSpacing
  double get itemSpacing => 1;
  @override
  // TODO: implement autoLoadData
  bool get autoLoadData => true;

  Color get dividerColor => getColor().pinkF2F5Color;
}
