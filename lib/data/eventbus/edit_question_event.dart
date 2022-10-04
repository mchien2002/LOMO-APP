class EditQuestionEvent {
  final int questionIndex;
  final String data;

  EditQuestionEvent(
      {required this.questionIndex,
      required this.data});
}
