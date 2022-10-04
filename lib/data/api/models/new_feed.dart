import 'package:hive/hive.dart';
import 'package:lomo/data/api/models/response/photo_model.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/database/db_type.dart';
import 'package:lomo/util/constants.dart';

import 'user.dart';

part 'new_feed.g.dart';

@HiveType(typeId: NEWFEED)
class NewFeed extends HiveObject with DiscoveryItemGroup {
  NewFeed({
    this.id,
    this.images,
    this.content,
    this.tags,
    this.hashtags,
    this.createdAt,
    this.isFavorite = false,
    this.isFollow,
    this.numberOfFavorite = 0,
    this.numberOfComment = 0,
    this.user,
    this.feeling,
    this.parentFeeling,
    this.topics,
    this.isBear,
    this.isReferral = false,
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  List<PhotoModel>? images;
  @HiveField(2)
  String? content;
  @HiveField(3)
  String? feeling;
  @HiveField(4)
  String? parentFeeling;
  @HiveField(5)
  int? createdAt;
  @HiveField(6)
  List<User>? tags;
  @HiveField(7)
  List<String>? hashtags;
  @HiveField(8)
  bool isFavorite;
  @HiveField(9)
  bool? isFollow;
  @HiveField(10)
  int numberOfFavorite;
  @HiveField(11)
  int numberOfComment;
  @HiveField(12)
  User? user;
  @HiveField(13)
  List<TopictItem>? topics;
  @HiveField(14)
  bool? isBear;
  bool isLock = false;
  bool isDeleted = false;
  bool isReferral;

  factory NewFeed.fromJson(Map<String, dynamic> json) {
    final newFeed = NewFeed(
      id: json["id"],
      images: json["images"] != null
          ? List<PhotoModel>.from(
              json["images"].map((x) => PhotoModel.fromJson(x)))
          : [],
      createdAt: json["createdAt"] ?? null,
      content: json["content"] != null ? json["content"] : "",
      tags: json["tags"] != null
          ? List<User>.from(json["tags"].map((x) => User.fromJson(x)))
          : [],
      hashtags: json["hashtags"] != null
          ? List<String>.from(json["hashtags"].map((x) => x))
          : [],
      isFavorite: json["isFavorite"] ?? false,
      numberOfFavorite: json["numberOfFavorite"] ?? 0,
      isFollow: json["isFollow"] ?? false,
      numberOfComment: json["numberOfComment"] ?? 0,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      feeling: json["feeling"] ?? null,
      parentFeeling: json["parentFeeling"] ?? null,
      topics: json["topics"] != null
          ? List<TopictItem>.from(
              json["topics"].map((x) => TopictItem.fromJson(x)))
          : [],
      isBear: json["isBear"] ?? false,
      isReferral: json["isReferral"] ?? false,
    );
    newFeed.user!.isFollow = newFeed.isFollow!;
    return newFeed;
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "images": images != null && images!.isNotEmpty == true
            ? List<dynamic>.from(images!.map((x) => x.toJson()))
            : [],
        "createdAt": createdAt != null ? createdAt : null,
        "content": content != null ? content : null,
        "tags": tags != null && tags!.isNotEmpty == true
            ? List<dynamic>.from(tags!.map((x) => x.toJson()))
            : [],
        "hashtags": hashtags != null && hashtags!.isNotEmpty == true
            ? List<dynamic>.from(hashtags!.map((x) => x))
            : [],
        "isFavorite": isFavorite,
        "isFollow": isFollow ?? null,
        "numberOfFavorite": numberOfFavorite,
        "numberOfComment": numberOfComment,
        "user": user != null ? user!.toJson() : null,
        "parentFeeling": parentFeeling ?? null,
        "feeling": feeling ?? null,
        "topics": topics != null && topics!.isNotEmpty == true
            ? List<dynamic>.from(topics!.map((x) => x.toJson()))
            : [],
        "isBear": isBear ?? null,
        "isReferral": isReferral,
      };
}
