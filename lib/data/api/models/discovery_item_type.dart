class DiscoveryItemType {
  DiscoveryItemType({required this.id, this.name = ""});
  String id;
  String name;

  factory DiscoveryItemType.fromJson(Map<String, dynamic> json) => DiscoveryItemType(
        id: json["id"],
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
