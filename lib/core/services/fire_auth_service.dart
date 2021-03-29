import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/user.dart';
import '../system/fire.dart';
import '../utils/fire_exception_hander.dart';

/// Custom service class for controlle authentication methods.
class FireAuthService {
  FireAuthService({
    firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Get user by [UserModel]
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
    });
  }

  /// Get user by `currentUser` property
  User getCurrentUser() {
    User user = firebaseAuth.currentUser;
    return user;
  }

  /// Sign Up.
  Future<AuthStatus> createUserWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    assert(username != null && email != null && password != null);
    AuthStatus authStatus;
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await saveUserToFirestore(username, result.user, email, password);
        authStatus = AuthStatus.successful;
      }
    } catch (e) {
      authStatus = AuthExceptionHandler.handleFireAuthException(e);
    }
    return authStatus;
  }

  /// Sign In.
  Future<AuthStatus> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    AuthStatus authStatus;
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        authStatus = AuthStatus.successful;
        usersRef.doc(result.user.uid).update({
          'password': password,
        });
      }
    } catch (e) {
      authStatus = AuthExceptionHandler.handleFireAuthException(e);
    }
    return authStatus;
  }

  Future<void> logOut() async => await Future.wait([_firebaseAuth.signOut()]);

  /// Save user to firebsae after calling `createUserWithEmailAndPassword` method.
  saveUserToFirestore(
    String username,
    User user,
    String email,
    String password,
  ) async {
    await usersRef.doc(user.uid).set({
      'username': username,
      'email': email,
      'accountCreated': Timestamp.now(),
      'id': user.uid,
      'photoUrl': user.photoURL ??
          'https://firebasestorage.googleapis.com/v0/b/gayi-dayi.appspot.com/o/profilePics%2Fempty.png?alt=media&token=bfc15ffb-1dfc-406b-b33f-2b15cf88a58e',
      'password': password,
      'createdPlatform:': Platform.isIOS ? "IOS" : "Android",
    });
  }
}

/// extension for integrate [UserModel] to firebase user.
extension on firebase_auth.User {
  UserModel get toUser {
    return UserModel(
      id: uid,
      email: email,
      username: displayName,
      photo: photoURL,
    );
  }
}
