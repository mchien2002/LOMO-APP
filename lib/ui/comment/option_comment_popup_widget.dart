import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/text_cmt_util.dart';

class OptionCommentWidget extends StatelessWidget {
  final Function(Comments) onDeleteClicked;
  final Function(Comments) onEditClicked;
  final Comments item;
  final bool isMe;

  const OptionCommentWidget(
      {required this.onDeleteClicked,
      required this.isMe,
      required this.item,
      required this.onEditClicked});

  @override
  Widget build(BuildContext context) {
    return itemMenu(context, item);
  }

  Widget itemMenu(BuildContext context, Comments item) {
    return Container(
      height: isMe == true ? 3 * 51 : 2 * 51,
      //  height: 3 * 51,
      decoration: BoxDecoration(
        color: getColor().white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Dimens.cornerRadius20)),
      ),
      child: Column(
        children: [
          Visibility(
            visible: isMe,
            child: _buildItemComment(
                context,
                item,
                Strings.delete.localize(context),
                (data) => onDeleteClicked(data)),
          ),
          _buildItemComment(context, item, Strings.copy.localize(context),
              (data) {
            var result = "${buildHtmlContent(data.content, data)}".trim();
            Clipboard.setData(ClipboardData(text: "$result")).then((_) {
              showToast(Strings.copySuccess.localize(context));
            });

            Navigator.pop(context);
            FocusScope.of(context).unfocus();
          }),
          // Visibility(
          //   visible: isMe,
          //   child: _buildItemComment(context, item,
          //       Strings.edit.localize(context), (data) => onEditClicked(data)),
          // ),
          _buildItemComment(context, item, Strings.cancel.localize(context),
              (data) {
            Navigator.pop(context);
            FocusScope.of(context).unfocus();
          }),
        ],
      ),
    );
  }

  Widget _buildItemComment(BuildContext context, Comments item, String text,
      Function(Comments) onTap) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap(item);
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              "$text",
              style: textTheme(context).subText.colorDart,
            ),
          ),
        ),
        Divider(
          height: 1,
          color: getColor().colorDivider,
        ),
      ],
    );
  }

  String? buildHtmlContent(String? editContent, Comments comments) =>
      generateContent(
        editContent,
        tags: comments.tags,
        hashtags: comments.hashtags,
        personBeingAnswered: comments.reply,
      );
}
