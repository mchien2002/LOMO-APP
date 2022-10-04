import 'package:lomo/ui/base/base_model.dart';
import 'package:rxdart/rxdart.dart';

class InAppWebViewModel extends BaseModel {
  var loadingStreamController = BehaviorSubject<bool>();
  var delayStreamSubject = BehaviorSubject<String>();

  @override
  ViewState get viewState => ViewState.loaded;

  void delayToLoadWebView(String url) {
    callApi(doSomething: () async {
      await Future.delayed(const Duration(milliseconds: 500), () {
        delayStreamSubject.sink.add(url);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingStreamController.close();
    delayStreamSubject.close();
  }
}
