import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devexam/core/services/user_service.dart';
import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/testing_helpers.dart';
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

  UserServices userServices;
  UserServiceMocker mocker;
  MockBuildContext mockContext;

  const String userID = "Iafoiuh13afsjk2535";

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
    mocker = UserServiceMocker();

    // Initilaze UserServices class.
    userServices = UserServices();

    // Initilaze MockBuildContext
    mockContext = MockBuildContext();
  });

  group("[UserServices]", () {
    group("ChangeUsername", () {
      test("-Success-", () {
        when(mocker.changeUsername(userID, 'New username'))
            .thenAnswer((_) => Future.value(true));
      });

      test("-Error-", () {
        when(mocker.changeUsername(null, 'New username'))
            .thenAnswer((_) => Future.value(false));
      });
    });

    group("ChangePassword", () {
      test("-Success-", () {
        when(mocker.changePassword(uid: userID, newPassword: "test123"))
            .thenAnswer((_) => Future.value(AuthStatus.successful));
      });

      test("Error - undefined", () {
        when(mocker.changePassword(uid: null, newPassword: "."))
            .thenAnswer((_) => Future.value(AuthStatus.undefined));
      });

      test("Error - weak password", () {
        when(mocker.changePassword(uid: null, newPassword: "test"))
            .thenAnswer((_) => Future.value(AuthStatus.weakPassword));
      });
    });

    group("Validate Current Password", () {
      test("-Success-", () {
        when(mocker.validateCurrentPassword('test123'))
            .thenAnswer((_) => Future.value(true));
      });

      test("-Error-", () {
        when(mocker.validateCurrentPassword("test"))
            .thenAnswer((_) => Future.value(false));
      });
    });

    group("Send password reset mail", () {
      test("-Success-", () {
        when(mocker.sendPasswordResetMail('test@example.com'))
            .thenAnswer((_) => Future.value(AuthStatus.successful));
      });

      test("Error - invalidEmail", () {
        when(mocker.sendPasswordResetMail("test"))
            .thenAnswer((_) => Future.value(AuthStatus.invalidEmail));
      });

      test("Error - userNotFound", () {
        when(mocker.sendPasswordResetMail("test@gmail.com"))
            .thenAnswer((_) => Future.value(AuthStatus.userNotFound));
      });

      test("Error - userDisabled", () {
        when(mocker.sendPasswordResetMail("test@example.com"))
            .thenAnswer((_) => Future.value(AuthStatus.userDisabled));
      });
    });

    group("Send bug report mail", () {
      test("-Success-", () {
        when(mocker.sendBugReportMail(
          title: "title",
          body: "body",
          recipient: "test@example.com",
          attachments: [],
        )).thenAnswer((_) => Future.value(AuthStatus.bugReportedSuccessfully));
      });

      test("-Error-", () {
        when(mocker.sendBugReportMail(
          title: null,
          body: null,
          recipient: null,
          attachments: null,
        )).thenAnswer((_) => Future.value(AuthStatus.undefined));
      });

      test("Add attachment - success", () {
        when(
          mocker.addAttachment(['path/images/img.png']),
        ).thenAnswer(
          (_) => userServices.addAttachment(['path/images/img.png']),
        );
      });
      test("Add attachment - error", () {
        when(
          mocker.addAttachment(null),
        ).thenAnswer(
          (_) => userServices.addAttachment(null),
        );
      });
    });

    group("Upload Profile Picture", () {
      test("-Success-", () {
        when(mocker.uploadProfilePicture(userID))
            .thenAnswer((_) => userServices.uploadProfilePicture(userID));
      });

      test("-Error-", () {
        when(mocker.uploadProfilePicture(null))
            .thenAnswer((_) => userServices.uploadProfilePicture(null));
      });
    });

    group("Save Exam History", () {
      test("-Success-", () {
        when(
          mocker.saveExamHistory(
            correctAnswersCount: '10',
            incorrectAnswersCount: '0',
            personID: userID,
            incorrectAnswersList: [],
            context: mockContext,
            devExam: devEx,
          ),
        ).thenAnswer((_) => Future.value(true));
      });

      test("-Error-", () {
        when(
          mocker.saveExamHistory(
            correctAnswersCount: null,
            incorrectAnswersCount: null,
            personID: null,
            incorrectAnswersList: null,
            context: null,
            devExam: null,
          ),
        ).thenAnswer((_) => Future.value(false));
      });
    });

    group("Create custom category", () {
      test("-Success-", () {
        when(mocker.createCustomCategory(
          uid: userID,
          savedQuestions: [
            {'1', '2', '3'},
            {'1', '2', '3'}
          ],
          context: mockContext,
          devExam: devEx,
        )).thenAnswer((_) => Future.value(true));
      });

      test("-Error-", () {
        when(mocker.createCustomCategory(
          uid: null,
          savedQuestions: null,
          context: null,
          devExam: null,
        )).thenAnswer((_) => Future.value(false));
      });
    });

    group("Delete Custom Category", () {
      test("-Success-", () {
        when(mocker.deleteCustomCategory(uid: userID, doc: 'documentId'))
            .thenAnswer(
          (_) =>
              userServices.deleteCustomCategory(uid: userID, doc: 'documentId'),
        );
      });

      test("-Error-", () {
        when(mocker.deleteCustomCategory(uid: null, doc: null)).thenAnswer(
          (_) => userServices.deleteCustomCategory(uid: null, doc: null),
        );
      });
    });
    group("Clear full exam history", () {
      test("-Success-", () {
        when(mocker.clearFullExamHistoryList(userID))
            .thenAnswer((_) => Future.value(true));
      });

      test("-Error-", () {
        when(mocker.clearFullExamHistoryList(null))
            .thenAnswer((_) => Future.value(false));
      });
    });

    group("Read Timestamp", () {
      test("-NOW-", () {
        when(mocker.readTimestamp(Timestamp.now(), mockContext, devEx))
            .thenAnswer(
          (_) => Timestamp.now().toString(),
        );
      });

      test("-Error (not now)-", () {
        when(mocker.readTimestamp(Timestamp(4332, 184), mockContext, devEx))
            .thenAnswer(
          (_) => Timestamp.now().toString(),
        );
      });
    });
  });
}
