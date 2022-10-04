import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterLiteracyWidget extends StatefulWidget {
  final List<Literacy>? chipName;
  final Function(List<Literacy>) onSelectionChanged;
  final ValueNotifier<Object?>? resetData;
  final List<Literacy> selectedChoicesLiteracyCache;

  FilterLiteracyWidget(this.chipName, this.onSelectionChanged, this.resetData,
      this.selectedChoicesLiteracyCache);

  @override
  _FilterLiteracyWidget createState() => _FilterLiteracyWidget();
}

class _FilterLiteracyWidget extends State<FilterLiteracyWidget> {
  ValueNotifier<Object?>? resetData;
  Object? oldResetDataObject;
  List<Literacy> selectedChoicesLiteracy = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedChoicesLiteracyCache.isNotEmpty == true) {
      selectedChoicesLiteracy = widget.selectedChoicesLiteracyCache;
    }
    resetData = widget.resetData ?? ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
        value: resetData!,
        child: Consumer<Object?>(builder: (context, reset, child) {
          if (reset != oldResetDataObject) {
            oldResetDataObject = reset;
          }
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.paddingBodyContent),
                    child: Text(
                      Strings.literacyFull.localize(context),
                      style: textTheme(context).text13.bold.colorDart,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (selectedChoicesLiteracy.length ==
                          widget.chipName!.length) {
                        selectedChoicesLiteracy.clear();
                        widget.onSelectionChanged(selectedChoicesLiteracy);
                        setState(() {
                          _buildChoiceList();
                        });
                      } else {
                        selectedChoicesLiteracy.clear();
                        selectedChoicesLiteracy.addAll(widget.chipName!);
                        widget.onSelectionChanged(widget.chipName!);
                        setState(() {
                          _buildChoiceList();
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text(
                        selectedChoicesLiteracy.length !=
                                widget.chipName!.length
                            ? Strings.all.localize(context)
                            : Strings.delete.localize(context),
                        style: textTheme(context).text13.bold.colorViolet,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimens.size5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: Dimens.size30, right: Dimens.size30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: Dimens.spacing5,
                    runSpacing: Dimens.spacing4,
                    children: _buildChoiceList(),
                  ),
                ),
              ),
            ],
          );
        }));
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.chipName != null
        ? widget.chipName!.reversed.forEach((item) {
            choices.add(Container(
                child: ChoiceChip(
              label: Text(item.name!),
              labelStyle: selectedChoicesLiteracy.contains(item)
                  ? textTheme(context).text13.bold.colorViolet
                  : textTheme(context).text13.bold.colorBlack00,
              shape: StadiumBorder(
                  side: BorderSide(
                      color: selectedChoicesLiteracy.contains(item)
                          ? getColor().violet
                          : getColor().colorGray)),
              selectedColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              selected: selectedChoicesLiteracy.contains(item),
              onSelected: (selected) {
                setState(() {
                  if (selectedChoicesLiteracy.contains(item)) {
                    selectedChoicesLiteracy.remove(item);
                    widget.onSelectionChanged(selectedChoicesLiteracy);
                  } else {
                    selectedChoicesLiteracy.add(item);
                    widget.onSelectionChanged(selectedChoicesLiteracy);
                  }
                });
              },
            )));
          })
        : Container();
    return choices;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
