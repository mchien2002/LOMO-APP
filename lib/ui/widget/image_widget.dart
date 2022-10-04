import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/image_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class RoundNetworkImage extends StatelessWidget {
  final String? url;
  final double height;
  final double width;
  final double? radius;
  final Widget? errorHolder;
  final dynamic placeholder;
  final BoxFit? boxFit;
  final Color? strokeColor;
  final double? strokeWidth;

  RoundNetworkImage(
      {required this.width,
      required this.height,
      this.url,
      this.radius = 0.0,
      this.placeholder,
      this.errorHolder,
      this.boxFit,
      this.strokeColor,
      this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: CachedNetworkImage(
        cacheManager: CustomCacheManager.instance,
        fadeInDuration: Duration(milliseconds: 300),
        fadeOutDuration: Duration(milliseconds: 500),
        imageUrl: getFullLinkImage(url),
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(radius!)),
            border: Border.all(
                color: strokeColor ?? Colors.transparent,
                width: strokeWidth ?? 0),
            image: DecorationImage(
              image: imageProvider,
              fit: boxFit ?? BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => _placeHolder(context),
        errorWidget: (context, url, error) =>
            errorHolder ?? _buildErrorWidget(),
        memCacheWidth: width > 300 ? 300 : width.toInt(),
        memCacheHeight: height > 300 ? 300 : height.toInt(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Image.asset(
      DImages.avatarDefaultLomo,
      height: height,
      width: width,
    );
  }

  Widget _placeHolder(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: placeholder != null
          ? placeholder is Widget
              ? placeholder
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(radius!)),
                      color: getColor().colorDart,
                      image: placeholder is String
                          ? DecorationImage(
                              image: AssetImage(placeholder),
                              fit: boxFit ?? BoxFit.cover,
                            )
                          : null))
          : LoadingWidget(
              radius: min(height, width) >= 100 ? 15 : min(height, width) / 6,
            ),
    );
  }
}

class CircleNetworkImage extends RoundNetworkImage {
  CircleNetworkImage(
      {required double size,
      String? url,
      Widget? errorHolder,
      dynamic placeholder,
      BoxFit? boxFit,
      Color? strokeColor,
      double? strokeWidth})
      : super(
            radius: size / 2,
            url: url,
            width: size,
            height: size,
            boxFit: boxFit,
            placeholder: placeholder,
            errorHolder: errorHolder,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor);
}

class PhotoViewNetworkImage extends StatelessWidget {
  final String? url;
  final double height;
  final double width;
  final double? radius;
  final Widget? errorHolder;
  final dynamic placeholder;
  final BoxFit? boxFit;
  final Color? strokeColor;
  final double? strokeWidth;

  PhotoViewNetworkImage(
      {required this.width,
      required this.height,
      this.url,
      this.radius = 0.0,
      this.placeholder,
      this.errorHolder,
      this.boxFit,
      this.strokeColor,
      this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: SizedBox(
        width: width,
        height: height,
        child: PhotoView(
          minScale: PhotoViewComputedScale.covered,
          maxScale: PhotoViewComputedScale.covered,
          filterQuality: FilterQuality.high,
          initialScale: PhotoViewComputedScale.covered,
          imageProvider: CachedNetworkImageProvider(getFullLinkImage(url)),
          loadingBuilder: (context, event) => _placeHolder(context),
        ),
      ),
    );
  }

  Widget _placeHolder(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: placeholder != null
          ? placeholder is Widget
              ? placeholder
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(radius!)),
                      color: getColor().colorDart,
                      image: placeholder is String
                          ? DecorationImage(
                              image: AssetImage(placeholder),
                              fit: boxFit ?? BoxFit.cover,
                            )
                          : null))
          : LoadingWidget(
              radius: min(height, width) >= 100 ? 15 : min(height, width) / 6,
            ),
    );
  }
}
