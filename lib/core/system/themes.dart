import 'package:flutter/material.dart';

class CustomColors {
  final accentExamBlue = Color(0xff2865CE);
  final darkExamBlue = Color(0xff1437C2);
  final accentTestPurple = Color(0xff8C3FF5);
  final darkTestPurple = Color(0xff3C1571);
  final accentGreenblue = Color(0xff017296);
  final darkGreenblue = Color(0xFF004155);

  final errorBg = Color.fromRGBO(185, 73, 61, 1);

  List<Color> get allColors => [
        accentExamBlue,
        darkExamBlue,
        accentTestPurple,
        darkTestPurple,
        accentGreenblue,
        darkGreenblue,
      ];
}

/// lomsa theme class
class Themes extends CustomColors {
  ThemeData of(BuildContext context) => Theme.of(context);

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white,
      );
}
