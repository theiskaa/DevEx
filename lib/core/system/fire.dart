import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

CollectionReference usersRef = firestore.collection('users');
CollectionReference examResultRef = firestore.collection("examResults");
CollectionReference questionIDSRef = firestore.collection('users');
