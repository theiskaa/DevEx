import 'dart:ui';

import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock for BuildContext
class MockBuildContext extends Mock implements BuildContext {}

main() {
  DevExam devEx;
  MockBuildContext mockContext;

  setUpAll(() {
    // Main dependency injection instance.
    devEx = DevExam();

    // Initilaze core dependency.
    devEx.intl = Intl();

    // Core dependency configuration.
    devEx.intl.locale = Locale('en');
    devEx.intl.supportedLocales = ['ru', 'en'];

    // Initilaze mock for context.
    mockContext = MockBuildContext();
  });

  group("[AuthExceptionHandler]", () {
    // Get generated exception message.
    String _generatedExceptionMessage(AuthStatus status) =>
        AuthExceptionHandler.generateExceptionMessage(
          status,
          mockContext,
          devEx,
          testMode: true,
        );

    test('undefined', () {
      AuthStatus status =
          AuthExceptionHandler.handleFireAuthException('', testMode: true);
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('loading', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'loading',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('successful', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'successful',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });
    test('emailAlreadyExists', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'email-already-in-use',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('wrongPassword', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'wrong-password',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('invalidEmail', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'invalid-email',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('userNotFound', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'user-not-found',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('userDisabled', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'user-disabled',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('operationNotAllowed', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'operation-not-allowed',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('tooManyRequests', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'too-many-requests',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });

    test('weakPassword', () {
      AuthStatus status = AuthExceptionHandler.handleFireAuthException(
        'weak-password',
        testMode: true,
      );
      String _exceptionMessage = _generatedExceptionMessage(status);
      expect(status.toStr, _exceptionMessage);
    });
  });
}
