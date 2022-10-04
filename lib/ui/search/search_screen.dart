import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/hash_tag.dart';
import 'package:lomo/data/api/models/topic_item.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/tracking/tracking_manager.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/search/search_hashtag/search_hashtag_screen.dart';
import 'package:lomo/ui/search/search_new_feed/search_new_feed_screen.dart';
import 'package:lomo/ui/search/search_theme/search_them_item.dart';
import 'package:lomo/ui/search/search_theme/search_theme_screen.dart';
import 'package:lomo/ui/search/search_user/search_user_item.dart';
import 'package:lomo/ui/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

import 'search_hashtag/search_hashtag_item.dart';
import 'search_model.dart';
import 'search_user/search_user_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseState<SearchModel, SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  static List<String> tabSearchItems = [
    Strings.user,
    Strings.newFeed,
    Strings.topic,
    Strings.hashtag,
  ];

  @override
  void initState() {
    super.initState();
    model.init();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget buildContentView(BuildContext context, SearchModel model) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Dimens.spacing4,
            ),
            _buildSearchBar(),
            SizedBox(
              height: Dimens.spacing8,
            ),
            Expanded(
              child: MultiProvider(
                providers: [
                  ValueListenableProvider.value(value: model.textSearch),
                  ValueListenableProvider.value(
                    value: model.suggestions,
                  )
                ],
                child: Consumer2<String, List<dynamic>>(
                  builder: (context, textSearch, suggestions, child) =>
                      suggestions.isNotEmpty
                          ? _buildMenuSuggest(suggestions)
                          : textSearch.isNotEmpty
                              ? _buildSearchResult()
                              : _buildSearchTrendsAndNearly(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 40,
            height: 40,
            child: Image.asset(
              DImages.backBlack,
              color: getColor().colorDart,
            ),
          ),
        ),
        SizedBox(
          width: Dimens.spacing8,
        ),
        Expanded(
          child: SearchBarWidget(
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (text) {
              model.suggestions.value = [];
              model.isShowSuggest = false;
              model.textSearch.value = text;
              locator<TrackingManager>().trackSearchButton();
            },
            autoFocus: false,
            controller: searchController,
            hint: Strings.lomo_search.localize(context),
            onTextChanged: (text) async {
              if (text.isNotEmpty) {
                if (model.isShowSuggest) {
                  await model.searchSuggestion(text);
                } else {
                  model.textSearch.value = text;
                  model.suggestions.value = [];
                }
              } else {
                model.suggestions.value = [];
                model.textSearch.value = "";
              }
              if (text != model.oldTextSearchSuggest) {
                model.oldTextSearchSuggest = text;
                model.isShowSuggest = true;
              }
              // model.textSearch.value = text;
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget _buildMenuSuggest(List<dynamic> suggestions) {
    return Container(
      color: getColor().white,
      width: double.infinity,
      height: double.infinity,
      child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            if (item is User) {
              return SearchUserItem(
                user: item,
                onPressed: () {
                  model.addRecentlySearchText(item.name!);
                },
              );
            } else if (item is HashTag) {
              return SearchHashTagItem(
                hashTag: item,
                onPressed: () {
                  model.addRecentlySearchText(item.name!);
                },
              );
            } else if (item is TopictItem) {
              return SearchThemItem(
                topic: item,
                onPressed: () {
                  model.addRecentlySearchText(item.name!);
                },
              );
            }
            return Container();
          },
          separatorBuilder: (context, index) => Container(
                height: 1,
                color: getColor().pinkF2F5Color,
              ),
          itemCount: suggestions.length),
    );
  }

  Widget _buildSearchResult() {
    return Column(
      children: [
        _buildContentSearchBar(),
        Expanded(
          child: _buildContentSearch(),
        )
      ],
    );
  }

  Widget _buildSearchTrendsAndNearly() {
    return Column(
      children: [
        _buildTrends(),
        _buildSearchNearly(),
      ],
    );
  }

  Widget _buildTrends() {
    return ValueListenableProvider.value(
      value: model.trends,
      child: Consumer<List<String>>(
        builder: (context, trends, child) => trends.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    color: getColor().pinkF2F5Color,
                    height: 32,
                    child: Text(
                      Strings.trend.localize(context),
                      style: textTheme(context).text13.bold.colorGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: trends
                          .map((e) => InkWell(
                                onTap: () {
                                  model.isShowSuggest = false;
                                  searchController.text = e;
                                  searchController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset:
                                              searchController.text.length));
                                },
                                child: Text(
                                  "#$e",
                                  style: textTheme(context)
                                      .text13
                                      .medium
                                      .colorDart,
                                ),
                              ))
                          .toList(),
                    ),
                  )
                ],
              )
            : SizedBox(
                height: 0,
              ),
      ),
    );
  }

  Widget _buildSearchNearly() {
    return model.recentlySearchTexts.isNotEmpty
        ? Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  color: getColor().pinkF2F5Color,
                  height: 32,
                  child: Text(
                    Strings.recently.localize(context),
                    style: textTheme(context).text13.bold.colorGray,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: model.recentlySearchTexts.reversed
                          .map((e) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  //                    <--- top side
                                  color: getColor().colorDivider,
                                  width: 1.0,
                                ))),
                                child: InkWell(
                                  onTap: () {
                                    model.isShowSuggest = false;
                                    searchController.text = e;
                                    searchController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                searchController.text.length));
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        DImages.recently,
                                        height: 32,
                                        width: 32,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        e,
                                        style: textTheme(context)
                                            .text15
                                            .medium
                                            .colorDart,
                                      )
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  //
  Widget _buildContentSearchBar() {
    return Container(
      width: double.infinity,
      height: Dimens.size40,
      decoration: BoxDecoration(
        color: getColor().white,
        border: Border(
          bottom: BorderSide(
            color: getColor().pinkF2F5Color,
            width: 1.0,
          ),
          top: BorderSide(
            color: getColor().pinkF2F5Color,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          physics: AlwaysScrollableScrollPhysics(),
          unselectedLabelColor: getColor().text9094abColor,
          labelColor: getColor().primaryColor,
          labelStyle: textTheme(context).text13.bold,
          unselectedLabelStyle: textTheme(context).text13.bold,
          indicatorColor: getColor().primaryColor,
          indicatorWeight: 3,
          tabs: [
            Tab(
              text: Strings.user.localize(context),
            ),
            Tab(
              text: Strings.newFeed.localize(context),
            ),
            Tab(
              text: Strings.topic.localize(context),
            ),
            Tab(
              text: Strings.hashtag.localize(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSearch() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: tabSearchItems
            .map((item) => _getItemSearchResult(tabSearchItems.indexOf(item)))
            .toList());
  }

  Widget _getItemSearchResult(int itemIndex) {
    switch (itemIndex) {
      case 0:
        return SearchUserScreen(
          textSearch: model.textSearch,
        );
      case 1:
        return SearchNewFeedScreen(
          textSearch: model.textSearch,
        );
      case 2:
        return SearchThemeScreen(
          textSearch: model.textSearch,
        );
      case 3:
        return SearchHashTagScreen(
          textSearch: model.textSearch,
        );
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
