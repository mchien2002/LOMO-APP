import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';

import 'shimmers/image/image_rectangle_shimmer.dart';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;
  final String? thumbnail;
  final double? ratio;
  VideoWidget({required this.videoUrl, this.thumbnail, this.ratio = 1});

  @override
  State<StatefulWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late double ratio;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ratio = (widget.ratio != null && widget.ratio != 0 ? widget.ratio! : 1);
    final width = MediaQuery.of(context).size.width - 32;
    final height = width / ratio;
    return GestureDetector(
      child: Container(
        color: getColor().black,
        width: width,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RoundNetworkImage(
              width: width,
              height: 300,
              url: widget.thumbnail,
              placeholder: ImageRectangleShimmer(
                width: width,
                height: height,
              ),
              errorHolder: ImageRectangleShimmer(
                width: width,
                height: height,
              ),
              boxFit: BoxFit.contain,
            ),
            Icon(
              Icons.slow_motion_video_sharp,
              size: 50,
              color: getColor().white,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.playerVideo,
            arguments: widget.videoUrl);
      },
    );
  }

  Widget _loadThumbDefault() {
    return Icon(
      Icons.slow_motion_video_sharp,
      size: 60,
      color: getColor().white,
    );
  }
}
