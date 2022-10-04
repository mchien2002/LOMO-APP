import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListGiftModel extends BaseListModel<Gift> {
  bool? isHot;
  final _commonRepository = locator<CommonRepository>();

  ViewState get initState => ViewState.loading;

  @override
  Future<List<Gift>> getData({params, bool isClear = false}) async {
    final data = await _commonRepository.getGifts(
      page,
      pageSize,
    );
    return data;
  }
}
