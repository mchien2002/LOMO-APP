import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../res/theme/theme_manager.dart';

class ImageRectangleShimmer extends StatelessWidget {
  final double width;
  final double? height;

  ImageRectangleShimmer({this.width = 90.0, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: getColor().shimmerBaseColor,
        highlightColor: getColor().shimmerHighlightColor,
        child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              color: DColors.gray8DColor,
              shape: BoxShape.rectangle,
            )));
  }
}
