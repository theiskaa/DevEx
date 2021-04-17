import 'app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/bloc_observer.dart';
import 'core/system/devexam.dart';
import 'core/system/intl.dart';
import 'core/system/log.dart';
import 'core/system/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize devExam singleton.
  final DevExam devExam = DevExam();

  // Initialize Firebase app.
  await Firebase.initializeApp();

  // Bloc observer for log bloc acts.
  Bloc.observer = SimpleBlocObserver();

  // Initialize theme from devExam singleton.
  devExam.theme = Themes();
  devExam.intl = Intl();

  // Initialize intl locale from devExam singleton.
  devExam.intl.locale = Locale('en');
  devExam.intl.supportedLocales = ['ru', 'en'];

  // Initialize log level.
  Log.level = 'verbose';

  /// Run app with wrapping widget with [BlocProvider/LocalizationBloc] BlocProvider.
  runApp(App());
}
