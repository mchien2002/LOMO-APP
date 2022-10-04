import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../res/theme/theme_manager.dart';

class ImageCircleShimmer extends StatelessWidget {
  final double size;

  ImageCircleShimmer({this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: getColor().shimmerBaseColor,
        highlightColor: getColor().shimmerHighlightColor,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
              color: DColors.gray8DColor,
              shape: BoxShape.circle,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ));
  }
}
