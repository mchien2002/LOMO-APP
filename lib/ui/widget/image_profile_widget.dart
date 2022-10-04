import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/icons.dart';
import 'package:lomo/ui/widget/image_widget.dart';

class ImageProfileWidget extends StatelessWidget {
  final User user;
  final NewFeed newfeed;
  const ImageProfileWidget({required this.user, required this.newfeed});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: RoundNetworkImage(
            placeholder: 'assets/images/img_b14.png',
            url: newfeed.images![0].link ?? "",
            height: 300,
            width: 150,
          ),
        ),
        Positioned(
            left: 10,
            bottom: 5,
            child: SvgPicture.asset(
              DIcons.heartGroup,
              color: DColors.whiteColor,
            )),
        Positioned(
            left: 40,
            bottom: 7,
            child: Text(
              user.story ?? "",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
