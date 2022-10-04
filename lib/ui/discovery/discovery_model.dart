import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/discovery_item.dart';
import 'package:lomo/data/eventbus/refresh_discovery_list_event.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/constants.dart';

class DiscoveryModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  final ValueNotifier<List<DiscoveryItem>> discoveryItems = ValueNotifier([]);

  @override
  ViewState get viewState => ViewState.loaded;

  Future<void> refresh({dynamic params}) async {
    print('refresh');
  }

  getCacheDiscoveryList() async {
    final cacheItems = await _commonRepository.getCacheDiscoveryItems();
    if (cacheItems?.isNotEmpty == true) {
      discoveryItems.value = cacheItems!;
    }
  }

  getDiscoveryList({bool refesh = false}) async {
    getCacheDiscoveryList();
    callApi(doSomething: () async {
      final listItem = await _commonRepository.getDiscoveryList();
      if (listItem.length > 0) {
        discoveryItems.value = listItem;
        _commonRepository.setCacheDiscoveryItems(listItem);
      }
      if (refesh) {
        eventBus.fire(RefreshDiscoveryListEvent());
      }
    });
  }

  Future<List<DiscoveryItemGroup>> getDiscoveryListDetail(
    DiscoveryItem item,
    int page,
    int limit,
  ) async {
    try {
      final response = await _commonRepository.getDiscoveryListDetail(item,
          page: page, limit: limit);
      return response;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
