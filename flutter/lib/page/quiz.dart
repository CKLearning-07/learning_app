import 'dart:convert';

import 'package:e_learning/model/quiz_data.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:e_learning/widgets/quiz_options.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/model/quiz_state.dart';
import 'package:e_learning/page/score.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    required this.quizData,
    required this.isFinal,
    this.quizNumber,
    this.retry,
    super.key,
  });

  final List<QuizData> quizData;
  final bool isFinal;
  final int? retry;
  final int? quizNumber;

  @override
  State<StatefulWidget> createState() {
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  // ignore: avoid_init_to_null
  var _selectedQuizValue = null;
  var _quizIndex = 0;
  bool isLoading = false;

  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  List<QuizState> quizState = [];

  int score = 0;
  void selectedValueHandler(int value) {
    setState(() {
      _selectedQuizValue = value;
    });
  }

  void updateProgress(String email) async {
    for (var element in quizState) {
      if (element.correctAnswer == element.selectedAnswer) {
        score++;
      }
    }

    if ((score / widget.quizData.length) * 100 > 90) {
      if (widget.quizNumber == 1) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/complete/1"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setBool("isQuiz1Finished", true);
      }
      if (widget.quizNumber == 2) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/complete/2"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setBool("isQuiz2Finished", true);
      }
      if (widget.quizNumber == 3) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/complete/3"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setBool("isQuiz3Finished", true);
      }
    }

    if ((score / widget.quizData.length) * 100 < 90) {
      if (widget.quizNumber == 1) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/retry/1"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setInt("quiz1Retry", prefs!.getInt("quiz1Retry")! - 1);
      }
      if (widget.quizNumber == 2) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/retry/2"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setInt("quiz2Retry", prefs!.getInt("quiz2Retry")! - 1);
      }
      if (widget.quizNumber == 3) {
        http.post(
          Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/retry/3"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
            {"email": prefs!.getString("email")},
          ),
        );
        await prefs!.setInt("quiz3Retry", prefs!.getInt("quiz3Retry")! - 1);
      }
    }
    if (!widget.isFinal) {
      if (!mounted) {
        return;
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: score,
            totalQuestions: widget.quizData.length,
            isFinal: widget.isFinal,
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/module/complete"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": prefs!.getString("email"),
            "module": 2,
          },
        ),
      );

      http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/retry-decrement"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": prefs!.getString("email"),
          },
        ),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (responseData["increment"]) {
        await prefs!.setInt("progress", (prefs!.getInt("progress")!) + 1);
      }

      http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/result"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "email": email,
            "score": (score / widget.quizData.length) * 100,
          },
        ),
      );

      if ((score / widget.quizData.length) * 100 > 90) {
        http.get(
          Uri.parse(
              "${dotenv.env["BACKEND_API_BASE_URL"]}/certificate/${prefs!.getString("username")}/${prefs!.getString("college")}/${prefs!.getString("email")}"),
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your certificate is sent to your email"),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });

      if (!mounted) {
        return;
      }

      // Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: score,
            totalQuestions: widget.quizData.length,
            isFinal: widget.isFinal,
            retry: widget.retry,
          ),
        ),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong."),
        ),
      );
    }
  }

  void quizIndexHandler(value) async {
    if (value == 1) {
      if (_selectedQuizValue == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an answer"),
          ),
        );
        return;
      }

      for (var element in quizState) {
        if (_quizIndex == element.questionIndex) {
          if (widget.quizData[_quizIndex].options
                  .indexOf(element.selectedAnswer) !=
              _selectedQuizValue) {
            setState(() {
              element.selectedAnswer =
                  widget.quizData[_quizIndex].options[_selectedQuizValue];
            });
          }
        }
      }

      for (var element in quizState) {
        if (_quizIndex + 1 == element.questionIndex) {
          setState(() {
            _selectedQuizValue = widget.quizData[_quizIndex + 1].options
                .indexOf(element.selectedAnswer);
            _quizIndex++;
          });
          return;
        }
      }

      quizState.add(
        QuizState(
          correctAnswer: widget.quizData[_quizIndex].answer,
          questionIndex: _quizIndex,
          selectedAnswer:
              widget.quizData[_quizIndex].options[_selectedQuizValue],
        ),
      );
      if (_quizIndex == widget.quizData.length - 1) {
        updateProgress(prefs!.getString('email')!);
        return;
      }
      setState(() {
        _selectedQuizValue = null;
        _quizIndex++;
      });
    } else if (value == -1) {
      for (var element in quizState) {
        if (_quizIndex == element.questionIndex) {
          if (widget.quizData[_quizIndex].options
                  .indexOf(element.selectedAnswer) !=
              _selectedQuizValue) {
            setState(() {
              element.selectedAnswer =
                  widget.quizData[_quizIndex].options[_selectedQuizValue];
            });
          }
        }
      }

      if (_quizIndex == 0) {
        // Navigator.pop(context);
      }

      for (var element in quizState) {
        if (_quizIndex - 1 == element.questionIndex) {
          setState(() {
            _selectedQuizValue = widget.quizData[_quizIndex - 1].options
                .indexOf(element.selectedAnswer);
            --_quizIndex;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    score = 0;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 156, 27, 255),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  // const SizedBox(width: 20),
                  // InkWell(
                  //   borderRadius: const BorderRadius.all(
                  //     Radius.circular(100),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Ink(
                  //     width: 45,
                  //     height: 50,
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(100),
                  //       ),
                  //     ),
                  //     child: const Icon(Icons.arrow_back_ios_new_rounded),
                  //   ),
                  // ),
                  const Spacer(),
                  Text(
                    "${_quizIndex + 1} of ${widget.quizData.length}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const Spacer(),
                  // const SizedBox(width: 65)
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - 150,
                height: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(108, 187, 148, 255),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    value: (_quizIndex + 1) / widget.quizData.length,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 140,
                margin: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 196, 118, 255),
                      blurRadius: 1,
                      offset: Offset(5, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Select right answer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 106, 106, 106),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 370,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              widget.quizData[_quizIndex].question,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            QuizOptions(
                              selectedValue: _selectedQuizValue,
                              options: widget.quizData[_quizIndex].options,
                              selectedValueHandler: selectedValueHandler,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            quizIndexHandler(-1);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Text(
                              "Back",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: isLoading
                              ? () {}
                              : () {
                                  quizIndexHandler(1);
                                },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 118, 32),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 230, 88, 0),
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    _quizIndex == widget.quizData.length - 1
                                        ? "Complete"
                                        : "Next",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
