import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:shimmer/shimmer.dart';

class ListviewShimmer extends StatelessWidget {
  final double? width;
  final childAspectRatio;
  final Color color;

  ListviewShimmer(
      {this.childAspectRatio = 1.0,
      this.color = DColors.whiteColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        color: color,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (contxt, childIndex) {
            return Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Shimmer.fromColors(
                  baseColor: getColor().shimmerBaseColor,
                  highlightColor: getColor().shimmerHighlightColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: getColor().colorGray,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 250,
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 20,
                              decoration: BoxDecoration(
                                color: getColor().colorGray,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 225,
                              height: 20,
                              decoration: BoxDecoration(
                                color: getColor().colorGray,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 250,
                              height: 20,
                              decoration: BoxDecoration(
                                color: getColor().colorGray,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
