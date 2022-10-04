import 'package:flutter/material.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class CircleIndicatorWidget extends StatefulWidget {
  final int totalStep;
  final ValueNotifier<int> currentStep;
  final Color? unselectedColor;
  final Color? selectedColor;
  final double size;
  final double? itemMargin;

  CircleIndicatorWidget(this.size, this.totalStep, this.currentStep,
      {this.selectedColor, this.unselectedColor, this.itemMargin});

  @override
  State<StatefulWidget> createState() => _CircleIndicatorWidgetState();
}

class _CircleIndicatorWidgetState extends State<CircleIndicatorWidget> {
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
          width: widget.itemMargin ?? 8,
        ));
      items.add(Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size / 2),
            color: i == widget.currentStep.value
                ? widget.selectedColor ?? getColor().pin88Color
                : widget.unselectedColor ??
                    getColor().pin88Color.withOpacity(0.3)),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
