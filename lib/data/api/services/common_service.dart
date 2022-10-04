import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/app_config.dart';
import 'package:lomo/data/api/models/checkin.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/discovery_item.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/error_log.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/filter_request_item.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/data/api/models/new_feed.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/request/app_config_request.dart';
import 'package:lomo/data/api/models/response/upload_avatar_response.dart';
import 'package:lomo/data/api/models/search_post_advance_response.dart';
import 'package:lomo/data/api/models/search_topic_advance_response.dart';
import 'package:lomo/data/api/models/search_user_advance_response.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/tracking_request.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/util/constants.dart';
import 'package:lomo/util/image_util.dart';
import 'package:path/path.dart';
import 'package:sprintf/sprintf.dart';

import 'base_service.dart';

class CommonService extends BaseService {
  Future<List<City>> getCities() async {
    final response = await get(
      PROVINCE,
      params: GetQueryParam(limit: 100, sorts: [FilterRequestItem(key: "priority", value: "1")])
          .toJson(),
    );
    return List<City>.from(response.map((item) => City.fromJson(item))).toList();
  }

  Future<List<City>> getDistrict(String id) async {
    final response = await get(DISTRICT,
        params: GetQueryParam(
            limit: 100,
            sorts: [FilterRequestItem(key: "priority", value: 1)],
            filters: [FilterRequestItem(key: "province", value: id)]).toJson());
    return List<City>.from(response.map((item) => City.fromJson(item))).toList();
  }

  Future<List<City>> getWard(String id) async {
    final response = await get(
      WARD,
      params: GetQueryParam(
          limit: 100,
          sorts: [FilterRequestItem(key: "priority", value: 1)],
          filters: [FilterRequestItem(key: "district", value: id)]).toJson(),
    );
    return List<City>.from(response.map((item) => City.fromJson(item))).toList();
  }

  Future<List<Event>> getEvents(int page, int pageSize, String eventType) async {
    final response = await get(
      EVENTS,
      params: GetQueryParam(
        page: page,
        limit: pageSize,
        filters: [
          FilterRequestItem(key: "type", value: eventType),
        ],
        sorts: [
          FilterRequestItem(key: "priority", value: 1),
          FilterRequestItem(key: "createdAt", value: -1)
        ],
      ).toJson(),
    );
    return List<Event>.from(response.map((item) => Event.fromJson(item))).toList();
  }

  Future<List<TopictItem>> getSearchTopic(
      String? textSearch, int page, int limit, bool isSort) async {
    final response = await get(
      LIST_TOPIC,
      params: GetQueryParam(
        page: page,
        limit: limit,
        filters: [
          if (textSearch != null && textSearch != "")
            FilterRequestItem(key: "\$text", value: textSearch)
        ],
        sorts: [
          if (isSort) FilterRequestItem(key: "numberOfPost", value: -1),
        ],
      ).toJson(),
    );
    return List<TopictItem>.from(response.map((item) => TopictItem.fromJson(item))).toList();
  }

  Future<List<HashTag>> searchHashTag(String textSearch, int page, int limit,
      {bool isTrend = false}) async {
    final response = await get(SEARCH_HASH_TAG,
        params: GetQueryParam(page: page, limit: limit, filters: [
          if (textSearch.isNotEmpty) FilterRequestItem(key: "name", value: textSearch),
          if (isTrend) FilterRequestItem(key: "isTrend", value: true),
        ], sorts: [
          FilterRequestItem(key: "numberOfPost", value: -1),
          FilterRequestItem(key: "priority", value: 1),
          FilterRequestItem(key: "createdAt", value: -1),
        ]).toJson());
    return List<HashTag>.from(response.map((item) => HashTag.fromJson(item)));
  }

  Future<List<TopictItem>> getListTopicWithType(String subjectType, int page, int pageSize) async {
    final response = await get(LIST_TOPIC_WITH_TYPE,
        params: GetQueryParam(page: page, limit: pageSize, filters: [
          FilterRequestItem(
            key: "types",
            value: subjectType,
          ),
        ], sorts: [
          FilterRequestItem(key: "priority", value: 1),
          FilterRequestItem(key: "createdAt", value: -1),
        ]).toJson());
    return List<TopictItem>.from(response.map((item) => TopictItem.fromJson(item))).toList();
  }

  Future<List<TopictItem>> getListKnowledgeSubject(int page, int pageSize) async {
    final response =
        await get(LIST_KNOWLEDGE, params: GetQueryParam(page: page, limit: pageSize).toJson());
    return List<TopictItem>.from(response.map((item) => TopictItem.fromJson(item))).toList();
  }

  Future<List<Gift>> getGifts(int page, int pageSize, {bool? isHot}) async {
    final response = await get(GIFTS,
        params: GetQueryParam(
          page: page,
          limit: pageSize,
          filters: [if (isHot == true) FilterRequestItem(key: "isHot", value: true)],
          sorts: [
            FilterRequestItem(key: "priority", value: 1),
            FilterRequestItem(key: "createdAt", value: -1)
          ],
        ).toJson());
    return List<Gift>.from(response.map((item) => Gift.fromJson(item))).toList();
  }

  Future<List<Checkin>> getListCheckin() async {
    final response = await get(
      POST_LIST_CHECKIN,
      params: GetQueryParam(page: 1, limit: 100).toJson(),
    );
    return List<Checkin>.from(response.map((item) => Checkin.fromJson(item))).toList();
  }

  Future<void> checkin() async {
    await post(POST_CHECKIN);
  }

  Future<List<Zodiac>> getZodiac() async {
    final data = {"page": 1, "limit": 100};
    final response = await post(POST_UPDATE_ZODIAC, data: data);
    return List<Zodiac>.from(response.map((item) => Zodiac.fromJson(item))).toList();
  }

  Future<List<Sogiesc>> getSogiesc() async {
    final data = {"page": 1, "limit": 100};
    final response = await post(POST_UPDATE_SOGIESC, data: data);
    return List<Sogiesc>.from(response.map((item) => Sogiesc.fromJson(item))).toList();
  }

  Future<List<Relationship>> getRelationship() async {
    final data = {"page": 1, "limit": 100};
    final response = await post(POST_UPDATE_RELATIONSHIP, data: data);
    return List<Relationship>.from(response.map((item) => Relationship.fromJson(item))).toList();
  }

  Future<String> uploadImageFromBytes(Uint8List u8List,
      {Function(int, int)? percentCallback, UploadDirName? uploadDir}) async {
    Map<String, dynamic> data = {};
    final filePath = await destinationFileImage;
    final file = await writeToFile(u8List, filePath);
    data["file"] = await MultipartFile.fromFile(filePath,
        filename: basename(filePath), contentType: MediaType.parse("image/jpeg"));

    var response = await postUpload(sprintf(UPLOAD_IMAGE, [uploadDir?.name ?? ""]),
        percentCallback: percentCallback, data: FormData.fromMap(data));
    file.delete();
    return UploadAvatarResponse.fromJson(response).link!;
  }

  Future<String> uploadVideo(Uint8List? u8List, Function(int, int) percentCallback,
      {UploadDirName? uploadDir}) async {
    if (u8List == null) return "";
    Map<String, dynamic> data = {};
    final filePath = await destinationFileVideo;
    final file = await writeToFile(u8List, filePath);
    data["file"] = await MultipartFile.fromFile(filePath,
        filename: basename(filePath), contentType: MediaType.parse("video/mp4"));
    var response = await postUpload(sprintf(UPLOAD_VIDEO, [uploadDir?.name ?? ""]),
        percentCallback: percentCallback, data: FormData.fromMap(data));
    file.delete();
    return UploadAvatarResponse.fromJson(response).link!;
  }

  Future<String> uploadImages(List<File> files, {UploadDirName? uploadDir}) async {
    Map<String, List<MultipartFile>> data = {"files": []};
    files.forEach((element) async {
      var file = await MultipartFile.fromFile(element.path,
          filename: basename(element.path), contentType: MediaType.parse("image/jpeg"));
      data['files']!.add(file);
    });
    var response = await postUpload(sprintf(UPLOAD_IMAGES, [uploadDir?.name ?? ""]),
        data: FormData.fromMap(data));

    return UploadAvatarResponse.fromJson(response).link!;
  }

  Future<ConstantList> getConstantList() async {
    final response = await get(LIST_TOTAL_CONSTANT);
    return ConstantList.fromJson(response);
  }

  Future<AppConfig> getAppConfig(AppConfigRequest appConfigRequest) async {
    final response = await post(CHECK_UPDATE_APP, data: appConfigRequest.toJson());
    return AppConfig.fromJson(response);
  }

  tracking(TrackingRequest request) async {
    await post(TRACKING, data: request.toJson());
  }

  Future<SearchUserAdvanceResponse> searchUserAdvance(
      String? textSearch, int skip, bool isFirst, int limit) async {
    final response = await get(SEARCH_USER_ADVANCE,
        params: GetQueryParam(
          skip: skip,
          limit: limit,
          filters: [
            FilterRequestItem(key: "isFirst", value: isFirst),
            FilterRequestItem(key: "text", value: textSearch),
          ],
        ).toJson());
    return SearchUserAdvanceResponse.fromJson(response);
  }

  Future<SearchPostAdvanceResponse> searchPostAdvance(
      String? textSearch, int skip, bool isFirst, int limit) async {
    final response = await get(
      SEARCH_POST_ADVANCE,
      params: GetQueryParam(
        skip: skip,
        limit: limit,
        filters: [
          FilterRequestItem(key: "isFirst", value: isFirst),
          FilterRequestItem(key: "text", value: textSearch),
        ],
      ).toJson(),
    );
    return SearchPostAdvanceResponse.fromJson(response);
  }

  Future<Gift> getGiftDetail(String giftId) async {
    final response = await get(sprintf(GIFT_DETAIL, [giftId]));
    return Gift.fromJson(response);
  }

  Future<SearchTopicAdvanceResponse> searchTopicAdvance(
      String? textSearch, int skip, bool isFirst, int limit) async {
    final response = await get(
      SEARCH_TOPIC_ADVANCE,
      params: GetQueryParam(skip: skip, limit: limit, filters: [
        FilterRequestItem(
          key: "isFirst",
          value: isFirst,
        ),
        FilterRequestItem(
          key: "text",
          value: textSearch,
        ),
      ], sorts: [
        FilterRequestItem(
          key: "numberOfPost",
          value: -1,
        )
      ]).toJson(),
    );
    return SearchTopicAdvanceResponse.fromJson(response);
  }

  Future<List<DiscoveryItem>> getDiscoveryList(
    int page,
    int limit,
  ) async {
    final response = await get(
      DISCOVERY_LIST,
      params: GetQueryParam(page: page, limit: limit, sorts: [
        FilterRequestItem(
          key: "priority",
          value: 1,
        )
      ]).toJson(),
    );
    return List<DiscoveryItem>.from(response.map((item) => DiscoveryItem.fromJson(item))).toList();
  }

  Future<List<DiscoveryItemGroup>> getDiscoveryListDetail(
    int page,
    int limit,
    DiscoveryItem item,
  ) async {
    final response = await get(
      sprintf(DISCOVERY_DETAIL, [item.id]),
      params: GetQueryParam(page: page, limit: limit).toJson(),
    );
    List<DiscoveryItemGroup>? result;
    switch (item.type?.id) {
      case DiscoveryItemTypeId.post:
        result = List<NewFeed>.from(response.map((item) => NewFeed.fromJson(item))).toList();
        break;
      case DiscoveryItemTypeId.profile:
        result = List<User>.from(response.map((item) => User.fromJson(item))).toList();
        break;
      case DiscoveryItemTypeId.topic:
        result = List<TopictItem>.from(response.map((item) => TopictItem.fromJson(item))).toList();
        break;
      case DiscoveryItemTypeId.gift:
        result = List<Gift>.from(response.map((item) => Gift.fromJson(item))).toList();
        break;
      case DiscoveryItemTypeId.banner:
        result = List<Event>.from(response.map((item) => Event.fromJson(item))).toList();
        break;
    }
    return result ?? [];
  }

  logError(ErrorLog errorLog) async {
    // await post(LOG_ERROR, data: errorLog.toJson());
  }

  sharePost(String postId) async {
    post(sprintf(SHARE_POST, [postId]));
  }
}
