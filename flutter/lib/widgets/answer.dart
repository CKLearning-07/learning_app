import 'package:e_learning/model/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerPage extends StatelessWidget {
  AnswerPage({super.key, required this.quizData});
  final List<QuizData> quizData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 153, 0, 255),
        title: Text("Answers",
            style: GoogleFonts.dmSerifDisplay()
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: quizData.length,
                itemBuilder: (context, index) {
                  QuizData data = quizData[index];
                  return ListTile(
                    title: Text(
                      '${index + 1} ) ${data.question}',
                      style: GoogleFonts.dmSerifDisplay(),
                    ),
                    subtitle: Text(
                      'Answer: ${data.answer}',
                      style: GoogleFonts.dmSerifDisplay()
                          .copyWith(color: Colors.green),
                    ),
                  );
                },
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
