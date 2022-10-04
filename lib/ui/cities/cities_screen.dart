import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/res/images.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:lomo/ui/base/base_state.dart';
import 'package:lomo/ui/widget/bottom_sheet_widgets.dart';
import 'package:lomo/ui/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

import 'cities_items.dart';
import 'cities_model.dart';

class CitiesScreen extends StatefulWidget {
  final City? initItem;
  final Widget? left;
  final Widget? right;
  final Function(City?)? onItemSelected;

  const CitiesScreen(
      {this.initItem, this.onItemSelected, this.left, this.right});

  @override
  _CitiesScreenState createState() => _CitiesScreenState();
}

class _CitiesScreenState extends BaseState<CitiesModel, CitiesScreen>
    with SingleTickerProviderStateMixin {
  City? selectedItem;

  @override
  void initState() {
    super.initState();
    model.getCities();
    selectedItem = widget.initItem;
  }

  @override
  Widget buildContentView(BuildContext context, CitiesModel model) {
    return BottomSheetModal(
      isRadius: true,
      appbarColor: getColor().white,
      isFull: true,
      contentWidget: _content(),
      titleStyle: textTheme(context).text18.bold.colorDart,
      left: _leftWidget(),
      // right: _rightWidget(),
      title: Strings.province.localize(context),
    );
  }

  Widget body() {
    return Container(
      color: getColor().grayBorder,
    );
  }

  _content() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 23),
          child: SearchBarWidget(
            textStyle: textTheme(context).text14Normal.colorPrimary,
            searchIcon: Image.asset(
              DImages.icTabSearch,
              width: 24,
              height: 24,
              color: getColor().primaryColor,
            ),
            hint: Strings.searchCity.localize(context),
            onTextChanged: (text) {
              model.searchCities(text);
            },
          ),
        ),
        Expanded(
          child: ValueListenableProvider.value(
            value: model.citiesUpdateListener,
            child: Consumer<int?>(
              builder: (context, _, child) => ListView.builder(
                itemCount: model.cities.length,
                itemBuilder: (BuildContext context, int index) {
                  return CitiesItem(
                    item: model.cities[index],
                    onPressed: (city) async {
                      if (selectedItem != city) {
                        selectedItem = city;
                        model.notifyCitiesListener();
                        if (widget.onItemSelected != null)
                          widget.onItemSelected!(selectedItem);
                        // await Future.delayed(
                        //     const Duration(milliseconds: 200), () {});
                        Navigator.of(context).pop();
                      }
                    },
                    initItem: selectedItem,
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  // _rightWidget() {
  //   return InkWell(
  //     child: Text(
  //       Strings.choose.localize(context),
  //       style: textTheme(context).text14Bold.colorWhite,
  //     ),
  //     onTap: () {},
  //   );
  // }

  _leftWidget() {
    return InkWell(
      child: Icon(
        Icons.close,
        size: 25,
        color: getColor().colorDart,
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
