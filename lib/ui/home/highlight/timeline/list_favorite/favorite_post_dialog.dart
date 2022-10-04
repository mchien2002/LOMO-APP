import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/home/highlight/timeline/list_favorite/list_favorite_post.dart';

class FavoritePostDialog extends StatelessWidget {
  const FavoritePostDialog({Key? key, this.onClosed, required this.isPost})
      : super(key: key);

  final Function? onClosed;
  final String? isPost;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: getColor().white,
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ListFavoritePost(
                isPost: isPost,
              ),
            ),
          ),
          _buildCloseButton(context),
          Padding(
            padding: const EdgeInsets.only(
              top: Dimens.size20,
              bottom: 13,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.likes.localize(context),
                  style: textTheme(context).text17.colorDart.bold,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 17, bottom: 13, left: 17),
        child: InkWell(
          onTap: () {
            if (onClosed != null) onClosed!();
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }
}
