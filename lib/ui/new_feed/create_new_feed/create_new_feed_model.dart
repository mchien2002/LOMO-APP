import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/feeling.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/change_menu_event.dart';
import 'package:lomo/data/eventbus/refresh_profile_event.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/new_feed_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/libraries/photo_manager/photo_manager.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/ui/new_feed/create_new_feed/create_new_feed_screen.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/image_util.dart';
import 'package:lomo/util/new_feed_util.dart';
import 'package:lomo/util/permission_handle_manager.dart';
import 'package:video_player/video_player.dart';

class CreateNewFeedModel extends BaseModel {
  final _newFeedRepository = locator<NewFeedRepository>();
  final _commonRepository = locator<CommonRepository>();
  final permissionManager = locator<PermissionHandleManager>();
  final user = locator<UserModel>().user;
  String firstLinkInComment = "";

  List<User> usersTagged = [];
  bool isEdit = false;
  NewFeed newFeed = NewFeed();
  NewFeed? oldFeed;
  String? linkShare;
  late String fileIdentifier;
  ValueNotifier<bool> validatedInfo = ValueNotifier(false);
  ValueNotifier<String> contentValue = ValueNotifier("");
  ValueNotifier<Feeling?> feelingValue = ValueNotifier(null);
  ValueNotifier<bool> shareLinkValue = ValueNotifier(false);
  ValueNotifier<bool> enableImageValue = ValueNotifier(true);
  ValueNotifier<bool> enableVideoValue = ValueNotifier(true);
  ValueNotifier<double> percentUpload = ValueNotifier(0.0);

  late ValueNotifier<List<PhotoInfo>> photosValue = ValueNotifier([]);
  late ValueNotifier<List<TopictItem>> topicsValue = ValueNotifier([]);
  bool changeVideo = false;
  @override
  ViewState get initState => ViewState.loaded;

  final userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();
  late BuildContext homeContext;

  addTopics(List<TopictItem> items) {
    topicsValue.value = items;
    notifyListeners();
  }

  String getTopicTitle(List<TopictItem> items) {
    if (items.isEmpty) return "";
    var title = "";
    items.forEach((element) {
      title = title + ", ${element.name}";
    });
    return title.substring(1).trim();
  }

  //
  init(CreateNewFeedAgrument agrument) {
    //Truong hop edit bai dang
    if (agrument.newFeed != null) {
      this.oldFeed = agrument.newFeed!;
      isEdit = true;
      topicsValue.value = (oldFeed?.topics ?? null)!;
      feelingValue.value =
          oldFeed?.feeling != null ? getFeeling(oldFeed!) ?? null : null;
      contentValue.value =
          replaceUserIdByUserName(oldFeed?.content, oldFeed?.tags);
      validatedInfo.value = true;
      usersTagged = oldFeed!.tags!;
      photosValue.value = oldFeed!.images!
          .map((e) => PhotoInfo(
              link: e.link,
              isVertical: e.isVertical,
              ratio: e.ratio,
              isVideo: e.type == Constants.TYPE_VIDEO,
              linkThumb: e.thumb,
              type: e.type))
          .toList();
      notifyListeners();
    }
    //Truong hop chia se link bo cau hoi AI HOP TOI
    if (agrument.linkShare != null) {
      linkShare = agrument.linkShare!;
      contentValue.value = linkShare!;
      shareLinkValue.value = true;
      checkContentShareLink(linkShare!);
      validatedInfo.value = true;
    }
  }

  VideoPlayerController? videoController;
  bool? videoIsPlay;

  void setVideoPlayer(VideoPlayerController controller, bool isPlay) {
    this.videoController = controller;
    this.videoIsPlay = isPlay;
  }

  void videoOnPlayPause() {
    if (videoIsPlay == null) return;
    if (videoIsPlay!) {
      videoController?.pause();
    } else {
      videoController?.play();
    }
  }

  Feeling? getFeeling(NewFeed oldNewFeed) {
    return Constants.feeling.firstWhere((element) =>
        oldNewFeed.feeling != null && element.name! == oldNewFeed.feeling!);
  }

  Future<PhotoModel> _uploadPhoto(PhotoInfo photo, int index) async {
    if (photo.u8List != null) {
      PhotoInfo photoInfo = await compressImageWithUint8List(photo.u8List!);
      String? photoUrl = await _commonRepository.uploadImageFromBytes(
          photoInfo.u8List!, percentCallback: (count, total) {
        final percent = double.parse(
            ((count + (total * index)) / (total * photosValue.value.length))
                .toStringAsFixed(2));
        percentUpload.value = percent > 1.0 ? 1.0 : percent;
        print("onSendProgress: ${percentUpload.value}");
        notifyListeners();
      }, uploadDir: UploadDirName.post);
      var photoModel = PhotoModel(photoUrl!,
          isVertical: photoInfo.isVertical, ratio: photoInfo.ratio);
      return photoModel;
    } else {
      return PhotoModel(photo.link!,
          isVertical: photo.isVertical, ratio: photo.ratio);
    }
  }

  Future<PhotoModel> _uploadVideo(PhotoInfo photo) async {
    print(">>>>>model: ${photo.duration}");
    if (photo.u8List != null) {
      final photoCompress = await compressVideo(photo);
      if (photoCompress == null)
        return PhotoModel(photo.link!,
            isVertical: photo.isVertical,
            ratio: photo.ratio ?? 0,
            type: photo.isVideo ? Constants.TYPE_VIDEO : Constants.TYPE_IMAGE,
            duration: photo.duration);

      String? videoUrl = await _commonRepository.uploadVideo(
        photoCompress.u8List,
        (count, total) {
          percentUpload.value =
              double.parse((count / total).toStringAsFixed(2));
          print("onSendProgress: ${percentUpload.value}");
          notifyListeners();
        },
        uploadDir: UploadDirName.post,
      );
      String? thumb = await _commonRepository.uploadImageFromBytes(
          photoCompress.thumb!,
          uploadDir: UploadDirName.post);
      var photoModel = PhotoModel(videoUrl!,
          isVertical: photoCompress.isVertical,
          ratio: photoCompress.ratio ?? 0,
          type: photoCompress.isVideo
              ? Constants.TYPE_VIDEO
              : Constants.TYPE_IMAGE,
          thumb: thumb ?? "",
          duration: photo.duration);
      return photoModel;
    } else {
      return PhotoModel(photo.link!,
          isVertical: photo.isVertical,
          ratio: photo.ratio ?? 0,
          type: photo.isVideo ? Constants.TYPE_VIDEO : Constants.TYPE_IMAGE,
          thumb: photo.linkThumb,
          duration: photo.duration);
    }
  }

  Future<Null> createOrUpdateDataNewFeed(String content) async {
    await callApi(doSomething: () async {
      if (photosValue.value.length > 0) {
        final photos = await uploadPhotosOrVideos(photosValue.value);
        isEdit
            ? await updateFeed(content, photos)
            : await postNewFeed(content, photos);
      } else {
        isEdit ? await updateFeed(content, []) : await postNewFeed(content, []);
      }
      percentUpload.value = 0.0;
    });
  }

  Future<Null> postNewFeed(String content, List<PhotoModel> photos) async {
    newFeed.images = photos;
    final removeSpaceAndEnterContent = removeInvalidSpaceAndEnter(content);
    if (usersTagged.isNotEmpty) {
      newFeed.content =
          replaceUserNameWithUserId(removeSpaceAndEnterContent, usersTagged);
      newFeed.tags = usersTagged;
    } else {
      newFeed.content = removeSpaceAndEnterContent;
    }
    if (topicsValue.value.isNotEmpty) newFeed.topics = topicsValue.value;
    newFeed.hashtags = getHashTagsFromText(removeSpaceAndEnterContent);
    var response = await _newFeedRepository.createNewFeed(newFeed);
    eventBus.fire(ChangeMenuEvent(index: 0));
    eventBus.fire(RefreshWhenCreatePostEvent(user!, newFeed: response!));
  }

  updateFeed(String content, List<PhotoModel> photos) async {
    final removeSpaceAndEnterContent = removeInvalidSpaceAndEnter(content);
    oldFeed!.images = photos;
    if (usersTagged.isNotEmpty) {
      oldFeed!.content =
          replaceUserNameWithUserId(removeSpaceAndEnterContent, usersTagged);
      oldFeed!.tags = usersTagged;
    } else {
      oldFeed!.content = removeSpaceAndEnterContent;
    }
    if (topicsValue.value.isNotEmpty) oldFeed!.topics = topicsValue.value;
    oldFeed!.hashtags = getHashTagsFromText(removeSpaceAndEnterContent);
    await _newFeedRepository.updateNewFeed(oldFeed!);
    eventBus.fire(RefreshWhenCreatePostEvent(user!));
  }

  Future<List<PhotoModel>> uploadPhotosOrVideos(List<PhotoInfo> photos) async {
    List<PhotoModel> paths = [];
    int index = 1;
    await Future.forEach(photos, (PhotoInfo element) async {
      var photoModel = element.isVideo
          ? await _uploadVideo(element)
          : await _uploadPhoto(element, index);
      paths.add(photoModel);
      index++;
    });

    return paths;
  }

  @override
  void dispose() {
    validatedInfo.dispose();
    contentValue.dispose();
    feelingValue.dispose();
    topicsValue.dispose();
    shareLinkValue.dispose();
    videoController?.dispose();
    super.dispose();
  }

  isValidatedInfo() {
    validatedInfo.value =
        (photosValue.value.length > 0) || contentValue.value != "";
  }

  // Hien thi man hinh chon hinh anh ben native va tra ve list path inh anh
  showPhotosPicker(BuildContext context) async {
    //Lay ra danh sach hinh anh duoc chon tu thu vien
    var itemsPath = photosValue.value
        .where((element) => element.u8List != null && !element.isCamera)
        .toList();
    //Lay ra danh sach hinh anh tu server hoac chup tu camera
    var itemsLinkAndCamera = photosValue.value
        .where((element) => element.link != null || element.isCamera)
        .toList();

    final photos = await getImagesUint8List(context,
        items: itemsPath, limit: 5 - itemsLinkAndCamera.length);
    //Remove nhung hinh anh cu
    isEdit
        ? photosValue.value.removeWhere((element) => element.u8List != null)
        : photosValue.value.removeWhere((element) => element.isCamera == false);
    photosValue.value.addAll(photos);
    shareLinkValue.value =
        firstLinkInComment != "" && photosValue.value.isEmpty ? true : false;
    checkEnableButton();
    isValidatedInfo();
    notifyListeners();
  }

  showVideos(BuildContext context) async {
    //Lay ra danh sach video duoc chon tu thu vien
    var itemsPath = photosValue.value
        .where((element) => element.u8List != null && !element.isCamera)
        .toList();

    final video = await getVideo(context, items: itemsPath);
    photosValue.value.clear();
    if (video != null) {
      photosValue.value.add(video);
      checkEnableButton();
      isValidatedInfo();
      notifyListeners();
    }
  }

  checkEnableButton() async {
    if (photosValue.value.isEmpty) {
      enableImageValue.value = true;
      enableVideoValue.value = true;
      notifyListeners();
      return;
    }
    final items = photosValue.value.where((element) => element.isVideo == true);
    if (items.length > 0) {
      enableVideoValue.value = true;
      enableImageValue.value = false;
    } else {
      enableVideoValue.value = false;
      enableImageValue.value = true;
    }
    notifyListeners();
  }

  Future<Null> onEditPhoto(
      BuildContext context, Uint8List u8List, int index) async {
    final u8ListEdit = await editPhoto(context, u8List);
    if (u8ListEdit != null) {
      photosValue.value[index].u8List = u8ListEdit;
      photosValue.value[index].isEdited = true;
      notifyListeners();
    }
  }

  Future<Null> onEditVideo(
      BuildContext context, Uint8List u8List, int index) async {
    final u8ListEdit = await editVideo(context, u8List);
    if (u8ListEdit != null) {
      photosValue.value[index].u8List = u8ListEdit;
      photosValue.value[index].isEdited = true;
      notifyListeners();
    }
  }

  checkContentShareLink(String content) {
    firstLinkInComment = getFirstLinkInContent(content);
    shareLinkValue.value =
        firstLinkInComment != "" && photosValue.value.isEmpty ? true : false;
    notifyListeners();
  }

  void deletePhotoOrVideo(int index) {
    photosValue.value.removeAt(index);
    shareLinkValue.value =
        firstLinkInComment != "" && photosValue.value.isEmpty ? true : false;
    checkEnableButton();
    isValidatedInfo();
    notifyListeners();
  }
}
