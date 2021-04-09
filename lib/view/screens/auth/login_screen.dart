import 'package:devexam/core/blocs/authentication/auth/auth_bloc.dart';
import 'package:devexam/core/blocs/authentication/login/login_cubit.dart';
import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/view/widgets/components/animated_custom_fab.dart';
import 'package:devexam/view/widgets/components/flutter_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';

import '../../../core/blocs/localization/localization_bloc.dart';
import '../../../core/models/user.dart';
import '../../../core/services/fire_auth_service.dart';
import '../../../core/services/local_db_service.dart';
import '../../../core/system/intl.dart';
import '../../../core/utils/connectivity.dart';
import '../../../core/utils/fire_exception_hander.dart';
import '../../../core/utils/ui.dart';
import '../../widgets/auth/authgrid_card.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../../widgets/auth/custom_auth_field.dart';
import '../../widgets/auth/suggestion_field.dart';
import '../../widgets/components/widgets.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class Login extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        fireAuthService: context.read<FireAuthService>(),
      ),
      child: LoginScreen(userModel: user),
    );
  }
}

class LoginScreen extends DevExamStatefulWidget {
  final UserModel userModel;
  LoginScreen({Key key, @required this.userModel}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends DevExamState<LoginScreen> {
  final _connection = ConnectivityObserver();
  final _instanceOfLocalDbService = LocalDbService.localDbServiceInstance;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool _showNoInternet = false;
  List<String> suggestionList = [];
  double authGridCardHeight = 350;

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  Future<void> getAndmathcLists() async {
    suggestionList = await _instanceOfLocalDbService.getDbList() ?? [];
  }

  @override
  void initState() {
    super.initState();
    getAndmathcLists();
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
    emailTextController.addListener(() {
      setState(() => authGridCardHeight = 450);
    });
    passwordTextController.addListener(() {
      setState(() => authGridCardHeight = 350);
    });
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
    return Scaffold(
      floatingActionButton: langFAB(),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          final errorMessage = AuthExceptionHandler.generateExceptionMessage(
            state.status,
            context,
            devExam,
          );
          if (state.status != AuthStatus.successful &&
              state.formzStatus.isSubmissionFailure) {
            showSnack(
              devExam: devExam,
              context: context,
              title: "$errorMessage",
              color: devExam.theme.darkExamBlue,
            );
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
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

  Column buildBody(LoginState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildtitle(),
        SizedBox(height: 30),
        buildAuthGridCard(widget.userModel),
        SizedBox(height: 30),
        _LoginButton(
          state,
          _showNoInternet,
          suggestionList: suggestionList,
          suggestedEmail: emailTextController,
        ),
      ],
    );
  }

  AuthGridCard buildAuthGridCard(UserModel userModel) {
    return AuthGridCard(
      wAnimation: true,
      height: authGridCardHeight,
      darkColor: devExam.theme.darkExamBlue,
      accentColor: devExam.theme.accentExamBlue,
      fields: fields(userModel),
      titleOfSeccondTextButton: devExam.intl.of(context).fmt('auth.signUp'),
      onTapForSCB: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Register(),
        ),
      ),
    );
  }

  List<Widget> fields(UserModel userModel) {
    return [
      SizedBox(height: 10),
      _EmailField(
        emailTextController: emailTextController,
        suggestionList: suggestionList,
        localDbService: _instanceOfLocalDbService,
      ),
      SizedBox(height: 15),
      _PasswordField(passwordTextController),
      SizedBox(height: 15),
      buildForgotPassword(),
    ];
  }

  Container buildForgotPassword() {
    return Container(
      alignment: Alignment.topRight,
      child: FlutterTextButton(
        titleAlign: TextAlign.right,
        wOpacity: true,
        defaultSize: 17,
        tappedSize: 16,
        opacityValue: .5,
        titleColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white
            : Colors.black,
        title: devExam.intl.of(context).fmt('auth.forgotPassword'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPassword(),
          ),
        ),
      ),
    );
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

  String getLANGCODE() {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return "RU";
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return "EN";
    } else {
      return null;
    }
  }

  Widget langFAB() {
    return AnimatedFloatingActionButton(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Text(
          getLANGCODE(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      border: Border.all(color: devExam.theme.darkExamBlue.withOpacity(.3)),
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
}

class _EmailField extends DevExamStatelessWidget {
  final TextEditingController emailTextController;
  final List<String> suggestionList;
  final LocalDbService localDbService;

  _EmailField({
    this.emailTextController,
    this.suggestionList,
    this.localDbService,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return SuggestionField(
          hint: devExam.intl.of(context).fmt('account.email'),
          textController: emailTextController,
          suggestionList: suggestionList,
          errorText: state.email.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
          suggestionBoxDecoration:
              BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? buildSuggestionBoxDecoration(
                      devExam.theme.dark.scaffoldBackgroundColor,
                    )
                  : buildSuggestionBoxDecoration(Colors.white),
          suggestionItemStyle:
              BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? buildSuggestionItemStyle(Colors.black, Colors.white)
                  : buildSuggestionItemStyle(Colors.grey[100], Colors.black),
          onTap: () {
            context.read<LoginCubit>().emailChanged(emailTextController.text);
          },
          onIconTap: () => localDbService.saveSuggestionList(suggestionList),
          onChanged: (val) {
            context.read<LoginCubit>().emailChanged(val);
          },
        );
      },
    );
  }

  BoxDecoration buildSuggestionBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: devExam.theme.darkExamBlue, width: 0.5),
      boxShadow: [
        BoxShadow(
          spreadRadius: 10,
          offset: Offset(0, 5),
          color: devExam.theme.darkExamBlue.withOpacity(.3),
          blurRadius: 10,
        )
      ],
    );
  }

  SuggestionItemStyle buildSuggestionItemStyle(Color color, Color titleColor) {
    return SuggestionItemStyle(
      backgroundColor: color,
      icon: Icons.clear,
      iconColor: Colors.red,
      iconSize: 20,
      titleStyle: TextStyle(color: titleColor),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    );
  }
}

class _PasswordField extends DevExamStatelessWidget {
  final TextEditingController controller;
  _PasswordField(this.controller);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return CustomAuthField(
          controller: controller,
          onChanged: (val) {
            context.read<LoginCubit>().passwordChanged(val);
          },
          key: const Key('login_password_textField'),
          accentColor: devExam.theme.accentExamBlue,
          obscureText: true,
          darkColor: devExam.theme.darkExamBlue,
          errorText: state.password.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
          hint: devExam.intl.of(context).fmt('account.password'),
        );
      },
    );
  }
}

class _LoginButton extends DevExamStatelessWidget {
  final LoginState state;
  final bool showNoInternet;
  final List<String> suggestionList;
  final TextEditingController suggestedEmail;

  _LoginButton(
    this.state,
    this.showNoInternet, {
    this.suggestionList,
    this.suggestedEmail,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == AuthStatus.loading) {
      return customIndicatorButton(context);
    } else {
      return buildCustomAuthButton(context, state);
    }
  }

  CustomAuthButton buildCustomAuthButton(
    BuildContext context,
    LoginState state,
  ) {
    return CustomAuthButton(
      height: 55,
      width: MediaQuery.of(context).size.width - 80,
      onTap: () async {
        if (showNoInternet) {
          showSnack(
            devExam: devExam,
            context: context,
            title: devExam.intl.of(context).fmt('attention.noConnection'),
            color: devExam.theme.errorBg,
          );
        } else {
          print(state.formzStatus);
          if (state.formzStatus.isValid) {
            if (suggestionList.contains("${suggestedEmail.text}")) {
              print("Already have");
            } else {
              suggestionList.add("${suggestedEmail.text}");
            }
            print(state.formzStatus);
            context.read<LoginCubit>().loginWEP(suggestionList);
          } else {
            showSnack(
              devExam: devExam,
              context: context,
              title: devExam.intl.of(context).fmt('message.invalidFormz'),
              color: devExam.theme.accentExamBlue,
            );
          }
        }
      },
      borderWidth: 2,
      title: devExam.intl.of(context).fmt('auth.signIn'),
      titleSize: 20,
      fontWeight: FontWeight.w700,
      tappedTitleColor: Colors.white,
      titleColor: devExam.theme.darkExamBlue,
      spashColor: devExam.theme.accentExamBlue,
      borderColor: devExam.theme.darkExamBlue,
      borderRadius: BorderRadius.circular(30),
    );
  }

  Container customIndicatorButton(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: devExam.theme.darkExamBlue),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: SpinKitFadingCircle(
          color: devExam.theme.darkExamBlue,
          size: 30,
        ),
      ),
    );
  }
}
