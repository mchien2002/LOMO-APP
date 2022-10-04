import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class IntroModel extends BaseModel {
  final commonRepository = locator<CommonRepository>();
  CarouselController carouselController = CarouselController();
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  ViewState get initState => ViewState.loaded;

  setFirstUsedApp() async {
    await commonRepository.setFirstUseApp(false);
  }

  @override
  void dispose() {
    currentIndex.dispose();
    super.dispose();
  }
}
