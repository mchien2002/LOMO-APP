
import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/dating_list/dating_list_item_model.dart';
import 'package:lomo/ui/widget/bear/give_bear_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/photos_view_page.dart';
import 'package:lomo/ui/widget/say_hi_button.dart';
import 'package:lomo/ui/widget/who_suits_me_button.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:provider/provider.dart';

import '../user_dating_basic_info_widget.dart';

class DatingListItemScreen extends StatefulWidget {
  final User user;

  DatingListItemScreen(this.user);

  @override
  State<StatefulWidget> createState() => _DatingListItemScreenState();
}

class _DatingListItemScreenState
    extends BaseState<DatingListItemModel, DatingListItemScreen> {
  late double widthImageItem;
  final ratioImageItem = 390.0 / 300.0;

  @override
  void initState() {
    super.initState();
    model.init(widget.user);
  }

  @override
  Widget buildContentView(BuildContext context, DatingListItemModel model) {
    widthImageItem = MediaQuery.of(context).size.width * 300 / 375.0;
    return Container(
      color: getColor().white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: _buildImages(widget.user)),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserDatingBasicInfoWidget(
                  widget.user,
                  onUserInfoClicked: (user) async {
                    Navigator.pushNamed(context, Routes.datingUserDetail,
                        arguments: user);
                    locator<TrackingManager>()
                        .trackViewDatingProfileDetail(user.id!);
                  },
                  size: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildSogiesc(widget.user),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.quote ?? "",
                  style: textTheme(context).text13.colorDart,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 20,
                ),
                _buildBottomButton(widget.user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(User user) {
    return SizedBox(
      height: double.infinity,
      child: ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: user.datingImages?.length ?? 0,
        itemBuilder: (context, imageIndex) => Container(
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.cornerRadius10)),
          child: Material(
            elevation: 1,
            color: getColor().transparent,
            borderRadius: BorderRadius.circular(Dimens.cornerRadius10),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotosViewPage(
                          images:
                              user.datingImages?.map((e) => e.link!).toList(),
                          firstPage: imageIndex,
                          isDating: true,
                          user: user,
                          accessToken: model.accessToken,
                          onBlock: (){
                            callApi(callApiTask: () async {
                              await model.block(widget.user);
                              showToast(Strings.blockSuccess.localize(context));
                              Navigator.pop(context);
                            });
                          },

                        ),
                      ),
                    );
                  },
                  child:
                      user.datingImages?[imageIndex].u8List?.isNotEmpty == true
                          ? _buildLocalImage(user, imageIndex)
                          : _buildRemoteImage(user, imageIndex),
                ),
                if (user.datingImages?[imageIndex].isVerify == true)
                  Positioned(
                      top: 10,
                      right: 10,
                      child: Image.asset(
                        DImages.datingCheck,
                        height: 36,
                        width: 36,
                      ))
              ],
            ),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: 0,
        ),
      ),
    );
  }

  Widget _buildRemoteImage(User user, int imageIndex) {
    return RoundNetworkImage(
      height: double.infinity,
      width: widthImageItem,
      radius: Dimens.cornerRadius10,
      url: user.datingImages?[imageIndex].link ?? "",
    );
  }

  Widget _buildLocalImage(User user, int imageIndex) {
    final u8List = user.datingImages?[imageIndex].u8List;
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(Dimens.cornerRadius10),
      ),
      child: Image.memory(
        u8List!,
        height: double.infinity,
        width: widthImageItem,
      ),
    );
  }

  Widget _buildSogiesc(User user) {
    List<Widget> sogiescWigets = [
      Image.asset(
        DImages.sogiescList,
        height: 18,
        width: 18,
      )
    ];

    user.sogiescs?.forEach((element) {
      sogiescWigets.add(
        Text(
          user.sogiescs?.indexOf(element) != 0
              ? ", ${element.name}"
              : element.name ?? "",
          style: textTheme(context).text13.colorDart.medium,
        ),
      );
    });

    return Wrap(
      children: sogiescWigets,
      crossAxisAlignment: WrapCrossAlignment.center,
    );
  }

  Widget _buildBottomButton(User user) {
    return Row(
      children: [
        Expanded(child: SayHiButton(user)),
        SizedBox(
          width: Dimens.spacing10,
        ),
        Expanded(
          child: WhoSuitsMeButton(model.user),
        ),
        SizedBox(
          width: Dimens.spacing10,
        ),
        !model.user.isMe
            ? ChangeNotifierProvider.value(
                value: model,
                child: Consumer<DatingListItemModel>(
                    builder: (context, mModel, child) => Container(
                          width: Dimens.size44,
                          height: Dimens.size44,
                          child: GiveBearWidget(
                              model.user.id!, mModel.displaySentBear.value),
                        )),
              )
            : SizedBox(
                width: 0,
                height: 0,
              )
      ],
    );
  }
}
