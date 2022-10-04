class Tag {
  Tag({this.name, this.id});

  String? name;
  String? id;

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(name: json["name"], id: json["id"]);

  Map<String, dynamic> toJson() => {"name": name, "id": id};
}
