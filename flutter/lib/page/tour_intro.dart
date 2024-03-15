import 'package:e_learning/page/home.dart';
import 'package:e_learning/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:showcaseview/showcaseview.dart';

class TourIntro extends StatelessWidget {
  TourIntro({super.key});
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 450,
            // child: Stack(
            //   children: [
            //     Align(
            //       alignment: Alignment.center,
            //       child: Positioned(
            //         child: Image.asset(
            //           "assets/images/blobs/blob-haikei (1).png",
            //           width: 300,
            //           height: 550,
            //         ),
            //       ),
            //     ),
            //     Align(
            //       alignment: Alignment.center,
            //       child: Positioned(
            //         top: 200,
            //         child: Image.asset(
            //           "assets/images/blobs/sample.png",
            //           width: 200,
            //           // width: ,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            child: Image.asset("assets/images/blobs/sketch.jpeg"),
          ),
          Text(
            'Learn about Sales and Marketing ',
            style: GoogleFonts.lato(
              textStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'You will learn about how sales and marketing works',
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith()),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => ShowCaseWidget(
                          builder: Builder(
                            builder: (context) => const HomePage(
                              isFirstlogin: true,
                            ),
                          ),
                        )),
                  ),
                );
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 242, 211, 255),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Let's Get Started",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
    ));
  }
}
