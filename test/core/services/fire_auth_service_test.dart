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
      test("-Success-", () async {
        when(
          await mocker.saveUserToFirestore(
            'test',
            // TODO: Replace [auth.currentUser]
            null,
            'test@example.com',
            'test123',
          ),
        ).thenAnswer((_) async => await fireAuthService.saveUserToFirestore(
              'test',
              // TODO: Replace [auth.currentUser]
              null,
              'test@example.com',
              'test123',
            ));
      });

      test("-Error-", () async {
        when(
          await mocker.saveUserToFirestore(null, null, null, null),
        ).thenAnswer(
          (_) async =>
              await fireAuthService.saveUserToFirestore(null, null, null, null),
        );
      });
    });

    group("Login with Email and Password", () {
      test("-Success-", () async {
        when(await mocker.logInWithEmailAndPassword(
          email: "test@example.com",
          password: 'test123',
        ))
            .thenAnswer((_) => AuthStatus.successful);
      });

      test("-Success-", () async {
        when(await mocker.logInWithEmailAndPassword(
          email: "test@example.com",
          password: 'test123',
        ))
            .thenAnswer((_) => AuthStatus.successful);
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

      test("Error - wrong password", () async {
        when(await mocker.logInWithEmailAndPassword(
          email: "test@example.com",
          password: null,
        ))
            .thenAnswer((_) => AuthStatus.wrongPassword);
      });

      test("Error - invalid email", () async {
        when(
          await mocker.logInWithEmailAndPassword(
              email: null, password: 'test123'),
        ).thenAnswer((_) => AuthStatus.invalidEmail);
      });

      test("Error - Too Many Requests", () async {
        when(
          await mocker.logInWithEmailAndPassword(
              email: 'test@example.com', password: 'test123'),
        ).thenAnswer((_) => AuthStatus.tooManyRequests);
      });

      test("Error - User not found", () async {
        when(
          await mocker.logInWithEmailAndPassword(
            email: 'test@test.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => AuthStatus.userNotFound);
      });

      test("Error - User Disabled", () async {
        when(
          await mocker.logInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => AuthStatus.userDisabled);
      });
    });

    group("Log out", () {
      test("-Success-", () async {
        when(await mocker.logOut())
            .thenAnswer((_) async => await fireAuthService.logOut());
      });
      test("-Error-", () async {
        when(await mocker.logOut()).thenThrow(Future.value([null]));
      });
    });

    group("Create User With Email And Password", () {
      test("-Success-", () async {
        when(
          await mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => AuthStatus.successful);
      });
      test("Error - undefined", () async {
        when(
          await mocker.createUserWithEmailAndPassword(
            username: null,
            email: null,
            password: null,
          ),
        ).thenAnswer((_) => AuthStatus.undefined);
      });

      test("Error - email already exits", () async {
        when(
          await mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@example.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => AuthStatus.emailAlreadyExists);
      });

      test("Error - weak password", () async {
        when(
          await mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@gamil.com',
            password: '123',
          ),
        ).thenAnswer((_) => AuthStatus.weakPassword);
      });

      test("Error - operation Not Allowed", () async {
        when(
          await mocker.createUserWithEmailAndPassword(
            username: 'test',
            email: 'test@gamil.com',
            password: 'test123',
          ),
        ).thenAnswer((_) => AuthStatus.operationNotAllowed);
      });
    });
  });
}
