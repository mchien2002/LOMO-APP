import 'package:flutter/material.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:video_player/video_player.dart';

import '../../../../../app/lomo_app.dart';
import '../../../../../data/eventbus/outside_newfeed_event.dart';

class TimeLineItemVideo extends StatefulWidget {
  final bool isPlaying;

  /// video url
  final String network;

  /// set whether video plays again and again
  final bool looping;

  /// time jumps (in seconds) on fast-forward or fast-rewind
  final int timeJumps;

  /// height of the video player
  final double? height;

  /// width of the video player
  final double? width;

  /// loader to display while video loads
  final Widget? loader;

  TimeLineItemVideo(
      {required this.network,
      this.looping = false,
      this.isPlaying = false,
      this.timeJumps = 1,
      this.height,
      this.width,
      this.loader});

  @override
  _AutoPlayVideoState createState() => _AutoPlayVideoState();
}

class _AutoPlayVideoState extends State<TimeLineItemVideo>
    with SingleTickerProviderStateMixin {
  late Animation<Color> _colorAnimation;
  late AnimationController _animationController;
  late VideoPlayerController _controller;
  bool _showControllers = false;
  bool _completed = false;
  bool autoPlay = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<OutSideNewFeedsEvent>().listen((event) async {
      if (_controller.value.isInitialized && _controller.value.isPlaying) {
        _controller.pause();
      }
    });
    autoPlay = locator<UserModel>().userSetting.value?.isVideoAutoPlay ?? false;
    locator<UserModel>().userSetting.addListener(() {
      if (autoPlay != locator<UserModel>().userSetting.value?.isVideoAutoPlay) {
        setState(() {
          autoPlay =
              locator<UserModel>().userSetting.value?.isVideoAutoPlay ?? false;
        });
      }
    });
    _animationController = AnimationController(vsync: this);
    _colorAnimation = Tween<Color>(begin: Colors.red, end: Colors.red).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _controller = VideoPlayerController.network(widget.network);
    _controller.addListener(_listener);
    _controller.setLooping(widget.looping);
    _init();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// video controller listener
  void _listener() {
    if (!_controller.value.isInitialized) return;
    if (_controller.value.position.compareTo(_controller.value.duration) >= 0) {
      if (!_completed) {
        _completed = true;
        _onComplete();
      }
    }
    // else
    //   setState(() {});
  }

  Future<void> _init() async {
    await _controller.initialize();
    if (autoPlay && widget.isPlaying) {
      setState(() {
        _controller.play();
      });
    }
  }

  /// restart video
  void _onComplete() async {
    await _controller.seekTo(Duration());
    await _controller.pause();
    _completed = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized && widget.isPlaying) {
      if (autoPlay && !_controller.value.isPlaying) _controller.play();
      print("_controllerPlay");
    } else if (_controller.value.isInitialized && _controller.value.isPlaying) {
      _controller.pause();
      print("_controllerPause");
    }

    return Center(
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            (_controller.value.isInitialized && _controller.value.isPlaying)
                ? VideoPlayer(_controller)
                : widget.loader ??
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: _colorAnimation,
                        ),
                      ),
                    ),
            Positioned(
              child: SoundVideoButton(
                controller: _controller,
              ),
              top: 5,
              left: 5,
            ),
            // InkWell(
            //   onTap: () => _toggleVideoControllers(),
            //   child: ,
            // ),
            // if (_showControllers) _videoControllers(),
          ],
        ),
      ),
    );
  }

  /// video controllers overlay
  Widget _videoControllers() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // rewind button
                  IconButton(
                    onPressed: () => _seekVideo(false),
                    icon: Icon(
                      Icons.fast_rewind,
                      size: 40,
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  // play / pause button
                  IconButton(
                    onPressed: () => _playPause(),
                    icon: Icon(
                      (_controller.value.isPlaying)
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 40,
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  // forward button
                  IconButton(
                    onPressed: () => _seekVideo(true),
                    icon: Icon(
                      Icons.fast_forward,
                      size: 40,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              // current duration
              Text(
                _formatDuration(_controller.value.position, false),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                width: 6,
              ),
              // duration progress indicator
              Expanded(
                  child: LinearProgressIndicator(
                      value: _durationRatio(),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      minHeight: 2,
                      valueColor: _colorAnimation)),
              SizedBox(
                width: 6,
              ),
              // total duration
              Text(
                _formatDuration(_controller.value.duration, true),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// format duration into string
  String _formatDuration(Duration duration, bool isTotalDuration) {
    if (!_controller.value.isInitialized) return '00:00';

    int seconds = duration.inSeconds;
    int minutes = duration.inMinutes;
    int hours = duration.inHours;
    String str = '';

    if (_controller.value.duration.inHours > 0) {
      if (hours < 9)
        str += '0$hours:';
      else
        str += '$hours:';
    }

    if (minutes < 9)
      str += '0$minutes:';
    else
      str += '$minutes:';

    if (seconds < 9)
      str += '0$seconds';
    else
      str += '$seconds';

    return str;
  }

  /// ratio of current and total duration
  double _durationRatio() {
    if (!_controller.value.isInitialized) return 0.0;
    return _controller.value.position.inSeconds /
        _controller.value.duration.inSeconds;
  }

  /// seek video
  Future<void> _seekVideo(bool forward) async {
    if (!_controller.value.isInitialized) return;
    int newTime;
    if (forward) {
      newTime = _controller.value.position.inSeconds + widget.timeJumps;
      if (newTime > _controller.value.duration.inSeconds) {
        newTime = _controller.value.duration.inSeconds;
      }
    } else {
      newTime = _controller.value.position.inSeconds - widget.timeJumps;
      if (newTime < 0) {
        newTime = 0;
      }
    }
    _controller.seekTo(Duration(seconds: newTime));
  }

  /// play / pause video
  Future<void> _playPause() async {
    if (!_controller.value.isInitialized) return;
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  /// show hide video controllers
  Future<void> _toggleVideoControllers() async {
    if (_showControllers) return;
    setState(() => _showControllers = true);
    await Future.delayed(Duration(seconds: 3));
    if (_showControllers) setState(() => _showControllers = false);
  }
}

class SoundVideoButton extends StatefulWidget {
  VideoPlayerController? controller;
  SoundVideoButton({this.controller});
  @override
  State<StatefulWidget> createState() => _SoundVideoButtonState();
}

class _SoundVideoButtonState extends State<SoundVideoButton> {
  bool hasSoundVideo = false;

  @override
  void initState() {
    super.initState();
    locator<UserModel>().userSetting.addListener(() {
      enableSoundPlayer(
          locator<UserModel>().userSetting.value?.hasSoundVideoAutoPlay ??
              false);
    });
    enableSoundPlayer(
        locator<UserModel>().userSetting.value?.hasSoundVideoAutoPlay ?? false);
  }

  enableSoundPlayer(bool hasSound) {
    try {
      hasSoundVideo = hasSound;
      if (widget.controller != null) {
        widget.controller?.setVolume(hasSound ? 1.0 : 0.0);
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          locator<UserModel>().updateUserSetting(
              hasSoundVideoAutoPlay: !hasSoundVideo, isSaveSetting: false);
          // eventBus.fire(EnableSoundVideoInFeedEvent(!hasSoundVideo));
        },
        child: Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          child: hasSoundVideo
              ? Image.asset(
                  DImages.unmuteVideo,
                  height: 32,
                  width: 32,
                )
              : Image.asset(
                  DImages.muteVideo,
                  height: 32,
                  width: 32,
                ),
        ));
  }
}
