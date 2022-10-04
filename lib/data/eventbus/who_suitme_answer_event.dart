class WhoSuitMeAnswerEvent {
  final int questionIndex;
  final int answerIndex;
  final bool isTrue;

  WhoSuitMeAnswerEvent(
      {required this.questionIndex,
      required this.answerIndex,
      required this.isTrue});
}
