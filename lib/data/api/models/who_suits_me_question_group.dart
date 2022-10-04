import 'package:lomo/data/api/models/user.dart';

import 'who_suits_me_question.dart';

class WhoSuitsMeQuestionGroup {
  WhoSuitsMeQuestionGroup(
      {this.id = "",
      this.user,
      this.questions = const [],
      this.percent,
      this.createdAt = 0,
      this.updatedAt = 0,
      this.dateJoinAt = 0});

  String id;
  int? percent;
  User? user;
  List<WhoSuitsMeQuestion> questions;
  int createdAt;
  int updatedAt;
  int dateJoinAt;

  factory WhoSuitsMeQuestionGroup.fromJson(Map<String, dynamic> json) => WhoSuitsMeQuestionGroup(
      id: json["id"] ?? "",
      createdAt: json["createdAt"] ?? 0,
      updatedAt: json["updatedAt"] ?? 0,
      dateJoinAt: json["dateJoinAt"] ?? 0,
      percent: json["percent"],
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      questions: json["questions"] != null
          ? List<WhoSuitsMeQuestion>.from(
              json["questions"].map((x) => WhoSuitsMeQuestion.fromJson(x)))
          : []);

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "dateJoinAt": dateJoinAt,
        "user": user?.toJson(),
        "questions": questions.isNotEmpty == true
            ? List<dynamic>.from(
                questions.map((x) => x.toJson()),
              )
            : [],
        "percent": percent
      };
}
