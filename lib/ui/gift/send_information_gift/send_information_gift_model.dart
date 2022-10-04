import 'package:flutter/cupertino.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:rxdart/rxdart.dart';

class SendInformationGiftModel extends BaseModel {
  final userRepository = locator<UserRepository>();
  final commonRepository = locator<CommonRepository>();
  TextEditingController? techUserName = TextEditingController();
  TextEditingController? techPhone = TextEditingController();
  TextEditingController? techCity = TextEditingController();
  TextEditingController? emailController = TextEditingController();

  TextEditingController? provinceController = TextEditingController();
  List<City>? listProvince;
  late City getProvince;
  TextEditingController? districtController = TextEditingController();
  List<City>? listDistrict;
  City? getDistrict;
  TextEditingController? wardController = TextEditingController();
  List<City>? listWard;
  City? getWard;

  //Subject
  final disableDistrictSubject = BehaviorSubject<bool>();
  final disableWardSubject = BehaviorSubject<bool>();

  @override
  ViewState get initState => ViewState.loaded;

  late User user;

  init() async {
    user = locator<UserModel>().user!;
    techUserName!.text = user.name ?? "";
    techPhone!.text = user.phone ?? "";
    emailController!.text = user.email ?? "";
    if (user.province != null) {
      getProvince = user.province!;
      if (user.province?.name != "") {
        provinceController!.text = user.province!.name;
        disableDistrictSubject.sink.add(true);
      }
    }
  }

  getExchangeGift(String name, String phone, String address, String idGift,
      String province, String district, String ward, String email) async {
    await callApi(doSomething: () async {
      await userRepository.exchangeGift(idGift,
          name: name,
          phone: phone,
          address: address,
          province: province,
          district: district,
          ward: ward,
          email: email);
    });
  }

  updateUserAfterExchangeSuccessful(int price) async {
    await callApi(doSomething: () async {
      // var res = await userRepository.getMyProfile();
      user.numberOfCandy = user.numberOfCandy! - price;
      // await userRepository.updateUserAfterUpdateProfile(user);
      locator<UserModel>().user = user;
      locator<UserModel>().notifyListeners();
      // eventBus.fire(UpdateProfileEvent(user));
    });
  }

  @override
  void dispose() {
    techUserName!.dispose();
    techCity!.dispose();
    techPhone!.dispose();
    disableDistrictSubject.close();
    disableWardSubject.close();
    super.dispose();
  }
}
