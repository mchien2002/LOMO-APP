import 'package:flutter/material.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/strings.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterZodiacWidget extends StatefulWidget {
  final List<Zodiac>? chipName;
  final Function(List<Zodiac>) onSelectionChanged;
  final ValueNotifier<Object?> resetData;
  final List<Zodiac> selectedChoicesZodiacCache;

  FilterZodiacWidget(this.chipName, this.onSelectionChanged, this.resetData,
      this.selectedChoicesZodiacCache);

  @override
  _FilterZodiacWidget createState() => _FilterZodiacWidget();
}

class _FilterZodiacWidget extends State<FilterZodiacWidget> {
  late ValueNotifier<Object?> resetData;
  Object? oldResetDataObject;
  List<Zodiac> selectedChoicesZodiac = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedChoicesZodiacCache.isNotEmpty == true) {
      selectedChoicesZodiac = widget.selectedChoicesZodiacCache;
    }
    resetData = widget.resetData;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
        value: resetData,
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
                      Strings.zodiac.localize(context),
                      style: textTheme(context).text13.bold.colorDart,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (selectedChoicesZodiac.length !=
                          widget.chipName!.length) {
                        selectedChoicesZodiac.clear();
                        selectedChoicesZodiac.addAll(widget.chipName!);
                        widget.onSelectionChanged(widget.chipName!);
                        setState(() {
                          _buildChoiceList();
                        });
                      } else {
                        selectedChoicesZodiac.clear();
                        widget.onSelectionChanged(selectedChoicesZodiac);
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
                          selectedChoicesZodiac.length !=
                                  widget.chipName!.length
                              ? Strings.all.localize(context)
                              : Strings.delete.localize(context),
                          style: textTheme(context).text13.bold.colorViolet,
                        )),
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
              labelStyle: selectedChoicesZodiac.contains(item)
                  ? textTheme(context).text13.bold.colorViolet
                  : textTheme(context).text13.bold.colorBlack00,
              shape: StadiumBorder(
                  side: BorderSide(
                color: selectedChoicesZodiac.contains(item)
                    ? getColor().violet
                    : getColor().colorGray,
              )),
              selectedColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              selected: selectedChoicesZodiac.contains(item),
              onSelected: (selected) {
                setState(() {
                  if (selectedChoicesZodiac.contains(item)) {
                    selectedChoicesZodiac.remove(item);
                    widget.onSelectionChanged(selectedChoicesZodiac);
                  } else {
                    selectedChoicesZodiac.add(item);
                    widget.onSelectionChanged(selectedChoicesZodiac);
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
    // TODO: implement dispose
    super.dispose();
  }
}
