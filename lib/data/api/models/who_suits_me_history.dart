import 'user.dart';
import 'who_suits_me_question_group.dart';

class WhoSuitsMeHistory {
  WhoSuitsMeHistory({this.user, this.percent = 0, this.quiz});
  User? user;
  int percent;
  WhoSuitsMeQuestionGroup? quiz;

  factory WhoSuitsMeHistory.fromJson(Map<String, dynamic> json) =>
      WhoSuitsMeHistory(
          percent: json["percent"] ?? 0,
          user: json["user"] != null ? User.fromJson(json["user"]) : null,
          quiz: json["quiz"] != null
              ? WhoSuitsMeQuestionGroup.fromJson(json["quiz"])
              : null);

  Map<String, dynamic> toJson() => {
        "percent": percent,
        "user": user?.toJson(),
        "quiz": quiz?.toJson(),
      };
}
