import 'package:lomo/data/api/models/tracking_request.dart';
import 'package:lomo/data/api/models/tracking_time.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';

class TrackTimeType {
  static const String none = "none";
  static const String newsfeedTabSession = "Newsfeed_Session";
  static const String discoveryTabSession = "Discovery_Session";
  static const String notificationTabSession = "Notif_Session";
  static const String profileTabSession = "Profile_Session";
  static const String feedsSession = "Feed_Session";
  static const String chatSession = "Msg_Session";
  static const String datingSession = "Dating_Session";
  static const String appOnSite = "Time_Onsite";

  static const mainTabSessions = const [
    newsfeedTabSession,
    discoveryTabSession,
    notificationTabSession,
    profileTabSession
  ];
}

class TrackingManager {
  final _commonRepository = locator<CommonRepository>();
  List<TrackingTime> trackTimes = [];
  init() {}

  tracking(TrackingRequest request) async {
    try {
      _commonRepository.tracking(request);
    } catch (e) {
      print(e);
    }
  }

  updateTrackingTime(String type) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TrackingTime currentItemTracking = trackTimes.firstWhere(
        (element) => element.type == type,
        orElse: () => TrackingTime(TrackTimeType.none, 0));
    if (currentItemTracking.type != TrackTimeType.none) {
      currentItemTracking.timeStartTracking = currentTime;
    }
  }

  startTrackTime() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    trackTimes.add(TrackingTime(TrackTimeType.newsfeedTabSession, currentTime));
    trackTimes.add(TrackingTime(TrackTimeType.feedsSession, currentTime));
    trackTimes.add(TrackingTime(TrackTimeType.appOnSite, currentTime));
  }

  pauseTrackTime() {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    trackTimes.forEach((element) {
      if (element.type != TrackTimeType.appOnSite) {
        tracking(TrackingRequest(
            event: element.type,
            session: currentTime - element.timeStartTracking));
      }
    });
  }

  resumeTrackAppOnSite() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TrackingTime currentItemTracking = trackTimes.firstWhere(
        (element) => element.type == TrackTimeType.appOnSite,
        orElse: () => TrackingTime(TrackTimeType.none, 0));
    if (currentItemTracking.type != TrackTimeType.none) {
      currentItemTracking.timeStartTracking = currentTime;
    }
  }

  pauseTrackAppOnSite() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TrackingTime currentItemTracking = trackTimes.firstWhere(
        (element) => element.type == TrackTimeType.appOnSite,
        orElse: () => TrackingTime(TrackTimeType.none, 0));
    if (currentItemTracking.type != TrackTimeType.none) {
      tracking(TrackingRequest(
          event: currentItemTracking.type,
          session: currentTime - currentItemTracking.timeStartTracking));
    }
  }

  resumeTrackTime() {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    trackTimes.forEach((element) {
      element.timeStartTracking = currentTime;
    });
  }

  startTrackChatSession() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    trackTimes.add(TrackingTime(TrackTimeType.chatSession, currentTime));
  }

  stopTrackChatSession() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    TrackingTime currentItemTracking = trackTimes.firstWhere(
        (element) => element.type == TrackTimeType.chatSession,
        orElse: () => TrackingTime(TrackTimeType.none, 0));
    if (currentItemTracking.type != TrackTimeType.none) {
      tracking(TrackingRequest(
          event: currentItemTracking.type,
          session: currentTime - currentItemTracking.timeStartTracking));
    }
    trackTimes
        .removeWhere((element) => element.type == TrackTimeType.chatSession);
  }

  trackLoginNew() async {
    tracking(TrackingRequest(event: "Login_New"));
  }

  trackLoginRe() async {
    tracking(TrackingRequest(event: "Login_Re"));
  }

  trackRegisterOtp() async {
    tracking(TrackingRequest(event: "newreg_otp"));
  }

  trackRegisterName() async {
    tracking(TrackingRequest(event: "newreg_name"));
  }

  trackRegisterBirthDay() async {
    tracking(TrackingRequest(event: "newreg_bday"));
  }

  trackRegisterSogiesc() async {
    tracking(TrackingRequest(event: "newreg_sogi"));
  }

  trackRegisterImage() async {
    tracking(TrackingRequest(event: "newreg_pic"));
  }

  trackHomeTab(int tabIndex) async {
    switch (tabIndex) {
      case 0:
        updateTrackingTimeTab(TrackTimeType.newsfeedTabSession, tabIndex);
        updateTrackingTime(TrackTimeType.feedsSession);
        updateTrackingTime(TrackTimeType.datingSession);
        tracking(TrackingRequest(event: "Newsfeed_Btn"));
        break;
      case 1:
        updateTrackingTimeTab(TrackTimeType.discoveryTabSession, tabIndex);
        tracking(TrackingRequest(event: "Discovery_Btn"));
        break;
      case 2:
        // tracking(TrackingRequest(event: "Post_New"));
        break;
      case 3:
        updateTrackingTimeTab(TrackTimeType.notificationTabSession, tabIndex);
        tracking(TrackingRequest(event: "Notif_Btn"));
        break;
      case 4:
        updateTrackingTimeTab(TrackTimeType.profileTabSession, tabIndex);
        tracking(TrackingRequest(event: "Profile_Btn"));
        break;
      default:
        break;
    }
  }

  updateTrackingTimeTab(String tabType, int tabIndex) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    trackTimes.forEach((element) {
      if (TrackTimeType.mainTabSessions.contains(element.type)) {
        tracking(TrackingRequest(
            event: element.type,
            session: currentTime - element.timeStartTracking));
      }
    });

    // nếu khác tab nổi bật thì kiểm tra xem tab trước khi click qua tab mới có phải là tab nổi bật không
    // nếu là tab trước đó là nổi bật thì đẩy tracking của tab con lên
    final trackTabNewFeed = trackTimes.firstWhere(
        (element) => element.type == TrackTimeType.newsfeedTabSession,
        orElse: () => TrackingTime(TrackTimeType.none, 0));
    if (trackTabNewFeed.type != TrackTimeType.none) {
      final subTabNewFeed = trackTimes.firstWhere(
          (element) =>
              element.type == TrackTimeType.feedsSession ||
              element.type == TrackTimeType.datingSession,
          orElse: () => TrackingTime(TrackTimeType.none, 0));
      if (subTabNewFeed.type != TrackTimeType.none) {
        tracking(TrackingRequest(
            event: subTabNewFeed.type,
            session: currentTime - subTabNewFeed.timeStartTracking));
      }
    }

    // xóa tab trước đó sau khi tracking
    trackTimes.removeWhere(
        (element) => TrackTimeType.mainTabSessions.contains(element.type));
    // add start track cho tab mới click
    trackTimes.add(TrackingTime(tabType, currentTime));
  }

  trackHighlightTab(int index) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    switch (index) {
      case 0:
        tracking(TrackingRequest(event: "Feed_Btn"));
        trackTimes.forEach((element) {
          if (element.type == TrackTimeType.datingSession) {
            tracking(TrackingRequest(
                event: TrackTimeType.datingSession,
                session: currentTime - element.timeStartTracking));
          }
        });
        trackTimes.removeWhere(
            (element) => element.type == TrackTimeType.datingSession);
        trackTimes.add(TrackingTime(TrackTimeType.feedsSession, currentTime));
        break;

      case 1:
        trackTimes.forEach((element) {
          if (element.type == TrackTimeType.feedsSession) {
            tracking(TrackingRequest(
                event: TrackTimeType.feedsSession,
                session: currentTime - element.timeStartTracking));
          }
        });
        trackTimes.removeWhere(
            (element) => element.type == TrackTimeType.feedsSession);
        trackTimes.add(TrackingTime(TrackTimeType.datingSession, currentTime));
        tracking(TrackingRequest(event: "Dating_Btn"));
        break;

      default:
        break;
    }
  }

  trackFilterFeed() async {
    tracking(TrackingRequest(event: "Filter_Btn"));
  }

  trackOpenChatConversation() async {
    tracking(TrackingRequest(event: "Msg_Btn"));
  }

  trackOpenChatWithUser(String userId) async {
    tracking(TrackingRequest(event: "Msg_1-1", profile: userId));
  }

  trackViewDatingProfileDetail(String userId) async {
    tracking(TrackingRequest(event: "DatingPf_Btn", profile: userId));
  }

  trackWhoSuitsMeButton(String userId, {String? quizId}) async {
    tracking(TrackingRequest(event: "YNM_Btn", profile: userId, quiz: quizId));
  }

  trackDatingFilter() {
    tracking(TrackingRequest(event: "DatingFilter_Btn"));
  }

  trackBanner(String? eventId) {
    tracking(TrackingRequest(event: "Banner_Btn", banner: eventId));
  }

  trackSearchButton() async {
    tracking(TrackingRequest(event: "Search_Btn"));
  }

  trackViewMoreTopicHot() async {
    // tracking(TrackingRequest(event: "Topic_Sm"));
  }

  trackTopicHotDetail(String? topicId) async {
    // tracking(TrackingRequest(event: "Topic_Dtd", topic: topicId));
  }

  trackViewMoreHotMember() async {
    // tracking(TrackingRequest(event: "Hot_mem_Sm"));
  }

  trackHotMemberDetail(String? userId) async {
    // tracking(TrackingRequest(event: "Hot_mem_Pf", profile: userId));
  }

  trackViewMoreForYou() async {
    // tracking(TrackingRequest(event: "4U_Sm"));
  }

  trackForYouDetail(String? topicId) async {
    // tracking(TrackingRequest(event: "4U_Dtd", topic: topicId));
  }

  trackKnowledge() async {
    tracking(TrackingRequest(event: "KNWL_Dtd"));
  }

  trackEditProfile() async {
    tracking(TrackingRequest(
      event: "Profile_Setting",
    ));
  }

  trackMyBad() async {
    tracking(TrackingRequest(
      event: "Candy_Btn",
    ));
  }

  trackCheckIn() async {
    tracking(TrackingRequest(
      event: "Candy_checkin",
    ));
  }

  trackRewardExchange() async {
    tracking(TrackingRequest(
      event: "Candy_Prize",
    ));
  }

  trackGiftDetail(String? giftId) async {
    tracking(TrackingRequest(
      event: "Gift_Detail",
      gift: giftId,
    ));
  }

  trackConfirmCheckIn() async {
    tracking(TrackingRequest(
      event: "Checkin_On",
    ));
  }

  trackDeniedCheckIn() async {
    tracking(TrackingRequest(
      event: "Checkin_Denied",
    ));
  }

  trackCallButton() async {
    tracking(TrackingRequest(
      event: "Call_btn",
    ));
  }

  trackVideoCallButton() async {
    tracking(TrackingRequest(
      event: "Vcall_btn",
    ));
  }

  trackReferralEnterCodeStepRegister() async {
    tracking(TrackingRequest(
      event: "Ref_new_1",
    ));
  }

  trackNearRequestLocationButton() async {
    tracking(TrackingRequest(
      event: "Near_btn",
    ));
  }

  trackNearViewMore() async {
    tracking(TrackingRequest(
      event: "Near_um",
    ));
  }

  trackClickLinkLomoShareFromNetAloChat(String? postId) {
    tracking(TrackingRequest(event: "Lomo_Sharelink", post: postId));
  }
}
