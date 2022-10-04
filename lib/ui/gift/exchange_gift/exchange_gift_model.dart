import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

import '../../../data/repositories/user_repository.dart';

class ExchangeGiftModel extends BaseModel {
  final userRepository = locator<UserRepository>();
  late User user;

  init() async {
    user = locator<UserModel>().user!;
  }

  @override
  ViewState get initState => ViewState.loaded;

  getExchangeGift(String idVoucher, int price) async {
    await callApi(doSomething: () async {
      await userRepository.exchangeGift(idVoucher);
      user.numberOfCandy = user.numberOfCandy! - price;
      // await userRepository.updateUserAfterUpdateProfile(user);
      locator<UserModel>().user = user;
      locator<UserModel>().notifyListeners();
    });
  }
}
