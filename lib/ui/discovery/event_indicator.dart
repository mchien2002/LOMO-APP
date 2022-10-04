import 'package:flutter/cupertino.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class EventIndicatorWidget extends StatefulWidget {
  final int totalStep;
  final ValueNotifier<int> currentStep;

  EventIndicatorWidget(this.totalStep, this.currentStep);

  @override
  State<StatefulWidget> createState() => _EventIndicatorWidgetState();
}

class _EventIndicatorWidgetState extends State<EventIndicatorWidget> {
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
          width: 2,
        ));
      items.add(Expanded(
        child: Container(
          height: 4,
          color: i == widget.currentStep.value
              ? getColor().violetFBColor
              : getColor().white.withOpacity(0.42),
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
