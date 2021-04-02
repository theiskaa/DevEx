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

        buttonColor: Colors.black,
        textTheme: TextTheme(
          headline1: _blackText(),
          headline2: _blackText(),
          headline3: _blackText(),
          headline4: _blackText(),
        ),
        iconTheme: IconThemeData(),

        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline1: _blackText(),
            headline2: _blackText(),
            headline3: _blackText(),
            headline4: _blackText(),
          ),
        ),

        // Theme for Textfield
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
      );

  ThemeData get dark => ThemeData(
        scaffoldBackgroundColor: Colors.black54,
        brightness: Brightness.dark,

        buttonColor: Colors.white,
        textTheme: TextTheme(
          headline1: _whiteText(),
          headline2: _whiteText(),
          headline3: _whiteText(),
          headline4: _whiteText(),
        ),
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline1: _whiteText(),
            headline2: _whiteText(),
            headline3: _whiteText(),
            headline4: _whiteText(),
          ),
        ),

        // Theme for Textfield
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
        ),
      );

  TextStyle _whiteText() => TextStyle(color: Colors.white);
  TextStyle _blackText() => TextStyle(color: Colors.black);
}
