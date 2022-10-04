// To parse this JSON data, do
//
//     final notificationItem = notificationItemFromJson(jsonString);

class NotificationResponse {
  NotificationResponse({
    this.undRead,
    this.list,
  });

  int? undRead;
  List<NotificationItem>? list;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        undRead: json["unread"] ?? 0,
        list: json["list"] == null
            ? null
            : List<NotificationItem>.from(
                json["list"].map((x) => NotificationItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unread": undRead,
        "list": list?.isNotEmpty == true
            ? List<dynamic>.from(list!.map((x) => x.toJson()))
            : [],
      };
}

class NotificationItem {
  NotificationItem({
    this.id,
    this.title,
    this.content,
    this.sender,
    this.receiver,
    this.type,
    this.notify,
    this.post,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.quiz,
    this.push,
    this.cover,
    this.gift,
    this.opt,
  });

  String? id;
  String? title;
  String? content;
  Sender? sender;
  String? receiver;
  String? type;
  String? notify;
  String? post;
  String? quiz;
  String? gift;
  String? push;
  bool? isRead;
  int? createdAt;
  int? updatedAt;
  String? image;
  String? cover;
  Opt? opt;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
          id: json["id"],
          title: json["title"],
          content: json["content"] ?? "",
          sender:
              json["sender"] == null ? null : Sender.fromJson(json["sender"]),
          receiver: json["receiver"] ?? "",
          type: json["type"] ?? "",
          notify: json["notify"] ?? "",
          post: json["post"] ?? "",
          isRead: json["isRead"] ?? false,
          createdAt: json["createdAt"] ?? 0,
          updatedAt: json["updatedAt"] ?? 0,
          image: json["image"] ?? "",
          quiz: json["quiz"] ?? "",
          push: json["push"] ?? "",
          gift: json["gift"] ?? "",
          cover: json["cover"],
          opt: json["opt"] != null ? Opt.fromJson(json["opt"]) : null);

  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "title": title ?? "",
        "content": content ?? "",
        "sender": sender?.toJson(),
        "receiver": receiver ?? "",
        "type": type ?? "",
        "notify": notify ?? "",
        "post": post ?? "",
        "isRead": isRead ?? false,
        "createdAt": createdAt ?? 0,
        "updatedAt": updatedAt ?? 0,
        "image": image ?? "",
        "quiz": quiz ?? "",
        "push": push,
        "cover": cover,
        "gift": gift,
        "opt": opt?.toJson()
      };
}

class Opt {
  Opt({this.name, this.code, this.image});

  String? name;
  String? code;
  String? image;

  factory Opt.fromJson(Map<String, dynamic> json) => Opt(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code ?? "",
        "name": name ?? "",
        "image": image ?? "",
      };
}

class Sender {
  Sender({
    this.id,
    this.name,
    this.avatar,
    this.netAloId,
  });

  String? id;
  String? name;
  String? avatar;
  int? netAloId;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        avatar: json["avatar"] ?? "",
        netAloId: json["netAloId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "name": name ?? "",
        "avatar": avatar ?? "",
        "netAloId": netAloId ?? 0,
      };
}
