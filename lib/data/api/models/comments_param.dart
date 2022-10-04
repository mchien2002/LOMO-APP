// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

CommentsParam commentsFromJson(String str) =>
    CommentsParam.fromJson(json.decode(str));

String commentsToJson(CommentsParam data) => json.encode(data.toJson());

class CommentsParam {
  CommentsParam({
    this.parent,
    this.image,
    this.content,
    this.tags,
    this.hashtags,
    this.reply,
  });

  String? parent;
  String? image;
  String? content;
  List<String>? tags;
  List<String>? hashtags;
  String? reply;

  factory CommentsParam.fromJson(Map<String, dynamic> json) => CommentsParam(
        parent: json["parent"],
        image: json["image"],
        content: json["content"],
        tags: json["tags"] != null
            ? List<String>.from(json["tags"].map((x) => x))
            : [],
        hashtags: json["hashtags"] != null
            ? List<String>.from(json["hashtags"].map((x) => x))
            : [],
        reply: json["reply"],
      );

  Map<String, dynamic> toJson() => {
        "parent": parent,
        "image": image,
        "content": content,
        "reply": reply,
        "tags": tags?.isNotEmpty == true
            ? List<dynamic>.from(tags!.toSet().map((x) => x))
            : [],
        "hashtags": hashtags?.isNotEmpty == true
            ? List<dynamic>.from(hashtags!.map((x) => x))
            : [],
      };
}
