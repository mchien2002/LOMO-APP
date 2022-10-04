import 'package:flutter/material.dart';
import 'package:lomo/libraries/xlider/flutter_xlider.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/dimens.dart';
import 'package:lomo/res/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class FilterAgeWidget extends StatefulWidget {
  final Function(double) onSelectionLowerValueChanged;
  final Function(double) onSelectionUpperValueChanged;
  final ValueNotifier<Object?> resetData;
  final double? valueMinAgeOld;
  final double? valueMaxAgeOld;

  FilterAgeWidget(
      this.onSelectionLowerValueChanged,
      this.onSelectionUpperValueChanged,
      this.resetData,
      this.valueMinAgeOld,
      this.valueMaxAgeOld);

  _FilterAgeWidget createState() => _FilterAgeWidget();
}

class _FilterAgeWidget extends State<FilterAgeWidget> {
  double _lowerValue = Constants.minAge;
  double _upperValue = Constants.maxAge;
  late ValueNotifier<Object?> resetData;
  Object? oldResetDataObject;

  @override
  void initState() {
    super.initState();
    if (widget.valueMinAgeOld != Constants.minAge ||
        widget.valueMaxAgeOld != Constants.maxAge) {
      _lowerValue = widget.valueMinAgeOld!;
      _upperValue = widget.valueMaxAgeOld!;
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
          _lowerValue = Constants.minAge;
          _upperValue = Constants.maxAge;
        }
        return _buildFlutterSlider();
      }),
    );
  }

  _buildFlutterSlider() {
    return FlutterSlider(
      rangeSlider: true,
      values: [_lowerValue, _upperValue],
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
      max: Constants.maxAge,
      min: Constants.minAge,
      jump: true,
      tooltip: FlutterSliderTooltip(
        custom: (value) {
          return Text('${'$value'.split('.')[0]}');
        },
        positionOffset: FlutterSliderTooltipPositionOffset(top: -12.0),
      ),
      handler: customHandler(Icons.circle),
      rightHandler: customHandler(Icons.circle),
      step: FlutterSliderStep(step: 1),
      handlerAnimation: FlutterSliderHandlerAnimation(
          curve: Curves.linear,
          reverseCurve: Curves.linear,
          duration: Duration(milliseconds: 500),
          scale: 1.0),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        _upperValue = upperValue;
        widget.onSelectionLowerValueChanged(lowerValue);
        widget.onSelectionUpperValueChanged(upperValue);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: getColor().violet.withOpacity(0.0),
              shape: BoxShape.circle),
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
