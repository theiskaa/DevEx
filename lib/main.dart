import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/blocs/auth/auth_bloc.dart';
import 'core/blocs/bloc_observer.dart';
import 'core/blocs/localization/localization_bloc.dart';
import 'core/services/fire_auth_service.dart';
import 'core/system/devexam.dart';
import 'core/system/intl.dart';
import 'core/system/log.dart';
import 'core/system/themes.dart';
import 'core/utils/perceptive.dart';
import 'view/screens/auth/login_screen.dart';
import 'view/screens/home/main/main_screen.dart';
import 'view/screens/home/main/splash.dart';
import 'view/widgets/components/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize devExam singleton.
  final DevExam devExam = DevExam();

  // initialize Firebase app.
  await Firebase.initializeApp();

  // Bloc observer for log bloc acts.
  Bloc.observer = SimpleBlocObserver();

  // initialize theme from devExam singleton.
  devExam.theme = Themes();
  devExam.intl = Intl();

  // initialize intl locale from devExam singleton.
  devExam.intl.locale = Locale('az');
  devExam.intl.supportedLocales = ['ru', 'az'];

  // initialize log level.
  Log.level = 'verbose';

  /// Run app with wrapping widget with [BlocProvider/LocalizationBloc] BlocProvider
  runApp(
    BlocProvider(
      create: (_) => LocalizationBloc()..add(LocalizationStarted()),
      child: MyApp(),
    ),
  );
}

class MyApp extends DevExamStatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends DevExamState<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;
  final fireAuthService = FireAuthService();

  @override
  Widget build(BuildContext context) {
    return app();
  }

  RepositoryProvider<FireAuthService> app() {
    return RepositoryProvider.value(
      value: fireAuthService,
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(fireAuthService: fireAuthService),
        child: BlocBuilder<LocalizationBloc, LocalizationState>(
          builder: (context, localizationState) {
            return PerceptiveWidget(
              child: MaterialApp(
                theme: devExam.theme.light,
                locale:
                    localizationState.locale ?? devExam.intl.locale.languageCode,
                localizationsDelegates: [
                  devExam.intl.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('az', 'AZ'),
                  Locale('ru', 'RU'),
                ],
                navigatorKey: _navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'devExam',
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => Splash(),
                ),
                builder: (context, child) {
                  return buildBlocListener(child);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  BlocListener<AuthBloc, AuthState> buildBlocListener(Widget child) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authed:
            _navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
              (route) => false,
            );
            break;
          case AuthenticationStatus.unauthed:
            _navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
              (route) => false,
            );
            break;
          default:
            _navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
              (route) => false,
            );
        }
      },
      child: child,
    );
  }
}
