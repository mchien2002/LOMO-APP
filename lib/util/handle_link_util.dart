import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/dating/who_suits_me/reply_question/reply_question_screen.dart';
import 'package:lomo/ui/dating/who_suits_me/result_quiz_dialog.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/webview/webview_screen.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_utils.dart';
import 'constants.dart';
import 'navigator_service.dart';
import 'platform_channel.dart';

class HandleLinkUtil {
  final oldDomainShare = "https://netalomo.vn";
  bool isRegisterListenerDeepLink = false;
  ValueNotifier<String?> linkData = ValueNotifier(null);

  addListenerExecuteDeepLink(BuildContext context) {
    if (!isRegisterListenerDeepLink) {
      isRegisterListenerDeepLink = true;
      linkData.addListener(() {
        executeDeepLink(context);
      });
    }
  }

  executeDeepLink(BuildContext context) async {
    try {
      if (linkData.value == null) return;
      final data = linkData.value;
      await handleLinkApp(data,
          context: context, source: LinkSourceType.deepLink);
      //remove data after use
      linkData.value = null;
    } catch (e) {
      print(e);
    }
  }

  openLink(String url, {LinkSourceType? source}) {
    if (containDomainShare(url)) {
      handleLinkApp(url, source: source);
    } else
      launch(url);
  }

  bool containDomainShare(String url) {
    return url.contains(getLinkDomainShare()) || url.contains(oldDomainShare);
  }

  bool containHostShare(String url) {
    return url.contains(getHostShare()) || url.contains("netalomo.vn");
  }

  handleLinkApp(String? url,
      {LinkSourceType? source, BuildContext? context}) async {
    // showToast("handle:${linkData.value}");
    if (url?.isNotEmpty == true) {
      if (containHostShare(url!)) {
        if (url.contains("/post/")) {
          await getPostFromUrl(url, source: source, context: context);
        } else if (url.contains("/user/")) {
          await getProfileFromUrl(url, source: source, context: context);
        } else if (url.contains("/quiz/")) {
          await getQuizFromUrl(url, source: source, context: context);
        } else if (url.contains("/gift/")) {
          await getGiftFromUrl(url, source: source, context: context);
        } else {
          launch(url);
        }
      } else {
        launch(url);
      }
    }
  }

  getPostFromUrl(String url,
      {LinkSourceType? source, BuildContext? context}) async {
    final newFeedId = url.substring(url.lastIndexOf("/") + 1);
    var newFeed = await locator<UserRepository>().getDetailPost(newFeedId);
    navigateToPage(
      context,
      Routes.postDetail,
      arguments: PostDetailAgrument(newFeed),
    );
    if (source == LinkSourceType.netAlo &&
        locator<AppModel>().appConfig?.officialLomo == newFeed.user?.id) {
      locator<TrackingManager>()
          .trackClickLinkLomoShareFromNetAloChat(newFeedId);
    }
  }

  getProfileFromUrl(String url,
      {LinkSourceType? source, BuildContext? context}) async {
    final userId = url.substring(url.lastIndexOf("/") + 1);
    var user = await locator<UserRepository>().getUserDetail(userId);
    navigateToPage(
      context,
      Routes.profile,
      arguments: UserInfoAgrument(user),
    );
  }

  // get post of event gift
  getGiftFromUrl(String url,
      {LinkSourceType? source, BuildContext? context}) async {
    // quà của vqmm link: https://netalomo.vn/share/vi/gift/613fab97f2085bc09a646137/123
    // quà của lomo link: https://netalomo.vn/share/vi/gift/613fab97f2085bc09a646137
    final giftSuffix = url.split("/gift/")[1];
    final arr = giftSuffix.split("/");
    if (arr.length == 2) {
      final newFeedId = arr[1];
      final newFeed = await locator<UserRepository>().getDetailPost(newFeedId);
      navigateToPage(
        context,
        Routes.postDetail,
        arguments: PostDetailAgrument(newFeed),
      );
    } else {
      final giftId = arr[0];
      if (giftId == "promotion") {
        navigateToPage(context, Routes.profileCandy);
      } else {
        final gift = await locator<CommonRepository>().getGiftDetail(giftId);
        navigateToPage(context, Routes.exchangeGiftScreen, arguments: gift);
      }
    }
  }

  getQuizFromUrl(String url,
      {LinkSourceType? source, BuildContext? context}) async {
    final userId = url.substring(url.lastIndexOf("/") + 1);
    // nếu lỗi 404 tức là bộ câu hỏi quiz chưa được tạo
    // percent !=null là đã trả lời câu hỏi
    // còn lại là chưa trả lời
    if (userId == locator<UserModel>().user?.id) {
      navigateToPage(
        context,
        Routes.whoSuitsMeProfile,
      );
    } else
      Future.wait([
        locator<UserRepository>().getUserDetail(userId),
        locator<UserRepository>().getWhoSuitsMeQuestions(userId)
      ]).then((value) {
        try {
          User user = value[0] as User;
          WhoSuitsMeQuestionGroup questionGroup =
              value[1] as WhoSuitsMeQuestionGroup;
          if (questionGroup.percent != null) {
            showModalBottomSheet(
                backgroundColor: getColor().transparent,
                context: context ??
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState!
                        .context,
                isScrollControlled: true,
                enableDrag: false,
                builder: (context) => ResultQuizDialog(
                      user: user,
                      percent: questionGroup.percent!,
                    ));
          } else {
            navigateToPage(
              context,
              Routes.relyWhoSuitsMeQuestion,
              arguments: RelyQuestionArgument(user: user),
            );
          }
          readQuiz(userId);
        } catch (error) {
          print(error);
        }
      }).onError((error, stackTrace) {
        print(error);
      });
  }

  navigateToPage(BuildContext? context, String route, {Object? arguments}) {
    if (context != null) {
      Navigator.pushNamed(context, route, arguments: arguments);
    } else {
      locator<NavigationService>().navigateTo(route, arguments: arguments);
    }
  }

  readQuiz(String userId) async {
    try {
      locator<UserRepository>().readQuiz(userId);
    } catch (e) {
      print(e);
    }
  }

  String getLinkDomain() {
    String baseUrl;
    // init api
    switch (locator<AppModel>().env) {
      case Environment.prod:
        baseUrl = BASE_URL_PROD;
        break;
      case Environment.staging:
        baseUrl = BASE_URL_STA;
        break;
      case Environment.dev:
        baseUrl = BASE_URL_DEV;
        break;
    }

    return baseUrl;
  }

  String getLinkDomainShare() {
    String baseUrl;
    // init api
    switch (locator<AppModel>().env) {
      case Environment.prod:
        baseUrl = WEB_DOMAIN;
        break;
      case Environment.staging:
        baseUrl = BASE_URL_STA;
        break;
      case Environment.dev:
        baseUrl = BASE_URL_DEV;
        break;
    }

    return baseUrl;
  }

  String getHostShare() {
    return Uri.parse(getLinkDomainShare()).host;
  }

  shareNewFeed(String? newFeedId) async {
    if (newFeedId != null) {
      final language = locator<AppModel>().locale.languageCode;
      final shareSuccess = await locator<PlatformChannel>()
          .share(getLinkDomainShare() + "/share/$language/post/" + newFeedId);
      if (shareSuccess) {
        locator<CommonRepository>().sharePost(newFeedId);
      }
    }
  }

  shareProfile(String userId) {
    final language = locator<AppModel>().locale.languageCode;
    shareLink(getLinkDomainShare() + "/share/$language/user/" + userId);
  }

  shareReferral(String userId) {
    final language = locator<AppModel>().locale.languageCode;
    shareLink(getLinkDomainShare() + "/share/$language/referral/" + userId);
  }

  getShareReferral(String userId) {
    final language = locator<AppModel>().locale.languageCode;
    return getLinkDomainShare() + "/share/$language/referral/" + userId;
  }

  shareQuiz(String userId) {
    final language = locator<AppModel>().locale.languageCode;
    shareLink(getLinkDomainShare() + "/share/$language/quiz/" + userId);
  }

  shareGift(String giftId) {
    final language = locator<AppModel>().locale.languageCode;
    shareLink(getLinkDomainShare() + "/share/$language/gift/" + giftId);
  }

  shareGiftBadge() {
    final language = locator<AppModel>().locale.languageCode;
    shareLink(getLinkDomainShare() + "/share/$language/gift/" + "promotion");
  }

  openEvent() {
    final appConfig = locator<AppModel>().appConfig;
    final url = appConfig?.eventUrl ?? "";
    final hasUpdate = appConfig?.isUpdateApp ?? false;
    final forceUpdate = appConfig?.isForceUpdate ?? false;
    final user = locator<UserModel>().user;
    locator<NavigationService>().navigateTo(
      Routes.webView,
      arguments: WebViewArguments(
          url:
              "$url?token=${user?.netAloToken}&isFollowOfficial=${user?.isFollowOfficial}&isFollowSupport=${user?.isFollowSupport}&time=${DateTime.now().millisecondsSinceEpoch}&hasUpdate=$hasUpdate&forceUpdate=$forceUpdate",
          showFullPage: true),
    );
  }

  openLinkDiscoveryEvent(
      String? link, BuildContext context, BaseState state) async {
    if (link == "checkIn") {
      Navigator.pushNamed(context, Routes.profileCandy);
    } else if (link?.startsWith("postDetail:") == true) {
      state.showLoading();
      final postId = link!.replaceFirst("postDetail:", "");
      NewFeed? newFeed;
      try {
        newFeed = await locator<UserRepository>().getDetailPost(postId);
      } catch (e) {}
      state.hideLoading();
      if (newFeed != null)
        Navigator.pushNamed(context, Routes.postDetail,
            arguments: PostDetailAgrument(newFeed));
    } else if (link?.contains("linkType=browserDevice") == true) {
      try {
        launchAction(link!, forceWebView: false, enableJavaScript: true);
      } catch (e) {}
    } else if (link?.contains("linkType=browser") == true) {
      try {
        launchAction(link!, forceWebView: true, enableJavaScript: true);
      } catch (e) {}
    } else if (link == "event") {
      locator<HandleLinkUtil>().openEvent();
    } else
      Navigator.pushNamed(context, Routes.webView,
          arguments: WebViewArguments(url: link ?? ""));
  }
}
