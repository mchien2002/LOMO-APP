class ApiResponse {
  ApiResponse(
      {this.code, this.total, this.message, this.data, this.error, this.cod});

  int? code;
  int? total;
  String? cod;
  String? message;
  dynamic data;
  dynamic error;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
      code: json["code"],
      cod: json["cod"],
      total: json.containsKey("total") ? json["total"] : 0,
      message: json["message"],
      data: json["data"],
      error: json["error"]);

  Map<String, dynamic> toJson() => {
        "code": code,
        "total": total,
        "message": message,
        "data": data,
        "error": error,
        "cod": cod,
      };
}
