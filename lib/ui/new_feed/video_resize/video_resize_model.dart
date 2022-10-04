import 'package:flutter/cupertino.dart';
import 'package:lomo/ui/base/base_model.dart';

class VideoResizeModel extends BaseModel {
  double startValue = 0.0;
  double endValue = 0.0;
  ValueNotifier<bool> playingValue = ValueNotifier(false);
  ValueNotifier<bool> saveLoadingValue = ValueNotifier(false);
  changePlayingState(bool state) {
    this.playingValue.value = state;
    notifyListeners();
  }

  changeSaveLoadingState(bool state) {
    this.saveLoadingValue.value = state;
    notifyListeners();
  }
}
