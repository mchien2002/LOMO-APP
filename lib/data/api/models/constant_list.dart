// To parse this JSON data, do
//
//     final listConstant = listConstantFromJson(jsonString);

import 'dart:convert';

import 'package:lomo/data/api/models/gender.dart';
import 'package:lomo/data/api/models/quiz_template.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/zodiac.dart';

import 'key_value_ext.dart';

ConstantList listConstantFromJson(String str) =>
    ConstantList.fromJson(json.decode(str));

String listConstantToJson(ConstantList data) => json.encode(data.toJson());

class ConstantList {
  ConstantList({
    this.typeEvent,
    this.mission,
    this.gender,
    this.statusGift,
    this.statusOrder,
    this.statusReportPost,
    this.typeNotification,
    this.typeZodiac,
    this.statusUser,
    this.career,
    this.typeSogiesc,
    this.typeRelationship,
    this.privilege,
    this.notify,
    this.literacy,
    this.hobby,
    this.statusEvent,
    this.statusPost,
    this.statusAccount,
    this.roles,
    this.typeMessage,
    this.titles,
    this.quizTemplate,
    this.reasonDeleteAccount,
  });

  List<ModelItemSimple>? typeEvent;
  List<ModelItemSimple>? mission;
  List<Gender>? gender;
  List<ModelItemSimple>? statusGift;
  List<ModelItemSimple>? statusOrder;
  List<ModelItemSimple>? statusReportPost;
  List<ModelItemSimple>? typeNotification;
  List<Zodiac>? typeZodiac;
  List<ModelItemSimple>? statusUser;
  List<KeyValue>? career;
  List<KeyValue>? titles;
  List<Hobby>? hobby;
  List<Sogiesc>? typeSogiesc;
  List<Relationship>? typeRelationship;
  List<ModelItemSimple>? privilege;
  List<ModelItemSimple>? notify;
  List<Literacy>? literacy;
  List<ModelItemSimple>? statusEvent;
  List<ModelItemSimple>? statusPost;
  List<ModelItemSimple>? statusAccount;
  List<Role>? roles;
  List<ModelItemSimple>? typeMessage;
  List<QuizTemplate>? quizTemplate;
  List<KeyValue>? reasonDeleteAccount;

  factory ConstantList.fromJson(Map<String, dynamic> json) => ConstantList(
        titles: json["TYPE_TITLE"] == null
            ? []
            : List<KeyValue>.from(
                json["TYPE_TITLE"].map((x) => KeyValue.fromJson(x))),
        typeEvent: json["TYPE_EVENT"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["TYPE_EVENT"].map((x) => ModelItemSimple.fromJson(x))),
        mission: json["MISSION"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["MISSION"].map((x) => ModelItemSimple.fromJson(x))),
        gender: json["GENDER"] == null
            ? []
            : List<Gender>.from(json["GENDER"].map((x) => Gender.fromJson(x))),
        statusGift: json["STATUS_GIFT"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_GIFT"].map((x) => ModelItemSimple.fromJson(x))),
        statusOrder: json["STATUS_ORDER"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_ORDER"].map((x) => ModelItemSimple.fromJson(x))),
        statusReportPost: json["STATUS_REPORT_POST"] == null
            ? []
            : List<ModelItemSimple>.from(json["STATUS_REPORT_POST"]
                .map((x) => ModelItemSimple.fromJson(x))),
        typeNotification: json["TYPE_NOTIFICATION"] == null
            ? []
            : List<ModelItemSimple>.from(json["TYPE_NOTIFICATION"]
                .map((x) => ModelItemSimple.fromJson(x))),
        typeZodiac: json["TYPE_ZODIAC"] == null
            ? []
            : List<Zodiac>.from(
                json["TYPE_ZODIAC"].map((x) => Zodiac.fromJson(x))),
        statusUser: json["STATUS_USER"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_USER"].map((x) => ModelItemSimple.fromJson(x))),
        career: json["CAREER"] == null
            ? []
            : List<KeyValue>.from(
                json["CAREER"].map((x) => KeyValue.fromJson(x))),
        hobby: json["HOBBY"] == null
            ? []
            : List<Hobby>.from(json["HOBBY"].map((x) => Hobby.fromJson(x))),
        typeSogiesc: json["TYPE_SOGIESC"] == null
            ? []
            : List<Sogiesc>.from(
                json["TYPE_SOGIESC"].map((x) => Sogiesc.fromJson(x))),
        typeRelationship: json["TYPE_RELATIONSHIP"] == null
            ? []
            : List<Relationship>.from(
                json["TYPE_RELATIONSHIP"].map((x) => Relationship.fromJson(x))),
        privilege: json["PRIVILEGE"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["PRIVILEGE"].map((x) => ModelItemSimple.fromJson(x))),
        notify: json["NOTIFY"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["NOTIFY"].map((x) => ModelItemSimple.fromJson(x))),
        literacy: json["LITERACY"] == null
            ? []
            : List<Literacy>.from(
                json["LITERACY"].map((x) => Literacy.fromJson(x))),
        statusEvent: json["STATUS_EVENT"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_EVENT"].map((x) => ModelItemSimple.fromJson(x))),
        statusPost: json["STATUS_POST"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_POST"].map((x) => ModelItemSimple.fromJson(x))),
        statusAccount: json["STATUS_ACCOUNT"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["STATUS_ACCOUNT"].map((x) => ModelItemSimple.fromJson(x)),
              ),
        roles: json["TYPE_ROLE"] == null
            ? []
            : List<Role>.from(json["TYPE_ROLE"].map((x) => Role.fromJson(x))),
        typeMessage: json["TYPE_MESSAGE"] == null
            ? []
            : List<ModelItemSimple>.from(
                json["TYPE_MESSAGE"].map((x) => ModelItemSimple.fromJson(x))),
        quizTemplate: json["TYPE_MESSAGE"] == null
            ? []
            : List<QuizTemplate>.from(
                json["QUIZ_TEMPLATE"].map((x) => QuizTemplate.fromJson(x))),
        reasonDeleteAccount: json["REASON_DELETE_ACCOUNT"] == null
            ? []
            : List<KeyValue>.from(
                json["REASON_DELETE_ACCOUNT"].map((x) => KeyValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TYPE_TITLE": titles == null
            ? null
            : List<dynamic>.from(titles!.map((x) => x.toJson())),
        "TYPE_EVENT": typeEvent == null
            ? null
            : List<dynamic>.from(typeEvent!.map((x) => x.toJson())),
        "MISSION": mission == null
            ? null
            : List<dynamic>.from(mission!.map((x) => x.toJson())),
        "GENDER": gender == null
            ? null
            : List<dynamic>.from(gender!.map((x) => x.toJson())),
        "STATUS_GIFT": statusGift == null
            ? null
            : List<dynamic>.from(statusGift!.map((x) => x.toJson())),
        "STATUS_ORDER": statusOrder == null
            ? null
            : List<dynamic>.from(statusOrder!.map((x) => x.toJson())),
        "STATUS_REPORT_POST": statusReportPost == null
            ? null
            : List<dynamic>.from(statusReportPost!.map((x) => x.toJson())),
        "TYPE_NOTIFICATION": typeNotification == null
            ? null
            : List<dynamic>.from(typeNotification!.map((x) => x.toJson())),
        "TYPE_ZODIAC": typeZodiac == null
            ? null
            : List<dynamic>.from(typeZodiac!.map((x) => x.toJson())),
        "STATUS_USER": statusUser == null
            ? null
            : List<dynamic>.from(statusUser!.map((x) => x.toJson())),
        "CAREER": career == null
            ? null
            : List<dynamic>.from(career!.map((x) => x.toJson())),
        "HOBBY": hobby == null
            ? null
            : List<dynamic>.from(hobby!.map((x) => x.toJson())),
        "TYPE_SOGIESC": typeSogiesc == null
            ? null
            : List<dynamic>.from(typeSogiesc!.map((x) => x.toJson())),
        "TYPE_RELATIONSHIP": typeRelationship == null
            ? null
            : List<dynamic>.from(typeRelationship!.map((x) => x.toJson())),
        "PRIVILEGE": privilege == null
            ? null
            : List<dynamic>.from(privilege!.map((x) => x.toJson())),
        "NOTIFY": notify == null
            ? null
            : List<dynamic>.from(notify!.map((x) => x.toJson())),
        "LITERACY": literacy == null
            ? null
            : List<dynamic>.from(literacy!.map((x) => x.toJson())),
        "STATUS_EVENT": statusEvent == null
            ? null
            : List<dynamic>.from(statusEvent!.map((x) => x.toJson())),
        "STATUS_POST": statusPost == null
            ? null
            : List<dynamic>.from(statusPost!.map((x) => x.toJson())),
        "STATUS_ACCOUNT": statusAccount == null
            ? null
            : List<dynamic>.from(
                statusAccount!.map((x) => x.toJson()),
              ),
        "TYPE_MESSAGE": typeMessage == null
            ? null
            : List<dynamic>.from(
                typeMessage!.map((x) => x.toJson()),
              ),
        "REASON_DELETE_ACCOUNT": reasonDeleteAccount == null
            ? null
            : List<dynamic>.from(
                reasonDeleteAccount!.map((x) => x.toJson()),
              ),
      };
}

class KeyValue extends KeyValueExt {
  KeyValue({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory KeyValue.fromJson(Map<String, dynamic> json) => KeyValue(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String? getItemName() {
    return name;
  }
}

class Literacy extends KeyValueExt {
  Literacy({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Literacy.fromJson(Map<String, dynamic> json) => Literacy(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return 'Literacy{id: $id, name: $name}';
  }

  @override
  String? getItemName() {
    return name;
  }
}

class ModelItemSimple extends KeyValueExt {
  ModelItemSimple({this.id, this.name, this.messages});

  String? id;
  String? name;
  List<String>? messages;

  factory ModelItemSimple.fromJson(Map<String, dynamic> json) =>
      ModelItemSimple(
        id: json["id"],
        name: json["name"],
        messages: json["messages"] != null
            ? List<String>.from(json["messages"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "messages": messages?.isNotEmpty == true
            ? List<dynamic>.from(
                messages!.map((x) => x),
              )
            : []
      };
  @override
  String? getItemName() {
    return name;
  }
}

class Hobby extends KeyValueExt {
  Hobby({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Hobby.fromJson(Map<String, dynamic> json) => Hobby(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String? getItemName() {
    return name;
  }
}

class Role extends KeyValueExt {
  Role({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String? getItemName() {
    return name;
  }
}
