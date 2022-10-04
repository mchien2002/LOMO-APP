import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class ProfileFileModel extends BaseModel {
  final userRepository = locator<UserRepository>();

  String setTextList<T>(List<T> listData, String Function(T) getName) {
    var text = "";
    if (listData.isEmpty == true) return "...";
    for (int i = 0; i < listData.length; i++) {
      text = text + getName(listData[i]);
      if (i != listData.length - 1) text = text + ", ";
    }
    return text;
  }

  @override
  ViewState get initState => ViewState.loaded;
}
