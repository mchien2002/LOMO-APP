class OldLomoId {
  final String lomoId;
  final dynamic updatedAt;

  OldLomoId({required this.lomoId, required this.updatedAt});

  factory OldLomoId.fromJson(Map<String, dynamic> json) => OldLomoId(
        lomoId: json["lomoId"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "lomoId": lomoId,
        "updatedAt": updatedAt,
      };
}
