import 'dart:convert';

import 'package:e_learning/page/home.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

// ignore: must_be_immutable
class ScorePage extends StatefulWidget {
  ScorePage({
    required this.score,
    required this.totalQuestions,
    this.retry,
    required this.isFinal,
    super.key,
  });

  bool isFinal;
  final int score;
  final int? retry;
  final int totalQuestions;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  String getImage(double score) {
    if (score >= 90 && score <= 100) {
      return 'assets/images/score/excellent.webp';
    } 
    // else if (score >= 75 && score < 90) {
    //   return 'assets/images/score/welldone.webp';
    // } else if (score >9 && score < 75) {
    //   return 'assets/images/score/goodjob.webp';
    // } 
    else {
      return 'assets/images/score/needsimprovement.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? username = prefs?.getString("username");
    final String? email = prefs?.getString("email");
    final String? college = prefs?.getString("college");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 27, 255),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
              // color: Colors.black,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        (widget.score / widget.totalQuestions) * 100 >= 90
                            ? 'Passed!'
                            : 'Failed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color:
                                (widget.score / widget.totalQuestions) * 100 >=
                                        90
                                    ? Colors.green
                                    : Colors.red
                            // color: Colors.black,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        (widget.score / widget.totalQuestions) * 100 > 90
                            ? 'Hurray $username! \n You have completed the module successfully'
                            : 'Oops $username! \n You have failed the test. Good luck at the next attempt',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          // color: Colors.black,
                        ),
                      ),
                      if (widget.isFinal)
                        Text(
                          'Remaining attempts: ${widget.retry}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            // color: Colors.black,
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          getImage(
                            ((widget.score / widget.totalQuestions) * 100),
                          ),
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          ' ${widget.score} / ${widget.totalQuestions} ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      const Text(
                        ' Points',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          // color: Colors.black,
                        ),
                      ),
                      // const SizedBox(height: 15),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 80),
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => ShowCaseWidget(
                  //         builder: Builder(
                  //       builder: (context) => const HomePage(
                  //         isFirstlogin: false,
                  //       ),
                  //     )),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 68, 67, 67),
                  backgroundColor: const Color.fromARGB(255, 255, 105, 0),
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
