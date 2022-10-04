import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';

String generateContent(String? content,
    {List<User>? tags, List<String>? hashtags, User? personBeingAnswered}) {
  if (content?.isNotEmpty == true) {
    String result = content.toString();
    tags?.forEach((tag) {
      result = result.replaceAll(
          '@${tag.id}', getTagNameHtmlFromTagId(tag.id!, tag.name!));
    });
    hashtags?.forEach((hashTag) {
      Pattern pattern = "#$hashTag\\W";
      Iterable<RegExpMatch> matches =
          RegExp(pattern.toString()).allMatches(result);
      List<String> textBeginWithHashtags = [];
      matches.forEach((match) {
        textBeginWithHashtags.add(result.substring(match.start, match.end));
      });
      textBeginWithHashtags.forEach((element) {
        result = result.replaceFirst(
            element,
            getHashTagNameHtml(hashTag) +
                element.substring(hashTag.length + 1));
      });
      // trường hợp nằm cuối chuỗi mà không bắt được bằng regex
      if (result.endsWith("#$hashTag")) {
        result = result.replaceAll('#$hashTag', getHashTagNameHtml(hashTag));
      }
      // result = result.replaceAll('#$hashTag',
      //     getHashTagNameHtml(hashTag, cssHtmlClass: cssHashTagHtmlClass));
    });

    // dùng cho trường hợp trả lời comment 1 ai đó
    if (personBeingAnswered != null) {
      result = getTagNameHtmlFromTagId(
              personBeingAnswered.id!, personBeingAnswered.name!) +
          " " +
          result;
    }

    // check link trong content
    if (result.isNotEmpty == true) {
      Pattern pattern =
          r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
      RegExp exp = new RegExp(pattern.toString());
      Iterable<RegExpMatch> matches = exp.allMatches(result);
      List<String> links = [];
      matches.forEach((match) {
        String link = result.substring(match.start, match.end);
        links.add(link);
      });
      if (links.isNotEmpty) {
        links.forEach((link) {
          result = result.replaceAll(link, getLinkHtml(link));
        });
      }
    }
    return result;
  } else {
    return "";
  }
}

String getLinkHtml(String? link) {
  if (link?.isNotEmpty == true)
    return "$link";
  else
    return "";
}

String getTagNameHtmlFromTagId(String tagId, String tagName,
    {CssStyleClass? cssHtmlClass}) {
  return "@$tagName";
}

String getFirstLinkInComment(Comments? commentItem) {
  return getFirstLinkInContent(commentItem?.content);
}

String getFirstLinkInContent(String? content) {
  String result = "";
  if (content?.isNotEmpty == true) {
    Pattern pattern =
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
    RegExp exp = new RegExp(pattern.toString());
    RegExpMatch? match = exp.firstMatch(content!);
    if (match != null) {
      result = content.substring(match.start, match.end);
    }
  }
  print("linkNe: $result");
  return result;
}

String getHashTagNameHtml(String hashTag, {CssStyleClass? cssHtmlClass}) {
  return "#$hashTag";
}
