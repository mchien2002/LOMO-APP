import 'package:hive/hive.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/converters/date_time_converter.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/old_lomoid.dart';
import 'package:lomo/data/api/models/old_name.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/database/db_type.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/constants.dart';

import 'constant_list.dart';
import 'dating_filter.dart';
import 'dating_image.dart';
import 'dating_status.dart';
import 'gender.dart';

part 'user.g.dart';

@HiveType(typeId: USER)
class User extends DiscoveryItemGroup {
  User(
      {this.isFirstLogin,
      this.token,
      this.name,
      this.id,
      this.email,
      this.phone,
      this.netAloId,
      this.netAloAvatar,
      this.netAloToken,
      this.avatar,
      this.cover,
      this.isFollow = false,
      this.isFavorite = false,
      this.gender,
      this.followGenders,
      this.birthday,
      this.height,
      this.weight,
      this.story,
      this.province,
      this.numberOfBlocker,
      this.numberOfFollower,
      this.numberOfFavoritor,
      this.numberOfCandy,
      this.numberOfBear,
      this.numberOfFollowing,
      this.distance,
      this.feeling,
      this.city,
      this.zodiac,
      this.sogiescs = const [],
      this.relationship,
      this.careers = const [],
      this.hobbies = const [],
      this.literacy,
      this.backgroundImage,
      this.lomoId,
      this.isKol,
      this.fieldDisabled,
      this.datingImages,
      this.quote,
      this.filter,
      this.role,
      this.isVerify,
      this.verifyImages,
      this.title,
      this.datingStatus,
      this.isBear,
      this.isSayhi,
      this.isQuiz = true,
      this.isReadQuiz = true,
      this.oldNames = const [],
      this.oldLomoIds = const [],
      this.isFollowOfficial = false,
      this.isFollowSupport = false,
      this.isReferral = false,
      this.isDeleted = false,
      this.isVideo = false});

  @HiveField(0)
  bool? isFirstLogin;
  @HiveField(1)
  String? token;
  @HiveField(2)
  String? distance;
  @HiveField(3)
  String? feeling;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? id;
  @HiveField(6)
  String? email;
  @HiveField(7)
  String? phone;
  @HiveField(8)
  int? netAloId;
  @HiveField(9)
  String? netAloToken;
  @HiveField(10)
  String? netAloAvatar;
  @HiveField(11)
  String? avatar;
  @HiveField(12)
  String? cover;
  @HiveField(13)
  bool isFollow;
  @HiveField(14)
  bool isFavorite;
  @HiveField(15)
  Gender? gender;
  @HiveField(16)
  List<Gender>? followGenders;
  @HiveField(17)
  DateTime? birthday;
  @HiveField(18)
  int? height;
  @HiveField(19)
  int? weight;
  @HiveField(20)
  String? story;
  @HiveField(21)
  City? province;
  @HiveField(22)
  String? city;

  @HiveField(23)
  bool get isEnoughBasicInfo =>
      name != null && gender != null && birthday != null;

  @HiveField(24)
  bool get isEnoughNetAloBasicInfo => netAloId != null;
  @HiveField(25)
  int? numberOfBlocker;
  @HiveField(26)
  int? numberOfFollower;
  @HiveField(27)
  int? numberOfFavoritor;
  @HiveField(28)
  int? numberOfCandy;
  @HiveField(29)
  int? numberOfBear;
  @HiveField(30)
  int? numberOfFollowing;
  @HiveField(31)
  Zodiac? zodiac;
  @HiveField(32)
  List<Sogiesc>? sogiescs;
  @HiveField(33)
  Relationship? relationship;
  @HiveField(34)
  List<KeyValue>? careers;
  @HiveField(35)
  Literacy? literacy;
  @HiveField(36)
  String? backgroundImage;
  @HiveField(37)
  List<Hobby>? hobbies;
  @HiveField(38)
  String? lomoId;
  @HiveField(39)
  List<String>? fieldDisabled;
  @HiveField(40)
  bool? isKol;
  @HiveField(41)
  List<DatingImage>? datingImages;
  @HiveField(42)
  String? quote; // trích dẫn hẹn hò
  @HiveField(43)
  DatingFilter? filter;
  @HiveField(44)
  Role? role;
  @HiveField(45)
  bool? isVerify;
  @HiveField(46)
  List<String>? verifyImages;
  @HiveField(47)
  KeyValue? title;
  @HiveField(48)
  DatingStatus? datingStatus;
  @HiveField(49)
  bool? isBear;
  @HiveField(50)
  bool? isSayhi;
  @HiveField(51)
  bool isQuiz;
  @HiveField(52)
  bool isReadQuiz;
  @HiveField(53)
  bool isFollowOfficial;
  @HiveField(54)
  List<OldName> oldNames;
  @HiveField(55)
  List<OldLomoId> oldLomoIds;
  @HiveField(56)
  bool isFollowSupport;

  @HiveField(57)
  bool isDeleted;
  bool get hasDatingProfile => datingImages!.isNotEmpty == true;

  bool get isMe => id == locator<UserModel>().user!.id;
  @HiveField(58)
  bool isReferral;
  @HiveField(59)
  bool isVideo;

  factory User.fromJson(Map<String, dynamic> json) => User(
        lomoId: json["lomoId"],
        fieldDisabled: json["fieldDisabled"] == null
            ? []
            : List<String>.from(json["fieldDisabled"].map((x) => x)).toList(),
        isFirstLogin: json["isFirstLogin"] ?? false,
        token: json["token"],
        distance: json["distance"],
        feeling: json["feeling"],
        city: json["city"],
        name: json["name"],
        netAloToken: json["netAloToken"],
        id: json["id"] ?? "",
        email: json["email"],
        phone: json["phone"],
        netAloId: json["netAloId"],
        netAloAvatar: json["netAloAvatar"],
        avatar: json["avatar"],
        cover: json["cover"],
        isFollow: json["isFollow"] ?? false,
        isFavorite: json["isFavorite"] ?? false,
        isKol: json["isKol"] ?? false,
        gender: json["gender"] != null
            ? Gender.fromJson(json["gender"])
            : json["gender"],
        followGenders: json["followGenders"] != null
            ? List<Gender>.from(
                json["followGenders"].map((x) => Gender.fromJson(x)))
            : [],
        birthday: json["birthday"] != null
            ? DateConverter().fromJson(json["birthday"])
            : null,
        height: json["height"] ?? 0,
        weight: json["weight"] ?? 0,
        story: json["story"],
        province: json["province"] != null
            ? City.fromJson(json["province"])
            : json["province"],
        numberOfBlocker: json["numberOfBlocker"] ?? 0,
        numberOfFollower: json["numberOfFollower"] ?? 0,
        numberOfFavoritor: json["numberOfFavoritor"] ?? 0,
        numberOfCandy: json["numberOfCandy"] ?? 0,
        numberOfBear: json["numberOfBear"] ?? 0,
        numberOfFollowing: json["numberOfFollowing"] ?? 0,
        zodiac: json["zodiac"] != null
            ? Zodiac.fromJson(json["zodiac"])
            : json["zodiac"],
        sogiescs: json["sogiescs"] != null
            ? List<Sogiesc>.from(
                json["sogiescs"].map((x) => Sogiesc.fromJson(x)))
            : [],
        relationship: json["relationship"] != null
            ? Relationship.fromJson(json["relationship"])
            : json["relationship"],
        careers: json["careers"] != null
            ? List<KeyValue>.from(
                json["careers"].map((x) => KeyValue.fromJson(x)))
            : [],
        literacy: json["literacy"] != null
            ? Literacy.fromJson(json["literacy"])
            : json["literacy"],
        backgroundImage: json["backgroundImage"],
        hobbies: json["hobbies"] != null
            ? List<Hobby>.from(json["hobbies"].map((x) => Hobby.fromJson(x)))
            : [],
        datingImages: json["datingImages"] != null
            ? List<DatingImage>.from(
                json["datingImages"].map((x) => DatingImage.fromJson(x)))
            : [],
        quote: json["quote"],
        filter: json["filter"] != null
            ? DatingFilter.fromJson(json["filter"])
            : null,
        role: json["role"] != null ? Role.fromJson(json["role"]) : null,
        isVerify: json["isVerify"],
        verifyImages: json["verifyImages"] != null
            ? List<String>.from(json["verifyImages"].map((x) => x))
            : [],
        title: json["title"] != null ? KeyValue.fromJson(json["title"]) : null,
        datingStatus: json["datingStatus"] != null
            ? DatingStatus.fromJson(json["datingStatus"])
            : null,
        isBear: json["isBear"] ?? false,
        isSayhi: json["isSayhi"] ?? false,
        isQuiz: json["isQuiz"] ?? true,
        isReadQuiz: json["isReadQuiz"] ?? true,
        oldNames: json["oldNames"] != null
            ? List<OldName>.from(
                json["oldNames"].map((x) => OldName.fromJson(x)))
            : [],
        oldLomoIds: json["oldLomoIds"] != null
            ? List<OldLomoId>.from(
                json["oldLomoIds"].map((x) => OldLomoId.fromJson(x)))
            : [],
        isFollowOfficial: json["isFollowOfficial"] ?? false,
        isFollowSupport: json["isFollowSupport"] ?? false,
        isReferral: json["isReferral"] ?? false,
        isDeleted: json["isDeleted"] ?? false,
        isVideo: json["isVideo"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "lomoId": lomoId,
        "fieldDisabled": fieldDisabled?.isNotEmpty == true
            ? List<dynamic>.from(fieldDisabled!.map((x) => x))
            : [],
        "isFirstLogin": isFirstLogin,
        "token": token,
        "distance": distance,
        "feeling": feeling,
        "city": city,
        "name": name,
        "id": id,
        "email": email,
        "netAloToken": netAloToken,
        "phone": phone,
        "netAloId": netAloId,
        "netAloAvatar": netAloAvatar,
        "avatar": avatar,
        "cover": cover,
        "isFollow": isFollow,
        "isFavorite": isFavorite,
        "isKol": isKol,
        "gender": gender?.toJson(),
        "followGenders": followGenders?.isNotEmpty == true
            ? List<dynamic>.from(followGenders!.map((x) => x.toJson()))
            : followGenders,
        "birthday": birthday != null ? DateConverter().toJson(birthday!) : null,
        "height": height,
        "weight": weight,
        "story": story,
        "province": province?.toJson(),
        "numberOfBlocker": numberOfBlocker,
        "numberOfFollower": numberOfFollower,
        "numberOfFavoritor": numberOfFavoritor,
        "numberOfCandy": numberOfCandy,
        "numberOfBear": numberOfBear,
        "numberOfFollowing": numberOfFollowing,
        "zodiac": zodiac?.toJson(),
        "sogiescs": sogiescs?.isNotEmpty == true
            ? List<dynamic>.from(sogiescs!.map((x) => x.toJson()))
            : [],
        "relationship": relationship?.toJson(),
        "careers": careers?.isNotEmpty == true
            ? List<dynamic>.from(careers!.map((x) => x.toJson()))
            : [],
        "literacy": literacy != null ? literacy!.toJson() : null,
        "backgroundImage": backgroundImage,
        "hobbies": hobbies?.isNotEmpty == true
            ? List<dynamic>.from(hobbies!.map((x) => x.toJson()))
            : [],
        "datingImages": datingImages?.isNotEmpty == true
            ? List<dynamic>.from(datingImages!.map((x) => x.toJson()))
            : [],
        "quote": quote,
        "filter": filter?.toJson(),
        "role": role?.toJson(),
        "isVerify": isVerify,
        "verifyImages": verifyImages?.isNotEmpty == true
            ? List<dynamic>.from(
                verifyImages!.map((x) => x),
              )
            : [],
        "title": title?.toJson(),
        "datingStatus": datingStatus?.toJson(),
        "isBear": isBear,
        "isSayhi": isSayhi,
        "isQuiz": isQuiz,
        "isReadQuiz": isReadQuiz,
        "oldNames": oldNames.isNotEmpty == true
            ? List<dynamic>.from(
                oldNames.map((x) => x.toJson()),
              )
            : [],
        "oldLomoIds": oldLomoIds.isNotEmpty == true
            ? List<dynamic>.from(
                oldLomoIds.map((x) => x.toJson()),
              )
            : [],
        "isFollowOfficial": isFollowOfficial,
        "isFollowSupport": isFollowSupport,
        "isDeleted": isDeleted,
        "isReferral": isReferral,
        "isVideo": isVideo,
      };
}
