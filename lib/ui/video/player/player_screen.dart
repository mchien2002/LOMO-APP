import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/video/player/player_model.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen(this.url);
  final String? url;

  @override
  State<StatefulWidget> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends BaseState<PlayerModel, PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  Timer? _menuTimer;

  @override
  initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(getFullLinkVideo(widget.url))
          ..initialize().then((value) {
            setState(() {
              _chewieController = ChewieController(
                  allowedScreenSleep: false,
                  allowFullScreen: true,
                  deviceOrientationsOnEnterFullScreen: [
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                  ],
                  deviceOrientationsAfterFullScreen: [
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.portraitUp,
                  ],
                  videoPlayerController: _videoPlayerController,
                  autoInitialize: true,
                  autoPlay: true,
                  showControls: true,
                  showOptions: true
                  // aspectRatio: widget.args.ratio,
                  // aspectRatio: 2,
                  );
            });
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget buildContentView(BuildContext context, model) {
    return Scaffold(
      backgroundColor: getColor().blackBackgroundColor,
      body: SafeArea(
        child: Center(
          child: _chewieController != null
              ? Chewie(
                  controller: _chewieController!,
                )
              : LoadingWidget(),
        ),
      ),
    );
  }
}
