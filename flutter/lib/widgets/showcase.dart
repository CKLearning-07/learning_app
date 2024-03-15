import 'package:flutter/material.dart';

class ShowcaseView extends StatelessWidget {
  ShowcaseView(
      {super.key,
      required this.globalkey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeborder = const CircleBorder()});
  final GlobalKey globalkey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeborder;
  @override
  Widget build(BuildContext context) {
    return ShowcaseView(
      globalkey: globalkey,
      title: title,
      description: description,
      child: child,
      shapeborder: shapeborder,
    );
  }
}
