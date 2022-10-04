import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/base_app_config.dart';
import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/exceptions/api_exception.dart';
import 'package:lomo/data/api/models/who_suits_me_answer.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/eventbus/edit_answer_event.dart';
import 'package:lomo/data/eventbus/edit_question_event.dart';
import 'package:lomo/data/eventbus/validate_question_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class MyQuestionModel extends BaseModel {
  static const MAX_QUESTION = 10;
  final _userResponstory = locator<UserRepository>();
  ValueNotifier<WhoSuitsMeQuestionGroup?> whoSuitsMeQuestionGroupValue =
      ValueNotifier(null);
  ValueNotifier<bool>? enable = ValueNotifier(false);
  Function(int)? questionCountCalback;
  bool isEdit = false;

  init(Function(int) questionCountCalback) {
    whoSuitsMeQuestionGroupValue.value = createModelGroupQuestion();
    this.questionCountCalback = questionCountCalback;
    //Chon cau tra loi
    eventBus.on<ValidateQuestionEvent>().listen((event) async {
      whoSuitsMeQuestionGroupValue.value?.questions[event.questionIndex]
          .answers[event.answerIndex].isTrue = event.isTrue;
      onValidateQuestion();
    });
    //Thay doi noi dung cau hoi
    eventBus.on<EditQuestionEvent>().listen((event) async {
      whoSuitsMeQuestionGroupValue.value?.questions[event.questionIndex].name =
          event.data;
      isEdit = true;
      onValidateQuestion();
    });
    //Thay doi noi dung cau tra loi
    eventBus.on<EditAnswerEvent>().listen((event) async {
      whoSuitsMeQuestionGroupValue.value?.questions[event.questionIndex]
          .answers[event.answerIndex].name = event.data;
      isEdit = true;
      onValidateQuestion();
    });
  }

  @override
  ViewState get initState => ViewState.loading;

  int get totalQuestionCreated => whoSuitsMeQuestionGroupValue.value != null
      ? whoSuitsMeQuestionGroupValue.value!.questions
          .where((element) => !element.isNewItem)
          .toList()
          .length
      : 0;

  List<WhoSuitsMeQuestion> get templateQuestionSelected =>
      whoSuitsMeQuestionGroupValue.value != null
          ? whoSuitsMeQuestionGroupValue.value!.questions
              .where((element) => element.isNewItem)
              .toList()
          : [];

  int get totalQuestion => whoSuitsMeQuestionGroupValue.value != null &&
          whoSuitsMeQuestionGroupValue.value!.questions.length > 0
      ? whoSuitsMeQuestionGroupValue.value!.questions.length
      : 0;

  getData() async {
    await callApi(doSomething: () async {
      try {
        final response = await _userResponstory
            .getWhoSuitsMeQuestions(locator<UserModel>().user!.id!);
        whoSuitsMeQuestionGroupValue.value = response;
        isEdit = false;
        //Tra lai tong so item de hien hi tren tabbar
        if (questionCountCalback != null)
          questionCountCalback!(response.questions.length);
        viewState = ViewState.loaded;
      } catch (error) {
        print(error);
        if ((error as ApiException).statusCode == 404) {
          viewState = ViewState.loaded;
          //Neu chua tao bo cau hoi thi se khoi tao model de luu tru bo cau hoi moi
          createModelGroupQuestion();
        } else {
          viewState = ViewState.error;
          errorMessage = error.message!;
        }
      }
      enable!.value = false;
      notifyListeners();
    });
  }

  Future<void> sendModelGroupQuestion() async {
    await callApi(doSomething: () async {
      await _userResponstory
          .createWhoSuitsMeQuestions(whoSuitsMeQuestionGroupValue.value!);
      getData();
      notifyListeners();
    });
  }

  setQuestionData(int index, WhoSuitsMeQuestion question) {
    whoSuitsMeQuestionGroupValue.value?.questions[index] = question;
    notifyListeners();
  }

  //Tao group bo cau hoi
  WhoSuitsMeQuestionGroup createModelGroupQuestion() {
    final groupQuestion =
        WhoSuitsMeQuestionGroup(user: locator<UserModel>().user, questions: []);
    return groupQuestion;
  }

  createQuestionEmpty() {
    final question = WhoSuitsMeQuestion(answers: []);
    final answers1 = WhoSuitsMeAnswer();
    question.answers.add(answers1);
    final answers2 = WhoSuitsMeAnswer();
    question.answers.add(answers2);
    final answers3 = WhoSuitsMeAnswer();
    question.answers.add(answers3);
    whoSuitsMeQuestionGroupValue.value?.questions.insert(0, question);
    notifyListeners();
  }

  Future<void> deleteModelQuestion(int index) async {
    whoSuitsMeQuestionGroupValue.value!.questions.removeAt(index);
    if (questionCountCalback != null)
      questionCountCalback!(
          whoSuitsMeQuestionGroupValue.value!.questions.length);
    onValidateQuestion();
    notifyListeners();
  }

  onValidateQuestion() async {
    int totalItemInvalid = 0;
    await Future.forEach(whoSuitsMeQuestionGroupValue.value!.questions,
        (WhoSuitsMeQuestion question) async {
      if (question.name != "" &&
          question.answers[0].name != "" &&
          question.answers[1].name != "" &&
          question.answers[2].name != "" &&
          (question.answers[0].isTrue ||
              question.answers[1].isTrue ||
              question.answers[2].isTrue)) {
        totalItemInvalid++;
      }
    });

    enable!.value = (totalItemInvalid == totalQuestion) && totalQuestion >= 3;
  }

  @override
  void dispose() {
    whoSuitsMeQuestionGroupValue.dispose();
    super.dispose();
  }

  String getLinkDomainShare() {
    String baseUrl;
    // init api
    switch (locator<AppModel>().env) {
      case Environment.prod:
        baseUrl = WEB_DOMAIN;
        break;
      case Environment.staging:
        baseUrl = BASE_URL_STA;
        break;
      case Environment.dev:
        baseUrl = BASE_URL_DEV;
        break;
    }

    return baseUrl;
  }
}
