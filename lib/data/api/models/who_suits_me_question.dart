import 'package:lomo/data/api/models/who_suits_me_answer.dart';

class WhoSuitsMeQuestion {
  WhoSuitsMeQuestion(
      {this.id = "",
      this.name = "",
      this.priority = 0,
      this.answers = const [],
      this.isNewItem = false});

  String id;
  String name;
  int priority;
  List<WhoSuitsMeAnswer> answers;
  bool isNewItem;

  factory WhoSuitsMeQuestion.fromJson(Map<String, dynamic> json) =>
      WhoSuitsMeQuestion(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        priority: json["priority"] ?? 0,
        answers: json["answers"] != null
            ? List<WhoSuitsMeAnswer>.from(
                json["answers"].map((x) => WhoSuitsMeAnswer.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "priority": priority,
        "answers": answers.isNotEmpty == true
            ? List<dynamic>.from(
                answers.map((x) => x.toJson()),
              )
            : []
      };
}
