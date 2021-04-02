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

class Themes extends CustomColors {
  ThemeData of(BuildContext context) => Theme.of(context);

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        buttonColor: Colors.black,
        textTheme: _lightTextTheme(),
        iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          textTheme: _lightTextTheme(),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
          labelStyle: TextStyle(color: Colors.black),
          helperStyle: TextStyle(color: Colors.black, fontSize: 18),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: super.accentGreenblue,
          unselectedItemColor: Colors.grey,
        ),
        shadowColor: Colors.grey[700],
        backgroundColor: Colors.white,
        splashColor: Colors.black.withOpacity(.6),
      );

  ThemeData get dark => ThemeData(
        scaffoldBackgroundColor: Color(0xff0A0A0A),
        brightness: Brightness.dark,
        buttonColor: Colors.white,
        textTheme: _darkTextTheme(),
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          textTheme: _darkTextTheme(),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white, fontSize: 18),
          labelStyle: TextStyle(color: Colors.white),
          helperStyle: TextStyle(color: Colors.white, fontSize: 18),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
        ),
        backgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.5),
        ),
      );

  TextTheme _darkTextTheme() {
    return TextTheme(
      headline1: _whiteText(),
      headline2: _whiteText(),
      headline3: _whiteText(),
      headline4: _whiteText(),
      headline5: _whiteText(),
    );
  }

  TextTheme _lightTextTheme() {
    return TextTheme(
      headline1: _blackText(),
      headline2: _blackText(),
      headline3: _blackText(),
      headline4: _blackText(),
      headline5: _blackText(),
    );
  }

  TextStyle _whiteText() => TextStyle(color: Colors.white);
  TextStyle _blackText() => TextStyle(color: Colors.black);
}
