import 'package:flutter/material.dart';
import 'package:lomo/res/strings.dart';

import 'bottom_sheet_widgets.dart';
import 'dropdown_button_widget.dart';
import 'wheel_list_picker_widget.dart';

class DropDownHeightWeightWidget extends StatefulWidget {
  final Function(int, int)? onSelected;
  final int initHeight;
  final int initWeight;
  DropDownHeightWeightWidget(
      {this.onSelected, this.initHeight = 0, this.initWeight = 0});

  @override
  State<StatefulWidget> createState() => DropDownHeightWeightWidgetState();
}

class DropDownHeightWeightWidgetState
    extends State<DropDownHeightWeightWidget> {
  TextEditingController _controller = TextEditingController();
  int selectedHeightIndex = 90; // 160 cm
  int selectedWeightIndex = 20; // 55kg
  List<int> heights = List<int>.generate(150, (index) => 70 + index);
  List<int> weights = List<int>.generate(165, (index) => 35 + index);

  @override
  void initState() {
    super.initState();
    if (widget.initHeight != 0)
      selectedHeightIndex = heights.indexOf(widget.initHeight);
    if (widget.initWeight != 0)
      selectedWeightIndex = weights.indexOf(widget.initWeight);
  }

  @override
  Widget build(BuildContext context) {
    return DropDownButtonWidget(
      leftTitle: Strings.heightWeight.localize(context),
      hint: Strings.notChoose.localize(context),
      controller: _controller,
      initValue: widget.initWeight != 0 && widget.initWeight != 0
          ? "${heights[selectedHeightIndex]} cm, ${weights[selectedWeightIndex]} kg"
          : "",
      content: BottomSheetPickerModel(
        height: 300,
        onDone: () {
          if (widget.onSelected != null)
            widget.onSelected!(
                heights[selectedHeightIndex], weights[selectedWeightIndex]);
          _controller.text =
              "${heights[selectedHeightIndex]} cm, ${weights[selectedWeightIndex]} kg";
        },
        isFull: false,
        contentWidget: _content(),
        title: Strings.heightWeight.localize(context),
      ),
      isFullScreenPopUp: false,
    );
  }

  _content() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: WheelListPickerWidget(
              initItemIndex: selectedHeightIndex,
              items: heights.map((e) => "$e cm").toList(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHeightIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: WheelListPickerWidget(
              initItemIndex: selectedWeightIndex,
              items: weights.map((e) => "$e kg").toList(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedWeightIndex = index;
                });
              },
            ),
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
