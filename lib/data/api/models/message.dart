class Message {
  Message({
    this.avatar,
    this.name,
    this.lastMessage,
    this.updateAt,
    this.unReadCount,
  });

  String? avatar;
  String? name;
  String? lastMessage;
  String? updateAt;
  bool? unReadCount;
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        avatar: json["avatar"],
        name: json["name"],
        lastMessage: json["lastMessage"],
        updateAt: json["updateAt"],
        unReadCount: json["unReadCount"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "name": name,
        "lastMessage": lastMessage,
        "updateAt": updateAt,
        "unReadCount": unReadCount,
      };
}
