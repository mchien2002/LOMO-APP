import 'package:flutter/material.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/text_theme.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterVerifyAccountWidget extends StatefulWidget {
  const FilterVerifyAccountWidget(
      {Key? key,
      required this.text,
      required this.initSwitch,
      required this.selectedSwitch,
      required this.resetData})
      : super(key: key);
  final String text;
  final bool initSwitch;
  final Function(bool) selectedSwitch;
  final ValueNotifier<Object?> resetData;

  @override
  _FilterVerifyAccountWidgetState createState() => _FilterVerifyAccountWidgetState();
}

class _FilterVerifyAccountWidgetState extends State<FilterVerifyAccountWidget> {
  bool initValue = true;
  Object? oldResetDataObject;
  ValueNotifier<Object?>? resetData;

  @override
  void initState() {
    super.initState();
    initValue = widget.initSwitch;
    resetData = widget.resetData;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
        value: resetData!,
        child: Consumer<Object?>(builder: (context, reset, child) {
          if (reset != null && reset != oldResetDataObject) {
            oldResetDataObject = reset;
            initValue = widget.initSwitch;
          }
          return _build();
        }));
  }

  Widget _build() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyContent),
      child: Row(
        children: [
          Text(
            "${widget.text}",
            style: textTheme(context).text13.bold.colorDart,
          ),
          Spacer(),
          Switch(
            value: initValue,
            activeColor: getColor().violet,
            onChanged: (value) {
              setState(() {
                initValue = value;
              });
              widget.selectedSwitch(value);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
