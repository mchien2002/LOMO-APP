import 'package:lomo/data/api/models/who_suits_me_answers.dart';

class WhoSuitsMeResultAnswer {
  WhoSuitsMeResultAnswer({this.answers = const []});

  List<WhoSuitsMeAnswers> answers;

  factory WhoSuitsMeResultAnswer.fromJson(Map<String, dynamic> json) => WhoSuitsMeResultAnswer(
      answers: json["answers"] != null
          ? List<WhoSuitsMeAnswers>.from(json["answers"].map((x) => WhoSuitsMeAnswers.fromJson(x)))
          : []);

  Map<String, dynamic> toJson() => {
        "answers": answers.isNotEmpty == true
            ? List<dynamic>.from(
                answers.map((x) => x.toJson()),
              )
            : []
      };

  @override
  String toString() {
    return 'WhoSuitsMeResultAnswer{answers: $answers}';
  }
}
