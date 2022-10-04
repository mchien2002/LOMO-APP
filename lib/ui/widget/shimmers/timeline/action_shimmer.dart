import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../res/theme/theme_manager.dart';

class ActionShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Dimens.spacing16, right: Dimens.spacing16),
      child: Container(
        child: Shimmer.fromColors(
            baseColor: getColor().shimmerBaseColor,
            highlightColor: getColor().shimmerHighlightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: DColors.gray8DColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(0.0))),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: DColors.gray8DColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(0.0))),
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: DColors.gray8DColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(0.0))),
                )
              ],
            )),
      ),
    );
  }
}
