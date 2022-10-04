// To parse this JSON data, do
//
//     final webviewData = webviewDataFromJson(jsonString);

import 'dart:convert';

class WebViewData {
  WebViewData({
    this.type,
    this.data,
  });

  String? type;
  String? data;

  factory WebViewData.fromRawJson(String str) =>
      WebViewData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebViewData.fromJson(Map<String, dynamic> json) => WebViewData(
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
      };
}
