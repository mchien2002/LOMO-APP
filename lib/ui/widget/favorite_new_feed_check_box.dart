import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:rxdart/rxdart.dart';

import 'checkbox_widget.dart';

class FavoriteNewFeedCheckBox extends StatefulWidget {
  final NewFeed newFeed;
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
  final isDisable;

  FavoriteNewFeedCheckBox(
      {required this.newFeed,
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
      this.isDisable = false});

  @override
  State<StatefulWidget> createState() => _FavoriteNewFeedCheckBoxState();
}

class _FavoriteNewFeedCheckBoxState extends State<FavoriteNewFeedCheckBox> {
  bool onClick = true;
  final totalFavorite = BehaviorSubject<int>();
  final checkFavorite = BehaviorSubject<bool>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<bool>(
            stream: checkFavorite.stream,
            builder: (context, snapshot) {
              var check = snapshot.data != null
                  ? snapshot.data
                  : widget.newFeed.isFavorite;
              return CheckBoxWidget(
                height: widget.height,
                width: widget.width,
                initValue: check,
                onCheckChanged: (checked) async {
                  if (!widget.isDisable) {
                    try {
                      if (widget.newFeed.isFavorite) {
                        if (onClick) {
                          onClick = false;
                          await locator<UserRepository>()
                              .unFavoritePost(widget.newFeed.id!);
                          widget.newFeed.isFavorite = false;
                          widget.newFeed.numberOfFavorite -= 1;
                          totalFavorite.sink
                              .add(widget.newFeed.numberOfFavorite);
                          checkFavorite.sink.add(false);
                          onClick = true;
                          if (widget.onCheckChanged != null)
                            widget.onCheckChanged!(checked);
                        }
                      } else {
                        if (onClick) {
                          onClick = false;
                          await locator<UserRepository>()
                              .favoritePost(widget.newFeed.id!);
                          widget.newFeed.isFavorite = true;
                          widget.newFeed.numberOfFavorite += 1;
                          checkFavorite.sink.add(true);
                          totalFavorite.sink
                              .add(widget.newFeed.numberOfFavorite);
                          onClick = true;
                          if (widget.onCheckChanged != null)
                            widget.onCheckChanged!(checked);
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
                    widget.iconFavorite != null
                        ? widget.iconFavorite
                        : DImages.love,
                    height: widget.height,
                    width: widget.height,
                    color: widget.uncheckedColor ?? getColor().darkTextColor,
                  ),
                ),
                isDisable: widget.isDisable,
              );
            }),
        SizedBox(
          width: widget.padding == 0.0 ? 5 : 0,
        ),
        StreamBuilder<int>(
            stream: totalFavorite.stream,
            builder: (context, snapshot) {
              var total = snapshot.data != null
                  ? snapshot.data
                  : widget.newFeed.numberOfFavorite;
              return widget.newFeed.numberOfFavorite > 1
                  ? Text(
                      "$total ${!widget.isFormatTotal ? Strings.likes.localize(context).toLowerCase() : ""}",
                      style: widget.txtTheme != null
                          ? widget.txtTheme
                          : textTheme(context).text13.colorGray)
                  : Text(
                      "$total ${!widget.isFormatTotal ? Strings.like.localize(context).toLowerCase() : ""}",
                      style: widget.txtTheme != null
                          ? widget.txtTheme
                          : textTheme(context).text13.colorGray);
            })
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
