import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/home/highlight/post_detail/video_detail_model.dart';
import 'package:provider/provider.dart';

class ControlsOverlay extends StatefulWidget {
  ControlsOverlay(
      {Key? key,
      required this.model,
      required this.fullscreen,
      required this.showHideContent,
      required this.duration})
      : super(key: key);
  final VideoDetailModel model;
  final VoidCallback fullscreen;
  final int duration;
  final Function(bool) showHideContent;
  @override
  State<StatefulWidget> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  bool isControlVisible = true;
  bool isPlayValue = true;
  ValueNotifier<VideoProgress> videoProgressValue =
      ValueNotifier(VideoProgress(progress: 0, buffered: 0));
  bool fullScreenValue = false;
  bool volumeValue = false;
  Timer? countdownTimer;
  late Duration myDuration;
  late Size size;
  @override
  void initState() {
    super.initState();
    startTimer();
    isPlayValue = widget.model.videoPlayerController.value.isPlaying;
    fullScreenValue = widget.model.chewieController != null
        ? widget.model.chewieController!.isFullScreen
        : false;
    volumeValue =
        widget.model.videoPlayerController.value.volume != 0 ? true : false;
    widget.model.videoPlayerController.addListener(() {
      videoProgressValue.value = VideoProgress(
          progress:
              widget.model.videoPlayerController.value.position.inMilliseconds,
          buffered: widget.model.videoPlayerController.value.buffered.isEmpty
              ? widget.model.videoPlayerController.value.position.inMilliseconds
              : widget.model.videoPlayerController.value.buffered.last.end
                  .inMilliseconds);
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    countdownTimer?.cancel();
    myDuration = Duration(seconds: 3);
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer?.cancel();
      setState(() {
        isControlVisible = false;
      });
      widget.showHideContent(!isControlVisible);
    } else {
      myDuration = Duration(seconds: seconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: InkWell(
        onTap: () {
          setState(() {
            startTimer();
            isControlVisible = !isControlVisible;
            widget.showHideContent(!isControlVisible);
          });
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: !isControlVisible
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black12,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Stack(children: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Image.asset(
                              isPlayValue
                                  ? DImages.btnVideoPlay
                                  : DImages.btnVideoPause,
                              width: 64,
                              height: 64,
                            ),
                            onTap: () {
                              widget.model.videoPlayerController.value.isPlaying
                                  ? widget.model.videoPlayerController.pause()
                                  : widget.model.videoPlayerController.play();
                              isPlayValue = !isPlayValue;
                              startTimer();
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ValueListenableProvider.value(
                          value: videoProgressValue,
                          child: Consumer<VideoProgress>(
                              builder: (_, value, child) => Container(
                                    height: 40,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                            child: SizedBox(
                                          width: size.width -
                                              (fullScreenValue &&
                                                      widget
                                                              .model
                                                              .chewieController!
                                                              .aspectRatio! >
                                                          1
                                                  ? 190
                                                  : 130),
                                          height: 40,
                                          child: ProgressBar(
                                              progress: Duration(
                                                  milliseconds: value.progress),
                                              buffered: Duration(
                                                  milliseconds: value.buffered),
                                              total: Duration(
                                                  milliseconds: widget
                                                              .duration !=
                                                          0
                                                      ? widget.duration * 1000
                                                      : widget
                                                          .model
                                                          .videoPlayerController
                                                          .value
                                                          .duration
                                                          .inMilliseconds),
                                              onSeek: (duration) {
                                                widget
                                                    .model.videoPlayerController
                                                    .seekTo(duration);
                                              },
                                              progressBarColor:
                                                  getColor().white,
                                              bufferedBarColor: getColor()
                                                  .white
                                                  .withOpacity(0.3),
                                              baseBarColor: getColor()
                                                  .white
                                                  .withOpacity(0.3),
                                              thumbColor: getColor().white,
                                              timeLabelTextStyle:
                                                  textTheme(context)
                                                      .text11
                                                      .gray2eaColor,
                                              timeLabelLocation:
                                                  TimeLabelLocation.sides),
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          child: Image.asset(
                                            volumeValue
                                                ? DImages.btnVideoVolum
                                                : DImages.btnVideoDisableVolume,
                                            width: 40,
                                            height: 40,
                                          ),
                                          onTap: () {
                                            volumeValue = !volumeValue;
                                            if (volumeValue) {
                                              widget.model.videoPlayerController
                                                  .setVolume(1.0);
                                            } else {
                                              widget.model.videoPlayerController
                                                  .setVolume(0.0);
                                            }
                                            startTimer();
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        InkWell(
                                          child: Image.asset(
                                            fullScreenValue
                                                ? DImages.btnVideoUnfull
                                                : DImages.btnVideoFull,
                                            width: 40,
                                            height: 40,
                                          ),
                                          onTap: () async {
                                            widget.fullscreen();
                                            fullScreenValue = !fullScreenValue;
                                            startTimer();
                                            // setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  ))),
                    ),
                  ]),
                ),
        ),
      ),
    );
  }
}

class VideoProgress {
  int progress;
  int buffered;
  VideoProgress({required this.progress, required this.buffered});
}
