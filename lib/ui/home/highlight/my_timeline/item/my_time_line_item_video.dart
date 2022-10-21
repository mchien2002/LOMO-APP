import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user_setting.dart';
import 'package:lomo/data/eventbus/outside_newfeed_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class MyTimeLineItemVideo extends StatefulWidget {
  MyTimeLineItemVideo(
      {Key? key,
      this.isPlaying = false,
      required this.network,
      this.looping = false,
      this.timeJumps = 1,
      this.height,
      this.width,
      this.loader})
      : super(key: key);
  final bool isPlaying;
  final String network;
  final bool looping;
  final int timeJumps;
  final double? height;
  final double? width;
  final Widget? loader;
  @override
  State<MyTimeLineItemVideo> createState() => _MyTimeLineItemVideoState();
}

class _MyTimeLineItemVideoState extends State<MyTimeLineItemVideo>
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
    eventBus.on<OutSideNewFeedsEvent>().listen((event) {
      if (_controller.value.isInitialized && _controller.value.isPlaying) {
        _controller.pause();
      }
    });
    // tùy chỉnh auto play của video theo setting của
    autoPlay = locator<UserModel>().userSetting.value!.isVideoAutoPlay;
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

  Future<void> _init() async {
    await _controller.initialize();
    if (autoPlay && widget.isPlaying) {
      setState(() {
        _controller.play();
      });
    }
  }

  void _listener() {
    if (!_controller.value.isInitialized) return;
    // xét xem video đã chạy xong chưa
    if (_controller.value.position.compareTo(_controller.value.duration) >= 0) {
      if (!_completed) {
        _completed = true;
        _onComplete();
      }
    }
  }

  void _onComplete() async {
    await _controller.seekTo(Duration());
    await _controller.pause();
    _completed = false;
    setState(() {});
  }

  Widget _videoControllers() {
    return Container();
  }

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

  double _durationRatio() {
    if (!_controller.value.isInitialized) return 0.0;
    return _controller.value.position.inSeconds /
        _controller.value.duration.inSeconds;
  }

  // tua video
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

  Future<void> _playPause() async {
    if (!_controller.value.isInitialized) return;
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

// thay thế bộ điều của video
  Future<void> _toggleVideoControllers() async {
    if (_showControllers) return;
    setState(() {
      _showControllers = true;
    });
    await Future.delayed(Duration(seconds: 3));
    if (_showControllers)
      setState(() {
        _showControllers = false;
      });
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
                      color: getColor().black,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: _colorAnimation,
                        ),
                      ),
                    ),
            Positioned(
                child: MySoundVideoButotn(
              controller: _controller,
            ))
          ],
        ),
      ),
    );
  }
}

class MySoundVideoButotn extends StatefulWidget {
  MySoundVideoButotn({Key? key, this.controller}) : super(key: key);
  VideoPlayerController? controller;

  @override
  State<MySoundVideoButotn> createState() => _MySoundVideoButotnState();
}

class _MySoundVideoButotnState extends State<MySoundVideoButotn> {
  bool hashSoundVideo = false;
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

  // xét xem có auto bật video hay không
  void enableSoundPlayer(bool hasSound) {
    try {
      hashSoundVideo = hasSound;
      if (widget.controller != null) {
        widget.controller!.setVolume(hasSound ? 1.0 : 0.0);
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
            hasSoundVideoAutoPlay: !hashSoundVideo, isSaveSetting: false);
      },
      child: Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          child: Image.asset(
            hashSoundVideo ? DImages.unmuteVideo : DImages.muteVideo,
            height: 32,
            width: 32,
          )),
    );
  }
}
