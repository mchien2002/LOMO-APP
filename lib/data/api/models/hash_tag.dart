class HashTag {
  HashTag(
      {this.name,
      this.id,
      this.isTrend,
      this.priority,
      this.numberOfPost,
      this.createdAt,
      this.updatedAt});

  String? name;
  String? id;
  bool? isTrend;
  int? priority;
  int? numberOfPost;
  int? createdAt;
  int? updatedAt;
  factory HashTag.fromJson(Map<String, dynamic> json) => HashTag(
      name: json["name"],
      id: json["id"],
      isTrend: json["isTrend"],
      priority: json["priority"],
      numberOfPost: json["numberOfPost"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "isTrend": isTrend,
        "priority": priority,
        "numberOfPost": numberOfPost,
        "createdAt": createdAt,
        "updatedAt": updatedAt
      };
}
