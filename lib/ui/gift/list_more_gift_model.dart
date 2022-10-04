import 'package:lomo/data/api/models/gift.dart';
import 'package:lomo/data/repositories/common_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';

class ListMoreGiftModel extends BaseListModel<Gift> {
  Future<List<Gift>> Function(int page, int pageSize)? getItems;
  final _commonRepository = locator<CommonRepository>();

  ViewState get initState => ViewState.loading;

  init(Future<List<Gift>> Function(int page, int pageSize)? getItems) {
    this.getItems = getItems;
  }

  @override
  Future<List<Gift>> getData({params, bool isClear = false}) async {
    final data = await getItems!(
      page,
      pageSize,
    );
    return data;
  }
}
