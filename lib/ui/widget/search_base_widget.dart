import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

import 'search_bar_widget.dart';

class SearchBaseWidget<T> extends StatelessWidget {
  final Widget Function(BuildContext context, int index) builder;
  final Function(T t, int index)? onItemClicked;
  final String? title;
  SearchBaseWidget({required this.builder, this.onItemClicked, this.title});

  final ValueNotifier<List<T>?> items = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBarWidget(
              hint: Strings.searchCity.localize(context),
              onTextChanged: (text) {},
            ),
            Expanded(
              child: ValueListenableProvider.value(
                value: items,
                child: Consumer<int>(
                  builder: (context, _, child) => ListView.builder(
                    itemCount: items.value?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            builder(context, index),
                            if (index + 1 != items.value?.length)
                              Divider(
                                height: 1,
                                color: getColor().colorDivider,
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
