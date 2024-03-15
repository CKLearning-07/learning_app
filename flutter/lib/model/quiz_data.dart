class QuizData {
  const QuizData({
    required this.answer,
    required this.options,
    required this.question,
  });

  final String question;
  final List<String> options;
  final String answer;
}
