import 'package:devexam/core/blocs/authentication/reset-password/resetpassword_cubit.dart';
import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/view/widgets/components/animated_custom_fab.dart';
import 'package:devexam/view/widgets/components/opacity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';

import '../../../core/blocs/localization/localization_bloc.dart';
import '../../../core/services/user_service.dart';
import '../../../core/system/intl.dart';
import '../../../core/utils/connectivity.dart';
import '../../../core/utils/fire_exception_hander.dart';
import '../../../core/utils/ui.dart';
import '../../widgets/auth/authgrid_card.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../../widgets/auth/custom_auth_field.dart';
import '../../widgets/components/widgets.dart';

class ResetPassword extends DevExamStatelessWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetpasswordCubit(UserServices()),
      child: ResetPasswordScreen(),
    );
  }
}

class ResetPasswordScreen extends DevExamStatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends DevExamState<ResetPasswordScreen> {
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
    return Scaffold(
      floatingActionButton: langFAB(context),
      appBar: appbar(context),
      body: BlocListener<ResetpasswordCubit, ResetpasswordState>(
        listener: buildBlocListener,
        child: BlocBuilder<ResetpasswordCubit, ResetpasswordState>(
          builder: (context, state) {
            return buildBody(state);
          },
        ),
      ),
    );
  }

  Widget buildBody(ResetpasswordState state) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildtitle(),
            SizedBox(height: 30),
            buildAuthGridCard(),
            SizedBox(height: 50),
            _SendEmailButton(state, _showNoInternet)
          ],
        ),
      ),
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
        color: devExam.theme.darkGreenblue,
      );
    }
    if (state.status == AuthStatus.successful) {
      showSnack(
        devExam: devExam,
        sec: 6,
        context: context,
        title: devExam.intl.of(context).fmt('message.resetPasswordSuccess'),
        color: devExam.theme.accentGreenblue,
      );
      state.status = AuthStatus.undefined;
    }
  }

  String getLANGCODE(BuildContext context) {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return "RU";
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return "EN";
    } else {
      return null;
    }
  }

  Widget langFAB(BuildContext context) {
    return AnimatedFloatingActionButton(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Text(
          getLANGCODE(context),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      border: Border.all(color: devExam.theme.darkGreenblue.withOpacity(.3)),
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
      height: 115,
      wAnimation: false,
      darkColor: devExam.theme.darkGreenblue,
      accentColor: devExam.theme.accentGreenblue,
      fields: [_EmailField()],
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

  AppBar appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.arrow_back_ios),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

class _EmailField extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetpasswordCubit, ResetpasswordState>(
      builder: (context, state) {
        return CustomAuthField(
          onChanged: (val) {
            context.read<ResetpasswordCubit>().emailChanged(val);
          },
          key: const Key('reset_password_email_textField'),
          accentColor: devExam.theme.accentGreenblue,
          darkColor: devExam.theme.darkGreenblue,
          hint: devExam.intl.of(context).fmt('account.email'),
          errorText: state.email.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
        );
      },
    );
  }
}

class _SendEmailButton extends DevExamStatelessWidget {
  final ResetpasswordState state;
  final bool showNoInternet;
  _SendEmailButton(this.state, this.showNoInternet);
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
    ResetpasswordState state,
  ) {
    return CustomAuthButton(
      height: 55,
      width: MediaQuery.of(context).size.width - 40,
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
          print(state.status);
          if (state.formzStatus.isValid) {
            print(state.formzStatus);
            context.read<ResetpasswordCubit>().sendResetPasswordMail();
          } else {
            showSnack(
              devExam: devExam,
              context: context,
              title: devExam.intl.of(context).fmt('message.invalidFormz'),
              color: Colors.redAccent[700],
            );
          }
        }
      },
      borderWidth: 2,
      title: devExam.intl.of(context).fmt('auth.sendPasswordResetMail'),
      titleSize: 18,
      fontWeight: FontWeight.w700,
      tappedTitleColor: Colors.white,
      titleColor: devExam.theme.accentGreenblue,
      spashColor: devExam.theme.accentGreenblue,
      borderColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.accentGreenblue
          : devExam.theme.darkGreenblue,
      borderRadius: BorderRadius.circular(30),
    );
  }

  Container customIndicatorButton(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? devExam.theme.accentGreenblue
              : devExam.theme.darkGreenblue,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: SpinKitFadingCircle(
          color: devExam.theme.darkGreenblue,
          size: 30,
        ),
      ),
    );
  }
}
