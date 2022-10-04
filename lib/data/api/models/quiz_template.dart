class QuizTemplate {
  QuizTemplate({
    this.id = "",
    this.name = "",
    this.priority = 0,
    this.answers = const [],
  });

  String id;
  String name;
  int priority;
  List<String> answers;

  factory QuizTemplate.fromJson(Map<String, dynamic> json) => QuizTemplate(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        priority: json["priority"] ?? 0,
        answers: List<String>.from(json["answers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "priority": priority,
        "answers": List<dynamic>.from(answers.map((x) => x)),
      };
}
