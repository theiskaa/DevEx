import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../system/devexam.dart';

enum AuthStatus {
  loading,
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  weakPassword,
  undefined,
  bugReportedSuccessfully,

  cantSaveSuggestion
}

extension AuthStatusExt on AuthStatus {
  String get toStr => describeEnum(this);
}

class AuthExceptionHandler {
  /// method for detect/handle firebase auth exception.
  static handleFireAuthException(e, {bool testMode = false}) {
    var status;
    switch (testMode ? e : e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      default:
        status = AuthStatus.undefined;
    }
    return status;
  }

  /// Generate a message by listening exception.
  static generateExceptionMessage(
      exceptionCode, BuildContext context, DevExam devExam,
      {bool testMode = false}) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthStatus.invalidEmail:
        errorMessage = testMode
            ? 'invalidEmail'
            : devExam.intl.of(context).fmt('authStatus.invalidEmail');
        break;
      case AuthStatus.wrongPassword:
        errorMessage = testMode
            ? 'wrongPassword'
            : devExam.intl.of(context).fmt('authStatus.wrongPassword');
        break;
      case AuthStatus.userNotFound:
        errorMessage = testMode
            ? 'userNotFound'
            : devExam.intl.of(context).fmt('authStatus.userNotFound');
        break;
      case AuthStatus.userDisabled:
        errorMessage = testMode
            ? 'userDisabled'
            : devExam.intl.of(context).fmt('authStatus.userDisabled');
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = testMode
            ? 'tooManyRequests'
            : devExam.intl.of(context).fmt('authStatus.tooManyRequests');
        break;
      case AuthStatus.operationNotAllowed:
        errorMessage = testMode
            ? 'operationNotAllowed'
            : devExam.intl.of(context).fmt('authStatus.operationNotAllowed');
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage = testMode
            ? 'emailAlreadyExists'
            : devExam.intl.of(context).fmt('authStatus.emailAlreadyExists');
        break;
      case AuthStatus.weakPassword:
        errorMessage = testMode
            ? 'weakPassword'
            : devExam.intl.of(context).fmt('authStatus.weakPassword');
        break;
      case AuthStatus.cantSaveSuggestion:
        errorMessage =
            testMode ? 'cantSaveSuggestion' : "Can't save suggestion";
        break;
      case AuthStatus.bugReportedSuccessfully:
        errorMessage = testMode
            ? 'bugReportedSuccessfully'
            : devExam.intl
                .of(context)
                .fmt('authStatus.bugReportedSuccessfully');
        break;
      default:
        errorMessage = testMode
            ? 'undefined'
            : devExam.intl.of(context).fmt('authStatus.undefined');
    }

    return errorMessage;
  }
}
