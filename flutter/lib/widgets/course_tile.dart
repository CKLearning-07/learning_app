import 'package:e_learning/model/quiz_data.dart';
import 'package:e_learning/page/module.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseTile extends StatelessWidget {
  CourseTile({
    required this.title,
    required this.moduleIndex,
    required this.moduleData,
    required this.heroTag,
    required this.quizData,
    required this.isFinal,
    this.isIntro = false,
    super.key,
  });

  final List<QuizData> quizData;
  final List moduleData;
  final String title;
  final String heroTag;
  final int moduleIndex;
  final bool isFinal;
  final bool isIntro;

  final List<Color> mainColors = [
    const Color.fromARGB(255, 147, 232, 146),
    const Color.fromARGB(255, 255, 182, 199),
    const Color.fromARGB(255, 255, 242, 146),
    const Color.fromARGB(255, 193, 193, 255),
    const Color.fromARGB(255, 201, 248, 254),
    const Color.fromARGB(255, 255, 237, 237),
    const Color.fromARGB(255, 254, 241, 222),
    const Color.fromARGB(255, 186, 239, 229),
  ];

  final List<Color> boxColors = [
    const Color.fromARGB(255, 139, 216, 137),
    const Color.fromARGB(255, 255, 167, 188),
    const Color.fromARGB(255, 254, 238, 97),
    const Color.fromARGB(255, 178, 175, 254),
    const Color.fromARGB(255, 164, 241, 251),
    const Color.fromARGB(255, 255, 211, 212),
    const Color.fromARGB(255, 255, 225, 184),
    const Color.fromARGB(255, 109, 214, 198),
  ];

  @override
  Widget build(BuildContext context) {
    int colorSelector = moduleIndex - 1;

    if (moduleIndex >= boxColors.length) {
      colorSelector = moduleIndex % boxColors.length;
    }

    return GestureDetector(
      onTap: isIntro
          ? () {}
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ModulePage(
                    moduleData: moduleData,
                    appBarTitle: "Module $moduleIndex",
                    title: title,
                    // quizData: quizData,
                    moduleIndex: moduleIndex,
                    // isFinal: isFinal,
                  ),
                ),
              );
            },
      child: Container(
        width: double.infinity,
        height: 175,
        decoration: BoxDecoration(
          color: mainColors[colorSelector],
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 50, 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
                color: boxColors[colorSelector],
              ),
              child: Text(
                moduleIndex < 10 ? "0$moduleIndex" : moduleIndex.toString(),
                style: GoogleFonts.playfairDisplay().copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 37, 37, 37),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                color: Colors.white,
              ),
              child: Text(
                title,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
