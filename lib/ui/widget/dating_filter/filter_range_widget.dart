import 'package:flutter/material.dart';
import 'package:lomo/libraries/xlider/flutter_xlider.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterRangeWidget extends StatefulWidget {
  final Function(double) onSelectionChanged;
  final ValueNotifier<Object?> resetData;
  final double valueRangeOld;

  FilterRangeWidget(this.onSelectionChanged, this.resetData, this.valueRangeOld);

  _FilterRangeWidget createState() => _FilterRangeWidget();
}

class _FilterRangeWidget extends State<FilterRangeWidget> {
  double _lowerValue = Constants.MAX_RANGE;
  late ValueNotifier<Object?> resetData;
  Object? oldResetDataObject;

  @override
  void initState() {
    super.initState();
    if (widget.valueRangeOld != 0.0) {
      _lowerValue = (widget.valueRangeOld);
    }
    resetData = widget.resetData;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider.value(
      value: resetData,
      child: Consumer<Object?>(builder: (context, reset, child) {
        if (reset != null && reset != oldResetDataObject) {
          oldResetDataObject = reset;
          _lowerValue = Constants.MAX_RANGE;
        }
        return _buildFlutterSlider();
      }),
    );
  }

  _buildFlutterSlider() {
    return FlutterSlider(
      values: [_lowerValue],
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: Dimens.spacing7,
        inactiveTrackBarHeight: Dimens.spacing7,
        activeTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: getColor().violet,
        ),
        inactiveTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
      ),
      max: (Constants.MAX_RANGE),
      min: 1,
      jump: true,
      tooltip: FlutterSliderTooltip(
        custom: (value) {
          return Text('${'$value'.split('.')[0]}');
        },
        positionOffset: FlutterSliderTooltipPositionOffset(top: -20),
      ),
      handler: customHandler(Icons.circle),
      step: FlutterSliderStep(
        step: 1,
      ),
      handlerAnimation: FlutterSliderHandlerAnimation(
          curve: Curves.linear,
          reverseCurve: Curves.linear,
          duration: Duration(milliseconds: 500),
          scale: 1.0),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        widget.onSelectionChanged(lowerValue);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(1),
          decoration:
              BoxDecoration(color: getColor().violet.withOpacity(0.0), shape: BoxShape.circle),
          child: Icon(
            icon,
            color: getColor().violet,
            size: Dimens.size25,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 0.05,
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }
}
