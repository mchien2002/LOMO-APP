import 'package:flutter/cupertino.dart';
import 'package:lomo/res/colors.dart';
import 'package:provider/provider.dart';

class LineIndicatorWidget extends StatefulWidget {
  final int totalStep;
  final ValueNotifier<int> currentStep;
  final unselectedColor;
  final selectedColor;

  LineIndicatorWidget(this.totalStep, this.currentStep,
      {this.selectedColor = DColors.whiteColor,
      this.unselectedColor = DColors.gray99Color});

  @override
  State<StatefulWidget> createState() => _LineIndicatorWidgetState();
}

class _LineIndicatorWidgetState extends State<LineIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: widget.currentStep,
      child: Consumer<int>(
        builder: (context, currentStep, child) => _buildIndicator(),
      ),
    );
  }

  Widget _buildIndicator() {
    List<Widget> items = [];
    for (int i = 0; i < widget.totalStep; i++) {
      // từ phần tử thứ 2 trở đi sẽ thêm khoảng cách giữa các phần tử vào
      if (i != 0)
        items.add(SizedBox(
          width: 5,
        ));
      items.add(Container(
        height: 4,
        width: i == widget.currentStep.value ? 20 : 6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: i == widget.currentStep.value
                ? widget.selectedColor
                : widget.unselectedColor),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
