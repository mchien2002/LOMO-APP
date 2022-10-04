import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';

class ToolTipManager {
  final commonRepository = locator<CommonRepository>();
  bool isShowToolTipCheckIn = false;

  init() async {
    isShowToolTipCheckIn = await commonRepository.isShowToolTipCheckIn();
  }

  setShowToolTipCheckIn(bool isShow) async {
    isShowToolTipCheckIn = isShow;
    await commonRepository.setShowToolTipCheckIn(isShow);
  }
}
