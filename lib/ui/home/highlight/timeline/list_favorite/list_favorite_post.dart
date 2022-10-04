import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/widget/follow_user_check_box.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'favorite_post_model.dart';

class ListFavoritePost extends StatefulWidget {
  const ListFavoritePost({Key? key, required this.isPost}) : super(key: key);

  final String? isPost;
  @override
  _ListFavoritePostState createState() => _ListFavoritePostState();
}

class _ListFavoritePostState
    extends BaseListState<User, FavoritePostModel, ListFavoritePost>
    with AutomaticKeepAliveClientMixin<ListFavoritePost> {
  @override
  void initState() {
    super.initState();
    model.init(widget.isPost);
    model.loadData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return super.buildContent();
  }

  @override
  Widget buildItem(BuildContext context, User item, int index) {
    return _buildContent(context, item, index);
  }

  Widget _buildContent(BuildContext context, User item, int index) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: UserInfoWidget(
              item,
              titleStyle: textTheme(context).text16.darkTextColor.medium,
              widgetHeight: MediaQuery.of(context).size.width - 125,
            ),
          ),
          //Case xem chinh minh
          if (model.user.isMe)
            Visibility(
              visible: (model.user.isMe != item.isMe) && !item.isDeleted,
              child: FollowUserCheckBox(
                item,
                isUnfollowAction: !item.isMe,
                followedWidget: _buildMyFollowed(item),
              ),
            ),
          if (!model.user.isMe)
            FollowUserCheckBox(
              item,
              isUnfollowAction: false,
              followedWidget: _buildUserFollowed(item),
            ),
        ],
      ),
    );
  }

  Widget _buildUserFollowed(User user) {
    return InkWell(
      child: Image.asset(
        DImages.navigationRight,
        height: 36,
        width: 36,
      ),
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
        : Image.asset(
            DImages.unfollow,
            height: 36,
            width: 36,
          );
  }

  Color get dividerColor => getColor().pinkF2F5Color;

  @override
  double get itemSpacing => 1;

  @override
  bool get autoLoadData => false;
}
