import 'dart:async';

import 'package:async/async.dart';
import 'package:devexam/core/utils/testers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_platform_interface/src/method_channel/method_channel_firebase_auth.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:mockito/mockito.dart';

void main() {
  setupFirebaseAuthMocks();

  FirebaseAuth auth;

  const String kMockEmail = 'test@example.com';
  const String kMockPassword = 'passw0rd';

  final int kMockCreationTimestamp =
      DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch;
  final int kMockLastSignInTimestamp =
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;

  Map<String, dynamic> kMockUser = <String, dynamic>{
    'isAnonymous': true,
    'emailVerified': false,
    'displayName': 'displayName',
    'metadata': <String, int>{
      'creationTime': kMockCreationTimestamp,
      'lastSignInTime': kMockLastSignInTimestamp,
    },
    'providerData': <Map<String, String>>[
      <String, String>{
        'providerId': 'firebase',
        'uid': '12345',
        'displayName': 'Flutter Test User',
        'photoURL': 'http://www.example.com/',
        'email': 'test@example.com',
      },
    ],
  };
  MockUserPlatform mockUserPlatform;
  MockUserCredentialPlatform mockUserCredPlatform;
  MockConfirmationResultPlatform mockConfirmationResultPlatform;
  MockRecaptchaVerifier mockVerifier;
  AdditionalUserInfo mockAdditionalUserInfo;
  EmailAuthCredential mockCredential;

  MockFirebaseAuth mockAuthPlatform = MockFirebaseAuth();

  group('[$FirebaseAuth]', () {
    Map<String, dynamic> user;

    var testCount = 0;

    setUp(() async {
      FirebaseAuthPlatform.instance = mockAuthPlatform = MockFirebaseAuth();

      final app = await Firebase.initializeApp(
        name: '$testCount',
        options: const FirebaseOptions(
          apiKey: '',
          appId: '',
          messagingSenderId: '',
          projectId: '',
        ),
      );

      auth = FirebaseAuth.instanceFor(app: app);
      user = kMockUser;

      mockUserPlatform = MockUserPlatform(mockAuthPlatform, user);
      mockConfirmationResultPlatform = MockConfirmationResultPlatform();
      mockAdditionalUserInfo = AdditionalUserInfo(
        isNewUser: false,
        username: 'flutterUser',
        providerId: 'testProvider',
        profile: <String, dynamic>{'foo': 'bar'},
      );
      mockCredential = EmailAuthProvider.credential(
        email: 'test',
        password: 'test',
      ) as EmailAuthCredential;
      mockUserCredPlatform = MockUserCredentialPlatform(
        FirebaseAuthPlatform.instance,
        mockAdditionalUserInfo,
        mockCredential,
        mockUserPlatform,
      );
      mockVerifier = MockRecaptchaVerifier();

      when(mockAuthPlatform.signInAnonymously())
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithCredential(any)).thenAnswer(
          (_) => Future<UserCredentialPlatform>.value(mockUserCredPlatform));

      when(mockAuthPlatform.currentUser).thenReturn(mockUserPlatform);

      when(mockAuthPlatform.instanceFor(
        app: anyNamed('app'),
        pluginConstants: anyNamed('pluginConstants'),
      )).thenAnswer((_) => mockUserPlatform);

      when(mockAuthPlatform.delegateFor(
        app: anyNamed('app'),
      )).thenAnswer((_) => mockAuthPlatform);

      when(mockAuthPlatform.setInitialValues(
        currentUser: anyNamed('currentUser'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) => mockAuthPlatform);

      when(mockAuthPlatform.createUserWithEmailAndPassword(any, any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.getRedirectResult())
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithCustomToken(any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithEmailAndPassword(any, any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithEmailLink(any, any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithPhoneNumber(any, any))
          .thenAnswer((_) async => mockConfirmationResultPlatform);

      when(mockVerifier.delegate).thenReturn(mockVerifier.mockDelegate);

      when(mockAuthPlatform.signInWithPopup(any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.signInWithRedirect(any))
          .thenAnswer((_) async => mockUserCredPlatform);

      when(mockAuthPlatform.authStateChanges()).thenAnswer((_) =>
          Stream<UserPlatform>.fromIterable(<UserPlatform>[mockUserPlatform]));

      when(mockAuthPlatform.idTokenChanges()).thenAnswer((_) =>
          Stream<UserPlatform>.fromIterable(<UserPlatform>[mockUserPlatform]));

      when(mockAuthPlatform.userChanges()).thenAnswer((_) =>
          Stream<UserPlatform>.fromIterable(<UserPlatform>[mockUserPlatform]));

      MethodChannelFirebaseAuth.channel.setMockMethodCallHandler((call) async {
        return <String, dynamic>{'user': user};
      });
    });

    tearDown(() => testCount++);

    setUp(() async {
      user = kMockUser;
      await auth.signInAnonymously();
    });

    group('currentUser', () {
      test('get currentUser', () {
        User user = auth.currentUser;
        verify(mockAuthPlatform.currentUser);
        expect(user, isA<User>());
      });
    });

    group('createUserWithEmailAndPassword()', () {
      test('should call delegate method', () async {
        when(mockAuthPlatform.createUserWithEmailAndPassword(any, any))
            .thenAnswer((i) async => EmptyUserCredentialPlatform());

        await auth.createUserWithEmailAndPassword(
          email: kMockEmail,
          password: kMockPassword,
        );

        verify(mockAuthPlatform.createUserWithEmailAndPassword(
          kMockEmail,
          kMockPassword,
        ));
      });
    });

    group('fetchSignInMethodsForEmail()', () {
      test('should call delegate method', () async {
        when(mockAuthPlatform.fetchSignInMethodsForEmail(any))
            .thenAnswer((i) async => []);

        await auth.fetchSignInMethodsForEmail(kMockEmail);
        verify(mockAuthPlatform.fetchSignInMethodsForEmail(kMockEmail));
      });
    });

    group('authStateChanges()', () {
      test('should stream changes', () async {
        final StreamQueue<User> changes =
            StreamQueue<User>(auth.authStateChanges());
        expect(await changes.next, isA<User>());
      });
    });

    group('userChanges()', () {
      test('should stream changes', () async {
        final StreamQueue<User> changes = StreamQueue<User>(auth.userChanges());
        expect(await changes.next, isA<User>());
      });
    });

    group('sendPasswordResetEmail()', () {
      test('should call delegate method', () async {
        when(mockAuthPlatform.sendPasswordResetEmail(any))
            .thenAnswer((i) async {});

        await auth.sendPasswordResetEmail(email: kMockEmail);
        verify(mockAuthPlatform.sendPasswordResetEmail(kMockEmail));
      });
    });

    group('signOut()', () {
      test('should call delegate method', () async {
        when(mockAuthPlatform.signOut()).thenAnswer((i) async {});

        await auth.signOut();
        verify(mockAuthPlatform.signOut());
      });
    });
  });
}

class MockFirebaseAuth extends Mock
    with MockPlatformInterfaceMixin
    implements TestFirebaseAuthPlatform {
  @override
  Stream<UserPlatform> userChanges() {
    return super.noSuchMethod(
      Invocation.method(#userChanges, []),
      returnValue: const Stream<UserPlatform>.empty(),
      returnValueForMissingStub: const Stream<UserPlatform>.empty(),
    );
  }

  @override
  Stream<UserPlatform> authStateChanges() {
    return super.noSuchMethod(
      Invocation.method(#authStateChanges, []),
      returnValue: const Stream<UserPlatform>.empty(),
      returnValueForMissingStub: const Stream<UserPlatform>.empty(),
    );
  }

  @override
  FirebaseAuthPlatform delegateFor({FirebaseApp app}) {
    return super.noSuchMethod(
      Invocation.method(#delegateFor, [], {#app: app}),
      returnValue: TestFirebaseAuthPlatform(),
      returnValueForMissingStub: TestFirebaseAuthPlatform(),
    );
  }

  @override
  Future<UserCredentialPlatform> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return super.noSuchMethod(
      Invocation.method(#createUserWithEmailAndPassword, [email, password]),
      returnValue: neverEndingFuture<UserCredentialPlatform>(),
      returnValueForMissingStub: neverEndingFuture<UserCredentialPlatform>(),
    );
  }

  @override
  Future<ConfirmationResultPlatform> signInWithPhoneNumber(
    String phoneNumber,
    RecaptchaVerifierFactoryPlatform applicationVerifier,
  ) {
    return super.noSuchMethod(
      Invocation.method(
        #signInWithPhoneNumber,
        [phoneNumber, applicationVerifier],
      ),
      returnValue: neverEndingFuture<ConfirmationResultPlatform>(),
      returnValueForMissingStub:
          neverEndingFuture<ConfirmationResultPlatform>(),
    );
  }

  @override
  Future<UserCredentialPlatform> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return super.noSuchMethod(
      Invocation.method(#signInWithEmailAndPassword, [email, password]),
      returnValue: neverEndingFuture<UserCredentialPlatform>(),
      returnValueForMissingStub: neverEndingFuture<UserCredentialPlatform>(),
    );
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) {
    return super.noSuchMethod(
      Invocation.method(#confirmPasswordReset, [code, newPassword]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) {
    return super.noSuchMethod(
      Invocation.method(#checkActionCode, [email]),
      returnValue: neverEndingFuture<List<String>>(),
      returnValueForMissingStub: neverEndingFuture<List<String>>(),
    );
  }

  @override
  Future<void> sendPasswordResetEmail(
    String email, [
    ActionCodeSettings actionCodeSettings,
  ]) {
    return super.noSuchMethod(
      Invocation.method(#sendPasswordResetEmail, [email, actionCodeSettings]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<void> signOut() {
    return super.noSuchMethod(
      Invocation.method(#signOut, [signOut]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<String> verifyPasswordResetCode(String code) {
    return super.noSuchMethod(
      Invocation.method(#verifyPasswordResetCode, [code]),
      returnValue: neverEndingFuture<String>(),
      returnValueForMissingStub: neverEndingFuture<String>(),
    );
  }

  @override
  Future<void> verifyPhoneNumber({
    String phoneNumber,
    Object verificationCompleted,
    Object verificationFailed,
    Object codeSent,
    Object codeAutoRetrievalTimeout,
    Duration timeout = const Duration(seconds: 30),
    int forceResendingToken,
    String autoRetrievedSmsCodeForTesting,
  }) {
    return super.noSuchMethod(
      Invocation.method(#verifyPhoneNumber, [], {
        #phoneNumber: phoneNumber,
        #verificationCompleted: verificationCompleted,
        #verificationFailed: verificationFailed,
        #codeSent: codeSent,
        #codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        #timeout: timeout,
        #forceResendingToken: forceResendingToken,
        #autoRetrievedSmsCodeForTesting: autoRetrievedSmsCodeForTesting,
      }),
      returnValue: neverEndingFuture<String>(),
      returnValueForMissingStub: neverEndingFuture<String>(),
    );
  }
}

class MockUserPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestUserPlatform {
  MockUserPlatform(FirebaseAuthPlatform auth, Map<String, dynamic> _user) {
    TestUserPlatform(auth, _user);
  }
}

class MockUserCredentialPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestUserCredentialPlatform {
  MockUserCredentialPlatform(
    FirebaseAuthPlatform auth,
    AdditionalUserInfo additionalUserInfo,
    AuthCredential credential,
    UserPlatform userPlatform,
  ) {
    TestUserCredentialPlatform(
      auth,
      additionalUserInfo,
      credential,
      userPlatform,
    );
  }
}

class MockConfirmationResultPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestConfirmationResultPlatform {
  MockConfirmationResultPlatform() {
    TestConfirmationResultPlatform();
  }
}

class TestConfirmationResultPlatform extends ConfirmationResultPlatform {
  TestConfirmationResultPlatform() : super('TEST');
}

class TestFirebaseAuthPlatform extends FirebaseAuthPlatform {
  TestFirebaseAuthPlatform() : super();

  void instanceFor({
    FirebaseApp app,
    Map<dynamic, dynamic> pluginConstants,
  }) {}

  @override
  FirebaseAuthPlatform delegateFor({FirebaseApp app}) {
    return this;
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    Map<String, dynamic> currentUser,
    String languageCode,
  }) {
    return this;
  }
}

class MockRecaptchaVerifier extends Mock
    with MockPlatformInterfaceMixin
    implements TestRecaptchaVerifier {
  MockRecaptchaVerifier() {
    TestRecaptchaVerifier();
  }

  RecaptchaVerifierFactoryPlatform get mockDelegate {
    return MockRecaptchaVerifierFactoryPlatform();
  }

  @override
  RecaptchaVerifierFactoryPlatform get delegate {
    return super.noSuchMethod(
      Invocation.getter(#delegate),
      returnValue: MockRecaptchaVerifierFactoryPlatform(),
      returnValueForMissingStub: MockRecaptchaVerifierFactoryPlatform(),
    );
  }
}

class MockRecaptchaVerifierFactoryPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestRecaptchaVerifierFactoryPlatform {
  MockRecaptchaVerifierFactoryPlatform() {
    TestRecaptchaVerifierFactoryPlatform();
  }
}

class TestRecaptchaVerifier implements RecaptchaVerifier {
  TestRecaptchaVerifier() : super();

  @override
  void clear() {}

  @override
  RecaptchaVerifierFactoryPlatform get delegate =>
      TestRecaptchaVerifierFactoryPlatform();

  @override
  Future<int> render() {
    throw UnimplementedError();
  }

  @override
  String get type => throw UnimplementedError();

  @override
  Future<String> verify() {
    throw UnimplementedError();
  }
}

class TestRecaptchaVerifierFactoryPlatform
    extends RecaptchaVerifierFactoryPlatform {}

class TestAuthProvider extends AuthProvider {
  TestAuthProvider() : super('TEST');
}

class TestUserPlatform extends UserPlatform {
  TestUserPlatform(FirebaseAuthPlatform auth, Map<String, dynamic> data)
      : super(auth, data);
}

class TestUserCredentialPlatform extends UserCredentialPlatform {
  TestUserCredentialPlatform(
    FirebaseAuthPlatform auth,
    AdditionalUserInfo additionalUserInfo,
    AuthCredential credential,
    UserPlatform userPlatform,
  ) : super(
          auth: auth,
          additionalUserInfo: additionalUserInfo,
          credential: credential,
          user: userPlatform,
        );
}

class EmptyUserCredentialPlatform extends UserCredentialPlatform {
  EmptyUserCredentialPlatform() : super(auth: FirebaseAuthPlatform.instance);
}
