class EditAnswerEvent {
  final int questionIndex;
  final int answerIndex;
  final String data;

  EditAnswerEvent(
      {required this.questionIndex,
      required this.answerIndex,
      required this.data});
}
