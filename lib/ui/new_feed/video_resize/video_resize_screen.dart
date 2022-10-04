import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lomo/libraries/video_trimmer/src/file_formats.dart';
import 'package:lomo/libraries/video_trimmer/src/trim_editor.dart';
import 'package:lomo/libraries/video_trimmer/src/trimmer.dart';
import 'package:lomo/libraries/video_trimmer/src/video_viewer.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/new_feed/video_resize/video_resize_model.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoResizeScreen extends StatefulWidget {
  final File? file;
  final String? pathVideo;
  VideoResizeScreen({this.file, this.pathVideo, Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _VideoResizeScreenState();
}

class _VideoResizeScreenState
    extends BaseState<VideoResizeModel, VideoResizeScreen> {
  final Trimmer _trimmer = Trimmer();
  File? video;
  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget buildContentView(BuildContext context, VideoResizeModel model) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Strings.editVideo.localize(context),
          style: textTheme(context).text18.bold.colorWhite,
        ),
        backgroundColor: getColor().primaryColor,
        elevation: 0,
        actions: [
          ValueListenableProvider.value(
            value: model.saveLoadingValue,
            child: Consumer<bool>(
                builder: (context, enable, child) => IconButton(
                    onPressed: () => _saveVideo(),
                    icon: enable
                        ? LoadingWidget(
                            activeColor: getColor().white,
                            inactiveColor: getColor().colorGrayC1,
                            radius: 16,
                          )
                        : Icon(
                            Icons.check,
                            color: getColor().white,
                          ))),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (video != null)
                      VideoViewer(
                        trimmer: _trimmer,
                      ),
                    if (video != null)
                      ValueListenableProvider.value(
                        value: model.playingValue,
                        child: Consumer<bool>(
                          builder: (context, enable, child) => TextButton(
                            child: enable
                                ? Image.asset(
                                    DImages.pauseVideo,
                                    width: 60.0,
                                    height: 60.0,
                                  )
                                : Image.asset(
                                    DImages.btnVideoPause,
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                            onPressed: () async {
                              bool playbackState =
                                  await _trimmer.videPlaybackControl(
                                startValue: model.startValue,
                                endValue: model.endValue,
                              );
                              model.changePlayingState(playbackState);
                            },
                          ),
                        ),
                      ),
                    if (video == null)
                      Center(
                        child: LoadingWidget(),
                      )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TrimEditor(
                  trimmer: _trimmer,
                  fit: BoxFit.fill,
                  viewerHeight: 50.0,
                  circlePaintColor: getColor().white,
                  circleSize: 8.0,
                  sideTapSize: 16,
                  scrubberWidth: 1,
                  circleSizeOnDrag: 12.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  maxVideoLength: const Duration(seconds: 60),
                  onChangeStart: (value) {
                    model.startValue = value;
                  },
                  onChangeEnd: (value) {
                    model.endValue = value;
                    print("onChangeEnd: $value");
                  },
                  onChangePlaybackState: (value) {
                    model.changePlayingState(value);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: getColor().blackBackgroundColor,
    );
  }

  void _loadVideo() async {
    if (widget.pathVideo == null && widget.file == null) {
      showToast("Video bị lỗi");
      return;
    }
    if (widget.pathVideo != null) {
      video = File(widget.pathVideo!);
    } else {
      video = widget.file;
    }

    _trimmer.loadVideo(videoFile: video!).then((value) {
      setState(() {});
    });
  }

  Future<void> _saveVideo() async {
    if (video != null) {
      model.changeSaveLoadingState(true);
      _trimmer.saveTrimmedVideo(
          startValue: model.startValue,
          endValue: model.endValue,
          outputFormat: FileFormat.mp4,
          onSave: (String? outputPath) async {
            final fileEdit = File(outputPath ?? "");
            final u8List = fileEdit.readAsBytesSync();
            final int duration = (model.endValue - model.startValue) ~/ 1000;
            //Get thumbnail
            Uint8List? thumb = await VideoThumbnail.thumbnailData(
              video: video!.path,
              imageFormat: ImageFormat.JPEG,
              quality: 40,
            );
            Navigator.pop(context, [u8List, thumb, duration]);
          });
    }
  }
}
