import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoProvider extends ChangeNotifier {
  ValueNotifier<bool> spinnerValue = ValueNotifier(true); //True up
  List<AssetPathEntity> listGallarys = [];
  List<AssetEntity> listThumb = [];
  int gallaryIndex = 0;

  init() async {
    refreshGalleryList();
  }

  RequestType type = RequestType.common;

  var hasAll = true;

  var onlyAll = false;

  Map<AssetPathEntity, AssetPathProvider> pathProviderMap = {};

  bool _notifying = false;

  bool _needTitle = false;

  bool get needTitle => _needTitle;

  AssetPathEntity? get currentGroup {
    if (listGallarys.length > 0 && gallaryIndex <= listGallarys.length) {
      return listGallarys[gallaryIndex];
    }
    return null;
  }

  bool _containsEmptyAlbum = false;

  bool _containsPathModified = false;

  bool get containsPathModified => _containsPathModified;

  bool get containsEmptyAlbum => _containsEmptyAlbum;

  set needTitle(bool? needTitle) {
    if (needTitle == null) {
      return;
    }
    _needTitle = needTitle;
    notifyListeners();
  }

  changeSpinnerValue() {
    spinnerValue.value = !spinnerValue.value;
    notifyListeners();
  }

  onChangedGallary(int index) {
    if (index != gallaryIndex) {
      gallaryIndex = index;
      locator<AssetPathProvider>().changeGallary(listGallarys[gallaryIndex]);
    }
    changeSpinnerValue();
  }

  set containsEmptyAlbum(bool containsEmptyAlbum) {
    _containsEmptyAlbum = containsEmptyAlbum;
    notifyListeners();
  }

  set containsPathModified(bool containsPathModified) {
    _containsPathModified = containsPathModified;
    notifyListeners();
  }

  DateTime _startDt = DateTime(2005); // Default Before 8 years

  DateTime get startDt => _startDt;

  set startDt(DateTime startDt) {
    _startDt = startDt;
    notifyListeners();
  }

  DateTime _endDt = DateTime.now();

  DateTime get endDt => _endDt;

  set endDt(DateTime endDt) {
    _endDt = endDt;
    notifyListeners();
  }

  bool _asc = false;

  bool get asc => _asc;

  set asc(bool? asc) {
    if (asc == null) {
      return;
    }
    _asc = asc;
    notifyListeners();
  }

  var _thumbFormat = ThumbnailFormat.png;

  ThumbnailFormat get thumbFormat => _thumbFormat;

  set thumbFormat(thumbFormat) {
    _thumbFormat = thumbFormat;
    notifyListeners();
  }

  bool get notifying => _notifying;

  String minWidth = "0";
  String maxWidth = "10000";
  String minHeight = "0";
  String maxHeight = "10000";
  bool _ignoreSize = true;

  bool get ignoreSize => _ignoreSize;

  set ignoreSize(bool? ignoreSize) {
    if (ignoreSize == null) {
      return;
    }
    _ignoreSize = ignoreSize;
    notifyListeners();
  }

  Duration _minDuration = Duration.zero;

  Duration get minDuration => _minDuration;

  set minDuration(Duration minDuration) {
    _minDuration = minDuration;
    notifyListeners();
  }

  Duration _maxDuration = Duration(hours: 1);

  Duration get maxDuration => _maxDuration;

  set maxDuration(Duration maxDuration) {
    _maxDuration = maxDuration;
    notifyListeners();
  }

  set notifying(bool? notifying) {
    if (notifying == null) {
      return;
    }
    _notifying = notifying;
    notifyListeners();
  }

  void changeType(RequestType type) async {
    if (this.type == type) return;
    this.type = type;
    this.gallaryIndex = 0;
    await refreshGalleryList();
    locator<AssetPathProvider>().reloadAssetPathEntity();
    notifyListeners();
  }

  void changeHasAll(bool? value) {
    if (value == null) {
      return;
    }
    this.hasAll = value;
    notifyListeners();
  }

  void changeOnlyAll(bool? value) {
    if (value == null) {
      return;
    }
    this.onlyAll = value;
    notifyListeners();
  }

  void changeContainsEmptyAlbum(bool? value) {
    if (value == null) {
      return;
    }
    this.containsEmptyAlbum = value;
    notifyListeners();
  }

  void changeContainsPathModified(bool? value) {
    if (value == null) {
      return;
    }
    this.containsPathModified = value;
  }

  void reset() {
    this.listGallarys.clear();
    pathProviderMap.clear();
  }

  Future<void> refreshAll() async {
    await refreshGalleryList();
    locator<AssetPathProvider>().onRefresh();
  }

  Future<void> refreshGalleryList() async {
    final option = makeOption();
    reset();
    var galleryList = await elapsedFuture(PhotoManager.getAssetPathList(
      type: type,
      hasAll: hasAll,
      onlyAll: onlyAll,
      filterOption: option,
    ));
    if (galleryList.isNotEmpty) {
      this.listGallarys.clear();
      await Future.forEach(galleryList, (AssetPathEntity element) async {
        if (await element.assetCountAsync > 0 && element.type == type) {
          listGallarys.add(element);
        }
      });

      if (listGallarys.length > 0) {
        locator<AssetPathProvider>().path = listGallarys[gallaryIndex];
        await getGalleryListThumb();
      }
    }
  }

  Future<void> getGalleryListThumb() async {
    if (listGallarys.length == 0) {
      return;
    }
    listThumb.clear();
    await Future.forEach(listGallarys, (AssetPathEntity element) async {
      if (await element.assetCountAsync > 0) {
        var items = await elapsedFuture(
          element.getAssetListPaged(page: 0, size: 1),
          prefix: 'Load more assets list from path ${element.id}',
        );
        listThumb.add(items[0]);
      }
    });
  }

  FilterOptionGroup makeOption() {
    final option = FilterOption(
      sizeConstraint: SizeConstraint(
        minWidth: int.tryParse(minWidth) ?? 0,
        maxWidth: int.tryParse(maxWidth) ?? 100000,
        minHeight: int.tryParse(minHeight) ?? 0,
        maxHeight: int.tryParse(maxHeight) ?? 100000,
        ignoreSize: ignoreSize,
      ),
      durationConstraint: DurationConstraint(
        min: minDuration,
        max: maxDuration,
      ),
      needTitle: needTitle,
    );

    final createDtCond = DateTimeCond(
      min: startDt,
      max: endDt,
      ignore: false,
    );

    return FilterOptionGroup()
      ..setOption(AssetType.video, option)
      ..setOption(AssetType.image, option)
      ..createTimeCond = createDtCond
      ..containsPathModified = _containsPathModified
      ..containsLivePhotos = false
      ..onlyLivePhotos = false
      ..addOrderOption(
        OrderOption(
          type: OrderOptionType.updateDate,
          asc: asc,
        ),
      );
  }

  Future<void> refreshAllGalleryProperties() async {
    await Future.wait(
      List<Future<void>>.generate(listGallarys.length, (int i) async {
        final AssetPathEntity gallery = listGallarys[i];
        final AssetPathEntity newGallery = await elapsedFuture(
          AssetPathEntity.obtainPathFromProperties(
            id: gallery.id,
            albumType: gallery.albumType,
            type: gallery.type,
            optionGroup: gallery.filterOption,
          ),
          prefix: 'Refresh path entity ${gallery.id}',
        );
        listGallarys[i] = newGallery;
      }),
    );
    locator<AssetPathProvider>().onRefresh();
    notifyListeners();
  }

  void changeThumbFormat() {
    if (thumbFormat == ThumbnailFormat.jpeg) {
      thumbFormat = ThumbnailFormat.png;
    } else {
      thumbFormat = ThumbnailFormat.jpeg;
    }
  }
}

class AssetPathProvider extends ChangeNotifier {
  ValueNotifier<bool> loadingValue = ValueNotifier(false);
  static const loadCount = 30;
  bool isInit = false;
  int totalPhoto = 1;
  late AssetPathEntity path;

  initData(List<PhotoInfo>? itemsSelected, int totalPhoto) {
    if (itemsSelected == null) return;
    this.itemsSelected.clear();
    this.itemsSelected.addAll(itemsSelected);
    this.totalPhoto = totalPhoto;
  }

  AssetPathProvider();

  List<AssetEntity> list = [];
  List<PhotoInfo> itemsSelected = [];

  var page = 0;

  Future<int> get showItemCount async {
    int length = await path.assetCountAsync;
    if (list.length == length) {
      return length;
    } else {
      return list.length;
    }
  }

  reloadAssetPathEntity() async {
    // await path.fetchPathProperties();
    onRefresh();
  }

  changeGallary(AssetPathEntity path) {
    this.path = path;
    itemsSelected.clear();
    list.clear();
    reloadAssetPathEntity();
  }

  photoRemoveItem(String id) async {
    if (itemsSelected.length == 0) {
      return;
    }
    itemsSelected.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> photoAddItem(
      AssetEntity entity, bool isMultiple, RequestType type) async {
    if (itemsSelected.length >= totalPhoto && isMultiple) return;
    if (!isMultiple) itemsSelected.clear();
    if (totalPhoto == itemsSelected.length) return;
    itemsSelected.add(PhotoInfo(
        id: entity.id,
        entity: entity,
        isVideo: type == RequestType.video ? true : false));
    notifyListeners();
  }

  int getIndexPhotoChecked(String id) {
    if (itemsSelected.length == 0) {
      return -1;
    }
    return itemsSelected.indexWhere((element) => element.id == id);
  }

  clearAllData() {
    totalPhoto = 1;
    itemsSelected.clear();
  }

  bool refreshing = false;

  Future onRefresh() async {
    if (refreshing) {
      return;
    }
    refreshing = true;
    // await path.fetchPathProperties();
    page = 0;
    if (locator<PhotoProvider>().listGallarys.isNotEmpty) {
      final list = await elapsedFuture(
        path.getAssetListPaged(page: page, size: loadCount),
        prefix: 'Refresh assets list from path ${path.id}',
      );
      this.list.clear();
      this.list.addAll(list);
    } else {
      this.list.clear();
    }
    isInit = true;
    notifyListeners();
    printListLength("onRefresh");
    refreshing = false;
  }

  Future<void> onLoadMore() async {
    if (refreshing) {
      return;
    }
    int count = await path.assetCountAsync;
    int length = await showItemCount;
    if (length >= count) {
      return;
    }
    if ((page + 1) * loadCount == length) {
      page = page + 1;
      final list = await path.getAssetListPaged(page: page, size: loadCount);
      this.list.addAll(list);
      notifyListeners();
      printListLength("loadmore");
    }
  }

  void printListLength(String tag) {
    print("$tag length : ${list.length}");
  }

  Future<List<PhotoInfo>> getListPaths() async {
    return itemsSelected;
  }
}

class PhotoInfo {
  String? id;
  Uint8List? u8List; //Hinh moi
  String? link; //Link khi hinh tren server danh cho truong hop edit
  String? linkThumb;
  bool isVertical;
  bool isEdited;
  bool isCamera;
  double? ratio;
  String? type;
  bool isVideo;
  Uint8List? thumb;
  AssetEntity? entity;
  int? duration;

  PhotoInfo(
      {this.id,
      this.u8List,
      this.link,
      this.linkThumb,
      this.isVertical = false,
      this.isEdited = false,
      this.isCamera = false,
      this.ratio,
      this.type,
      this.isVideo = false,
      this.thumb,
      this.entity,
      this.duration = 0});
}
