import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/values.dart';
import 'package:lomo/ui/widget/image_widget.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

import '../report/report_screen.dart';
import 'bottom_sheet_widgets.dart';
import 'dialog_widget.dart';

class PhotosViewPage extends StatefulWidget {
  const PhotosViewPage(
      {Key? key,
      this.images,
      this.firstPage = 0,
      this.user,
      this.accessToken,
      this.onBlock,
      this.isDating})
      : super(key: key);

  final List<String>? images;
  final int firstPage;
  final String? accessToken;
  final User? user;
  final bool? isDating;
  final Function? onBlock;

  @override
  _PhotosViewPageState createState() => _PhotosViewPageState();
}

class _PhotosViewPageState extends State<PhotosViewPage> {
  int _index = 0;
  PhotoViewComputedScale scale = PhotoViewComputedScale.covered;

  @override
  void initState() {
    super.initState();
    _index = widget.firstPage;
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: _index);
    return Scaffold(
      body: Stack(children: [
        PhotoViewGallery.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.images!.length,
          pageController: _pageController,
          onPageChanged: (index) => setState(() => _index = index),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions.customChild(
              minScale: scale,
              maxScale: scale * 2,
              child: RoundNetworkImage(
                url: widget.images![index],
                width: double.infinity,
                height: double.infinity,
                boxFit: BoxFit.contain,
              ),
            );
          },
          loadingBuilder: (context, event) {
            return CircularProgressIndicator();
          },
        ),
        Positioned(
          top: 30,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  '${_index + 1}/${widget.images!.length}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                _buildButtonMore(),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildButtonMore() {
    return BottomSheetMenuWidget(
      items: widget.isDating != null && widget.isDating == true
          ? PhotoMenu.values.map((e) => e.name.localize(context)).toList()
          : PhotoMenuNormal.values
              .map((e) => e.name.localize(context))
              .toList(),
      onItemClicked: (index) async {
        if (widget.isDating == true) {
          switch (PhotoMenu.values[index]) {
            case PhotoMenu.report:
              Navigator.pushNamed(context, Routes.report,
                  arguments: ReportScreenArgs(user: widget.user!));
              break;
            case PhotoMenu.block:
              showDialog(
                  context: context,
                  builder: (context) => TwoButtonDialogWidget(
                        title: Strings.blockThisUser.localize(context),
                        description:
                            Strings.blockedUserContent.localize(context),
                        onConfirmed: () {
                          widget.onBlock!();
                        },
                      ));
              break;
            case PhotoMenu.cancel:
              break;
          }
        } else {
          switch (PhotoMenuNormal.values[index]) {
            case PhotoMenuNormal.download:
              try {
                var imageId = await ImageDownloader.downloadImage(
                    getFullLinkImage(widget.images![_index]));
                if (imageId == null) {
                  return;
                } else {
                  showToast(Strings.saveImageSuccess.localize(context));
                }
              } on Exception catch (error) {
                print(error);
              }
              break;
            case PhotoMenuNormal.share:
              Share.share(getFullLinkImage(widget.images![_index]));
              break;
          }
        }
      },
      child: Image.asset(
        DImages.moreGray,
        height: 36,
        width: 36,
      ),
    );
  }
}

enum PhotoMenu { report, block, cancel }

extension PhotoMenuExt on PhotoMenu {
  String get name {
    switch (this) {
      case PhotoMenu.block:
        return Strings.block;
      case PhotoMenu.report:
        return Strings.report;
      case PhotoMenu.cancel:
        return Strings.cancel;
    }
    return "";
  }
}

enum PhotoMenuNormal { download, share }

extension PhotoMenuExtNormal on PhotoMenuNormal {
  String get name {
    switch (this) {
      case PhotoMenuNormal.download:
        return Strings.download;
      case PhotoMenuNormal.share:
        return Strings.share;
    }
    return "";
  }
}
