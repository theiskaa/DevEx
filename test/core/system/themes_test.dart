import 'dart:ui';

import 'package:devexam/core/system/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CustomColors customColors;
  ThemeData lightTheme;
  ThemeData darkTheme;

  setUpAll(() {
    // Initilaze custom colors.
    customColors = CustomColors();

    // Initilaze light theme.
    lightTheme = Themes().light;

    // Initilaze dark theme.
    darkTheme = Themes().dark;
  });

  group('[CustomColors]', () {
    test('has expected default property values', () {
      expect(customColors.accentExamBlue, Color(0xff2865CE));
      expect(customColors.darkExamBlue, Color(0xff1437C2));
      expect(customColors.accentTestPurple, Color(0xff8C3FF5));
      expect(customColors.darkTestPurple, Color(0xff3C1571));
      expect(customColors.accentGreenblue, Color(0xff017296));
      expect(customColors.darkGreenblue, Color(0xFF004155));

      expect(customColors.errorBg, Color.fromRGBO(185, 73, 61, 1));
    });
  });

  group('[Themes]', () {
    test('LightTheme', () {
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.primaryColor, Colors.white);
      expect(lightTheme.accentColor, Colors.white);
      expect(lightTheme.buttonColor, Colors.black);
      expect(lightTheme.textTheme, lightTheme.textTheme);
      expect(lightTheme.iconTheme, IconThemeData(color: Colors.black));
      expect(lightTheme.appBarTheme, lightTheme.appBarTheme);
      expect(
        lightTheme.textSelectionTheme,
        TextSelectionThemeData(cursorColor: Colors.black),
      );
      expect(lightTheme.inputDecorationTheme, _lightInputDecoration());
      expect(
        lightTheme.bottomNavigationBarTheme,
        BottomNavigationBarThemeData(
          selectedItemColor: customColors.accentGreenblue,
          unselectedItemColor: Colors.grey,
        ),
      );
      expect(lightTheme.shadowColor, Colors.grey[700]);
      expect(lightTheme.backgroundColor, Colors.white);
      expect(lightTheme.splashColor, Colors.black.withOpacity(.6));
    });

    test('DarkTheme', () {
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.primaryColor, Colors.grey[900]);
      expect(darkTheme.accentColor, Colors.grey[900]);
      expect(darkTheme.buttonColor, Colors.white);
      expect(darkTheme.textTheme, darkTheme.textTheme);
      expect(darkTheme.iconTheme, IconThemeData(color: Colors.white));
      expect(darkTheme.appBarTheme, darkTheme.appBarTheme);
      expect(
        darkTheme.textSelectionTheme,
        TextSelectionThemeData(cursorColor: Colors.white),
      );
      expect(darkTheme.inputDecorationTheme, _darkInputDecoration());
      expect(
        darkTheme.bottomNavigationBarTheme,
        BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.5),
        ),
      );
      expect(darkTheme.backgroundColor, Colors.black);
      expect(darkTheme.scaffoldBackgroundColor, Color(0xff0A0A0A));
    });
  });
}

// Matcher for [lightTheme.inputDecorationTheme]
InputDecorationTheme _lightInputDecoration() {
  return InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black.withOpacity(.7), fontSize: 18),
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
  );
}

// Matcher for [darkTheme.inputDecorationTheme]
InputDecorationTheme _darkInputDecoration() {
  return InputDecorationTheme(
    hintStyle: TextStyle(
      color: Colors.white.withOpacity(.7),
      fontSize: 18,
    ),
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
  );
}
