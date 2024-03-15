import 'dart:convert';

import 'package:e_learning/data/city.dart';
import 'package:e_learning/page/login.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  bool isFinalPage = false;
  bool isLoading = false;

  String? selectedCity;

  String? enteredEmail;
  String? enteredPassword;
  String? enteredUsername;

  void signup() async {
    if (!_signupFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_API_BASE_URL"]}/user/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": enteredUsername,
            "email": enteredEmail!.toLowerCase(),
            "password": enteredPassword,
            "phno": _phoneNumberController.text,
            "city": selectedCity,
            "college": _collegeController.text,
            "branch": _branchController.text
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

      setState(() {
        _emailController.text = "";
        _passwordController.text = "";
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful. Please Login"),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => LoginPage()),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  List<String> getCitiesList() {
    return City.values.map((city) => city.toString().split('.').last).toList();
  }

  List<String> cities = [];
  _SignupPageState() {
    cities = getCitiesList();
    selectedCity = null;
    print(cities);
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
                    "Create an \naccount!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _signupFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: !isFinalPage,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Username",
                                  prefixIcon: const Icon(Icons.person),
                                ),
                                onSaved: (username) {
                                  setState(() {
                                    enteredUsername = username;
                                  });
                                },
                                validator: (username) {
                                  if (username == null ||
                                      username.trim().isEmpty) {
                                    return "The username should not be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                onSaved: (email) {
                                  setState(() {
                                    enteredEmail = email;
                                  });
                                },
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                                onSaved: (password) {
                                  setState(() {
                                    enteredPassword = password;
                                  });
                                },
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
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Confirm Password",
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                                validator: (password) {
                                  if (password == null) {
                                    return "The password should not be empty";
                                  }
                                  if (!isPassword(password.trim())) {
                                    return "The password must have at least 6 characters";
                                  }
                                  if (_passwordController.text != password) {
                                    return "The passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isFinalPage,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Phone Number",
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                                validator: (number) {
                                  if (number == null) {
                                    return "The Phone number should not be empty";
                                  }
                                  if (!isPhoneNumber(number.trim())) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              Container(
                                child: DropdownButtonFormField<String>(
                                  value: selectedCity,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelText: "Resident City",
                                    prefixIcon: const Icon(Icons.location_city),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text("Please select your city"),
                                    ),
                                    ...cities.map((String city) {
                                      String displayedCity = city.length > 20
                                          ? '${city.substring(0, 20)}\n${city.substring(20)}'
                                          : city;
                                      return DropdownMenuItem<String>(
                                        value: city,
                                        child: Text(
                                          displayedCity,
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedCity = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select your city";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _collegeController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "College",
                                  prefixIcon: const Icon(Icons.school_outlined),
                                ),
                                validator: (college) {
                                  if (college == null ||
                                      college.trim().isEmpty) {
                                    return "Please enter your college name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _branchController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: "Branch",
                                  prefixIcon: const Icon(Icons.book_outlined),
                                ),
                                validator: (branch) {
                                  if (branch == null || branch.trim().isEmpty) {
                                    return "Please enter your branch";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: isLoading
                              ? () {}
                              : isFinalPage
                                  ? signup
                                  : (() {
                                      if (_signupFormKey.currentState!
                                          .validate()) {
                                        _signupFormKey.currentState!.save();
                                        setState(() {
                                          isFinalPage = !isFinalPage;
                                        });
                                      }
                                    }),
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
                                  ? CircularProgressIndicator()
                                  : Text(
                                      isFinalPage ? "Signup" : "Next",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: isFinalPage
                              ? () {
                                  setState(() {
                                    isFinalPage = !isFinalPage;
                                  });
                                }
                              : () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: ((context) => const LoginPage()),
                                    ),
                                  );
                                },
                          child: Text(
                            isFinalPage ? "Back" : "Already a User?   Login!",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
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
