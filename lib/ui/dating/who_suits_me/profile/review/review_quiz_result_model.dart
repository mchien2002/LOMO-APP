import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ReviewQuizResultModel extends BaseListModel<WhoSuitsMeHistory> {
  final _userRepository = locator<UserRepository>();
  late WhoSuitsMeHistory result;

  PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  ValueNotifier<int> currentPageIndex = ValueNotifier(1);

  init(WhoSuitsMeHistory result) {
    this.result = result;
    loadData();
  }

  @override
  ViewState get initState => ViewState.loaded;

  @override
  Future<List<WhoSuitsMeHistory>> getData({params,bool isClear = false}) async {
    return await _userRepository.getWhoSuitsMeResult(result.user!.id!);
  }
}
