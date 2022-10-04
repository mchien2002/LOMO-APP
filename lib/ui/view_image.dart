import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageScreen extends StatefulWidget {
  final String? url;

  const ViewImageScreen({this.url});

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        widget.url != null && widget.url != ""
            ? PhotoView(
                minScale: PhotoViewComputedScale.contained,
                filterQuality: FilterQuality.high,
                imageProvider: CachedNetworkImageProvider(
                  getFullLinkImage(widget.url),
                ),
              )
            : Center(
                child: Text(
                  Strings.noData.localize(context),
                  style: textTheme(context).text16.colorDart,
                ),
              ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: InkWell(
            onTap: () async {
              Navigator.of(context).maybePop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Image.asset(
                DImages.closex,
                width: 32,
                height: 32,
                color: getColor().white,
              ),
            ),
          ),
        )
      ],
    ));
  }
}
