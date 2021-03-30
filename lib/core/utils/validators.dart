import 'package:devexam/core/system/devexam.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

enum UsernameValidationError { invalid }
enum EmailValidationError { invalid }
enum PasswordValidationError { invalid }
enum ConfirmedPasswordValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=[a-zA-Z0-9._]{2,10}$)(?!.*[_.]{2})[^_.].*[^_.]$');

  @override
  UsernameValidationError validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : UsernameValidationError.invalid;
  }
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  EmailValidationError validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

  @override
  PasswordValidationError validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure({this.password}) : super.pure('');
  const ConfirmedPassword.dirty(
      {@required this.password, String value = '' + " "})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError validator(String value) {
    return password == value ? null : ConfirmedPasswordValidationError.invalid;
  }
}


String validateNewUsername({
  String newUsername,
  DevExam devExam,
  BuildContext context,
}) {
  RegExp regExp =
      RegExp(r'^(?=[a-zA-Z0-9._]{2,10}$)(?!.*[_.]{2})[^_.].*[^_.]$');
  if (!regExp.hasMatch(newUsername)) {
    return devExam.intl.of(context).fmt('account.create.invalidForm');
  } else {
    return null;
  }
}
