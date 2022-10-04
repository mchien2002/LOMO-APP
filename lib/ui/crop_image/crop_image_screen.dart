import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/dialog_widget.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

class CropImageScreen extends StatefulWidget {
  final File image;

  CropImageScreen(this.image);

  @override
  State<StatefulWidget> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  Widget? _loadingDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildTop(),
          Expanded(
            child: Stack(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: ClipRect(
                    child: PhotoView(
                      minScale: PhotoViewComputedScale.covered,
                      filterQuality: FilterQuality.high,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      initialScale: PhotoViewComputedScale.covered,
                      imageProvider: FileImage(widget.image),
                      loadingBuilder: (context, event) => Center(
                        child: LoadingWidget(
                          radius: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: Dimens.spacing20,
                    bottom: Dimens.spacing24,
                    child: Image.asset(
                      DImages.zoom,
                      height: Dimens.size32,
                      width: Dimens.size32,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Container(
      padding: EdgeInsets.only(left: Dimens.spacing15, right: Dimens.spacing20),
      color: getColor().colorBlackBg,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: getColor().white,
                size: 25,
              ),
            ),
            InkWell(
              onTap: () async {
                showLoading();
                screenshotController.capture(pixelRatio: 3).then((image) async {
                  hideLoading();
                  Navigator.pop(context, image);
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  Strings.done.localize(context),
                  style: textTheme(context).text20.bold.colorWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showLoading({BuildContext? dialogContext}) {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog();
      showDialog(
          barrierDismissible: false,
          context: dialogContext ?? context,
          builder: (_) => _loadingDialog!);
    }
  }

  hideLoading({BuildContext? dialogContext}) {
    Navigator.pop(dialogContext ?? context);
    _loadingDialog = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
