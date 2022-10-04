import 'package:lomo/ui/base/base_model.dart';

class ForgotPasswordModel extends BaseModel {
  @override
  ViewState get initState => ViewState.loaded;

  forgotPassword() async {
    await callApi(doSomething: () async {});
  }
}
