import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/edit_comment_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/text_cmt_util.dart';

import 'flutter_mention/mention_view.dart';
import 'flutter_mention/models.dart';

class TagUserWidget extends StatefulWidget {
  final TextStyle? tagStyle;
  final TextStyle? textStyle;
  final TextStyle? hashTagStyle;
  final SuggestionPosition? suggestionPosition;
  final Function(List<User>)? onUsersTaggedChanged;
  final Function(String)? onTextChanged;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final InputDecoration? decoration;
  final String? defaultText;
  final List<User>? initTaggedUsers;
  final ValueNotifier<Object?>? clearTextEvent;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  TagUserWidget(
      {this.tagStyle,
      this.textStyle,
      this.hashTagStyle,
      this.suggestionPosition,
      this.onUsersTaggedChanged,
      this.maxLines = 1,
      this.minLines = 1,
      this.maxLength,
      this.decoration,
      this.defaultText,
      this.onTextChanged,
      this.initTaggedUsers,
      this.clearTextEvent,
      this.focusNode,
      this.keyboardType,
      this.textInputAction,
      this.textCapitalization});

  @override
  State<StatefulWidget> createState() => _TagUserWidgetState();
}

class _TagUserWidgetState extends State<TagUserWidget> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  List<Map<String, dynamic>> tagUserData = [];
  List<Map<String, dynamic>> hashtagData = [];
  late List<User> usersTagged;
  List<User> currentUsersSearchResult = [];
  String previousSearchText = " ";

  @override
  void initState() {
    super.initState();
    usersTagged = widget.initTaggedUsers ?? [];

    // for edit data
    if (widget.initTaggedUsers?.isNotEmpty == true) {
      generateTagDataFromUsers(widget.initTaggedUsers!);
      currentUsersSearchResult = widget.initTaggedUsers!.map((e) => e).toList();
    }

    widget.clearTextEvent?.addListener(() {
      key.currentState!.controller.clear();
    });
    eventBus.on<EditCommentEvent>().listen((event) async {
      // final user = await locator<UserRepository>()
      //     .getUserDetail(url.substring(1, url.length));
      // print("--------Split${event.data.split('@')[1]}");
      // print("--------search$testData");

      key.currentState?.controller.clear();
      usersTagged = event.data.tags!;
      usersTagged = widget.initTaggedUsers ?? [];
      // for edit data
      if (widget.initTaggedUsers?.isNotEmpty == true) {
        generateTagDataFromUsers(widget.initTaggedUsers!);
        currentUsersSearchResult =
            widget.initTaggedUsers!.map((e) => e).toList();
      }
      key.currentState?.controller.text =
          "${buildHtmlContent(event.data.content, event.data)}".trim();
     setState(() {});

      //currentUsersSearchResult.addAll(event.data.tags);
      // print("onMentionAdd: $event");
      // currentUsersSearchResult.forEach((user) {
      //   if (user.id == event.data.user!.id) usersTagged.add(user);
      // });
      // if (widget.onUsersTaggedChanged != null) {
      //   widget.onUsersTaggedChanged!(usersTagged);
      // }
      // List<User> unionUsersTagged = getListUserFromTaggedText(
      //     key.currentState!.controller.text, usersTagged);
      // usersTagged.clear();
      // usersTagged.addAll(unionUsersTagged);
      // if (widget.onUsersTaggedChanged != null) {
      //   widget.onUsersTaggedChanged!(usersTagged);
      // }
      // key.currentState?.controller.text = "${buildHtmlContent(event.data.content, event.data)}".trim();

      // widget.defaultText ==  event.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterMentions(
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        focusNode: widget.focusNode,
        defaultText: widget.defaultText ?? "",
        key: key,
        style: widget.textStyle ?? textTheme(context).text16.colorDart,
        maxLength: widget.maxLength,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        decoration: widget.decoration ??
            InputDecoration(
                counterText: "",
                isDense: false,
                border: InputBorder.none,
                hintText: Strings.enterContent.localize(context),
                contentPadding: EdgeInsets.all(0)),
        suggestionPosition: widget.suggestionPosition ?? SuggestionPosition.Top,
        onChanged: (val) {
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(val);
          }
        },
        onMarkupChanged: (val) {
          List<User> unionUsersTagged = getListUserFromTaggedText(
              key.currentState!.controller.text, usersTagged);
          usersTagged.clear();
          usersTagged.addAll(unionUsersTagged);
          if (widget.onUsersTaggedChanged != null) {
            widget.onUsersTaggedChanged!(usersTagged);
          }
        },
        onSubmitted: (data) {
          print("$data");
        },
        onSearchChanged: (
          trigger,
          value,
        ) async {
          if (trigger == "@" && value != previousSearchText) {
            try {
              currentUsersSearchResult =
                  await locator<UserRepository>().searchUserForTag(value, 1);
              if (currentUsersSearchResult.length > 0) {
                generateTagDataFromUsers(currentUsersSearchResult);
              } else {
                tagUserData = [];
              }
            } catch (e) {
              print(e);
              tagUserData = [];
            }
            setState(() {});
          }
          previousSearchText = value;
        },
        onEditingComplete: () {
          //key.currentState!.controller.clear();
          //key.currentState.controller.text = '';
        },
        onMentionAdd: (data) {
          print("onMentionAdd: $data");
          currentUsersSearchResult.forEach((user) {
            if (user.id == data["id"]) usersTagged.add(user);
          });
          if (widget.onUsersTaggedChanged != null) {
            widget.onUsersTaggedChanged!(usersTagged);
          }
        },
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        suggestionMargin: EdgeInsets.symmetric(horizontal: 20),
        suggestionListHeight: 220,
        suggestionListDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: const Color(0x1a000000),
                offset: Offset(0, -5),
                blurRadius: 2,
                spreadRadius: 0),
            BoxShadow(
                color: const Color(0x1a000000),
                blurRadius: 2.0,
                offset: Offset(0.0, 5)),
          ],
        ),
        mentions: [
          Mention(
              trigger: r'@',
              style:
                  widget.tagStyle ?? textTheme(context).text16.bold.colorDart,
              data: tagUserData,
              suggestionBuilder: (data) {
                return Container(
                  color: Colors.white,
                  width: 300,
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      CircleNetworkImage(
                        size: 44,
                        url: data['photo'],
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            data['full_name'],
                            style: textTheme(context).text16Bold.colorDart,
                          ),
                          Text('@${data['lomo_id']}',
                              style: textTheme(context).text14Normal.colorGray),
                          SizedBox(
                            height: 13,
                          ),
                          Divider(
                            height: 1,
                            color: getColor().colorGray,
                          )
                        ],
                      ))
                    ],
                  ),
                );
              }),
          Mention(
            trigger: r'#',
            style: widget.hashTagStyle ?? textTheme(context).text16.bold.colorDart,
            data: [],
          )
        ],
      ),
    );
  }

  generateTagDataFromUsers(List<User> users) {
    tagUserData = users
        .map((user) => {
              "id": user.id,
              "display": user.name,
              "photo": user.avatar,
              "lomo_id": user.lomoId,
              "full_name": user.name
            })
        .toList();
  }

  String? buildHtmlContent(String? editContent, Comments comments) =>
      generateContent(
        editContent,
        tags: comments.tags,
        hashtags: comments.hashtags,
        personBeingAnswered: comments.reply,
      );
}
