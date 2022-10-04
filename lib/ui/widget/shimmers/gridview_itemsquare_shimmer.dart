import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/ui/widget/shimmers/image/image_rectangle_shimmer.dart';

class GridviewItemSquareShimmer extends StatelessWidget {
  final double? width;
  final childAspectRatio;
  final Color color;

  GridviewItemSquareShimmer(
      {this.childAspectRatio = 1.0,
      this.color = DColors.whiteColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    double widthShimmer = width ?? MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        color: color,
        child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0),
          itemBuilder: (contxt, childIndex) {
            return ImageRectangleShimmer(
              width: widthShimmer / 2,
              height: widthShimmer / 2,
            );
          },
        ),
      ),
    );
  }
}
