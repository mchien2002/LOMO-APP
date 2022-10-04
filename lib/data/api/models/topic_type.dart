class TopicType {
  TopicType({
    this.id = "",
    this.name,
  });

  String id;
  String? name;

  factory TopicType.fromJson(Map<String, dynamic> json) => TopicType(
        id: json["id"] ?? "",
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
