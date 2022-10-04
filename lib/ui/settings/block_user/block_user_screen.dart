import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/settings/block_user/block_user_model.dart';
import 'package:lomo/ui/widget/icon_name_item_widegt.dart';
import 'package:lomo/ui/widget/image_widget.dart';

class BlockUserScreen extends StatefulWidget {
  final User user;

  const BlockUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BlockUserScreenState createState() => _BlockUserScreenState();
}

class _BlockUserScreenState
    extends BaseListState<User, BlockUserModel, BlockUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor().colorviolet6FB,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: getColor().colorDart,
            ),
          ),
        ),
        title: Text(
          Strings.blocklist.localize(context),
          style: textTheme(context).text18.semiBold.colorDart,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.size20,
          vertical: Dimens.size10,
        ),
        child: buildContent(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model.init(widget.user);
    model.loadData();
  }

  @override
  Widget buildItem(BuildContext context, User item, int index) {
    return BlockUserItem(item, () {
      // if (item.isMe) return;
      // Navigator.pushNamed(context, Routes.profile,
      //     arguments: UserInfoAgrument(item));
    }, () {
      model.unblock(item, index);
    });
  }

  @override
  double get itemSpacing => 10;

  @override
  bool get autoLoadData => false;
}

class BlockUserItem extends StatefulWidget {
  final Function()? selectedButton;
  final Function selectedItem;
  final User item;

  BlockUserItem(this.item, this.selectedItem, this.selectedButton);

  @override
  _BlockUserItemState createState() => _BlockUserItemState();
}

class _BlockUserItemState extends State<BlockUserItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        widget.selectedItem();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: IconNameItem(
          imageWidget: RoundNetworkImage(
            radius: 20,
            height: Dimens.size40,
            width: Dimens.size40,
            placeholder: DImages.logo,
            url: widget.item.avatar ?? "",
          ),
          textName: widget.item.name ?? "",
          widget: !widget.item.isMe
              ? Visibility(
                  visible: !widget.item.isFollow,
                  child: MaterialButton(
                      height: Dimens.size30,
                      color: getColor().violet008,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          Text(
                            Strings.unBlock.localize(context),
                            style: textTheme(context).text14Normal.colorPrimary,
                          ),
                        ],
                      ),
                      splashColor: Colors.red,
                      onPressed: () async {
                        if (widget.selectedButton != null) {
                          widget.selectedButton!();
                        }
                      }),
                )
              : Container(),
          onPressed: () {},
        ),
      ),
    );
  }
}
