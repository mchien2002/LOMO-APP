import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/ui/cities/cities_screen.dart';
import 'package:provider/provider.dart';

import 'dropdown_button_widget.dart';

class DropDownCityWidget extends StatefulWidget {
  final Function(City)? onItemSelected;
  final City? initCity;
  final ValueNotifier<Object?>? resetData;

  DropDownCityWidget({this.onItemSelected, this.initCity, this.resetData});

  @override
  State<StatefulWidget> createState() => DropDownCityWidgetState();
}

class DropDownCityWidgetState extends State<DropDownCityWidget> {
  TextEditingController _controller = TextEditingController();
  City? currentCity;
  late ValueNotifier<Object?> resetData;
  Object? oldResetDataObject;

  @override
  void initState() {
    super.initState();
    currentCity = widget.initCity;
    resetData = widget.resetData ?? ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: resetData,
      child: Consumer<Object?>(
        builder: (context, reset, child) {
          if (reset != null && reset != oldResetDataObject) {
            currentCity = null;
            _controller.text = "";
            oldResetDataObject = reset;
          }
          return DropDownButtonWidget(
            controller: _controller,
            leftTitle: Strings.city.localize(context),
            // rightTitle: Strings.required.localize(context),
            hint: Strings.notChoose.localize(context),
            initValue: currentCity?.name ?? "",
            content: CitiesScreen(
              initItem: currentCity,
              onItemSelected: (item) {
                currentCity = item;
                setState(() {
                  _controller.text = item!.name;
                  if (widget.onItemSelected != null) {
                    widget.onItemSelected!(item);
                  }
                });
              },
            ),
            isFullScreenPopUp: true,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
