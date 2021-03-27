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
  undefined,

  cantSaveSuggestion
}

class AuthExceptionHandler {
  /// method for detect/handle firebase auth exception.
  static handleFireAuthException(e) {
    print(e.code);
    var status;
    switch (e.code) {
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
      default:
        status = AuthStatus.undefined;
    }
    return status;
  }

  /// Generate a message by listening exception.
  static generateExceptionMessage(
      exceptionCode, BuildContext context, DevExam devExam) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthStatus.invalidEmail:
        errorMessage = devExam.intl.of(context).fmt('authStatus.invalidEmail');
        break;
      case AuthStatus.wrongPassword:
        errorMessage = devExam.intl.of(context).fmt('authStatus.wrongPassword');
        break;
      case AuthStatus.userNotFound:
        errorMessage = devExam.intl.of(context).fmt('authStatus.userNotFound');
        break;
      case AuthStatus.userDisabled:
        errorMessage = devExam.intl.of(context).fmt('authStatus.userDisabled');
        break;
      case AuthStatus.tooManyRequests:
        errorMessage =
            devExam.intl.of(context).fmt('authStatus.tooManyRequests');
        break;
      case AuthStatus.operationNotAllowed:
        errorMessage =
            devExam.intl.of(context).fmt('authStatus.operationNotAllowed');
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            devExam.intl.of(context).fmt('authStatus.emailAlreadyExists');
        break;
      case AuthStatus.cantSaveSuggestion:
        errorMessage = "Can't save suggestion";
        break;
      default:
        errorMessage = devExam.intl.of(context).fmt('authStatus.undefined');
    }

    return errorMessage;
  }
}
