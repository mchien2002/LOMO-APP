import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/feeling.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_model.dart';
import 'package:lomo/ui/new_feed/create_new_feed/item/video_item.dart';
import 'package:lomo/ui/new_feed/search_list_topic/topic_list_screen.dart';
import 'package:lomo/ui/widget/dialog_widget.dart';
import 'package:lomo/ui/widget/flutter_mention/models.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/ui/widget/seo_intent_link_widget.dart';
import 'package:lomo/ui/widget/tag_user_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/location_manager.dart';
import 'package:provider/provider.dart';

import '../../../app/app_model.dart';

class CreateNewFeedScreen extends StatefulWidget {
  final CreateNewFeedAgrument? agrument;

  CreateNewFeedScreen({this.agrument});

  @override
  State<StatefulWidget> createState() => _CreateNewFeedScreenState();
}

class _CreateNewFeedScreenState
    extends BaseState<CreateNewFeedModel, CreateNewFeedScreen> {
  double imageWidth = 100;
  final contentMaxLength = 5000;
  final locationManager = locator<LocationManager>();

  @override
  void initState() {
    super.initState();
    if (widget.agrument != null) model.init(widget.agrument!);
  }

  @override
  Widget build(BuildContext context) {
    return super.buildContent();
  }

  @override
  Widget buildContentView(BuildContext context, CreateNewFeedModel model) {
    imageWidth = MediaQuery.of(context).size.width - Dimens.padding * 2;
    return Scaffold(
      appBar: _buildAppBar(),
      body: FooterLayout(
          child: Container(
              padding:
                  EdgeInsets.only(left: Dimens.padding, right: Dimens.padding),
              child: ListView(
                children: [
                  SizedBox(
                    height: Dimens.spacing20,
                  ),
                  _buildUser(),
                  SizedBox(
                    height: 10,
                  ),
                  ValueListenableProvider.value(
                    value: model.topicsValue,
                    child: Consumer<List<TopictItem>>(
                        builder: (context, topics, child) => Column(
                              children: [
                                if (topics.isNotEmpty) _topicLayout(topics),
                                if (topics.isNotEmpty)
                                  SizedBox(
                                    height: Dimens.spacing10,
                                  ),
                              ],
                            )),
                  ),
                  _buildContent(),
                  ValueListenableProvider.value(
                    value: model.shareLinkValue,
                    child: model.shareLinkValue.value
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              VerticalSeoIntentLinkWidget(
                                model.firstLinkInComment,
                                margin: EdgeInsets.only(bottom: 15),
                              )
                            ],
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ),
                  SizedBox(
                    height: Dimens.spacing20,
                  ),
                  ValueListenableProvider.value(
                    value: model.photosValue,
                    child: Consumer<List<PhotoInfo>>(
                      builder: (context, photos, child) => ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final item = photos[index];
                            return item.isVideo
                                ? _videoItem(item, index)
                                : _photoItem(item, index);
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
          footer: _bottomMenu()),
    );
  }

  Widget _bottomMenu() {
    return Container(
      height: 90,
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomImage(),
          if (locator<AppModel>().appConfig?.isVideo == true &&
              locator<UserModel>().user?.isVideo == true)
            _buildBottomVideo(),
          _buildBottomTopic()
        ],
      ),
    );
  }

  Widget _buildBottomImage() {
    return ValueListenableProvider.value(
      value: model.enableImageValue,
      child: Consumer<bool>(
          builder: (context, enable, child) => InkWell(
                onTap: () async {
                  if (enable) model.showPhotosPicker(context);
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        DImages.addPhoto,
                        color: enable
                            ? getColor().primaryColor
                            : DColors.gray84Color,
                      ),
                      onPressed: null,
                    ),
                    Text(
                      Strings.image.localize(context),
                      style: textTheme(context).text13.colorGray,
                    )
                  ],
                ),
              )),
    );
  }

  Widget _buildBottomVideo() {
    return ValueListenableProvider.value(
      value: model.enableVideoValue,
      child: Consumer<bool>(
        builder: (context, enable, child) => InkWell(
          onTap: () async {
            if (enable) {
              model.changeVideo = true;
              model.videoOnPlayPause();
              model.showVideos(context);
            }
          },
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  DImages.addVideo,
                  color: enable ? getColor().primaryColor : DColors.gray84Color,
                ),
                onPressed: null,
              ),
              Text(
                Strings.video.localize(context),
                style: textTheme(context).text13.colorGray,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTopic() {
    return InkWell(
      onTap: () {
        _showTopicView();
      },
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(DImages.addtag2),
            onPressed: null,
          ),
          Text(
            Strings.topic.localize(context),
            style: textTheme(context).text13.colorGray,
          )
        ],
      ),
    );
  }

  _showTopicView() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.96,
              //set this as you want
              maxChildSize: 0.96,
              //set this as you want
              minChildSize: 0.96,
              //set this as you want
              expand: false,
              builder: (context, scrollController) {
                return TopicListScreen(
                  topics: model.topicsValue.value != []
                      ? model.topicsValue.value
                      : [],
                  onTopicsSelected: (items) {
                    model.addTopics(items);
                  },
                ); //whatever you're returning, does not have to be a Container
              });
        });
  }

  Widget _buildCloseButtonAppBar() {
    return ValueListenableProvider.value(
      value: model.contentValue,
      child: Consumer<String>(
        builder: (context, newFeedContent, child) => WillPopScope(
            onWillPop: () async {
              if (newFeedContent != "") {
                showMenuCancel();
                return false;
              } else {
                return true;
              }
            },
            child: InkWell(
              child: Icon(
                Icons.close,
                color: getColor().colorDart,
                size: 30,
              ),
              onTap: () {
                newFeedContent == ""
                    ? Navigator.pop(context)
                    : showMenuCancel();
              },
            )),
      ),
    );
  }

  Widget _buildCreateOrUpdateNewFeedButton() {
    return InkWell(
      splashColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.spacing8,
          vertical: Dimens.spacing10,
        ),
        padding: EdgeInsets.all(Dimens.spacing8),
        child: ValueListenableProvider.value(
          value: model.validatedInfo,
          child: Consumer<bool>(
            builder: (context, enable, child) => Text(
              model.isEdit
                  ? Strings.update.localize(context)
                  : Strings.posting.localize(context),
              style: enable
                  ? textTheme(context).text14Bold.colorPrimary
                  : textTheme(context).text14Bold.colorHint,
            ),
          ),
        ),
      ),
      onTap: () async {
        if (model.validatedInfo.value) {
          callApi(callApiTask: () async {
            model.changeVideo = false;
            model.videoOnPlayPause();
            await model.createOrUpdateDataNewFeed(model.contentValue.value);
          }, onSuccess: () {
            showToast(model.isEdit
                ? Strings.updatePostSuccess.localize(context)
                : Strings.createPostSuccess.localize(context));
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context);
            });
          });
        }
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: getColor().white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: _buildCloseButtonAppBar(),
      title: Center(
        child: Text(
          Strings.createPost.localize(context),
          style: textTheme(context).text18.bold.colorDart,
        ),
      ),
      actions: [
        _buildCreateOrUpdateNewFeedButton(),
      ],
    );
  }

  showMenuCancel() {
    final items = [
      Strings.cancelPost.localize(context),
      Strings.continueEdit.localize(context)
    ];
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: getColor().white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimens.cornerRadius20)),
              ),
              child: SafeArea(
                child: SizedBox(
                  height: items.length < 7 ? items.length * 50.0 : 350.0,
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => InkWell(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text(
                                    items[index].localize(context),
                                    style: textTheme(context).subText.colorDart,
                                  ),
                                ),
                                if (index != items.length - 1)
                                  Divider(
                                    height: 1,
                                    color: getColor().colorDivider,
                                  )
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              if (index == 0) {
                                Navigator.pop(context);
                              }
                            },
                          )),
                ),
              ),
            ));
  }

  Widget _buildUser() {
    return Row(
      children: [
        CircleNetworkImage(
          size: Dimens.size40,
          url: model.user!.avatar,
          strokeWidth: 2,
          strokeColor: getColor().colorPrimary,
        ),
        SizedBox(
          width: Dimens.spacing12,
        ),
        Expanded(
            child: ValueListenableProvider.value(
          value: model.feelingValue,
          child: Consumer<Feeling?>(
            builder: (context, feeling, child) => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: model.user!.name,
                      style: textTheme(context).text15.bold.bold.colorDart),
                  if (feeling != null)
                    TextSpan(
                        text: Strings.isFeeling.localize(context) +
                            feeling.name!.localize(context).toLowerCase() +
                            " ",
                        style: textTheme(context).text16.colorDart),
                  if (feeling != null)
                    WidgetSpan(
                      child: Image.asset(
                        feeling.iconData!,
                        height: Dimens.size18,
                        width: Dimens.size18,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          ),
        )),
      ],
    );
  }

  Widget _topicLayout(List<TopictItem> items) {
    return Container(
      child: Row(
        children: [
          Image.asset(
            DImages.topicGroup,
            width: 24,
            height: 24,
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text(
              "${model.getTopicTitle(items)}",
              style: textTheme(context).text13.bold.colorPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Image.asset(
              DImages.editToProfile,
              width: 32,
              height: 32,
            ),
            onPressed: () {
              _showTopicView();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.cornerRadius6),
          color: getColor().backgroundSearch),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TagUserWidget(
            initTaggedUsers: model.usersTagged,
            minLines: 4,
            suggestionPosition: SuggestionPosition.Bottom,
            defaultText: model.contentValue.value,
            maxLines: 4,
            maxLength: contentMaxLength,
            textStyle: textTheme(context).text13.colorDart,
            tagStyle: textTheme(context).text13.colorPrimary,
            hashTagStyle: textTheme(context).text13.bold.colorDart,
            onUsersTaggedChanged: (usersTagged) {
              model.usersTagged = usersTagged;
            },
            onTextChanged: (text) {
              model.contentValue.value = text;
              model.isValidatedInfo();
              model.checkContentShareLink(text);
            },
          ),
          SizedBox(
            height: Dimens.spacing5,
          ),
          ValueListenableProvider.value(
            value: model.contentValue,
            child: Consumer<String>(
              builder: (context, content, child) => Text(
                "${content.length}/$contentMaxLength",
                style: textTheme(context).text11.colorHint,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _photoItem(PhotoInfo photo, int index) {
    return Container(
        constraints:
            new BoxConstraints(minHeight: 200, minWidth: double.infinity),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: photo.u8List != null
                    ? Image.memory(
                        photo.u8List!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                      )
                    : RoundNetworkImage(
                        radius: 6,
                        width: imageWidth,
                        height: photo.isVertical
                            ? imageWidth * 3 / 2
                            : imageWidth * 2 / 3,
                        url: photo.link,
                      )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: photo.u8List != null,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.only(left: 16, top: 5),
                          padding: EdgeInsets.only(
                              left: 5, right: 10, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: DColors.black3dDColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                DImages.editPhoto,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                Strings.edit.localize(context),
                                style: textTheme(context).text13.colorWhite,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          model.onEditPhoto(context, photo.u8List!, index);
                        },
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 5),
                    child: IconButton(
                        icon: Image.asset(
                          DImages.closeWhite,
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          model.deletePhotoOrVideo(index);
                        }),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _videoItem(PhotoInfo photo, int index) {
    return Container(
        constraints:
            new BoxConstraints(minHeight: 200, minWidth: double.infinity),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: VideoItem(photo.u8List, photo.link,
                    (videoController, isPlay) {
                  model.setVideoPlayer(videoController, isPlay);
                }, model.changeVideo)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: photo.u8List != null,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.only(left: 16, top: 5),
                          padding: EdgeInsets.only(
                              left: 5, right: 10, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: DColors.black3dDColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                DImages.editPhoto,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                Strings.edit.localize(context),
                                style: textTheme(context).text13.colorWhite,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          model.onEditVideo(context, photo.u8List!, index);
                        },
                      )),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 5),
                    child: IconButton(
                        icon: Image.asset(
                          DImages.closeWhite,
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          model.deletePhotoOrVideo(index);
                        }),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  showLoading({BuildContext? dialogContext}) {
    showDialog(
        barrierDismissible: false,
        context: dialogContext ?? context,
        builder: (_) => model.photosValue.value.length > 0
            ? ChangeNotifierProvider.value(
                value: model.percentUpload,
                child: StatefulBuilder(
                    builder: (context, state) => LoadingPercentDialogWidget(
                          title: Strings.dataUploading.localize(context),
                          percent: model.percentUpload,
                        )),
              )
            : LoadingWidget());
  }

  @override
  hideLoading({BuildContext? dialogContext}) {
    Navigator.pop(dialogContext ?? context);
  }
}

class CreateNewFeedAgrument {
  final NewFeed? newFeed;
  final String? linkShare;

  CreateNewFeedAgrument({this.newFeed, this.linkShare});
}
