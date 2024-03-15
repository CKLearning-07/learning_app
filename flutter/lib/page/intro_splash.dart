import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroSplash extends StatelessWidget {
  IntroSplash({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 227, 148),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/introsplash.png',
                height: 400,
                width: 400,
              ),
              Text(
                'Learn about Sales and Marketing ',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'You will learn about how sales and marketing works',
                style: GoogleFonts.lato(
                    textStyle:
                        Theme.of(context).textTheme.titleMedium!.copyWith()),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 224, 211, 141)),
              )
            ],
          ),
        ));
  }
}
