class WhoSuitsMeAnswers {
  WhoSuitsMeAnswers({
    this.idQuestion,
    this.idAnswer,
  });

  String? idQuestion;
  String? idAnswer;

  factory WhoSuitsMeAnswers.fromJson(Map<String, dynamic> json) => WhoSuitsMeAnswers(
        idQuestion: json["question"] ?? "",
        idAnswer: json["answer"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "question": idQuestion,
        "answer": idAnswer,
      };

  @override
  String toString() {
    return 'WhoSuitsMeAnswers{idQuestion: $idQuestion, idAnswer: $idAnswer}';
  }
}
