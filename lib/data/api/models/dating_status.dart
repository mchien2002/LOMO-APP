class DatingStatus {
  DatingStatus({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory DatingStatus.fromJson(Map<String, dynamic> json) => DatingStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name ?? "",
      };
}
