import 'package:lomo/data/api/models/dating_status.dart';
import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/notification_type.dart';
import 'package:lomo/res/strings.dart';

final GENDERS = [
  Gender(id: "5ed34251e6278057e83ac671", name: Strings.male, key: "male"),
  Gender(id: "5ed34251e6278057e83ac687", name: Strings.female, key: "female"),
  Gender(id: "5ed34251e6278057e83ac691", name: Strings.other, key: "other")
];

final DATING_STATUS = [
  DatingStatus(id: DatingStatusId.approved, name: Strings.approved),
  DatingStatus(id: DatingStatusId.reject, name: Strings.reject),
  DatingStatus(id: DatingStatusId.waiting, name: Strings.waiting),
  DatingStatus(id: DatingStatusId.notVerify, name: Strings.notVerify),
];

enum FollowType { follower, following }

enum CommentType { post }

enum WhoSuitsMeAnswerStatus { init, check, verify }

enum LinkSourceType { app, netAlo, deepLink, other }

class SocketModelType {
  static const post = "Post";
  static const event = "Event";
  static const user = "User";
}

class SocketActionType {
  static const lock = "lock";
  static const delete = "delete";
  static const notify = "notify";
  static const follow = "follow";
  static const unfollow = "unfollow";
  static const accountActivated = "accountActivated";
  static const accountDeactivated = "accountDeactivated";
}

class DatingStatusId {
  static const approved = "60a37f80fb2da21e0584e90f";
  static const reject = "60a37f80fb2da21e0584e90e";
  static const waiting = "60a37f80fb2da21e0584e90d";
  static const notVerify = "60a48788d9e953509675a875";
}

class DeepLinkType {
  static const post = "post";
  static const message = "message";
  static const profile = "profile";
}

class DeepLinkQuery {
  static const type = "type";
  static const id = "id";
}

class UserDatingFieldDisabled {
  static const datingTitle = "datingTitle";
  static const datingRole = "datingRole";
  static const datingZodiac = "datingZodiac";
  static const datingHeightWeight = "datingHeightWeight";
  static const datingProvince = "datingProvince";
  static const datingLiteracy = "datingLiteracy";
  static const datingCareers = "datingCareers";
  static const datingHobbies = "datingHobbies";
}

class UserFieldDisabled {
  static const birthday = "birthday";
  static const weight = "weight";
  static const province = "province";
  static const zodiac = "zodiac";
  static const relationship = "relationship";
  static const literacy = "literacy";
  static const sogiescs = "sogiescs";
  static const hobbies = "hobbies";
  static const careers = "careers";
  static const gender = "gender";
  static const title = "title";
  static const age = "age";
  static const role = "role";
  static const email = "email";
}

const UserFieldDisabledListGender = [
  UserFieldDisabled.gender,
  UserFieldDisabled.sogiescs,
  UserFieldDisabled.title
];

const UserFieldDisabledListDetail = [
  UserFieldDisabled.age,
  UserFieldDisabled.birthday,
  UserFieldDisabled.email,
  UserFieldDisabled.relationship,
  UserFieldDisabled.hobbies,
  UserFieldDisabled.careers,
  UserFieldDisabled.literacy,
  UserFieldDisabled.province,
  UserFieldDisabled.weight,
  UserFieldDisabled.zodiac,
];

class TopicTypeId {
  static const hot = "60aca65e3316acaeb46e806f";
  static const forYou = "60aca65e3316acaeb46e8070";
  static const knowledge = "60aca65e3316acaeb46e8071";
}

class WebViewType {
  static const String sogiescTest = "sogiesc_test";
  static const String report = "report";
  static const String event = "event";
}

class KnowledgeTopicId {
  static final official = "official";
  static final others = "others";
}

class DiscoveryKey {
  static const postHot = "postHot";
  static const topicHot = "topicHot";
  static const lomoChoice = "lomoChoice";
  static const peopleNear = "peopleNear";
  static const giftHot = "giftHot";
  static const peopleHot = "peopleHot";
  static const companion = "companion";
  static const eventQueer = "eventQueer";
  static const forU = "forU";
  static const knowledge = "knowledge";
}

const DEFAULT_LAT = 10.7939734;
const DEFAULT_LNG = 106.664401;
const MAX_LENGTH_USERNAME = 50;
const DEFAULT_DISTANCE = 2000.0;

// Event type
const EVENT_TYPE_SLIDER = "5fe95d6f438161234fc20762";
const EVENT_TYPE_LIST = "5fe95d6f438161234fc20763";

final LIST_NOTIFICATION_DATA_TYPE = [
  NotificationType(id: null, name: Strings.allActivities),
  NotificationType(id: "5f2a256f231afd03a5061996", name: Strings.system),
  NotificationType(id: "5ffd2136673b00121ef626b9", name: Strings.userSupport),
  NotificationType(id: "5ffd2136673b00121ef626ba", name: Strings.account),
  NotificationType(id: "5ffd2136673b00121ef626bb", name: Strings.postActivity),
  NotificationType(
      id: "5ffd2136673b00121ef626bc", name: Strings.getBearCandiesGifts),
];

final NOTIFICATION_NOTIFY_DETAIL = [
  //------------------------------------He thong------------------------------------(0 1 2)-----------------------------
  NotificationType(id: "5f2a2522231afd03a5061995", name: "Thông báo hệ thống"),
  NotificationType(id: "5ed34887e6278057e83ada0f", name: "Ma xac thuc: {otp}."),
  NotificationType(
      id: "5ed34887e6278057e83ad9f9",
      name: "Mat khau dang nhap cua ban: {password}."),
  //-------------------------------------Hoat dong bai dang--------------------------(3 4 5)--------------------------------------
  NotificationType(
      id: "5ffd2642673b00121ef626bd",
      name: "{name} đã thả tim bài viết của bạn"),
  NotificationType(
      id: "5ffd2642673b00121ef626be",
      name: "{name} đã bình luận bài viết của bạn"),
  NotificationType(
      id: "5ffd2642673b00121ef626bf",
      name: "{name} đã nhắc đến bạn trong một bài viết/bình luận"),
  //-----------------------------------------Nhan keo & qua tang-----------------------(6 7 - 8 9 10)-------------------------------------
  // -- Gau & keo --
  NotificationType(
      id: "5ffd2642673b00121ef626c0", name: "Bạn đã được {name} tặng gấu"),
  NotificationType(
      id: "5ffd2642673b00121ef626c1", name: "Bạn đã nhận thêm {candy} kẹo"),
  //-- Qua --
  NotificationType(
      id: "5ffd2642673b00121ef626c2",
      name: "Bạn đã đổi thành công {candy} kẹo lấy {gift}"),
  NotificationType(
      id: "5ffd29d2673b00121ef626ca", name: "Quà của bạn đã được xác nhận"),
  NotificationType(
      id: "5ffd2642673b00121ef626c3",
      name:
          "Quà của bạn đã được xác nhận và sẽ được giao đến bạn trong vòng 7 ngày"),
  //-------------------------------------------------Tai khoan----------------------------(11 12 13)------------------------
  NotificationType(
      id: "5ffd2642673b00121ef626c4", name: "Bạn đã được {name} theo dõi"),
  NotificationType(
      id: "5ffd2642673b00121ef626c5",
      name: "Bạn và {name} đã chính thức kết nối với nhau"),
  NotificationType(id: "5ffd2642673b00121ef626c6", name: "Bạn đã chặn {name}"),
  //-------------------------------------------------Ho tro nguoi dung------------------------(14 15 16)----------------------------
  NotificationType(
      id: "5ffd2642673b00121ef626c7",
      name: "Bạn đã gửi phản hồi đến LOMO thành công"),
  NotificationType(
      id: "5ffd2642673b00121ef626c8",
      name: "Bài viết của bạn đã bị tạm gỡ do vi phạm chính sách người dùng"),
  NotificationType(
      id: "5ffd2642673b00121ef626c9",
      name:
          "Tài khoản của bạn đã bị tạm ngừng hoạt động do vi phạm chính sách người dùng"),

  //------------------------(17)----------------------
  NotificationType(id: "6062c48fb2d3fc540b7f5601", name: "Reply"),
  //-------------------------quiz ai hợp tôi---------------------(18)
  NotificationType(id: "60e66f45c4bb314345430035", name: "Hoàn thành bài quiz"),
  //-------------------------làm quen---------------------(19)
  NotificationType(id: "6108d93294f06f4f2ebe506f", name: "Làm quen"),
  //-------------------------người giới thiệu---------------------(20)
  NotificationType(id: "625e75e2f0af27b14cb3aef6", name: "người giới thiệu"),
  //-------------------------người được giới thiệu---------------------(21)
  NotificationType(
      id: "625e75e2f0af27b14cb3aef7", name: "người được giới thiệu"),
];

class FilterHighlight {
  static const newKey = "createdAt";
  static const hotKey = "numberOfFavorite";
  static const forYouKey = "for_you";
  static const followKey = "following";
}

class DiscoveryItemTypeId {
  static const post = "6209ccd497e3e72f60224943";
  static const profile = "6209ccd497e3e72f60224944";
  static const topic = "6209ccd497e3e72f60224945";
  static const gift = "6209ccd497e3e72f60224946";
  static const banner = "6209ccd497e3e72f60224947";
  static const profileNear = "6258de860d9160ca0d45e026";
  static const knowledge = "6258de860d9160ca0d45e027";
}

class DiscoveryItemGroup {
  Map<String, dynamic> toJson() => {};
}

class GiftTypeId {
  static const voucher = "623bf70563678cdc29ed0166";
  static const material = "623bf70563678cdc29ed0167";
}

class ApiCodType {
  static const userLocked = "UserLocked";
  static const userDeleted = "UserDeleted";
  static const userDeactivated = "UserDeactivated";
  static const userNotFound = "UserNotFound";
}

class UserStatus {
  static const active = 0;
  static const deActive = 1;
  static const deleted = 2;
}
