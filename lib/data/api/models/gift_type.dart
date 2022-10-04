class GiftType {
  GiftType({required this.id, required this.name});
  String id;
  String name;

  factory GiftType.fromJson(Map<String, dynamic> json) =>
      GiftType(id: json["id"] ?? "", name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
