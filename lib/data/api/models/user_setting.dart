class UserSetting {
  bool isVideoAutoPlay;
  bool hasSoundVideoAutoPlay = false;

  UserSetting(
      {this.isVideoAutoPlay = true, this.hasSoundVideoAutoPlay = false});
  factory UserSetting.fromJson(Map<String, dynamic> json) => UserSetting(
        // hasSoundVideoAutoPlay: json["hasSoundVideoAutoPlay"] ?? false,
        isVideoAutoPlay: json["isVideoAutoPlay"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        // "hasSoundVideoAutoPlay": hasSoundVideoAutoPlay,
        "isVideoAutoPlay": isVideoAutoPlay,
      };
}
