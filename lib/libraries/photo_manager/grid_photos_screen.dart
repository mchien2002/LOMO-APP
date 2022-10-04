import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/widget/loading_widget.dart';
import 'package:photo_manager/photo_manager.dart';

import 'camera/take_picture.dart';
import 'change_notifier_builder.dart';
import 'image_item_widget.dart';
import 'list_group_photo_screen.dart';

class GridPhotosScreen extends StatefulWidget {
  final int totalPhoto;
  final List<PhotoInfo>? itemsSelected;
  final bool isMultiple;
  final RequestType type;

  GridPhotosScreen(
      {this.totalPhoto = 1,
      this.itemsSelected,
      required this.isMultiple,
      required this.type});

  @override
  State<StatefulWidget> createState() => _GridPhotosScreenState();
}

class _GridPhotosScreenState extends State<GridPhotosScreen>
    with
        AutomaticKeepAliveClientMixin<GridPhotosScreen>,
        WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();

  PhotoProvider get photoProvider => locator<PhotoProvider>();

  AssetPathProvider get provider => locator<AssetPathProvider>();

  List<AssetEntity> checked = [];

  bool get isIOS => Platform.isIOS ? true : false;

  ThumbnailOption get thumbOption =>
      ThumbnailOption(size: ThumbnailSize(139, 139), quality: 86);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    photoProvider.changeType(widget.type);
    provider.initData(widget.itemsSelected, widget.totalPhoto);
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      photoProvider.refreshAll();
    }
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    if (_controller.position.extentAfter < 400) {
      onLoadMore();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PhotoCachingManager().cancelCacheRequest();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBar(context),
      body: Stack(
        children: [
          buildRefreshIndicator(),
          ChangeNotifierBuilder(
              value: photoProvider,
              builder: (_, __) {
                if (!photoProvider.spinnerValue.value)
                  return ListGroupPhotoScreen();
                return SizedBox(
                  width: 0.0,
                  height: 0.0,
                );
              }),
          ChangeNotifierBuilder(
              builder: (_, __) {
                return provider.loadingValue.value
                    ? Center(
                        child: LoadingWidget(),
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      );
              },
              value: provider)
        ],
      ),
      floatingActionButton: _buttonAccept(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildRefreshIndicator() {
    return ChangeNotifierBuilder(
        value: provider,
        builder: (_, __) {
          return provider.list.length > 0
              ? CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: _onRefresh,
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 3),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildItem(provider.list[index], index);
                          },
                          childCount: provider.list.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1.0,
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child: Text(
                    Strings.noData.localize(context),
                    style: textTheme(context).text16.colorDart,
                  ),
                );
        });
  }

  Future<void> _onRefresh() async {
    if (!mounted) {
      return;
    }
    await provider.reloadAssetPathEntity();
  }

  Future<void> onLoadMore() async {
    if (!mounted) {
      return;
    }
    await provider.onLoadMore();
  }

  Widget _buildItem(AssetEntity entity, int index) {
    int index = provider.getIndexPhotoChecked(entity.id);
    bool isChecked = index < 0 ? false : true;
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          child: Stack(
            children: [
              ImageItemWidget(
                key: ValueKey(entity),
                entity: entity,
                option: thumbOption,
                type: widget.type,
              ),
              Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                      top: isChecked ? 3 : 6, right: isChecked ? 3 : 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.transparent,
                    border: isChecked
                        ? Border.all(
                            width: 3,
                            color: getColor()
                                .primaryColor //                   <--- border width here
                            )
                        : null,
                  ),
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: isChecked
                          ? getColor().primaryColor
                          : Colors.transparent,
                      border: Border.all(
                          width: isChecked ? 0 : 2,
                          color: getColor()
                              .grayBorder //                   <--- border width here
                          ),
                    ),
                    child: isChecked
                        ? widget.isMultiple
                            ? Text(
                                "${index + 1}",
                                style: textTheme(context).text12.colorWhite,
                              )
                            : Icon(
                                Icons.check,
                                color: getColor().white,
                              )
                        : null,
                  ))
            ],
          ),
          onTap: () async {
            isChecked
                ? provider.photoRemoveItem(entity.id)
                : provider.photoAddItem(entity, widget.isMultiple, widget.type);
          },
        ));
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColor().primaryColor.withOpacity(0.95),
      elevation: 0,
      centerTitle: true,
      title: pathEntitySelector(context),
      leading: IconButton(
        icon: Icon(
          Icons.close,
          size: 32,
          color: getColor().white,
        ),
        onPressed: () {
          provider.clearAllData();
          Navigator.of(context).pop();
        },
      ),
      actions: [
        if (widget.type != RequestType.video)
          IconButton(
            icon: Icon(
              Icons.camera_enhance,
              size: 32,
              color: getColor().white,
            ),
            onPressed: () async {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;
              final page = TakePictureScreen(
                camera: firstCamera,
              );
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => page,
              ));
              if (result != null)
                Navigator.of(context).pop(widget.isMultiple
                    ? List<PhotoInfo>.from([result])
                    : result);
            },
          ),
      ],
    );
  }

  Widget pathEntitySelector(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 6, top: 6, bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChangeNotifierBuilder(
                builder: (_, __) => Text(
                      photoProvider.currentGroup?.name ?? "",
                      style: textTheme(context).text15.bold.colorWhite,
                    ),
                value: photoProvider),
            SizedBox(
              width: 3,
            ),
            Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white38,
                ),
                child: ChangeNotifierBuilder(
                  value: photoProvider,
                  builder: (_, __) => Icon(
                    photoProvider.spinnerValue.value
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    color: Colors.black54,
                  ),
                ))
          ],
        ),
      ),
      onTap: () {
        photoProvider.changeSpinnerValue();
      },
    );
  }

  Widget _buttonAccept() {
    bool isClick = true;
    return ChangeNotifierBuilder(
        builder: (_, __) {
          return provider.itemsSelected.length > 0
              ? InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: getColor().primaryColor),
                    child: Text(
                      widget.isMultiple
                          ? "${Strings.selected.localize(context)} ${provider.itemsSelected.length}/${provider.totalPhoto} ${Strings.images.localize(context)}"
                          : "${Strings.complete.localize(context)}",
                      style: textTheme(context).text15.bold.colorWhite,
                    ),
                  ),
                  onTap: () async {
                    if (isClick) {
                      isClick = false;
                      try {
                        final items = await provider.getListPaths();
                        Navigator.of(context)
                            .pop(widget.isMultiple ? items : items[0]);
                        isClick = true;
                      } catch (e) {
                        isClick = true;
                      }
                    }
                  },
                )
              : SizedBox(
                  width: 0.0,
                  height: 0.0,
                );
        },
        value: provider);
  }

  @override
  bool get wantKeepAlive => true;
}
