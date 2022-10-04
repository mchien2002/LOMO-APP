class AppConfigRequest {
  AppConfigRequest({
    this.os,
    this.verName,
    this.verCode,
  });

  String? os;
  String? verName;
  int? verCode;

  factory AppConfigRequest.fromJson(Map<String, dynamic> json) =>
      AppConfigRequest(
        os: json["os"],
        verName: json["verName"],
        verCode: json["verCode"],
      );

  Map<String, dynamic> toJson() => {
        "os": os,
        "verName": verName,
        "verCode": verCode,
      };
}
