import 'package:lomo/ui/base/base_model.dart';

abstract class BaseFormModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loaded;
}
