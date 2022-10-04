import 'dart:typed_data';

import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/app_config.dart';
import 'package:lomo/data/api/models/checkin.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/discovery_item.dart';
import 'package:lomo/data/api/models/enums.dart';
import 'package:lomo/data/api/models/event.dart';
import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/data/api/models/quiz_template.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/request/app_config_request.dart';
import 'package:lomo/data/api/models/search_post_advance_response.dart';
import 'package:lomo/data/api/models/search_topic_advance_response.dart';
import 'package:lomo/data/api/models/search_user_advance_response.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/tracking_request.dart';
import 'package:lomo/data/api/models/who_suits_me_answer.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/api/services/common_service.dart';
import 'package:lomo/data/preferences/preferences.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/util/common_utils.dart';
import 'package:lomo/util/constants.dart';

class CommonRepository {
  var _commonService = locator<CommonService>();
  List<Zodiac>? listZodiac;
  List<Sogiesc>? listSogiesc;
  List<Relationship>? listRelationship;
  List<City>? listCity;
  List<KeyValue>? listCareer;
  late List<KeyValue> listTitle;
  List<Literacy>? listLiteracy;
  late List<Hobby> listHobby;
  List<Role>? roles;
  late List<ModelItemSimple> listSampleMessageDating;
  List<QuizTemplate>? quizTemplate;
  List<KeyValue>? listReasonDeleteAccount;

  Future<ConstantList?> getConstantList() async {
    getCities();
    final ConstantList? res = await _commonService.getConstantList();
    if (res != null) {
      listZodiac = res.typeZodiac!;
      listSogiesc = res.typeSogiesc!;
      listRelationship = res.typeRelationship!;
      listCareer = res.career!;
      listLiteracy = res.literacy!;
      listHobby = res.hobby!;
      roles = res.roles!;
      listSampleMessageDating = res.typeMessage!;
      listTitle = res.titles!;
      quizTemplate = res.quizTemplate!;
      listReasonDeleteAccount = res.reasonDeleteAccount!;
    }
    return res;
  }

  Future<String?> uploadImageFromBytes(Uint8List file,
      {Function(int, int)? percentCallback,
      UploadDirName? uploadDir,
      int retries = 2}) async {
    try {
      return _commonService.uploadImageFromBytes(file,
          percentCallback: percentCallback, uploadDir: uploadDir);
    } catch (e) {
      if (retries > 0) {
        retries--;
        return _commonService.uploadImageFromBytes(file,
            percentCallback: percentCallback, uploadDir: uploadDir);
      }
    }
    return null;
  }

  Future<String?> uploadVideo(
      Uint8List? u8List, Function(int, int) percentCallback,
      {UploadDirName? uploadDir, int retries = 2}) async {
    try {
      return _commonService.uploadVideo(
        u8List,
        percentCallback,
        uploadDir: uploadDir,
      );
    } catch (e) {
      if (retries > 0) {
        retries--;
        return _commonService.uploadVideo(u8List, percentCallback,
            uploadDir: uploadDir);
      }
    }
    return null;
  }

  Future<bool> isSendFCMToken() async {
    return Preferences.isSendFCMToken();
  }

  setSendFCMToken(bool isSent) async {
    await Preferences.setSendFCMToken(isSent);
  }

  Future<bool> isShowPopupCheckin() async {
    return Preferences.isShowPopupCheckin();
  }

  setShowPopupCheckin(String currentDay) async {
    await Preferences.setCurrentDayShowPopupCheckin(currentDay);
  }

  setDontShowCheckTimeVQMM(bool value) async {
    await Preferences.setShowVQMM(value);
  }

  Future<bool> isDonShowAgainVQMM() async {
    return Preferences.isNoShowAgainVQMM();
  }

  setShow(String currentDay) async {
    await Preferences.setCurrentDayShowPopupCheckin(currentDay);
  }

  Future<bool> isShowCheckTimeVQMM() async {
    return Preferences.isShowPopupCheckTimeVQMM();
  }

  setShowVQMM(String currentDay) async {
    await Preferences.setCurrentDayShowPopupCheckVQMM(currentDay);
  }

  setTheme(int theme) async {
    await Preferences.setTheme(theme);
  }

  Future<int> getTheme() async {
    return Preferences.getTheme();
  }

  setSearchRecently(List<String> texts) async {
    return Preferences.setSearchRecently(texts);
  }

  Future<List<String>> getSearchRecently() async {
    return Preferences.getSearchRecently();
  }

  setFirstUseApp(bool value) async {
    Preferences.setFirstUseApp(value);
  }

  Future<bool> isFirstUseApp() async {
    return Preferences.isFirstUseApp();
  }

  setShowSogiesTest(bool value) async {
    Preferences.setShowSogiesTest(value);
  }

  Future<bool> isShowSogiesTest() async {
    return Preferences.isShowSogiesTest();
  }

  Future<List<City>> getCities({String? id}) async {
    if (listCity?.isEmpty == true || listCity == null) {
      listCity = await _commonService.getCities();
    }
    return listCity!;
  }

  Future<List<City>> getDistrict({required String id}) async {
    return await _commonService.getDistrict(id);
  }

  Future<List<City>> getWard({required String id}) async {
    return await _commonService.getWard(id);
  }

  Future<List<Event>> getSliderEvents() async {
    return _commonService.getEvents(1, 100, EVENT_TYPE_SLIDER);
  }

  Future<List<Event>> getOutStandingEvents(int page, pageSize) async {
    return _commonService.getEvents(1, 100, EVENT_TYPE_LIST);
  }

  Future<List<TopictItem>> getSearchTopic(String textSearch, int page,
      {int limit = PAGE_SIZE, bool isSort = false}) async {
    return _commonService.getSearchTopic(textSearch, page, limit, isSort);
  }

  Future<List<HashTag>> searchHashTag(String textSearch, int page,
      {int limit = PAGE_SIZE, bool isTrend = false}) async {
    return _commonService.searchHashTag(textSearch, page, limit,
        isTrend: isTrend);
  }

  Future<List<TopictItem>> getListHotTopic(int page, int pageSize) async {
    return _commonService.getListTopicWithType(
        "60aca65e3316acaeb46e806f", page, pageSize);
  }

  Future<List<TopictItem>> getListForYouTopic(int page, int pageSize) async {
    return _commonService.getListTopicWithType(
        "60aca65e3316acaeb46e8070", page, pageSize);
  }

  Future<List<TopictItem>> getListKnowledgeTopic(int page, int pageSize) async {
    final data = await _commonService.getListKnowledgeSubject(page, pageSize);
    data.forEach((element) {
      if (element.id == KnowledgeTopicId.official) {
        element.name = Strings.knowledgeOfficial;
        element.imageLocal = DImages.lomoOfficial;
      } else {
        element.name = Strings.knowledgePublic;
        element.imageLocal = DImages.publishLomo;
      }
    });
    return data;
  }

  Future<List<Gift>> getGifts(int page, int pageSize, {bool? isHot}) async {
    return _commonService.getGifts(page, pageSize, isHot: isHot);
  }

  Future<Gift> getGiftDetail(String giftId) async =>
      _commonService.getGiftDetail(giftId);

  Future<List<Checkin>> getListCheckin() async {
    return _commonService.getListCheckin();
  }

  Future<void> checkin() async {
    return _commonService.checkin();
  }

  Future<List<WhoSuitsMeQuestion>> getQuizTemplate() async {
    if (quizTemplate == null || quizTemplate?.length == 0) return [];
    final questions = quizTemplate
        ?.map((question) => WhoSuitsMeQuestion(
            id: question.id,
            name: question.name,
            priority: question.priority,
            answers: question.answers
                .map((answer) => WhoSuitsMeAnswer(id: "", name: answer))
                .toList()))
        .toList();

    return questions!;
  }

  Future<List<Zodiac>?> getZodiac() async {
    if (listZodiac?.isEmpty == true || listZodiac == null) {
      var res = await getConstantList();
      listZodiac = res!.typeZodiac!;
      listZodiac!.sort((a, b) => a.name!.compareTo(b.name!));
    }
    return listZodiac;
  }

  Future<List<Role>?> getRoles() async {
    if (roles!.isEmpty == true || roles == null) {
      var res = await getConstantList();
      roles = res!.roles!;
      roles!.sort((a, b) => a.name!.compareTo(b.name!));
    }
    return roles;
  }

  Future<List<Sogiesc>?> getSogiesc() async {
    if (listSogiesc!.isEmpty == true || listSogiesc == null) {
      var res = await getConstantList();
      listSogiesc = res!.typeSogiesc!;
      for (int i = 0; i < listSogiesc!.length; i++) {
        listSogiesc![i].priority = listSogiesc![i].priority;
      }
    }
    return listSogiesc;
  }

  Future<List<Relationship>?> getRelationship() async {
    if (listRelationship!.isEmpty == true || listRelationship == null) {
      var res = await getConstantList();
      listRelationship = res!.typeRelationship!;
      listRelationship!.sort((a, b) => a.name!.compareTo(b.name!));
    }
    return listRelationship;
  }

  Future<List<Literacy>?> getListLiteracy() async {
    if (listLiteracy!.isEmpty == true || listLiteracy == null) {
      var res = await getConstantList();
      listLiteracy = res!.literacy!;
      listLiteracy!.sort((a, b) => a.name!.compareTo(b.name!));
    }
    return listLiteracy;
  }

  Future<List<KeyValue>?> getListCareer() async {
    if (listCareer?.isEmpty == true || listCareer == null) {
      var res = await getConstantList();
      listCareer = res!.career!;
    }
    return listCareer;
  }

  Future<List<Hobby>> getListHobby() async {
    if (listHobby.isEmpty == true) {
      var res = await getConstantList();
      listHobby = res!.hobby!;
    }
    return listHobby;
  }

  Future<String?> getDownloadImageDomain() async {
    return Preferences.getDownloadImageDomain();
  }

  setDownloadImageDomain(String domain) async {
    return Preferences.setDownloadImageDomain(domain);
  }

  Future<AppConfig> getAppConfig(AppConfigRequest appConfigRequest) async =>
      _commonService.getAppConfig(appConfigRequest);

  Future<AppConfig> getAppConfigLocal() async => Preferences.getAppConfig();

  setAppConfigLocal(AppConfig config) async => Preferences.setAppConfig(config);

  tracking(TrackingRequest request) async {
    return _commonService.tracking(request);
  }

  setShowToolTipCheckIn(bool value) async {
    Preferences.setShowToolTipCheckIn(value);
  }

  Future<bool> isShowToolTipCheckIn() async {
    return Preferences.isShowToolTipCheckIn();
  }

  Future<SearchUserAdvanceResponse> searchUserAdvance(
      String? textSearch, int skip, bool isFirst,
      {int limit = PAGE_SIZE}) async {
    return _commonService.searchUserAdvance(textSearch, skip, isFirst, limit);
  }

  Future<SearchPostAdvanceResponse> searchPostAdvance(
      String? textSearch, int skip, bool isFirst,
      {int limit = PAGE_SIZE}) async {
    return _commonService.searchPostAdvance(textSearch, skip, isFirst, limit);
  }

  Future<SearchTopicAdvanceResponse> searchTopicAdvance(
      String? textSearch, int skip, bool isFirst,
      {int limit = PAGE_SIZE}) async {
    return _commonService.searchTopicAdvance(textSearch, skip, isFirst, limit);
  }

  sharePost(String postId) async {
    return _commonService.sharePost(postId);
  }

  Future<List<DiscoveryItem>> getDiscoveryList({
    int page = 1,
    int limit = PAGE_SIZE,
  }) async =>
      _commonService.getDiscoveryList(page, limit);

  Future<List<DiscoveryItemGroup>> getDiscoveryListDetail(
    DiscoveryItem item, {
    int page = 1,
    int limit = PAGE_SIZE,
  }) async =>
      _commonService.getDiscoveryListDetail(page, limit, item);

  setCacheDiscoveryItems(List<DiscoveryItem> items) async {
    Preferences.setDiscoveryItems(items);
  }

  Future<List<DiscoveryItem>?> getCacheDiscoveryItems() async {
    return Preferences.getDiscoveryItems();
  }

  logError(
      {required Object exception,
      required StackTrace stackTrace,
      String? className}) async {
    try {
      await _commonService.logError(getErrorLog(
          exception: exception, stackTrace: stackTrace, className: className));
    } catch (e) {}
  }

  void clearAllData() {
    listZodiac!.clear();
    listSogiesc!.clear();
    listRelationship!.clear();
    listCareer!.clear();
    listLiteracy!.clear();
    listHobby.clear();
  }
}
