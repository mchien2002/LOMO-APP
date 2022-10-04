import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/discovery/list_type_discovery/list_type_discovery_screen.dart';
import 'package:lomo/ui/widget/user_info_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/handle_link_util.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:lomo/util/text_util.dart';

class HtmlView extends StatelessWidget {
  HtmlView({
    this.htmlData,
    this.textStyle,
    this.onTapUrl,
  });

  final String? htmlData;
  final TextStyle? textStyle;
  final Function(String)? onTapUrl;

  @override
  Widget build(BuildContext context) {
    return htmlData?.isNotEmpty == true
        ? HtmlWidget(
            htmlData!,
            onTapUrl: (url) {
              if (onTapUrl != null) onTapUrl!(url);
              return true;
            },
            textStyle: textStyle ?? textTheme(context).text16.colorDart,
            webView: true,
            customStylesBuilder: (e) {
              switch (e.className) {
                case 'ql-align-left':
                  return {'text-align': 'left'};
                case 'ql-align-center':
                  return {'text-align': 'center'};
                case 'ql-align-right':
                  return {'text-align': 'right'};
                case 'bold-16':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '16px', 'fontFamily': 'Google Sans', 'color': '#000000'};
                case 'underline-blue-16':
                  return {'text-decoration': 'underline', 'font-weight': 'normal', 'font-size': '16px', 'fontFamily': 'Google Sans', 'color': '#0084F4'};
                case 'underline-blue-14':
                  return {'text-decoration': 'underline', 'font-weight': 'normal', 'font-size': '14px', 'fontFamily': 'Google Sans', 'color': '#0084F4'};
                case 'normal-14-white':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '14px', 'fontFamily': 'Google Sans', 'color': '#ffffff'};
                case 'normal-14-black':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '14px', 'fontFamily': 'Google Sans', 'color': '#000000'};
                case 'normal-14-violet':
                  return {'text-decoration': 'none', 'font-size': '14px', 'fontFamily': 'Google Sans', 'color': '#9c5aff'};
                case 'normal-13-violet':
                  return {'text-decoration': 'none', 'font-size': '13px', 'fontFamily': 'Google Sans', 'color': '#9c5aff'};
                case 'normal-13-white':
                  return {'text-decoration': 'none', 'font-size': '13px', 'fontFamily': 'Google Sans', 'color': '#ffffff'};
                case 'normal-13-black':
                  return {'text-decoration': 'none', 'font-size': '13px', 'fontFamily': 'Google Sans', 'color': '#000000'};
                case 'bold-13-violet':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '13px', 'font-style': 'normal', 'fontFamily': 'Google Sans', 'color': '#5425a7'};
                case 'bold-13-black':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '13px', 'font-style': 'normal', 'fontFamily': 'Google Sans', 'color': '#000000'};
                case 'bold-13-white':
                  return {'text-decoration': 'none', 'font-weight': 'bold', 'font-size': '13px', 'font-style': 'normal', 'fontFamily': 'Google Sans', 'color': '#ffffff'};
              }
              switch (e.localName) {
                case 'p':
                  return {'text-align': 'justify'};
              }
              return null;
            },
          )
        : Text("");
  }
}

enum CssStyleClass {
  ql_align_left,
  ql_align_center,
  ql_align_right,
  bold_16,
  underline_blue_16,
  underline_blue_14,
  normal_14_white,
  normal_14_black,
  normal_14_violet,
  normal_13_violet,
  normal_13_white,
  normal_13_black,
  bold_13_violet,
  bold_13_black,
  bold_13_white
}

extension CssStyleClassExt on CssStyleClass {
  String get name {
    switch (this) {
      case CssStyleClass.ql_align_left:
        return "ql-align-left";
      case CssStyleClass.ql_align_center:
        return "ql-align-center";
      case CssStyleClass.ql_align_right:
        return "ql-align-right";
      case CssStyleClass.bold_16:
        return "bold-16";
      case CssStyleClass.underline_blue_16:
        return "underline-blue-16";
      case CssStyleClass.normal_14_white:
        return "normal-14-white";
      case CssStyleClass.normal_14_black:
        return "normal-14-black";
      case CssStyleClass.normal_14_violet:
        return "normal-14-violet";
      case CssStyleClass.normal_13_violet:
        return "normal-13-violet";
      case CssStyleClass.normal_13_white:
        return "normal-13-white";
      case CssStyleClass.normal_13_black:
        return "normal-13-black";
      case CssStyleClass.bold_13_violet:
        return "bold-13-violet";
      case CssStyleClass.underline_blue_14:
        return "underline-blue-14";
      case CssStyleClass.bold_13_black:
        return "bold-13-black";
      case CssStyleClass.bold_13_white:
        return "bold-13-white";
    }
  }
}

class HtmlViewContent extends StatelessWidget {
  final String? content;
  final TextStyle? textStyle;
  final CssStyleClass? cssTagHtmlClass;
  final CssStyleClass? cssHashTagHtmlClass;
  final List<User>? tags;
  final List<String>? hashtags;
  final User? personBeingAnswered;
  final int? minLengthContent;
  final bool? isViewMore;
  final bool isShowContentLink;

  HtmlViewContent({
    this.content,
    this.tags,
    this.hashtags,
    this.personBeingAnswered,
    this.textStyle,
    this.cssTagHtmlClass,
    this.cssHashTagHtmlClass,
    this.minLengthContent = 150,
    this.isViewMore = false,
    this.isShowContentLink = true,
  });

  String? buildHtmlContent(String? editContent) => generateHtmlContent(
        editContent,
        tags: tags,
        hashtags: hashtags,
        personBeingAnswered: personBeingAnswered,
        cssTagHtmlClass: cssTagHtmlClass,
        cssHashTagHtmlClass: cssHashTagHtmlClass,
        isShowContentLink: isShowContentLink,
      );

  @override
  Widget build(BuildContext context) {
    String editContent = content?.isNotEmpty == true
        ? (content!.length > minLengthContent!) && !isViewMore!
            ? getSubContent(content!, minLengthContent!)
            : content!
        : "";
    return HtmlView(
      htmlData: buildHtmlContent(editContent),
      textStyle: textStyle ?? textTheme(context).text13.colorDart,
      onTapUrl: (url) async {
        if (url.isNotEmpty == true) {
          if (url.contains("http")) {
            locator<HandleLinkUtil>().openLink(url);
          } else
            switch (url.substring(0, 1)) {
              case '@':
                try {
                  final user = await locator<UserRepository>().getUserDetail(url.substring(1, url.length));
                  if (!user.isMe) Navigator.pushNamed(context, Routes.profile, arguments: UserInfoAgrument(user));
                } catch (e) {}
                break;
              case '#':
                try {
                  var title = "#" + url.substring(1, url.length);
                  var argument = TypeDiscoverAgrument(title, [FilterRequestItem(key: "hashtags", value: url.substring(1, url.length))]);
                  Navigator.pushNamed(context, Routes.typeDiscovery, arguments: argument);
                } catch (e) {
                  print(e);
                }
                break;
            }
        }
      },
    );
  }
}

class HtmlViewNewFeed extends HtmlViewContent {
  final NewFeed newFeed;
  final TextStyle? textStyle;
  final CssStyleClass? cssTagHtmlClass;
  final CssStyleClass? cssHashTagHtmlClass;
  final int minLengthContent;
  final bool? isViewMore;

  HtmlViewNewFeed({
    required this.newFeed,
    this.textStyle,
    this.cssTagHtmlClass,
    this.cssHashTagHtmlClass,
    this.minLengthContent = 120,
    this.isViewMore = false,
  }) : super(
            content: replaceEnterCharacterInTextForHtml(newFeed.content),
            tags: newFeed.tags,
            hashtags: newFeed.hashtags,
            personBeingAnswered: null,
            cssTagHtmlClass: cssTagHtmlClass,
            cssHashTagHtmlClass: cssHashTagHtmlClass!,
            isViewMore: isViewMore);
}

class HtmlViewComments extends StatelessWidget {
  final Comments comments;
  final TextStyle? textStyle;
  final CssStyleClass? cssTagHtmlClass;
  final CssStyleClass? cssHashTagHtmlClass;

  HtmlViewComments({
    required this.comments,
    this.textStyle,
    this.cssTagHtmlClass,
    this.cssHashTagHtmlClass,
  });

  @override
  Widget build(BuildContext context) {
    return (comments.content?.isNotEmpty == true && comments.content!.length > 150) ? _buildShowMoreContent(context) : _buildNormalContent(context);
  }

  Widget _buildShowMoreContent(BuildContext context) {
    return ExpandableNotifier(
      // <-- Provides ExpandableController to its children
      child: Column(
        children: [
          Expandable(
            // <-- Driven by ExpandableController from ExpandableNotifier
            collapsed: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCollapsedContent(context),
                ExpandableButton(
                  // <-- Expands when tapped on the cover photo
                  child: Text(
                    Strings.viewMore.localize(context),
                    textAlign: TextAlign.end,
                    style: textTheme(context).text12.colorHint,
                  ),
                )
              ],
            ),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildExpandedContent(context),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExpandableButton(
                      // <-- Collapses when tapped on
                      child: Text(
                        Strings.collapse.localize(context),
                        textAlign: TextAlign.end,
                        style: textTheme(context).text12.colorHint.medium,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 17,
                      color: getColor().textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context) {
    return HtmlViewContent(
        content: comments.content,
        tags: comments.tags,
        hashtags: comments.hashtags,
        personBeingAnswered: comments.reply,
        cssTagHtmlClass: cssTagHtmlClass,
        cssHashTagHtmlClass: cssHashTagHtmlClass);
  }

  Widget _buildCollapsedContent(BuildContext context) {
    // content!.substring(0, minLengthContent) + " ..."
    return HtmlViewContent(
        content: comments.content!.substring(0, 150) + " ...",
        tags: comments.tags,
        hashtags: comments.hashtags,
        personBeingAnswered: comments.reply,
        cssTagHtmlClass: cssTagHtmlClass,
        cssHashTagHtmlClass: cssHashTagHtmlClass,
        isViewMore: true);
  }

  Widget _buildExpandedContent(BuildContext context) {
    return HtmlViewContent(
        content: comments.content,
        tags: comments.tags,
        hashtags: comments.hashtags,
        personBeingAnswered: comments.reply,
        cssTagHtmlClass: cssTagHtmlClass,
        cssHashTagHtmlClass: cssHashTagHtmlClass,
        isViewMore: true);
  }
}
