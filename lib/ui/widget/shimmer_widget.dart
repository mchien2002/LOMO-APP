import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../res/theme/theme_manager.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  ShimmerWidget({required this.child});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getColor().grayF1Color,
      highlightColor: getColor().gray2eaColor,
      period: const Duration(milliseconds: 1000),
      child: child,
    );
  }
}
