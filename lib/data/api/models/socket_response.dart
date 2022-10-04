class SocketResponse {
  SocketResponse({this.model, this.action, this.data});
  String? model;
  String? action;
  dynamic data;

  factory SocketResponse.fromJson(Map<String, dynamic> json) => SocketResponse(
        model: json["model"],
        action: json["action"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "action": action,
        "data": data,
      };
}
