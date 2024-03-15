import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:e_learning/widgets/custom_drawer.dart';
import 'package:e_learning/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  String? username;
  String? email;
  String? userId;
  String? phno;
  String? city;
  String? college;
  String? branch;

  void getUserDetails() {
    username = prefs!.getString("username");
    email = prefs!.getString("email");
    userId = prefs!.getString("userId");
    phno = prefs!.getString("phno");
    city = prefs!.getString("city");
    college = prefs!.getString("college");
    branch = prefs!.getString("branch");
  }

  @override
  Widget build(BuildContext context) {
    getUserDetails();
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 153, 0, 255),
          foregroundColor: Colors.white,
          title: const Text("Profile"),
          centerTitle: true,
        ),
        drawer: CustomDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              // padding: EdgeInsets.all(30),
              color: const Color.fromARGB(255, 242, 242, 242),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Image.asset(
                    'assets/images/profile/none.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$username",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Account Information',
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: const Color.fromARGB(255, 86, 86, 86))),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileData(
                      path: "assets/images/profile/mail.png",
                      attribute: "Email",
                      value: "$email"),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileData(
                      path: "assets/images/profile/phone.png",
                      attribute: "Phone",
                      value: "$phno"),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileData(
                      path: "assets/images/profile/location.png",
                      attribute: "City",
                      value: "$city"),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileData(
                      path: "assets/images/profile/college.png",
                      attribute: "College",
                      value: "$college"),
                  const SizedBox(
                    height: 12,
                  ),
                  ProfileData(
                      path: "assets/images/profile/book.png",
                      attribute: "Branch",
                      value: "$branch"),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
