import 'dart:convert';

import 'package:e_learning/page/blank.dart';
// ignore: unused_import
import 'package:e_learning/page/home.dart';
import 'package:e_learning/page/signup.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;


  void checkNOP() async {
    try {
      if (prefs!.getString("email") == null) {
        return;
      }

      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/module/NOP"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": prefs!.getString("email")!}),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      await prefs!.setInt("nop", responseData["nop"]);
        checkToken();

    } catch (error) {
      print(error);
    }
  }

  // void checkModule() async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/module/check"),
  //     );

  //     var responseData = jsonDecode(response.body);

  //     if (response.statusCode > 399) {
  //       throw responseData["message"];
  //     }

  //     await prefs!.setBool("isCaseStudyOpen", responseData["isCaseStudyOpen"]);
  //   } catch (error) {}
  // }

  void checkToken() {
    String? token = prefs?.getString("token");

    if (!mounted) {
      return;
    }

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: ((context) => const SignupPage()),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: ((context) => ShowCaseWidget(
              builder: Builder(
                builder: (context) => const HomePage(
                  isFirstlogin: false,
                ),
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
            checkNOP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                // width: 150,
                // height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                "Let's Learn",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 0, 69, 187),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
