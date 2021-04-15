import 'package:devexam/core/services/fire_auth_service.dart';
import 'package:devexam/core/services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

typedef Callback = void Function(MethodCall call);

/// Mocker for BuildContext.
class MockBuildContext extends Mock implements BuildContext {}

/// Mocker for [UserServices] class.
class UserServiceMocker extends Mock implements UserServices {}

/// Mocker for [FireAuthService] class.
class FireAuthServiceMocker extends Mock implements FireAuthService {}

class FireMocker {
  /// Setup the auth mocks.
  void setupFirebaseAuthMocks([Callback customHandlers]) {
    TestWidgetsFlutterBinding.ensureInitialized();

    // ignore: invalid_use_of_visible_for_testing_member
    MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
      if (call.method == 'Firebase#initializeCore') {
        return [
          {
            'name': defaultFirebaseAppName,
            'options': {
              'apiKey': '123',
              'appId': '123',
              'messagingSenderId': '123',
              'projectId': '123',
            },
            'pluginConstants': {},
          }
        ];
      }

      if (call.method == 'Firebase#initializeApp') {
        return {
          'name': call.arguments['appName'],
          'options': call.arguments['options'],
          'pluginConstants': {},
        };
      }

      if (customHandlers != null) {
        customHandlers(call);
      }

      return null;
    });
  }

  Future<T> neverEndingFuture<T>() async {
    // ignore: literal_only_boolean_expressions
    while (true) {
      await Future.delayed(const Duration(minutes: 5));
    }
  }

  /// Setup the cloud firestore mocks.
  void setupCloudFirestoreMocks([Callback customHandlers]) {
    TestWidgetsFlutterBinding.ensureInitialized();

    // ignore: invalid_use_of_visible_for_testing_member
    MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
      if (call.method == 'Firebase#initializeCore') {
        return [
          {
            'name': defaultFirebaseAppName,
            'options': {
              'apiKey': '123',
              'appId': '123',
              'messagingSenderId': '123',
              'projectId': '123',
            },
            'pluginConstants': {},
          }
        ];
      }

      if (call.method == 'Firebase#initializeApp') {
        return {
          'name': call.arguments['appName'],
          'options': call.arguments['options'],
          'pluginConstants': {},
        };
      }

      if (customHandlers != null) {
        customHandlers(call);
      }

      return null;
    });
  }
}
