import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/profile/person/person_follow/person_follow_model.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/search_bar_widget.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/constants.dart';

class PersonFollowScreen extends StatefulWidget {
  final User user;
  final FollowType type; //0 Nguoi theo doi,1 Dang theo doi
  PersonFollowScreen(this.user, this.type);

  @override
  _PersonFollowScreenState createState() => _PersonFollowScreenState();
}

class _PersonFollowScreenState
    extends BaseListState<User, PersonFollowModel, PersonFollowScreen>
    with AutomaticKeepAliveClientMixin<PersonFollowScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearch(),
        SizedBox(
          height: 15,
        ),
        Expanded(child: buildContent()),
      ],
    );
  }

  Widget buildSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: SearchBarWidget(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (text) {
          model.textSearch = text;
          model.refresh();
        },
        autoFocus: false,
        controller: searchController,
        hint: Strings.search_name.localize(context),
        onTextChanged: (text) async {
          model.textSearch = text;
          model.refresh();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    model.init(widget.user, widget.type);
    model.loadData();
  }

  @override
  Widget buildItem(BuildContext context, User item, int index) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: UserInfoWidget(
              item,
              titleStyle: textTheme(context).text15.medium.darkTextColor,
              widgetHeight: MediaQuery.of(context).size.width - 125,
            ),
          ),
          //Case xem chinh minh
          if (model.user.isMe)
            FollowUserCheckBox(
              item,
              isUnfollowAction: !item.isMe,
              followedWidget: _buildMyFollowed(item),
            ),
          if (!model.user.isMe)
            FollowUserCheckBox(
              item,
              followWidget: item.isMe ? SizedBox() : null,
              isUnfollowAction: false,
              followedWidget: _buildUserFollowed(item),
            ),
        ],
      ),
    );
  }

  Widget _buildUserFollowed(User user) {
    return InkWell(
      child: SizedBox(),
      onTap: () {
        Navigator.pushNamed(context, Routes.profile,
            arguments: UserInfoAgrument(user));
      },
    );
  }

  Widget _buildMyFollowed(User user) {
    return user.isMe
        ? InkWell(
            child: Image.asset(
              DImages.navigationRight,
              height: 36,
              width: 36,
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
            },
          )
        : Container();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  double get itemSpacing => 1;

  @override
  bool get autoLoadData => false;

  Color get dividerColor => getColor().pinkF2F5Color;
}
