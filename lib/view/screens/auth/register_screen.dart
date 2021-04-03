import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/fabs/custom_fab.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';

import '../../../core/blocs/localization/localization_bloc.dart';
import '../../../core/blocs/register/register_cubit.dart';
import '../../../core/services/fire_auth_service.dart';
import '../../../core/system/intl.dart';
import '../../../core/utils/connectivity.dart';
import '../../../core/utils/fire_exception_hander.dart';
import '../../../core/utils/ui.dart';
import '../../widgets/auth/authgrid_card.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../../widgets/auth/custom_auth_field.dart';
import '../../widgets/components/widgets.dart';
import 'login_screen.dart';

class Register extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(
        context.read<FireAuthService>(),
      ),
      child: RegisterScreen(),
    );
  }
}

class RegisterScreen extends DevExamStatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends DevExamState<RegisterScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  @override
  void initState() {
    super.initState();
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
  }

  @override
  void dispose() {
    if (_connection.timerHandler != null) {
      _connection.timerHandler.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      floatingActionButton: langFAB(),
      key: scaffoldKey,
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: buildBlocListener,
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: buildBody(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Column buildBody(RegisterState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildtitle(),
        SizedBox(height: 30),
        buildAuthGridCard(),
        SizedBox(height: 30),
        _RegisterButton(
          state: state,
          showNoInternet: _showNoInternet,
        ),
      ],
    );
  }

  void buildBlocListener(context, state) {
    final errorMessage = AuthExceptionHandler.generateExceptionMessage(
        state.status, context, devExam);
    if (state.status != AuthStatus.successful &&
        state.formzStatus.isSubmissionFailure) {
      showSnack(
        devExam: devExam,
        context: context,
        title: "$errorMessage",
        color: devExam.theme.darkTestPurple,
      );
    }
  }

  String getLANGCODE() {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return "RU";
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return "EN";
    } else {
      return null;
    }
  }

  AnimatedCustomFAB langFAB() {
    return AnimatedCustomFAB(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Text(
          getLANGCODE(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      border: Border.all(color: devExam.theme.darkTestPurple.withOpacity(.3)),
      onTap: () {
        if (devExam.intl.of(context).fmt('lang') == "en") {
          BlocProvider.of<LocalizationBloc>(context)
              .add(LocalizationSuccess(langCode: Lang.RUS));
        } else if (devExam.intl.of(context).fmt('lang') == "ru") {
          BlocProvider.of<LocalizationBloc>(context)
              .add(LocalizationSuccess(langCode: Lang.EN));
        }
      },
    );
  }

  AuthGridCard buildAuthGridCard() {
    return AuthGridCard(
      wAnimation: false,
      height: 410,
      darkColor: devExam.theme.darkTestPurple,
      accentColor: devExam.theme.accentTestPurple,
      fields: fields(),
      titleOfSeccondTextButton: devExam.intl.of(context).fmt('auth.signIn'),
      onTapForSCB: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      ),
    );
  }

  List<Widget> fields() {
    return [
      SizedBox(height: 10),
      _UsernameField(),
      SizedBox(height: 15),
      _EmailField(),
      SizedBox(height: 15),
      _PasswordField(),
      SizedBox(height: 15),
      _ConfirmPasswordField(),
    ];
  }

  Text buildtitle() {
    return Text(
      "Dev Ex",
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 50,
      ),
    );
  }
}

class _UsernameField extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return CustomAuthField(
          errorText: state.username.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
          accentColor: devExam.theme.accentTestPurple,
          darkColor: devExam.theme.darkTestPurple,
          hint: devExam.intl.of(context).fmt('account.username'),
          obscureText: false,
          onChanged: (val) =>
              context.read<RegisterCubit>().usernameChanged(val),
        );
      },
    );
  }
}

class _EmailField extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return CustomAuthField(
          accentColor: devExam.theme.accentTestPurple,
          darkColor: devExam.theme.darkTestPurple,
          hint: devExam.intl.of(context).fmt('account.email'),
          obscureText: false,
          errorText: state.email.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
          onChanged: (val) => context.read<RegisterCubit>().emailChanged(val),
        );
      },
    );
  }
}

class _PasswordField extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return CustomAuthField(
          accentColor: devExam.theme.accentTestPurple,
          darkColor: devExam.theme.darkTestPurple,
          errorText: state.password.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidPassword')
              : null,
          hint: devExam.intl.of(context).fmt('account.password'),
          obscureText: true,
          onChanged: (val) =>
              context.read<RegisterCubit>().passwordChanged(val),
        );
      },
    );
  }
}

class _ConfirmPasswordField extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return CustomAuthField(
          accentColor: devExam.theme.accentTestPurple,
          darkColor: devExam.theme.darkTestPurple,
          hint: devExam.intl.of(context).fmt('account.confirmPassword'),
          obscureText: true,
          errorText: state.confirmedPassword.invalid
              ? devExam.intl
                  .of(context)
                  .fmt('account.create.passwordsDoesntMatch')
              : null,
          onChanged: (val) =>
              context.read<RegisterCubit>().confirmedPasswordChanged(val),
        );
      },
    );
  }
}

class _RegisterButton extends DevExamStatelessWidget {
  final RegisterState state;
  final bool showNoInternet;
  _RegisterButton({this.state, this.showNoInternet});
  @override
  Widget build(BuildContext context) {
    if (state.status == AuthStatus.loading) {
      return customIndicatorButton(context);
    } else {
      return buildCustomAuthButton(context, state);
    }
  }

  CustomAuthButton buildCustomAuthButton(
      BuildContext context, RegisterState state) {
    return CustomAuthButton(
      height: 55,
      width: MediaQuery.of(context).size.width - 80,
      onTap: () {
        if (showNoInternet) {
          showSnack(
            devExam: devExam,
            context: context,
            title: devExam.intl.of(context).fmt('attention.noConnection'),
            color: Colors.red[700],
          );
        } else {
          print(state.formzStatus);
          if (state.formzStatus.isValid) {
            print(state.formzStatus);
            context.read<RegisterCubit>().registerWEP();
          } else {
            showSnack(
              devExam: devExam,
              context: context,
              title: devExam.intl.of(context).fmt('message.invalidFormz'),
              color: devExam.theme.accentTestPurple,
            );
          }
        }
      },
      borderWidth: 2,
      title: devExam.intl.of(context).fmt('auth.signUp'),
      titleSize: 20,
      fontWeight: FontWeight.w700,
      tappedTitleColor: Colors.white,
      titleColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.accentTestPurple
          : devExam.theme.darkTestPurple,
      spashColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.accentTestPurple
          : devExam.theme.darkTestPurple,
      borderColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.accentTestPurple
          : devExam.theme.darkTestPurple,
      borderRadius: BorderRadius.circular(30),
    );
  }

  Container customIndicatorButton(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.2,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? devExam.theme.accentTestPurple
              : devExam.theme.darkTestPurple,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: SpinKitFadingCircle(
          color: devExam.theme.accentTestPurple,
          size: 30,
        ),
      ),
    );
  }
}
