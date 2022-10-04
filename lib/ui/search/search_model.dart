import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class SearchModel extends BaseModel {
  final _commonRepository = locator<CommonRepository>();
  final _userRepository = locator<UserRepository>();

  bool isShowSuggest = true;
  String oldTextSearchSuggest = "";

  ViewState get initState => ViewState.loaded;

  ValueNotifier<String> textSearch = ValueNotifier("");

  List<String> recentlySearchTexts = [];

  ValueNotifier<List<String>> trends = ValueNotifier([]);

  ValueNotifier<List<dynamic>> suggestions = ValueNotifier([]);

  Future<List<User>> searchUser(String textSearch) async {
    final response = await locator<CommonRepository>()
        .searchUserAdvance(textSearch, 0, true, limit: 7);
    return response.list;
  }

  Future<List<HashTag>> searchHashTag(String textSearch) async {
    return await locator<CommonRepository>()
        .searchHashTag(textSearch, 1, limit: 5);
  }

  Future<List<TopictItem>> searchTopic(String textSearch) async {
    final response = await locator<CommonRepository>()
        .searchTopicAdvance(textSearch, 0, true, limit: 5);
    return response.list;
  }

  init() async {
    textSearch.addListener(() {
      if (textSearch.value.isNotEmpty) {
        addRecentlySearchText(textSearch.value);
      }
    });
    getTrends();
    final recentlySearchTexts = await _commonRepository.getSearchRecently();
    if (recentlySearchTexts.isNotEmpty) {
      this.recentlySearchTexts.addAll(recentlySearchTexts);
      notifyListeners();
    }
  }

  searchSuggestion(String textSearch) async {
    callApi(doSomething: () async {
      final responses = await Future.wait([
        searchUser(textSearch),
        searchHashTag(textSearch),
        searchTopic(textSearch)
      ]);
      if (responses.isNotEmpty == true) {
        final data = [];
        responses.forEach((element) {
          data.addAll(element);
        });
        suggestions.value = data;
      }
    });
  }

  getTrends() async {
    callApi(doSomething: () async {
      final hashtagTrends = await _commonRepository
          .searchHashTag(textSearch.value, 1, limit: 100, isTrend: true);
      if (hashtagTrends.isNotEmpty == true) {
        this.trends.value = hashtagTrends.map((e) => e.name!).toList();
      }
    });
  }

  addRecentlySearchText(String text) async {
    if (text.isNotEmpty && !recentlySearchTexts.contains(text)) {
      if (recentlySearchTexts.length == 10) {
        recentlySearchTexts.removeAt(0);
      }
      recentlySearchTexts.add(text);
      _commonRepository.setSearchRecently(recentlySearchTexts);
    }
  }

  @override
  void dispose() {
    textSearch.dispose();
    trends.dispose();
    super.dispose();
  }
}
