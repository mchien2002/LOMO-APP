import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/base/dialog_widget.dart';
import 'package:lomo/ui/home/highlight/post_detail/post_detail_screen.dart';
import 'package:lomo/ui/update_information/update_info_non_require_screen.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/navigator_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewArguments {
  final String url;
  final bool isInApp;
  final bool showFullPage;

  WebViewArguments({required this.url, this.isInApp = false, this.showFullPage = false});
}

class WebViewScreen extends StatefulWidget {
  final WebViewArguments args;

  WebViewScreen(this.args);

  @override
  State<StatefulWidget> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late String urlEncoded;
  Widget? _loadingDialog;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    urlEncoded = Uri.encodeFull(widget.args.url);
    print(urlEncoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColor().white,
      body: widget.args.showFullPage
          ? _buildContent()
          : SafeArea(
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: WebView(
              onWebViewCreated: (WebViewController webViewController) {
                showLoading();
              },
              initialUrl: urlEncoded,
              allowsInlineMediaPlayback: true,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                return handleNavigation(request);
              },
              onPageFinished: (url) {
                hideLoading();
              },
            )),
          ],
        ),
        if (!widget.args.showFullPage)
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              height: 30,
              width: 30,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: getColor().blackB3,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<NavigationDecision> handleNavigation(NavigationRequest request) async {
    if (request.url.contains("webview_type")) {
      var params = Uri.parse(Uri.decodeFull(request.url)).queryParameters;
      switch (params["webview_type"]) {
        case WebViewType.sogiescTest:
          Navigator.pop(context);
          // handleSogiescTestRedirect(params);
          break;
        case WebViewType.report:
          if (params["data"] == "finish") {
            Navigator.pop(context);
          }
          break;
        case WebViewType.event:
          handleEventRedirect(params, request.url);
          break;
      }
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  handleSogiescTestRedirect(Map params) async {
    List<String> sogiescData;
    if (params["data"]!.contains(",")) {
      // var dec = Uri.decodeFull(params["data"]);
      sogiescData = params["data"]!.split(", ");
    } else {
      sogiescData = [params["data"]!];
    }
    for (int i = 0; i < sogiescData.length; i++) {
      if (sogiescData[i].contains("/")) {
        final sogiescSplitWithSplash = sogiescData[i].split("/");
        sogiescData.removeAt(i);
        sogiescData.addAll(sogiescSplitWithSplash);
      }
    }
    print(sogiescData);
    Navigator.pushReplacementNamed(
      context,
      Routes.updateNonRequireProfile,
      arguments: UpdateInfoNonRequireArguments(
        locator<UserModel>().user!,
        isUpdate: true,
        sogiescName: sogiescData,
      ),
    );
  }

  handleEventRedirect(Map params, String url) async {
    switch (params["data"]) {
      case "finish":
        Navigator.pop(context);
        break;
      case "share":
        if (locator<AppModel>().appConfig?.eventUrl.isNotEmpty == true && params["id"] != null) {
          shareLink(locator<AppModel>().appConfig!.eventUrl + "/" + params["id"]!);
        }
        break;
      case "checkin":
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.profileCandy);
        break;
      case "follow_fb_lomo":
        Navigator.pop(context);
        try {
          bool launched = await launch(
              Platform.isAndroid ? FACEBOOK_PROTOCOL_ANDROID_LINK : FACEBOOK_PROTOCOL_IOS_LINK,
              forceSafariVC: false);

          if (!launched) {
            await launch(FACEBOOK_FAN_PAGE_LINK, forceSafariVC: false);
          }
        } catch (e) {
          await launch(FACEBOOK_FAN_PAGE_LINK, forceSafariVC: false);
        }
        break;
      case "share_post":
        showLoading();
        final postId = params["id"];
        if (postId?.isNotEmpty == true) {
          var newFeed = await locator<UserRepository>().getDetailPost(postId!);
          hideLoading();
          Navigator.pop(context);
          locator<NavigationService>()
              .navigateTo(Routes.postDetail, arguments: PostDetailAgrument(newFeed));
          await Future.delayed(Duration(seconds: 1));
          locator<HandleLinkUtil>().shareNewFeed(postId);
        }
        break;
      case "follow":
        showLoading();
        final userId = params["id"];
        var user;
        if (userId?.isNotEmpty == true) {
          try {
            user = await locator<UserRepository>().getUserDetail(userId!);
          } catch (e) {}
        }
        hideLoading();
        if (user != null) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            Routes.profile,
            arguments: UserInfoAgrument(user),
          );
        }
        break;
      case "open_post":
        showLoading();
        final newFeedId = url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf("?"));
        var newFeed;
        try {
          newFeed = await locator<UserRepository>().getDetailPost(newFeedId);
        } catch (e) {}
        hideLoading();
        if (newFeed != null)
          Navigator.pushNamed(
            context,
            Routes.postDetail,
            arguments: PostDetailAgrument(newFeed),
          );
        break;
      case "update_app":
        navigateToStore();
        break;
      default:
        break;
    }
  }

  showLoading() {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) =>
              _loadingDialog ??
              Container(
                color: Colors.transparent,
              ));
    }
  }

  hideLoading() {
    if (_loadingDialog != null) {
      Navigator.pop(context);
      _loadingDialog = null;
    }
  }
}
