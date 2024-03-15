import 'dart:convert';
import 'package:e_learning/model/quiz_data.dart';
import 'package:e_learning/page/quiz.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class QuizSplash extends StatefulWidget {
  const QuizSplash({
    required this.quizData,
    required this.isFinal,
    super.key,
  });

  final List<QuizData> quizData;
  final bool isFinal;

  @override
  State<QuizSplash> createState() {
    return _QuizSplashState();
  }
}

class _QuizSplashState extends State<QuizSplash> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 150, top: 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                const Text(
                  'Final Quiz Module',
                  style: TextStyle(
                      color: Color.fromARGB(255, 192, 192, 192), fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  'Basics of Sales and Marketing',
                  style: TextStyle(
                      color: Color.fromARGB(255, 151, 151, 151), fontSize: 20),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 40,
                  color: const Color.fromARGB(255, 200, 223, 196),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 106, 106, 106)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Flexible(
                      child: Text(
                        'You can attempt this quiz a maximum of three times',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 106, 106, 106)),
                      ),
                    ),
                  ],
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 106, 106, 106)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Flexible(
                      child: Text(
                        'You need to score atleast 60% on this quiz to get the certification.',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 106, 106, 106)),
                      ),
                    ),
                  ],
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 106, 106, 106)),
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Flexible(
                      child: Text(
                        'Each right answer carries a maximum of 10 points and reduces based on the number of attempts. Refer to the score grid below',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 106, 106, 106)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Score Grid',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 245, 245, 247),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 245, 245, 247),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Attempts',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Answered',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Multiplier',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Final Points',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 66, 66, 66)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 245, 245, 247),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 20),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '1',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '10',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '10',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '100',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 245, 245, 247),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '2',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '10',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '8.5',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '85',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 245, 245, 247),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 0),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '3',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '10',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '7.5',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '75',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? () {}
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                if (!widget.isFinal) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        quizData: widget.quizData,
                                        isFinal: widget.isFinal,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                var response = await http.post(
                                  Uri.parse(
                                      "${dotenv.env["BACKEND_API_BASE_URL"]}/quiz/retryCheck"),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode(
                                    {
                                      "email": prefs!.getString("email"),
                                    },
                                  ),
                                );

                                setState(() {
                                  isLoading = false;
                                });

                                var responseData = jsonDecode(response.body);

                                if (response.statusCode > 399) {
                                  throw responseData["message"];
                                }

                                if (!mounted) {
                                  return;
                                }

                                if (responseData['score'] > 60) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You have already passed this test"),
                                    ),
                                  );
                                  return;
                                }

                                if (responseData['retry'] <= 0) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You have completed all your attempts"),
                                    ),
                                  );
                                  return;
                                }

                                if (!mounted) {
                                  return;
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizPage(
                                      retry: responseData['retry'],
                                      quizData: widget.quizData,
                                      isFinal: widget.isFinal,
                                    ),
                                  ),
                                );
                              } catch (e) {}
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 139, 0, 232),
                              width: 2),
                        ),
                      ),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Take Quiz',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 139, 0, 232)),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
