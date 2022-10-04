import 'package:flutter/cupertino.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/eventbus/give_bear_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class DatingListItemModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  ValueNotifier<bool> enableButtonSayHi = ValueNotifier(false);
  late User user;
  ValueNotifier<bool> displaySentBear = ValueNotifier(true);
  ValueNotifier<int> totalBear = ValueNotifier(0);
  late String accessToken = "";

  init(User user) async {
    this.user = user;
    notifyListeners();
    getAccessToken().then((value) => accessToken = value);

    enableButtonSayHi.value = !user.isSayhi!;
    eventBus.on<GiveBearUserEvent>().listen((event) async {
      if (this.user.id == event.userId) {
        this.user.isBear = event.isBear;
        this.user.numberOfBear = this.user.numberOfBear! + 1;
        totalBear.value =
            this.user.numberOfBear != null ? this.user.numberOfBear! : 1;
        //Disable nut tang gau
        displaySentBear.value = true;
        notifyListeners();
      }
    });
    await getUserDetailData();
  }

  getUserDetailData() async {
    user = await _userRepository.getUserDetail(user.id!);
    totalBear.value = user.numberOfBear!;
    displaySentBear.value = user.isBear!;
    notifyListeners();
  }

  sentFirstMessageSuccess() async {
    callApi(doSomething: () {
      locator<UserRepository>().sentSayHi(user.id!);
    });
  }

  Future<String> getAccessToken() async {
    return await _userRepository.getAccessToken() ?? "";
  }

  block(User user) async {
    await callApi(doSomething: () async {
      await _userRepository.blockUser(user);
    });
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  void dispose() {
    displaySentBear.dispose();
    enableButtonSayHi.dispose();
    super.dispose();
  }
}
