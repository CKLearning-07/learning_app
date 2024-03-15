class QuizState {
  QuizState({
    required this.correctAnswer,
    required this.questionIndex,
    required this.selectedAnswer,
  });
  final int questionIndex;
  final String correctAnswer;
  String selectedAnswer;
}