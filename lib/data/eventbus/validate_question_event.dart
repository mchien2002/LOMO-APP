class ValidateQuestionEvent {
  final int questionIndex;
  final int answerIndex;
  final bool isTrue;

  ValidateQuestionEvent(
      {required this.questionIndex,
      required this.answerIndex,
      required this.isTrue});
}
