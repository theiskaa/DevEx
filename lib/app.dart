import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/blocs/authentication/auth/auth_bloc.dart';
import 'core/blocs/design/designprefs_bloc.dart';
import 'core/blocs/localization/localization_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/blocs/theme/theme_bloc.dart';
import 'core/services/fire_auth_service.dart';
import 'core/utils/perceptive.dart';
import 'view/screens/auth/login_screen.dart';
import 'view/screens/home/main/main_screen.dart';
import 'view/screens/home/main/splash.dart';
import 'view/widgets/components/widgets.dart';

class App extends DevExamStatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends DevExamState<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;
  final fireAuthService = FireAuthService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocalizationBloc()..add(LocalizationStarted()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(fireAuthService: fireAuthService),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(devExam)..add(DecideTheme()),
        ),
        BlocProvider<DesignprefsBloc>(
          create: (context) =>
              DesignprefsBloc(devExam)..add(DecideDesignPrefs()),
        ),
      ],
      child: body(),
    );
  }

  RepositoryProvider<FireAuthService> body() {
    return RepositoryProvider.value(
      value: fireAuthService,
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<DesignprefsBloc, DesignprefsState>(
                builder: (context, state) {
                  return materialApp(localizationState, themeState);
                },
              );
            },
          );
        },
      ),
    );
  }

  PerceptiveWidget materialApp(
    LocalizationState localizationState,
    ThemeState themeState,
  ) {
    return PerceptiveWidget(
      child: MaterialApp(
        theme: themeState.themeData,
        locale: localizationState.locale ?? devExam.intl.locale.languageCode,
        localizationsDelegates: [
          devExam.intl.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'UK'),
          Locale('ru', 'RU'),
        ],
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'DevExam',
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => Splash(),
        ),
        builder: (context, child) {
          return buildBlocListener(child);
        },
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
