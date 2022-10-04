import 'package:dio/dio.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/eventbus/api_time_out_event.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/util/log_data.dart';

import 'api_constants.dart';
import 'exceptions/api_exception.dart';

class RestClient {
  static const TIMEOUT = 60000;
  static const ENABLE_LOG = true;
  static const ACCESS_TOKEN_HEADER = 'Authorization';
  static const LANGUAGE = 'Accept-Language';

  // singleton
  static final RestClient instance = new RestClient._internal();

  factory RestClient() {
    return instance;
  }

  RestClient._internal();

  late String baseUrl;
  late Map<String, dynamic> headers;

  void init(String baseUrl,
      {String? platform,
      String? deviceId,
      String? language,
      String? appVersionName,
      String? appVersionCode,
      String? accessToken}) {
    this.baseUrl = baseUrl;
    headers = {
      'Content-Type': 'application/json',
      'x-app-version-name': appVersionName,
      'x-app-version-code': appVersionCode,
      'x-device-type': platform,
      'x-device-id': deviceId
    };
    if (accessToken != null) setToken(accessToken);
    setLanguage(language!);
  }

  void setToken(String token) {
    headers[ACCESS_TOKEN_HEADER] = "Bearer $token";
  }

  void setLanguage(String language) {
    headers[LANGUAGE] = language;
  }

  void clearToken() {
    headers.remove(ACCESS_TOKEN_HEADER);
  }

  static Dio getDio({bool isUpload = false, String? customUrl}) {
    var dio = Dio(
        instance.getDioBaseOption(isUpload: isUpload, customUrl: customUrl));
    // dio.interceptors.clear();

    if (ENABLE_LOG) {
      dio.interceptors.add(LogInterceptor(
          requestBody: true, responseBody: true, logPrint: logPrint));
    }
    // //check expire time
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError error, handler) async {
        if (error.type == DioErrorType.connectTimeout ||
            error.type == DioErrorType.receiveTimeout) {
          eventBus.fire(ApiTimeOutEvent());
        } else if (error.response != null &&
            error.response?.statusCode == 401) {
          locator<AppModel>().forceLogout();
        } else {
          handler.next(error);
        }
      },
    ));
    return dio;
  }

  BaseOptions getDioBaseOption({bool isUpload = false, String? customUrl}) {
    return BaseOptions(
      baseUrl: isUpload
          ? UPLOAD_PHOTO_URL!
          : customUrl != null
              ? customUrl
              : instance.baseUrl,
      connectTimeout: TIMEOUT,
      receiveTimeout: TIMEOUT,
      headers: instance.headers,
      responseType: ResponseType.json,
    );
  }
}
