import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/ui/widget/html_view_widget.dart';

String generateHtmlContent(String? content,
    {List<User>? tags,
    List<String>? hashtags,
    User? personBeingAnswered,
    CssStyleClass? cssTagHtmlClass = CssStyleClass.bold_13_violet,
    CssStyleClass? cssHashTagHtmlClass = CssStyleClass.bold_13_black,
    bool isShowContentLink = true}) {
  if (content?.isNotEmpty == true) {
    String result = content.toString();
    tags?.forEach((tag) {
      result = result.replaceAll('@${tag.id}', getTagNameHtmlFromTagId(tag.id!, tag.name!, cssHtmlClass: cssTagHtmlClass));
    });
    hashtags?.forEach((hashTag) {
      Pattern pattern = "#$hashTag\\W";
      Iterable<RegExpMatch> matches = RegExp(pattern.toString()).allMatches(result);
      List<String> textBeginWithHashtags = [];
      matches.forEach((match) {
        textBeginWithHashtags.add(result.substring(match.start, match.end));
      });
      String endsWithString = "";
      //trường hợp nằm cuối chuỗi mà không bắt được bằng regex
      if (result.endsWith("#$hashTag")) {
        endsWithString = "#$hashTag";
        result = result.replaceAll('#$hashTag', getHashTagNameHtml(hashTag, cssHtmlClass: cssHashTagHtmlClass));
      }
      textBeginWithHashtags.forEach((element) {
        if (element != endsWithString) {
          result = result.replaceAll(element, getHashTagNameHtml(hashTag, cssHtmlClass: cssHashTagHtmlClass) + element.substring(hashTag.length + 1));
        }
      });
    });

    // dùng cho trường hợp trả lời comment 1 ai đó
    if (personBeingAnswered != null) {
      result = getTagNameHtmlFromTagId(personBeingAnswered.id!, personBeingAnswered.name!) + " " + result;
    }

    // check link trong content
    if (isShowContentLink && result.isNotEmpty == true) {
      Pattern pattern = r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
      RegExp exp = new RegExp(pattern.toString());
      Iterable<RegExpMatch> matches = exp.allMatches(result);
      List<String> links = [];
      matches.forEach((match) {
        String link = result.substring(match.start, match.end);
        links.add(link);
      });
      if (links.isNotEmpty) {
        //remove link double
        links.toSet().forEach((link) {
          result = result.replaceAll(link, getLinkHtml(link));
        });
      }
    }
    return result;
  } else {
    return "";
  }
}

String getLinkHtml(String? link, {CssStyleClass? cssHtmlClass}) {
  if (link?.isNotEmpty == true)
    return "<a href='$link' class='${cssHtmlClass?.name ?? CssStyleClass.normal_13_violet.name}'>$link</a>";
  else
    return "";
}

String getTagNameHtmlFromTagId(String tagId, String tagName, {CssStyleClass? cssHtmlClass}) {
  return "<a href='@$tagId' class='${cssHtmlClass?.name ?? CssStyleClass.bold_13_black.name}'>$tagName</a>";
}

String getFirstLinkInComment(Comments? commentItem) {
  // String result = "";
  // if (commentItem?.content?.isNotEmpty == true) {
  //   Pattern pattern =
  //       r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
  //   RegExp exp = new RegExp(pattern.toString());
  //   RegExpMatch? match = exp.firstMatch(commentItem!.content!);
  //   if (match != null) {
  //     result = commentItem.content!.substring(match.start, match.end);
  //   }
  // }
  // print("linkNe: $result");
  return getFirstLinkInContent(commentItem?.content);
}

String getFirstLinkInContent(String? content) {
  String result = "";
  if (content?.isNotEmpty == true) {
    Pattern pattern = r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
    RegExp exp = new RegExp(pattern.toString());
    RegExpMatch? match = exp.firstMatch(content!);
    if (match != null) {
      result = content.substring(match.start, match.end);
    }
  }
  //print("linkNe: $result");
  return result;
}

String getHashTagNameHtml(String hashTag, {CssStyleClass? cssHtmlClass}) {
  return "<a href='#$hashTag' class='${cssHtmlClass?.name ?? CssStyleClass.bold_13_black.name}'>#$hashTag</a>";
}
