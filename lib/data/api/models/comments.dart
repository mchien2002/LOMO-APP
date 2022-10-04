// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

import 'package:lomo/data/api/models/user.dart';

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.id,
    this.image,
    this.content,
    this.tags,
    this.hashtags,
    this.numberOfFavorite = 0,
    this.numberOfComment = 0,
    this.isFavorite = false,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.reply,
    this.parent,
  });

  String? id;
  String? image;
  String? content;
  List<User>? tags;
  List<String>? hashtags;
  int numberOfFavorite;
  int numberOfComment;
  bool isFavorite;
  User? user;
  int? createdAt;
  int? updatedAt;
  User? reply;
  String? parent;

  List<Comments> children = [];

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["id"],
        image: json["image"],
        content: json["content"],
        parent: json["parent"],
        reply: json["reply"] == null ? null : User.fromJson(json["reply"]),
        tags: json["tags"] == [] || json["tags"] == null
            ? json["tags"]
            : List<User>.from(json["tags"].map((x) => User.fromJson(x))),
        hashtags: json["hashtags"] == [] || json["hashtags"] == null
            ? json["hashtags"]
            : List<String>.from(json["hashtags"].map((x) => x)),
        numberOfFavorite: json["numberOfFavorite"] ?? 0,
        numberOfComment: json["numberOfComment"] ?? 0,
        isFavorite: json["isFavorite"] ?? false,
        user: User.fromJson(json["user"]),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "content": content,
        "parent": parent,
        "reply": reply?.toJson(),
        "tags": tags?.isNotEmpty == true ? List<dynamic>.from(tags!.map((x) => x.toJson())) : [],
        "hashtags": hashtags?.isNotEmpty == true ? List<dynamic>.from(hashtags!.map((x) => x)) : [],
        "numberOfFavorite": numberOfFavorite,
        "numberOfComment": numberOfComment,
        "isFavorite": isFavorite,
        "user": user?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  @override
  String toString() {
    return 'Comments{ children: $children, $id, $content, $user}';
  }
}
