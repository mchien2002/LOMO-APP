class OldName {
  final String name;
  final dynamic updatedAt;

  OldName({required this.name, required this.updatedAt});

  factory OldName.fromJson(Map<String, dynamic> json) => OldName(
        name: json["name"]??"",
        updatedAt: json["updatedAt"]??"",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "updatedAt": updatedAt,
      };
}
