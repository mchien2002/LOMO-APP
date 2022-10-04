class Feeling {
  Feeling({
    this.iconData,
    this.name,
    this.parentFeeling,
  });

  String? iconData;
  String? name;
  String? parentFeeling;

  factory Feeling.fromJson(Map<String, dynamic> json) => Feeling(
      iconData: json["iconData"] ?? "",
      name: json["name"] ?? "",
      parentFeeling: json["parentFeeling"] ?? "");

  Map<String, dynamic> toJson() => {
        "iconData": iconData ?? "",
        "name": name ?? "",
        "parentFeeling": parentFeeling ?? ""
      };
}
