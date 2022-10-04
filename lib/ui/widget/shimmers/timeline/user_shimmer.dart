import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/dimens.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../res/theme/theme_manager.dart';

class UserShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Dimens.spacing16, right: Dimens.spacing16),
      child: Column(
        children: [_buildUser()],
      ),
    );
  }

  Widget _buildUser() {
    return Container(
        child: Shimmer.fromColors(
      baseColor: getColor().shimmerBaseColor,
      highlightColor: getColor().shimmerHighlightColor,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: DColors.gray8DColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 100,
            height: 20,
            decoration: const BoxDecoration(
              color: DColors.gray8DColor,
              shape: BoxShape.rectangle,
            ),
          )
        ],
      ),
    ));
  }
}
