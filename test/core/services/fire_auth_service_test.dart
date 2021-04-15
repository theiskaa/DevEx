import 'package:devexam/core/services/fire_auth_service.dart';
import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/testing_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

main() {
  DevExam devEx;

  // Setup cloud firesotre mocks.
  FireMocker().setupCloudFirestoreMocks();

  // Setup firebase auth mocks.
  FireMocker().setupFirebaseAuthMocks();

  FireAuthService fireAuthService;
  FireAuthServiceMocker mocker;

  FirebaseAuth auth;

  var testCount = 0;

  setUpAll(() async {
    // Initialze firebase app
    await Firebase.initializeApp();

    // Initilaze main singleton.
    devEx = DevExam();

    // Initilaze core dependency of main singleton.
    devEx.intl = Intl();

    // Core dependency configuration.
    devEx.intl.locale = Locale('en');
    devEx.intl.supportedLocales = ['ru', 'en'];

    // Initilaze UserServiceMocker
    mocker = FireAuthServiceMocker();

    final app = await Firebase.initializeApp(
      name: '$testCount -',
      options: const FirebaseOptions(
        apiKey: '',
        appId: '',
        messagingSenderId: '',
        projectId: '',
      ),
    );

    auth = FirebaseAuth.instanceFor(app: app);

    // Initilaze fireAuthService class.
    fireAuthService = FireAuthService(firebaseAuth: auth);
  });

  group("[FireAuthService]", () {
    group("Save user to firestore", () {
      test("-Success-", () {
        when(
          mocker.saveUserToFirestore(
            'test',
            // TODO: Replace [auth.currentUser]
            null,
            'test@example.com',
            'test123',
          ),
        ).thenAnswer((_) => fireAuthService.saveUserToFirestore(
              'test',
              // TODO: Replace [auth.currentUser]
              null,
              'test@example.com',
              'test123',
            ));
      });

      test("-Error-", () {
        when(
          mocker.saveUserToFirestore(null, null, null, null),
        ).thenAnswer(
          (_) => fireAuthService.saveUserToFirestore(null, null, null, null),
        );
      });
    });

    group("Login with Email and Password", () {
      test("-Success-", () {
        when(mocker.logInWithEmailAndPassword(
          email: "test@example.com",
          password: 'test123',
        )).thenAnswer((_) => Future.value(AuthStatus.successful));
      });

      test("Error - Undefined", () {
        when(
          mocker.logInWithEmailAndPassword(
            email: null,
            password: null,
          ),
        ).thenAnswer(
          (_) => Future.value(AuthStatus.undefined),
        );
      });

      test("Error - wrong password", () {
        when(mocker.logInWithEmailAndPassword(
          email: "test@example.com",
          password: null,
        )).thenAnswer((_) => Future.value(AuthStatus.wrongPassword));
      });

      test("Error - invalid email", () {
        when(
          mocker.logInWithEmailAndPassword(email: null, password: 'test123'),
        ).thenAnswer(
          (_) => Future.value(AuthStatus.invalidEmail),
        );
      });

      test("Error - Too Many Requests", () {
        when(
          mocker.logInWithEmailAndPassword(
              email: 'test@example.com', password: 'test123'),
        ).thenAnswer(
          (_) => Future.value(AuthStatus.tooManyRequests),
        );
      });

      test("Error - User not found", () {
        when(
          mocker.logInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'test123',
          ),
        ).thenAnswer(
          (_) => Future.value(AuthStatus.userNotFound),
        );
      });

      test("Error - User Disabled", () {
        when(
          mocker.logInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer(
          (_) => Future.value(AuthStatus.userDisabled),
        );
      });
    });

    group("Log out", () {
      test("-Success-", () {
        when(mocker.logOut()).thenAnswer((_) => fireAuthService.logOut());
      });
      test("-Error-", () {
        when(mocker.logOut()).thenThrow(Future.value([null]));
      });
    });

    group("Create User With Email And Password", () {
      test("-Success-", () {
        when(
          mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => Future.value(AuthStatus.successful));
      });
      test("Error - undefined", () {
        when(
          mocker.createUserWithEmailAndPassword(
            username: null,
            email: null,
            password: null,
          ),
        ).thenAnswer((_) => Future.value(AuthStatus.undefined));
      });

      test("Error - email already exits", () {
        when(
          mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => Future.value(AuthStatus.emailAlreadyExists));
      });

      test("Error - weak password", () {
        when(
          mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@gamil.com',
            password: '123',
          ),
        ).thenAnswer((_) => Future.value(AuthStatus.weakPassword));
      });

      test("Error - operation Not Allowed", () {
        when(
          mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@gamil.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => Future.value(AuthStatus.operationNotAllowed));
      });
    });
  });
}
