import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';
import 'package:devexam/core/blocs/auth/auth_bloc.dart';
import 'package:devexam/core/blocs/reset-password/resetpassword_cubit.dart';
import 'package:devexam/core/models/user.dart';
import 'package:devexam/core/services/fire_auth_service.dart';
import 'package:devexam/core/services/user_service.dart';
import 'package:devexam/core/utils/connectivity.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/ui.dart';
import 'package:devexam/view/widgets/auth/custom_auth_button.dart';
import 'package:devexam/view/widgets/auth/custom_auth_field.dart';
import 'package:devexam/view/widgets/components/widgets.dart';

class ChangePassword extends DevExamStatelessWidget {
  final userId;
  ChangePassword({this.userId});
  @override
  Widget build(BuildContext context) {
    // final user = context.select((AuthBloc authBloc) => authBloc.state.user);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (contxt) => AuthBloc(fireAuthService: FireAuthService()),
        ),
        BlocProvider(
          create: (contxt) => ResetpasswordCubit(UserServices()),
        ),
      ],
      child: ChangePasswordView(userID: userId),
    );
  }
}

// ignore: must_be_immutable
class ChangePasswordView extends DevExamStatefulWidget {
  String userID;
  final UserModel user;
  final String currentPassword;

  ChangePasswordView({
    Key key,
    this.userID,
    this.currentPassword,
    this.user,
  }) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends DevExamState<ChangePasswordView> {
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  bool checkCurrentPassword = false;
  final _userService = UserServices();

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
      appBar: buildAppBar(context),
      body: BlocListener<ResetpasswordCubit, ResetpasswordState>(
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
          if (state.status == AuthStatus.successful) {
            setState(() {
              widget.userID = "empty";
            });
            Navigator.pop(context);
            context.read<AuthBloc>().add(AuthLogoutRequested());
          }
        },
        child: BlocBuilder<ResetpasswordCubit, ResetpasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  buildcurrentPasswordField(context, state),
                  SizedBox(height: 30),
                  _NewPasswordField(newPassController),
                  SizedBox(height: 50),
                  _ChangePasswordButton(
                    state: state,
                    showNoInternet: _showNoInternet,
                    uid: widget.userID,
                    currentPassword: currentPassController.text,
                    newPassword: newPassController.text,
                    userServices: _userService,
                    checkCurrentPass: checkCurrentPassword,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  CustomAuthField buildcurrentPasswordField(
      BuildContext context, ResetpasswordState state) {
    return CustomAuthField(
      controller: currentPassController,
      accentColor: devExam.theme.darkGreenblue,
      darkColor: devExam.theme.darkGreenblue,
      obscureText: true,
      onChanged: (val) {
        setState(() {});
      },
      hint: devExam.intl.of(context).fmt('account.oldPassword'),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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

class _NewPasswordField extends DevExamStatefulWidget {
  final TextEditingController controller;
  _NewPasswordField(this.controller);

  @override
  __NewPasswordFieldState createState() => __NewPasswordFieldState();
}

class __NewPasswordFieldState extends DevExamState<_NewPasswordField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetpasswordCubit, ResetpasswordState>(
      builder: (context, state) {
        return CustomAuthField(
          controller: widget.controller,
          obscureText: true,
          onChanged: (val) {
            context.read<ResetpasswordCubit>().newPasswordChanged(val);
            setState(() {});
          },
          accentColor: devExam.theme.darkGreenblue,
          darkColor: devExam.theme.darkGreenblue,
          hint: devExam.intl.of(context).fmt('account.newPassword'),
          errorText: state.email.invalid
              ? devExam.intl.of(context).fmt('account.create.invalidForm')
              : null,
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _ChangePasswordButton extends DevExamStatefulWidget {
  final ResetpasswordState state;
  final bool showNoInternet;
  bool checkCurrentPass;
  final String uid;
  final String currentPassword;
  final String newPassword;
  final UserServices userServices;

  _ChangePasswordButton({
    this.state,
    this.showNoInternet,
    this.checkCurrentPass,
    this.uid,
    this.currentPassword,
    this.newPassword,
    this.userServices,
  });

  @override
  __ChangePasswordButtonState createState() => __ChangePasswordButtonState();
}

class __ChangePasswordButtonState extends DevExamState<_ChangePasswordButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.status == AuthStatus.loading) {
      return customIndicatorButton(context);
    } else {
      return buildCustomAuthButton(context, widget.state);
    }
  }

  CustomAuthButton buildCustomAuthButton(
    BuildContext context,
    ResetpasswordState state,
  ) {
    return CustomAuthButton(
      height: 40,
      width: MediaQuery.of(context).size.width - 100,
      onTap: () async {
        if (widget.showNoInternet) {
          showSnack(
            devExam: devExam,
            context: context,
            title: devExam.intl.of(context).fmt('attention.noConnection'),
            color: Colors.red[700],
          );
        } else {
          if (widget.currentPassword == widget.newPassword) {
            showSnack(
              devExam: devExam,
              context: context,
              title: devExam.intl.of(context).fmt('authStatus.samePasswords'),
              color: Colors.red[700],
            );
          } else {
            print(state.formzStatus);
            print(state.status);
            if (state.formzStatus.isValid) {
              print(state.formzStatus);
              widget.checkCurrentPass = await widget.userServices
                  .validateCurrentPassword(widget.currentPassword);
              print(widget.checkCurrentPass);
              setState(() {});
              if (widget.checkCurrentPass) {
                context.read<ResetpasswordCubit>().changePassword(
                      uid: widget.uid,
                      newPassword: widget.newPassword,
                    );
              } else {
                showSnack(
                  devExam: devExam,
                  context: context,
                  title: devExam.intl
                      .of(context)
                      .fmt('authStatus.currentPasswordIsIncorrect'),
                  color: devExam.theme.errorBg,
                );
              }
            } else {
              showSnack(
                devExam: devExam,
                context: context,
                title: devExam.intl.of(context).fmt('message.invalidFormz'),
                color: devExam.theme.errorBg,
              );
            }
          }
        }
      },
      borderWidth: 2,
      title: devExam.intl.of(context).fmt('settings.changePassword'),
      titleSize: 17,
      fontWeight: FontWeight.w700,
      tappedTitleColor: Colors.white,
      titleColor: devExam.theme.darkGreenblue,
      spashColor: devExam.theme.accentGreenblue,
      borderColor: devExam.theme.darkGreenblue,
      borderRadius: BorderRadius.circular(30),
    );
  }

  Container customIndicatorButton(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: devExam.theme.darkGreenblue),
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
