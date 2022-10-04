import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/image_util.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final Uint8List? video;
  final String? videoUrl;
  final bool changeVideo;
  final Function(VideoPlayerController, bool)? onClick;

  VideoItem(this.video, this.videoUrl, this.onClick, this.changeVideo,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController? _controller;
  File? file;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video != oldWidget.video && widget.changeVideo) initVideo();
  }

  void initVideo() async {
    if (widget.video == null && widget.videoUrl == null) return;
    if (widget.video != null) {
      final filePath = await destinationFileVideo;
      file = await writeToFile(widget.video!, filePath);
      _controller = VideoPlayerController.file(file!)
        ..initialize().then((_) {
          _controller?.setLooping(true);
          setState(() {
            _controller?.play();
            if (widget.onClick != null) widget.onClick!(_controller!, true);
          });
        });
    } else if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.network(getFullLinkVideo(widget.videoUrl))
            ..initialize().then((_) {
              _controller?.setLooping(true);
              setState(() {
                _controller?.play();
                if (widget.onClick != null) widget.onClick!(_controller!, true);
              });
            });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    file?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller != null ? _controller!.value.aspectRatio : 1.0,
      child: _controller != null
          ? VideoPlayer(_controller!)
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
    );
  }
}
