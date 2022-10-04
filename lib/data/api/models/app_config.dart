import 'discovery_item.dart';

class AppConfig {
  AppConfig({
    this.isForceUpdate = false,
    this.isUpdateApp = false,
    this.hasFuncUpdateApp = false,
    this.hasFuncSogiesTest = true,
    this.description,
    this.photoUrl,
    this.videoUrl,
    this.officialLomo,
    this.supportLomo,
    this.isEvent = false,
    this.isCheckIn = true,
    this.isChat = true,
    this.eventUrl = "",
    this.iconEventImage = "",
    this.bannerEventImage = "",
    this.discoveries = const [],
    this.isDeleteAccount = true,
    this.isVideo = false,
  });

  bool isForceUpdate;
  bool isUpdateApp;
  bool hasFuncUpdateApp;
  bool hasFuncSogiesTest;
  String? description;
  String? photoUrl;
  String? videoUrl;
  String? officialLomo;
  String? supportLomo;
  bool isEvent;
  bool isCheckIn;
  bool isChat;
  bool isVideo;
  bool isDeleteAccount;
  String eventUrl;
  String iconEventImage;
  String bannerEventImage;
  List<DiscoveryItem> discoveries;

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        isForceUpdate: json["isForceUpdate"] ?? false,
        isUpdateApp: json["isUpdateApp"] ?? false,
        hasFuncUpdateApp: json["hasFuncUpdateApp"] ?? false,
        hasFuncSogiesTest: json["hasFuncSogiesTest"] ?? true,
        description: json["description"] ?? "",
        photoUrl: json["photoUrl"] ?? "",
        videoUrl: json["videoUrl"] ?? "",
        officialLomo: json["officialLomo"],
        supportLomo: json["supportLomo"],
        isEvent: json["isEvent"] ?? false,
        isCheckIn: json["isCheckIn"] ?? true,
        isChat: json["isChat"] ?? true,
        eventUrl: json["eventUrl"] ?? "",
        iconEventImage: json["iconEventImage"] ?? "",
        bannerEventImage: json["bannerEventImage"] ?? "",
        discoveries: json["discoveries"] != null
            ? List<DiscoveryItem>.from(
                json["discoveries"].map((x) => DiscoveryItem.fromJson(x)))
            : [],
        isDeleteAccount: json["isDeleteAccount"] ?? true,
        isVideo: json["isVideo"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "isForceUpdate": isForceUpdate,
        "isUpdateApp": isUpdateApp,
        "hasFuncUpdateApp": hasFuncUpdateApp,
        "hasFuncSogiesTest": hasFuncSogiesTest,
        "description": description,
        "photoUrl": photoUrl,
        "videoUrl": videoUrl,
        "officialLomo": officialLomo,
        "supportLomo": supportLomo,
        "isEvent": isEvent,
        "isCheckIn": isCheckIn,
        "isChat": isChat,
        "eventUrl": eventUrl,
        "iconEventImage": iconEventImage,
        "bannerEventImage": bannerEventImage,
        "discoveries": List<dynamic>.from(
          discoveries.map((x) => x.toJson()),
        ),
        "isDeleteAccount": isDeleteAccount,
        "isVideo": isVideo,
      };
}
