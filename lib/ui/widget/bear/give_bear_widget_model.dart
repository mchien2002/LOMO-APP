import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/eventbus/give_bear_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:rxdart/rxdart.dart';

class GiveBearWidgetModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  bool isBear = false;
  late String userId;
  final loadingSubject = BehaviorSubject<bool>();

  @override
  ViewState get viewState => ViewState.loaded;

  init(String userId, bool isBear) {
    this.userId = userId;
    this.isBear = isBear;
  }

  sendBear(String userId) async {
    await callApi(doSomething: () async {
      await _userRepository.sendBear(userId);
      locator<UserModel>().user!.numberOfCandy =
          locator<UserModel>().user!.numberOfCandy! - 1;
      locator<UserModel>().notifyListeners();
    });
  }

  updateBear() {
    eventBus.fire(GiveBearUserEvent(userId, isBear));
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubject.close();
  }
}
