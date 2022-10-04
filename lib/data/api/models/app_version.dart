class AppVersion {
  AppVersion({
    this.verCode,
    this.verName,
    this.isForce,
  });

  int? verCode;
  String? verName;
  bool? isForce;

  factory AppVersion.fromJson(Map<String, dynamic> json) => AppVersion(
        verCode: json["verCode"],
        verName: json["verName"],
        isForce: json["isForce"],
      );

  Map<String, dynamic> toJson() => {
        "verCode": verCode,
        "verName": verName,
        "isForce": isForce,
      };
}
