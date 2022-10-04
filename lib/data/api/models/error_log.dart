import 'dart:io';

class ErrorLog {
  String osName = Platform.isAndroid ? "android" : "ios";
  String? osVersion;
  dynamic message;
  String? className;
  String? user;
  String? device;
  ErrorLog(
      {this.message, this.className, this.user, this.device, this.osVersion});

  Map<String, dynamic> toJson() => {
        "osName": osName,
        "osVersion": osVersion,
        "message": message,
        "user": user,
        "device": device,
        "className": className,
      };
}
