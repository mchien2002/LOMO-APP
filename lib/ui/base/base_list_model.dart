import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/api_constants.dart';

import 'base_model.dart';

abstract class BaseListModel<T> extends BaseModel {
  bool isShowKeyBoard = false;
  List<T> items = [];
  dynamic _params;
  int page = 1;

  int get pageSize => PAGE_SIZE;

  int get itemCount => items.length;

  ViewState get initState => ViewState.loading;

  bool get isGetDataLocal => false;
  ValueNotifier<bool> loadMoreValue = ValueNotifier(false);
  bool disableLoadMore = false;

  loadData({dynamic params, bool isClear = false}) async {
    print(
        "\n\n*************************** page: $page ***************************\n\n");
    this._params = params;
    try {
      final data = await getData(params: params, isClear: isClear);
      if (isClear) items.clear();
      disableLoadMore = data == null || data.length == 0;
      if (data?.isNotEmpty == true) {
        items.addAll(data!);
        page++;
      }
      progressState = ProgressState.success;
      viewState = ViewState.loaded;
    } catch (e) {
      progressState = ProgressState.error;
      viewState = ViewState.loaded;
    }
    loadMoreValue.value = false;
    notifyListeners();
  }

  loadCacheData({dynamic params}) async {
    progressState = ProgressState.success;
    viewState = ViewState.loaded;
    this._params = params;
    try {
      final cacheData = await getCacheData(params: params);
      if (cacheData != null && cacheData.length > 0) {
        items.clear();
        items.addAll(cacheData);
        page++;
        notifyListeners();
      } else {
        progressState = ProgressState.error;
        viewState = ViewState.error;
      }
    } catch (e) {
      progressState = ProgressState.error;
      viewState = ViewState.error;
    }
    loadMoreValue.value = false;
    notifyListeners();
  }

  loadMoreData({dynamic params}) {
    if (loadMoreValue.value || disableLoadMore) return;
    loadMoreValue.value = true;
    notifyListeners();
    loadData(params: params);
  }

  Future<void> refresh({dynamic params}) async {
    page = 1;
    loadData(params: params, isClear: true);
  }

  clearAll() {
    page = 1;
    items.clear();
    notifyListeners();
  }

  Future<List<T>?> getData({dynamic params, bool isClear});

  Future<List<T>?>? getCacheData({dynamic params}) {
    return null;
  }
}
