import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/exceptions/access_token_expire_exception.dart';
import 'package:lomo/data/api/exceptions/api_exception.dart';
import 'package:lomo/data/api/models/response/api_respone.dart';
import 'package:lomo/data/api/models/response/data_response.dart';
import 'package:lomo/di/locator.dart';

import '../../eventbus/server_maintenance_event.dart';
import '../exceptions/server_maintenance_exception.dart';
import '../rest_client.dart';

abstract class BaseService {
  Future<dynamic> getWithCustomUrl(String customUrl, String path,
      {Map<String, dynamic>? params}) async {
    final response = await RestClient.getDio(customUrl: customUrl)
        .get(path, queryParameters: params);
    return response.data;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) async {
    final response =
        await RestClient.getDio().get(path, queryParameters: params);
    return _handleResponse(response);
  }

  Future<DataResponse> get2(String path, {Map<String, dynamic>? params}) async {
    final response =
        await RestClient.getDio().get(path, queryParameters: params);
    return _handleResponse2(response);
  }

  Future<dynamic> post(String path, {data}) async {
    final response = await RestClient.getDio().post(path, data: data);
    return _handleResponse(response);
  }

  Future<DataResponse> post2(String path,
      {data, bool enableCache = false}) async {
    final response = await RestClient.getDio().post(path, data: data);
    return _handleResponse2(response);
  }

  Future<dynamic> put(String path, {data}) async {
    final response = await RestClient.getDio().put(path, data: data);
    return _handleResponse(response);
  }

  Future<DataResponse> put2(String path, {data}) async {
    final response = await RestClient.getDio().put(path, data: data);
    return _handleResponse2(response);
  }

  Future<dynamic> delete(String path, {data}) async {
    final response = await RestClient.getDio().delete(path, data: data);
    return _handleResponse(response);
  }

  Future<DataResponse> delete2(String path, {data}) async {
    final response = await RestClient.getDio().delete(path, data: data);
    return _handleResponse2(response);
  }

  Future<dynamic> postUpload(String path,
      {Function(int, int)? percentCallback, data}) async {
    final response = await RestClient.getDio(isUpload: true)
        .post(path, data: data, onSendProgress: (count, total) {
      if (percentCallback != null) percentCallback(count, total);
    });
    return _handleResponse(response);
  }

  Future<dynamic> postUploadFromBytes(String path, Uint8List file) async {
    final response = await RestClient.getDio(isUpload: true)
        .post(path, data: Stream.fromIterable(file.map((e) => [e])),
            onSendProgress: (count, total) {
      print("onSendProgress:Count $count - Total $total");
    }, onReceiveProgress: (count, total) {
      print("onReceiveProgress:Count $count - Total $total");
    });
    return _handleResponse(response);
  }

  Future<DataResponse> postUpload2(String path, {data}) async {
    final response =
        await RestClient.getDio(isUpload: true).post(path, data: data);
    return _handleResponse2(response);
  }

  dynamic _handleResponse(dio.Response response) {
    switch (response.statusCode) {
      case 200:
        var apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.code == 200)
          return apiResponse.data;
        else
          throw ApiException(
            statusCode: apiResponse.code,
            message: apiResponse.message,
            error: apiResponse.error,
            cod: apiResponse.cod,
          );
        break;
      // case 400: // case refresh token expire, pop to login page
      //   locator<AppModel>().forceLogout();
      //   throw RefreshTokenExpireException();
      //   break;
      case 401:
        locator<AppModel>().forceLogout();
        throw AccessTokenExpireException();
      case 501:
      case 502:
      case 503:
      case 504:
        eventBus.fire(ServerMaintenanceEvent());
        throw ServerMaintenanceException();
      default:
        throw ApiException(
            statusCode: response.statusCode!, message: response.statusMessage!);
    }
  }

  DataResponse _handleResponse2(dio.Response response) {
    switch (response.statusCode) {
      case 200:
        var apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.code == 200)
          return DataResponse(apiResponse.data, total: apiResponse.total!);
        else
          throw ApiException(
              statusCode: apiResponse.code,
              message: apiResponse.message,
              error: apiResponse.error);
        break;
      // case 400: // case refresh token expire, pop to login page
      //   locator<AppModel>().forceLogout();
      //   throw RefreshTokenExpireException();
      //   break;
      case 401:
        locator<AppModel>().forceLogout();
        throw AccessTokenExpireException();

      case 501:
      case 502:
      case 503:
      case 504:
        eventBus.fire(ServerMaintenanceEvent());
        throw ServerMaintenanceException();
        break;
      default:
        throw ApiException(
            statusCode: response.statusCode!, message: response.statusMessage!);
    }
  }

  download(String url, savePath, {ProgressCallback? onReceiveProgress}) async {
    await RestClient.getDio().download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
