import 'package:flutter/material.dart';

/// Colors which were used frequently in app design.
class CustomColors {
  final accentExamBlue = Color(0xff2865CE);
  final darkExamBlue = Color(0xff1437C2);
  final accentTestPurple = Color(0xff8C3FF5);
  final darkTestPurple = Color(0xff3C1571);
  final accentGreenblue = Color(0xff017296);
  final darkGreenblue = Color(0xFF004155);
  final errorBg = Color.fromRGBO(185, 73, 61, 1);

  /// All custom colors into one list.
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
        textTheme: lightTextTheme(),
        iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          textTheme: lightTextTheme(),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
        inputDecorationTheme: inputDecorationTheme(Colors.black),
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
        textTheme: darkTextTheme(),
        primaryColor: Colors.grey[900],
        accentColor: Colors.grey[900],
        iconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          textTheme: darkTextTheme(),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        inputDecorationTheme: inputDecorationTheme(Colors.white),
        backgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.5),
        ),
      );

  InputDecorationTheme inputDecorationTheme(Color mainColor) {
    return InputDecorationTheme(
      hintStyle: TextStyle(color: mainColor.withOpacity(.7), fontSize: 18),
      labelStyle: TextStyle(color: mainColor),
      helperStyle: TextStyle(color: mainColor, fontSize: 18),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: mainColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: mainColor),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
    );
  }

  TextTheme darkTextTheme() {
    return TextTheme(
      headline1: _whiteText(),
      headline2: _whiteText(),
      headline3: _whiteText(),
      headline4: _whiteText(),
      headline5: _whiteText(),
      headline6: _whiteText(),
    );
  }

  TextTheme lightTextTheme() {
    return TextTheme(
      headline1: _blackText(),
      headline2: _blackText(),
      headline3: _blackText(),
      headline4: _blackText(),
      headline5: _blackText(),
      headline6: _blackText(),
    );
  }

  TextStyle _whiteText() => TextStyle(color: Colors.white);
  TextStyle _blackText() => TextStyle(color: Colors.black);
}
