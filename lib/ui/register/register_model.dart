import 'package:lomo/ui/base/base_model.dart';

class RegisterModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loaded;

  register() async {
    await callApi(doSomething: () async {});
  }
}
