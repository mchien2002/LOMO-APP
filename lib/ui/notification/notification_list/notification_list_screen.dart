import 'dart:ui' as ui show PlaceholderAlignment;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/notification_item.dart';
import 'package:lomo/data/api/models/notification_type.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/notification_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_list_state.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/notification/notification_list/notification_list_model.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/ui/widget/selected_popup_widget.dart';
import 'package:lomo/ui/widget/shimmers/listview_shimmer.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/date_time_utils.dart';
import 'package:lomo/util/navigator_service.dart';
import 'package:lomo/util/platform_channel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationListScreen();
}

class _NotificationListScreen extends BaseListState<NotificationItem,
        NotificationListModel, NotificationListScreen>
    with
        AutomaticKeepAliveClientMixin<NotificationListScreen>,
        HandleNotificationMixin {
  @override
  void initState() {
    super.initState();
    model.init();
  }

  @override
  Widget get buildLoadingView => ListviewShimmer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: _titleAppbar(),
        actions: [
          _rightAction(),
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          super.buildContent(),
        ],
      ),
    );
  }

  Widget _titleAppbar() {
    return StreamBuilder<NotificationType>(
        initialData: model.listNotificationType[0],
        stream: model.notificationTypeSubject.stream,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SelectedPopupWidget(
                      listItems: model.listNotificationType,
                      initItem: snapshot.data,
                      selectedItem: (item) {
                        model.notificationTypeSubject.sink.add(item);
                        model.idType = item.id ?? null;
                        model.refresh();
                      },
                    );
                  });
            },
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: snapshot.data!.name!.localize(context) + " ",
                      style: textTheme(context).text18Bold.colorDart),
                  WidgetSpan(
                      alignment: ui.PlaceholderAlignment.middle,
                      child: Image.asset(
                        DImages.iconDropdown,
                        width: 18,
                        height: 18,
                        color: getColor().violetFBColor,
                      )),
                ]),
              ),
            ),
          );
        });
  }

  Widget _rightAction() {
    return ValueListenableProvider.value(
      value: model.notificationRepository.badgeNotification,
      child: Consumer<int>(
        builder: (context, numBagde, child) => IconButton(
          iconSize: 32,
          padding: EdgeInsets.only(right: 16),
          icon: Image.asset(
            DImages.check,
            color: numBagde > 0 ? getColor().primaryColor : getColor().black,
            width: 32,
            height: 32,
          ),
          onPressed: () async {
            model.readAllNotification();
          },
        ),
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, NotificationItem item, int index) {
    return InkWell(
      onTap: () {
        model.readNotification(item);
        handleNotification(item);
      },
      child: Container(
        color: item.isRead!
            ? getColor().white
            : getColor().colorPrimary.withOpacity(0.1),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: _buildItemDetail(item, index),
          ),
          secondaryActions: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: IconSlideAction(
                caption: Strings.delete.localize(context),
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  model.deleteNotification(item.id!, item.isRead!, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetail(NotificationItem item, int index) {
    if (item.type == model.listNotificationType[3].id) {
      return _accountNotification(item, index);
    } else if (item.type == model.listNotificationType[4].id) {
      return _postActivityNotification(item);
    } else if (item.type == model.listNotificationType[5].id) {
      return _bearAndCandyNotification(item);
    } else if (item.type == model.listNotificationType[2].id) {
      return _accountNotification(item, index);
    } else {
      return _systemNotification(item);
    }
  }

  Widget _readHtmlView(NotificationItem item) {
    return HtmlView(
      htmlData: item.title,
      onTapUrl: (url) async {
        if (url == "name") {
          User user = await model.getUserDetailData(item);
          model.readNotification(item);
          if (!user.isMe)
            Navigator.pushNamed(context, Routes.profile,
                arguments: UserInfoAgrument(user));
        }
      },
    );
  }

  Widget _systemNotification(NotificationItem item) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: Image.asset(
            DImages.notiSystem,
            height: 40,
            width: 40,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.title != "" && item.title != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _readHtmlView(item),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
                ),
              if (item.title != "" && item.title != null)
                SizedBox(
                  height: 3,
                ),
              Text(
                readTimeStampBySecond(item.createdAt!, context),
                style: textTheme(context).text12.colorGrayTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _postActivityNotification(NotificationItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            User user = await model.getUserDetailData(item);
            model.readNotification(item);
            if (!user.isMe)
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
          },
          child: Padding(
            padding: EdgeInsets.only(top: 3),
            child: CircleNetworkImage(
              size: Dimens.spacing40,
              url: item.sender!.avatar,
              placeholder: Image.asset(
                DImages.avatarDefault,
                height: Dimens.spacing40,
                width: Dimens.spacing40,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.title != "" && item.title != null) _readHtmlView(item),
              if (item.title != "" && item.title != null)
                SizedBox(
                  height: 3,
                ),
              Text(
                readTimeStampBySecond(item.createdAt!, context),
                style: textTheme(context).text12.colorGrayTime,
              ),
            ],
          ),
        ),
        if (item.image != null)
          Padding(
            padding: EdgeInsets.only(left: 10, top: 5.0),
            child: RoundNetworkImage(
              width: 35,
              height: 54,
              url: item.image,
              radius: 3,
            ),
          ),
      ],
    );
  }

  Widget _bearAndCandyNotification(NotificationItem item) {
    double widthItemIg = (40 / 375) * MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            User user = await model.getUserDetailData(item);
            model.readNotification(item);

            if (!user.isMe)
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
          },
          child: Padding(
            padding: EdgeInsets.only(top: 3),
            child: _getAvatarAccount(item),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.title != "" && item.title != null) _readHtmlView(item),
              if (item.title != "" && item.title != null)
                SizedBox(
                  height: 3,
                ),
              Text(
                readTimeStampBySecond(item.createdAt!, context),
                style: textTheme(context).text12.colorGrayTime,
              ),
            ],
          ),
        ),
        if (item.notify == model.listNotifyDetail[8].id)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ClipRRect(
              child: RoundNetworkImage(
                width: widthItemIg - 4,
                height: widthItemIg - 4,
                url: item.image,
                boxFit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  Widget _accountNotification(NotificationItem item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            User user = await model.getUserDetailData(item);
            model.readNotification(item);

            if (!user.isMe)
              Navigator.pushNamed(context, Routes.profile,
                  arguments: UserInfoAgrument(user));
          },
          child: Padding(
            padding: EdgeInsets.only(top: 3),
            child: _getAvatarAccount(item),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.title != "" && item.title != null) _readHtmlView(item),
              if (item.title != "" && item.title != null)
                SizedBox(
                  height: 3,
                ),
              Text(
                readTimeStampBySecond(item.createdAt!, context),
                style: textTheme(context).text12.colorGrayTime,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            accountClickAction(item, index);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: getColor().colorVioletEB,
            ),
            child: Text(
              getTextOfAccount(item.notify!),
              style: textTheme(context).text12.bold.colorViolet,
            ),
          ),
        ),
      ],
    );
  }

  String getTextOfAccount(String text) {
    if (text == model.listNotifyDetail[11].id) {
      return Strings.btn_follow.localize(context);
    } else if (text == model.listNotifyDetail[12].id ||
        text == model.listNotifyDetail[18].id ||
        text == model.listNotifyDetail[19].id) {
      return Strings.sendMessage.localize(context);
    } else if (text == model.listNotifyDetail[13].id) {
      return Strings.unBlock.localize(context);
    } else {
      return Strings.contact.localize(context);
    }
  }

  void accountClickAction(NotificationItem item, int index) async {
    if (item.notify == model.listNotifyDetail[11].id) {
      await model.userRepository.followUser(
        User(
          id: item.sender!.id,
          netAloId: item.sender!.netAloId,
          name: item.sender!.name,
          avatar: item.sender!.avatar,
        ),
      );
      if (model.progressState == ProgressState.success) {
        showToast(Strings.followSuccess.localize(context));
        model.deleteNotification(item.id!, item.isRead!, index);
      } else {
        showToast(model.errorMessage!.localize(context));
      }
    } else if (item.notify == model.listNotifyDetail[12].id ||
        item.notify == model.listNotifyDetail[18].id ||
        item.notify == model.listNotifyDetail[19].id) {
      model.readNotification(item);
      await model.openChat(item.sender!.id!);
    } else {
      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: Strings.info.localize(context),
          queryParameters: {'subject': ''});
      launch(_emailLaunchUri.toString());
    }
  }

  Widget _getAvatarAccount(NotificationItem item) {
    if (item.notify == model.listNotifyDetail[11].id ||
        item.notify == model.listNotifyDetail[12].id ||
        item.notify == model.listNotifyDetail[13].id ||
        item.notify == model.listNotifyDetail[6].id ||
        item.notify == model.listNotifyDetail[7].id ||
        item.notify == model.listNotifyDetail[18].id ||
        item.notify == model.listNotifyDetail[19].id) {
      return InkWell(
        onTap: () async {
          model.readNotification(item);
          User user = await model.getUserDetailData(item);

          if (!user.isMe)
            Navigator.pushNamed(context, Routes.profile,
                arguments: UserInfoAgrument(user));
        },
        child: CircleNetworkImage(
          size: Dimens.spacing40,
          url: item.sender!.avatar,
          placeholder: Image.asset(
            DImages.avatarDefault,
            height: 40,
            width: 40,
          ),
        ),
      );
    } else if (item.notify == model.listNotifyDetail[8].id) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Image.asset(
          DImages.notiGift,
          width: 40,
          height: 40,
        ),
        decoration: BoxDecoration(
          color: getColor().white,
          borderRadius: BorderRadius.circular(30),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Image.asset(
          DImages.logo,
          height: 20,
          width: 20,
        ),
        decoration: BoxDecoration(
          color: getColor().white,
          borderRadius: BorderRadius.circular(30),
        ),
      );
    }
  }

  @override
  Widget buildSeparator(BuildContext context, int index) {
    return Divider(
      height: 1,
      color: getColor().white,
    );
  }

  @override
  EdgeInsets get padding => EdgeInsets.only(bottom: 10);

  @override
  bool get wantKeepAlive => true;
}

mixin HandleNotificationMixin {
  bool isVideoContent(NewFeed item) {
    return item.images?.isNotEmpty == true &&
        item.images?[0].type == Constants.TYPE_VIDEO;
  }

  handleNotification(NotificationItem notification) async {
    var navigator = locator<NavigationService>();
    locator<NotificationRepository>().readNotification(notification.id!);
    if (notification.notify == NOTIFICATION_NOTIFY_DETAIL[8].id) {
      if (notification.opt?.code?.isNotEmpty == true) {
        navigator.navigateTo(
          Routes.voucherDetail,
          arguments: notification,
        );
      } else {
        navigator.navigateTo(Routes.profileCandy);
      }
    } else if ([
      NOTIFICATION_NOTIFY_DETAIL[6].id,
      // NOTIFICATION_NOTIFY_DETAIL[7].id,
      NOTIFICATION_NOTIFY_DETAIL[9].id,
      NOTIFICATION_NOTIFY_DETAIL[10].id
    ].contains(notification.notify)) {
      navigator.navigateTo(Routes.profileCandy);
    } else if ([
      NOTIFICATION_NOTIFY_DETAIL[3].id,
      NOTIFICATION_NOTIFY_DETAIL[4].id,
      NOTIFICATION_NOTIFY_DETAIL[5].id,
      NOTIFICATION_NOTIFY_DETAIL[17].id
    ].contains(notification.notify)) {
      var newFeed =
          await locator<UserRepository>().getDetailPost(notification.post!);

      if (isVideoContent(newFeed)) {
        navigator.navigateTo(
          Routes.postVideoDetail,
          arguments: PostDetailAgrument(newFeed),
        );
      } else {
        navigator.navigateTo(
          Routes.postDetail,
          arguments: PostDetailAgrument(newFeed),
        );
      }
    } else if (NOTIFICATION_NOTIFY_DETAIL[18].id == notification.notify) {
      if (notification.quiz != null && notification.sender?.id != null) {
        final historyQuizDetail = await locator<UserRepository>()
            .getHistoryQuizDetail(notification.quiz!, notification.sender!.id!);
        navigator.navigateTo(
          Routes.reviewQuizResultScreen,
          arguments: historyQuizDetail,
        );
      }
    } else if (NOTIFICATION_NOTIFY_DETAIL[19].id == notification.notify) {
      User user = await locator<UserRepository>()
          .getUserDetail(notification.sender!.id!);
      if (!user.isEnoughNetAloBasicInfo) {
        return;
      }
      locator<PlatformChannel>()
          .openChatWithUser(locator<UserModel>().user!, user);
    }
    // else if (NOTIFICATION_NOTIFY_DETAIL[20].id == notification.notify) {
    //   navigator.navigateTo(
    //     Routes.whoSuitsMeProfile,
    //     arguments: 1,
    //   );
    // }
    else if (LIST_NOTIFICATION_DATA_TYPE[1].id == notification.type) {
      navigator.navigateTo(Routes.notificationDetail, arguments: notification);
    } else if ([
      NOTIFICATION_NOTIFY_DETAIL[20].id,
      NOTIFICATION_NOTIFY_DETAIL[21].id
    ].contains(notification.notify)) {
      navigator.navigateTo(Routes.profileCandy);
    }
  }
}
