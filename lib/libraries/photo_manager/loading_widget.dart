import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../res/theme/theme_manager.dart';

final loadWidget = Center(
  child: SizedBox.fromSize(
    size: Size.square(30),
    child: (Platform.isIOS || Platform.isMacOS)
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator(),
  ),
);

Widget itemLoading(double size) {
  return Container(
      child: Shimmer.fromColors(
          baseColor: getColor().shimmerBaseColor,
          highlightColor: getColor().shimmerHighlightColor,
          child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: DColors.gray8DColor,
                shape: BoxShape.rectangle,
              ))));
}
