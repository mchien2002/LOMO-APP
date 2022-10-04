import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/exceptions/api_exception.dart';
import 'package:lomo/data/api/exceptions/refresh_token_expire_exception.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/strings.dart';

abstract class BaseModel extends ChangeNotifier {
  ViewState? viewState;
  String? errorMessage;
  String? apiErrorCod;

  ProgressState progressState = ProgressState.initial;

  ViewState get initState => ViewState.loaded;

  BaseModel() {
    viewState = initState;
  }

  updateView() {
    notifyListeners();
  }

  setState(ViewState newState, {forceUpdate = false, dynamic error}) {
    if (viewState == newState && !forceUpdate) return;

    viewState = newState;
    if (viewState == ViewState.error && error != null) {
      errorMessage = getErrorMessage(error);
    }
    notifyListeners();
  }

  String getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    if (error is RefreshTokenExpireException) {}
    if (error is ApiException) {
      apiErrorCod = error.cod;
      return error.message!;
    }
    // TODO check error type
    return Strings.unknownErrorMessage;
  }

  callApi({required Function doSomething}) async {
    try {
      apiErrorCod = null;
      progressState = ProgressState.processing;
      await doSomething();
      progressState = ProgressState.success;
    } catch (e, stackTrace) {
      errorMessage = getErrorMessage(e);
      progressState = ProgressState.error;
      print(e);
      sendErrorLogToServer(
        exception: e,
        stackTrace: stackTrace,
        className: this.runtimeType.toString(),
      );
    }
  }

  sendErrorLogToServer(
      {required Object exception,
      required StackTrace stackTrace,
      String? className}) {
    try {
      locator<CommonRepository>().logError(
        exception: exception,
        stackTrace: stackTrace,
        className: className,
      );
    } catch (e) {}
  }
}

enum ViewState { initial, loading, loaded, error }
enum ProgressState { initial, processing, success, error }
