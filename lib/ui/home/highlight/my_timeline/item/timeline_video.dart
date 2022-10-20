import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';

import '../../../../../res/images.dart';
import '../../../../../util/common_utils.dart';
import '../../../../widget/image_widget.dart';
import 'my_time_line_item_video.dart';

class TimeLineVideoItem extends StatelessWidget {
  TimeLineVideoItem({Key? key, required this.photo, required this.willPlay})
      : super(key: key);
  final PhotoModel photo;
  final bool willPlay;
  @override
  Widget build(BuildContext context) {
    final ratio = (photo.ratio != null && photo.ratio != 0 ? photo.ratio : 1);
    final width = MediaQuery.of(context).size.width;
    final height = width / ratio!;
    return MyTimeLineItemVideo(
      network: getFullLinkVideo(photo.link),
      height: height,
      width: width,
      isPlaying: willPlay,
      loader: Stack(
        alignment: Alignment.center,
        children: [
          RoundNetworkImage(
            width: width,
            height: height,
            url: getFullLinkImage(photo.thumb),
          ),
          Image.asset(
            DImages.btnVideoPause,
            height: 50,
            width: 50,
          )
        ],
      ),
    );
  }
}
