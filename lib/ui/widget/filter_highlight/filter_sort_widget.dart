import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterSortWidget extends StatefulWidget {
  final KeyValue initData;
  final String title;
  final List<KeyValue> itemSorts;
  final Function(KeyValue) onSelectionChanged;
  final ValueNotifier<Object?> resetData;

  FilterSortWidget(this.initData, this.itemSorts, this.onSelectionChanged,
      this.title, this.resetData);

  _FilterSortWidget createState() => _FilterSortWidget();
}

class _FilterSortWidget extends State<FilterSortWidget> {
  late ValueNotifier<Object?> resetData;
  Object? oldResetDataObject;
  KeyValue? selectedItemSort;

  @override
  void initState() {
    super.initState();
    selectedItemSort = widget.initData;
    resetData = widget.resetData;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: resetData,
      child: Consumer<Object?>(builder: (context, reset, child) {
        if (reset != null && reset != oldResetDataObject) {
          oldResetDataObject = reset;
          selectedItemSort = widget.initData;
        }
        return _buildSort();
      }),
    );
  }

  _buildSort() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimens.spacing20,
        ),
        Text(
          widget.title,
          style: textTheme(context).text13.bold.colorDart.fontGoogleSans,
        ),
        SizedBox(
          height: Dimens.spacing10,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: Dimens.spacing10,
            children: itemListSort(),
          ),
        ),
      ],
    );
  }

  itemListSort() {
    List<Widget> choices = [];
    widget.itemSorts != null
        ? widget.itemSorts.forEach((item) {
            choices.add(Container(
                child: ChoiceChip(
              label: Text(item.name!),
              labelStyle: _checkColorLabelStyle(item),
              shape: StadiumBorder(
                  side: BorderSide(
                color: _checkColor(item),
              )),
              selectedColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              selected: selectedItemSort == item,
              onSelected: (selected) {
                setState(() {
                  selectedItemSort = item;
                  widget.onSelectionChanged(selectedItemSort!);
                });
              },
            )));
          })
        : Container();
    return choices;
  }

  TextStyle _checkColorLabelStyle(KeyValue item) {
    return selectedItemSort != null
        ? selectedItemSort!.id == item.id
            ? textTheme(context).text13.bold.colorViolet.fontGoogleSans
            : textTheme(context).text13.bold.colorBlack00.fontGoogleSans
        : textTheme(context).text13.bold.colorBlack00.fontGoogleSans;
  }

  Color _checkColor(KeyValue item) {
    return selectedItemSort != null
        ? selectedItemSort!.id == item.id
            ? getColor().violet
            : getColor().colorGray
        : getColor().colorGray;
  }
}
