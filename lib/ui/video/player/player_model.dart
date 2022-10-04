import 'package:flutter/cupertino.dart';
import 'package:lomo/ui/base/base_model.dart';

class PlayerModel extends BaseModel {
  ValueNotifier<bool> isPlaying = ValueNotifier(false);
  ValueNotifier<bool> isShowMenu = ValueNotifier(true);

  @override
  void dispose() {
    isPlaying.dispose();
    isShowMenu.dispose();
    super.dispose();
  }
}
