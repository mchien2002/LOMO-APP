import 'package:flutter/cupertino.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/who_suits_me_answer.dart';
import 'package:lomo/data/api/models/who_suits_me_answers.dart';
import 'package:lomo/data/api/models/who_suits_me_history.dart';
import 'package:lomo/data/api/models/who_suits_me_question.dart';
import 'package:lomo/data/api/models/who_suits_me_question_group.dart';
import 'package:lomo/data/api/models/who_suits_me_result_answer.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_model.dart';

class ReplyQuestionModel extends BaseModel {
  final _userRepository = locator<UserRepository>();
  WhoSuitsMeQuestionGroup? questionGroup;

  List<WhoSuitsMeAnswers> answers = [];

  WhoSuitsMeHistory? result;

  late User user;
  PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  ValueNotifier<int> currentPageIndex = ValueNotifier(1);

  @override
  ViewState get initState => ViewState.loading;

  init(User user) {
    this.user = user;
    // user.id = "5fe187a20cdd731ad72b68de";
    getQuestionGroup();
  }

  getQuestionGroup() async {
    await callApi(doSomething: () async {
      questionGroup = await _userRepository.getWhoSuitsMeQuestions(user.id!);
      questionGroup!.questions = questionGroup!.questions.reversed.toList();
    });
    setState(ViewState.loaded);
  }

  sendAnswers() async {
    result = null;
    await callApi(doSomething: () async {
      result = await _userRepository.submitAnswer(user.id!,
          WhoSuitsMeResultAnswer(answers: answers), questionGroup?.id);
    });
  }

  sentFirstMessageSuccess() async {
    try {
      locator<UserRepository>().sentSayHi(user.id!);
    } catch (e) {
      print(e);
    }
  }

  WhoSuitsMeQuestionGroup createModelTest() {
    return WhoSuitsMeQuestionGroup(
      user: user,
      questions: [
        WhoSuitsMeQuestion(
          name: "Bạn thích uống loại thức uống nào?",
          id: "001H",
          answers: [
            WhoSuitsMeAnswer(
              name: "Trà Chanh",
              id: "0ABC",
            ),
            WhoSuitsMeAnswer(
              name: "Cafe đá không đường",
              isTrue: true,
              id: "0ABB",
            ),
            WhoSuitsMeAnswer(
              name: "Hồng trà sữa trân châu",
              id: "0ACC",
            ),
          ],
        ),
        WhoSuitsMeQuestion(
          name: "Bạn thích đi đâu chơi khi buồn",
          id: "002H",
          answers: [
            WhoSuitsMeAnswer(
              name: "Đi ngủ",
              id: "0AAC",
            ),
            WhoSuitsMeAnswer(
              name: "Đi dạo công viên",
              id: "0AAC",
            ),
            WhoSuitsMeAnswer(
              name: "Đi dạo toàn thành phố",
              isTrue: true,
              id: "0ABCAWS",
            ),
          ],
        ),
        WhoSuitsMeQuestion(
          name: "Bạn sợ gì nhất?",
          id: "003H",
          answers: [
            WhoSuitsMeAnswer(
              name: "Sơ ba má chửi",
              isTrue: true,
              id: "0ABCAA",
            ),
            WhoSuitsMeAnswer(
              name: "Sợ sợ sợ thôi",
              id: "0ABCCVB",
            ),
            WhoSuitsMeAnswer(
              name: "Siêu nhân nên không sợ.",
              id: "0ABAQEC",
            ),
          ],
        ),
      ],
    );
  }

  Future<String> getAccessToken() async {
    return await _userRepository.getAccessToken() ?? "";
  }

  @override
  void dispose() {
    controller.dispose();
    currentPageIndex.dispose();
    super.dispose();
  }
}
