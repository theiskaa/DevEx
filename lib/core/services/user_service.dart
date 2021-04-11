import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../system/devexam.dart';
import '../system/fire.dart';
import '../utils/fire_exception_hander.dart';

/// Custom service class for controlle user acts.
class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Change username.
  Future<bool> changeUsername(String uid, String newUsername) async {
    try {
      await usersRef.doc(uid).update({
        'username': newUsername,
      });
      await firebaseAuth.currentUser.updateProfile(displayName: newUsername);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Change password in local
  Future<AuthStatus> changePassword({
    String uid,
    String newPassword,
  }) async {
    AuthStatus authStatus;
    try {
      var user = _auth.currentUser;
      await user.updatePassword(newPassword);
      authStatus = AuthStatus.successful;
    } catch (e) {
      authStatus = AuthExceptionHandler.handleFireAuthException(e);
    }

    return authStatus;
  }

  // For reauthenticate and validate currentPassword.
  Future<bool> validateCurrentPassword(String password) async {
    var user = _auth.currentUser;

    var authCredentials = EmailAuthProvider.credential(
      email: user.email,
      password: password,
    );
    try {
      var authResult = await user.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Reset password by sending email.
  Future<AuthStatus> sendPasswordResetMail(String email) async {
    AuthStatus authStatus;
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email).then(
            (_) => authStatus = AuthStatus.successful,
          );
    } catch (e) {
      print(e.toString());
      authStatus = AuthExceptionHandler.handleFireAuthException(e);
      return authStatus;
    }

    return authStatus;
  }

  // Send bug report email.

  Future<AuthStatus> sendBugReportMail({
    @required String title,
    @required String body,
    @required String recipient,
    bool isHTML = false,
  }) async {
    AuthStatus status;

    final Email email = Email(
      body: body,
      subject: title,
      recipients: [recipient],
      //TODO: Attachment paths
      // attachmentPaths: ,
      isHTML: isHTML,
    );
    try {
      await FlutterEmailSender.send(email);
      status = AuthStatus.bugReportedSuccessfully;
    } catch (e) {
      status = AuthStatus.undefined;
    }

    return status;
  }

  /// pick, crop and upload picture to firebase stortage.
  uploadProfilePicture(String uid, {final Function onError}) async {
    final _picker = ImagePicker();
    final _storage = FirebaseStorage.instance;
    PickedFile _pickedImage;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      _pickedImage = await _picker.getImage(source: ImageSource.gallery);
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: _pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Color(0xff886EE4),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      if (croppedFile != null) {
        var snapshot = await _storage
            .ref()
            .child("profilePics/$uid")
            .putFile(croppedFile)
            .whenComplete(
              () => print("image Putted successfully"),
            );

        var downloadUrl = await snapshot.ref.getDownloadURL();

        usersRef.doc(uid).update({
          'photoUrl': downloadUrl,
        });
      }
    } else {
      return onError;
    }
  }

  /// Save Exam's `correctAnswersCount`, `incorrectAnswersCount` and `incorrectAnswersList`.
  /// for show this values into exam history list (profile).
  Future<bool> saveExamHistory({
    String correctAnswersCount,
    String incorrectAnswersCount,
    String personID,
    List<dynamic> incorrectAnswersList,
    BuildContext context,
    DevExam devExam,
  }) async {
    try {
      await usersRef.doc(personID).collection('examResults').doc().set({
        'correctAnswersCount': correctAnswersCount,
        'incorrectAnswersCount': incorrectAnswersCount,
        'incorrectAnswersList': incorrectAnswersList,
        'date': Timestamp.now(),
        'personID': personID,
        'lang': "${devExam.intl.of(context).fmt('test.custom.category.lang')}",
        'platform': Platform.isIOS ? "IOS" : "Android",
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// Create a custom category by saved question's map/list.
  Future<bool> createCustomCategory({
    String uid,
    List<dynamic> savedQuestions,
    BuildContext context,
    DevExam devExam,
  }) async {
    try {
      await usersRef.doc(uid).collection('savedQuestions').doc().set({
        'date': Timestamp.now(),
        'questions': savedQuestions,
        'lang':
            devExam.intl.of(context).fmt('test.custom.category.lang') ?? " ",
        'platform': Platform.isIOS ? "IOS" : "Android",
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// Remove/Delete created custom category.
  Future<void> deleteCustomCategory({String uid, String doc}) =>
      usersRef.doc(uid).collection('savedQuestions').doc(doc).delete();

  /// Clear all saved exam result histories.
  Future<bool> clearFullExamHistoryList(
    String personID,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      await usersRef
          .doc(personID)
          .collection('examResults')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });

        return batch.commit();
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// Convert given [Timestamp] to String.
  String readTimestamp(
      Timestamp timestamp, BuildContext context, DevExam devExam) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = "${devExam.intl.of(context).fmt('timestap.tomorrow')}";
      } else {
        time = diff.inDays.toString() +
            " ${devExam.intl.of(context).fmt('timestap.daysLater')}";
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() +
            " ${devExam.intl.of(context).fmt('timestap.weekLater')}";
      } else {
        time = (diff.inDays / 7).floor().toString() +
            " ${devExam.intl.of(context).fmt('timestap.weekLater')}";
      }
    }

    return time;
  }
}
