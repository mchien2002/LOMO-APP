import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:video_player/video_player.dart';

import 'controls_overlay.dart';

class VideoDetailModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  final _newFeedRepository = locator<NewFeedRepository>();
  late AnimationController controllerBottom;
  late Animation<Offset> offsetBottom;
  late AnimationController controllerTop;
  late Animation<Offset> offsetTop;

  late NewFeed newFeed;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  ValueNotifier<bool> videoInitialize = ValueNotifier(false);
  ValueNotifier<bool> closeButtonValue = ValueNotifier(true);
  bool showHideContent = false;
  final user = User.fromJson(locator<UserModel>().user!.toJson());

  init(NewFeed newFeed) {
    this.newFeed = newFeed;
    initVideo(newFeed.images?[0].link);
    changeControl();
  }

  initVideo(String? videoUrl) async {
    videoPlayerController = VideoPlayerController.network(
        getFullLinkVideo(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false, allowBackgroundPlayback: false));

    await videoPlayerController.initialize();
    chewieController = ChewieController(
      aspectRatio: videoInfo.ratio,
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
      allowFullScreen: true,
      customControls: ControlsOverlay(
        model: this,
        fullscreen: () {
          chewieController?.toggleFullScreen();
        },
        showHideContent: (value) {
          showHideContent = value;
          changeControl();
        },
        duration: newFeed.images![0].duration!,
      ),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
    );
    videoPlayerController.addListener(() {
      //Update view when initialzied
      if (!videoInitialize.value) {
        videoInitialize.value = videoPlayerController.value.isInitialized;
        updateView();
      }
    });
  }

  changeControl() {
    if (showHideContent) {
      controllerTop.reverse();
      controllerBottom.reverse();
      closeButtonValue.value = false;
    } else {
      controllerTop.forward();
      controllerBottom.forward();
      closeButtonValue.value = true;
    }
  }

  block(User user) async {
    await callApi(doSomething: () async {
      _userRepository.blockUser(user);
    });
  }

  deleteNewFeed(String postId) async {
    await callApi(doSomething: () async {
      await _newFeedRepository.deleteNewFeed(postId);
    });
  }

  PhotoModel get videoInfo => newFeed.images![0];
  String get videoThumb => newFeed.images![0].thumb ?? "";
}
