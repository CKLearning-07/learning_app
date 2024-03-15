import 'dart:convert';
import 'package:e_learning/page/forget_password.dart';
import 'package:e_learning/page/home.dart';
import 'package:e_learning/page/signup.dart';
import 'package:e_learning/page/tour_intro.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isLoading = false;
  bool isForgotPassLoading = false;
  void login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
            "password": _passwordController.text,
          },
        ),
      );

      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      print(responseData);

      await prefs?.setString("token", responseData["token"]);
      await prefs?.setString("email", responseData["email"]);
      await prefs?.setString("username", responseData["username"]);
      await prefs?.setString("userId", responseData["userId"]);
      await prefs?.setString("phno", responseData["phno"]);
      await prefs?.setString("city", responseData["city"]);
      await prefs?.setString("college", responseData["college"]);
      await prefs?.setString("branch", responseData["branch"]);
      await prefs?.setBool("isIntroFinished", responseData["progress"][0]);
      await prefs?.setBool("isModuleFinished", responseData["progress"][1]);
      await prefs?.setBool(
          "isInstructionFinished", responseData["progress"][2]);
      await prefs?.setBool(
          "isImageUploadFinished", responseData["progress"][3]);
      await prefs?.setBool("isCaseStudyFinished", responseData["progress"][4]);
      await prefs?.setBool("caseStudy1", responseData["caseStudy1"]);
      await prefs?.setBool("caseStudy2", responseData["caseStudy2"]);
      await prefs?.setBool("caseStudy3", responseData["caseStudy3"]);
      await prefs?.setBool("caseStudy4", responseData["caseStudy4"]);
      await prefs?.setBool("caseStudy5", responseData["caseStudy5"]);
      await prefs?.setBool("isQuiz1Finished", responseData["isQuiz1Finished"]);
      await prefs?.setBool("isQuiz2Finished", responseData["isQuiz2Finished"]);
      await prefs?.setBool("isQuiz3Finished", responseData["isQuiz3Finished"]);
      await prefs?.setInt("quiz1Retry", responseData["quiz1Retry"]);
      await prefs?.setInt("quiz2Retry", responseData["quiz2Retry"]);
      await prefs?.setInt("quiz3Retry", responseData["quiz3Retry"]);
      await prefs?.setInt("nop", responseData["nop"]);
      await prefs!.setBool("isCaseStudyOpen", responseData["isCaseStudyOpen"]);

      setState(() {
        isLoading = false;
      });

      if (!mounted) {
        return;
      }

      if (responseData["intro"]) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => TourIntro()),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShowCaseWidget(
              builder: Builder(
                builder: (context) => const HomePage(
                  isFirstlogin: false,
                ),
              ),
            ),
          ),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  void forgetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
      return;
    }
    if (!isEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid email"),
        ),
      );
      return;
    }
    setState(() {
      isForgotPassLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(
            "${dotenv.env["BACKEND_API_BASE_URL"]}/reset/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
          },
        ),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ForgetPassword(
            email: _emailController.text,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    } finally {
      setState(() {
        isForgotPassLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome\nBack!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   vertical: 15,
                            //   horizontal: 15,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (email) {
                            if (email == null) {
                              return "The email should not be empty";
                            }
                            if (!isEmail(email.trim())) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   vertical: 15,
                            //   horizontal: 15,
                            // ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (password) {
                            if (password == null) {
                              return "The password should not be empty";
                            }
                            if (!isPassword(password.trim())) {
                              return "The password must have at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: isLoading ? () {} : login,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(58, 142, 66, 255),
                            ),
                            width: MediaQuery.of(context).size.width - 225,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: ((context) => const SignupPage()),
                              ),
                            );
                          },
                          child: const Text(
                            "New to E Learning?   Signup!",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        // const SizedBox(height: 5),
                        TextButton(
                            onPressed: forgetPassword,
                            child: isForgotPassLoading
                                ? CircularProgressIndicator()
                                : const Text(
                                    "Forgot Password?",
                                    style: TextStyle(fontSize: 12),
                                  )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
