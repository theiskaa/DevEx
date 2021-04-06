import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devexam/core/services/local_db_service.dart';
import 'package:devexam/core/system/devexam.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final DevExam devExam;
  ThemeBloc(this.devExam) : super(ThemeState(themeData: devExam.theme.light));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    ThemeState theme;
    if (event is DecideTheme) {
      theme = await decideTheme(theme);
    }
    if (event is DarkTheme) {
      theme = ThemeState(themeData: devExam.theme.dark);

      try {
        theme = await switchTheme(true, theme);
      } catch (e) {
       print("Couldn't changed theme to Dark");
      }
    }

    if (event is LightTheme) {
      theme = ThemeState(themeData: devExam.theme.light);

      try {
        theme = await switchTheme(false, theme);
      } catch (e) {
        print("Couldn't changed theme to Light");
      }
    }
    yield theme;
  }

  Future<ThemeState> switchTheme(bool isDark, ThemeState themestate) async {
    var db = await LocalDbService.instance;
    await db.setTheme(isDark: isDark);
    if (isDark == false) {
      themestate = ThemeState(themeData: devExam.theme.light);
    } else if (isDark == true) {
      themestate = ThemeState(themeData: devExam.theme.dark);
    }
    return themestate;
  }

  Future<ThemeState> decideTheme(ThemeState theme) async {
    var db = await LocalDbService.instance;
    bool isDark = await db.getTheme();

    if (isDark == false) {
      theme = ThemeState(themeData: devExam.theme.light);
    } else if (isDark == true) {
      theme = ThemeState(themeData: devExam.theme.dark);
    } else {
      theme = ThemeState(themeData: devExam.theme.light);
    }
    return theme;
  }
}
