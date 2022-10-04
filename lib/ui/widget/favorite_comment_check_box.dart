import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/comments.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:rxdart/rxdart.dart';

import 'checkbox_widget.dart';

class FavoriteCommentCheckBox extends StatefulWidget {
  final Comments comment;
  final Function(bool)? onCheckChanged;
  final double height;
  final double width;
  final double padding;
  final Color? uncheckedColor;
  final Color? checkedColor;
  final bool isFormatTotal;
  final TextStyle? txtTheme;
  final iconFavorite;
  final iconFavoriteActive;
  final bool isDisable;
  final bool isShowText;

  FavoriteCommentCheckBox(
      {required this.comment,
      this.onCheckChanged,
      this.height = 24.0,
      this.width = 24.0,
      this.padding = 0.0,
      this.uncheckedColor,
      this.checkedColor,
      this.isFormatTotal = false,
      this.txtTheme,
      this.iconFavorite,
      this.iconFavoriteActive,
      this.isDisable = false,
      this.isShowText = false});

  @override
  State<StatefulWidget> createState() => _FavoriteCommentCheckBoxState();
}

class _FavoriteCommentCheckBoxState extends State<FavoriteCommentCheckBox> {
  bool onClick = true;
  final totalFavorite = BehaviorSubject<int>();
  final checkFavorite = BehaviorSubject<bool>();
//change position like zeplin
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<int>(
            stream: totalFavorite.stream,
            builder: (context, snapshot) {
              var total = snapshot.data != null ? snapshot.data : widget.comment.numberOfFavorite;
              return Row(
                children: [
                  Text("${total == 0 ? "" : total}",
                      style: widget.txtTheme != null
                          ? widget.txtTheme
                          : textTheme(context).text13.colorGray),
                  if (widget.isShowText)
                    widget.comment.numberOfFavorite > 1
                        ? Text(
                            " ${!widget.isFormatTotal ? Strings.likes.localize(context).toLowerCase() : ""}",
                            style: widget.txtTheme != null
                                ? widget.txtTheme
                                : textTheme(context).text13.colorGray)
                        : Text(
                            " ${!widget.isFormatTotal ? Strings.like.localize(context).toLowerCase() : ""}",
                            style: widget.txtTheme != null
                                ? widget.txtTheme
                                : textTheme(context).text13.colorGray)
                ],
              );
            }),
        SizedBox(
          width: widget.padding == 0.0 ? 5 : 0,
        ),
        StreamBuilder<bool>(
            stream: checkFavorite.stream,
            builder: (context, snapshot) {
              var check = snapshot.data != null ? snapshot.data : widget.comment.isFavorite;
              return CheckBoxWidget(
                height: widget.height,
                width: widget.width,
                initValue: check,
                onCheckChanged: (checked) async {
                  if (!widget.isDisable) {
                    try {
                      if (widget.comment.isFavorite) {
                        if (onClick) {
                          onClick = false;
                          await locator<NewFeedRepository>()
                              .favoriteComment(widget.comment.id!, false);
                          widget.comment.isFavorite = false;
                          widget.comment.numberOfFavorite -= 1;
                          totalFavorite.sink.add(widget.comment.numberOfFavorite);
                          checkFavorite.sink.add(false);
                          onClick = true;
                          if (widget.onCheckChanged != null) widget.onCheckChanged!(checked);
                        }
                      } else {
                        if (onClick) {
                          onClick = false;
                          await locator<NewFeedRepository>()
                              .favoriteComment(widget.comment.id!, true);
                          widget.comment.isFavorite = true;
                          widget.comment.numberOfFavorite += 1;
                          checkFavorite.sink.add(true);
                          totalFavorite.sink.add(widget.comment.numberOfFavorite);
                          onClick = true;
                          if (widget.onCheckChanged != null) widget.onCheckChanged!(checked);
                        }
                      }
                    } catch (e) {}
                    //setState(() {});
                  }
                },
                checkedIcon: Container(
                  padding: EdgeInsets.all(widget.padding),
                  child: Image.asset(
                    widget.iconFavoriteActive != null
                        ? widget.iconFavoriteActive
                        : DImages.loveActive,
                    height: widget.height,
                    width: widget.height,
                    color: widget.checkedColor ?? getColor().pin88Color,
                  ),
                ),
                unCheckedIcon: Container(
                  padding: EdgeInsets.all(widget.padding),
                  child: Image.asset(
                    widget.iconFavorite != null ? widget.iconFavorite : DImages.love,
                    height: widget.height,
                    width: widget.height,
                    color: widget.uncheckedColor ?? getColor().textHint,
                  ),
                ),
                isDisable: widget.isDisable,
              );
            }),
      ],
    );
  }

  @override
  void dispose() {
    totalFavorite.close();
    checkFavorite.close();
    super.dispose();
  }
}
