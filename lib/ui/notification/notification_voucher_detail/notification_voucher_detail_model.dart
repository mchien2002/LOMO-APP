import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../../data/api/models/gift.dart';
import '../../../data/repositories/common_repository.dart';
import '../../../di/locator.dart';

class NotificationVoucherDetailModel extends BaseModel {
  Gift itemGift = Gift();

  init(String? giftId) async {
    itemGift = await locator<CommonRepository>().getGiftDetail(giftId ?? "");
    notifyListeners();
  }
}
