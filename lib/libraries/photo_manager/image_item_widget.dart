import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:photo_manager/photo_manager.dart';

import 'change_notifier_builder.dart';
import 'core/lru_map.dart';
import 'loading_widget.dart';

class ImageItemWidget extends StatefulWidget {
  const ImageItemWidget(
      {Key? key, required this.entity, required this.option, this.type = null})
      : super(key: key);

  final AssetEntity entity;
  final ThumbnailOption option;
  final RequestType? type;

  @override
  _ImageItemWidgetState createState() => _ImageItemWidgetState();
}

class _ImageItemWidgetState extends State<ImageItemWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = locator<PhotoProvider>();
    return ChangeNotifierBuilder(
      builder: (c, p) {
        final format = provider.thumbFormat;
        return buildContent(format);
      },
      value: provider,
    );
  }

  Widget buildContent(ThumbnailFormat format) {
    if (widget.entity.type == AssetType.audio) {
      return Center(
        child: Icon(
          Icons.audiotrack,
          size: 30,
        ),
      );
    }
    final item = widget.entity;
    final size = widget.option.size.width;
    final u8List = ImageLruCache.getData(item, size, format);

    Widget image;

    if (u8List != null) {
      return _buildImageWidget(item, u8List, size);
    } else {
      image = FutureBuilder<Uint8List?>(
        future: item.thumbnailDataWithOption(widget.option),
        builder: (context, snapshot) {
          Widget w;
          if (snapshot.hasError) {
            w = Center(
              child: Text("load error, error: ${snapshot.error}"),
            );
          }
          if (snapshot.hasData) {
            ImageLruCache.setData(item, size, format, snapshot.data!);
            w = _buildImageWidget(item, snapshot.data!, size);
          } else {
            w = Center(
              child: itemLoading(size.toDouble()),
            );
          }

          return w;
        },
      );
    }

    return image;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildImageWidget(AssetEntity entity, Uint8List uint8list, num size) {
    return Stack(
      children: [
        Image.memory(
          uint8list,
          width: size.toDouble(),
          height: size.toDouble(),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
        if (widget.type != null && widget.type == RequestType.video)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                color: getColor().black.withOpacity(0.5),
                padding: EdgeInsets.all(5),
                child: Text(
                  "${_printDuration(Duration(seconds: entity.duration))}",
                  style: textTheme(context).text12.colorWhite,
                )),
          )
      ],
    );
  }

  @override
  void didUpdateWidget(ImageItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entity.id != oldWidget.entity.id) {
      setState(() {});
    }
  }
}
