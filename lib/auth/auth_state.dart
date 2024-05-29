import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/student/HomePageS.dart';
import 'package:mentorme/teacher/HomePageT.dart';
import 'package:mentorme/auth/LogInPage.dart';
import 'package:mentorme/firebase_options.dart';
import 'package:mentorme/widgets.dart';

class AuthState extends ChangeNotifier {
  bool _loggedIn = false;
  bool? _isStudent;
  bool get loggedIn => _loggedIn;
  bool? get isStudent => _isStudent;

  AuthState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await checkUserType(user.uid);
        setLoggedIn(true);
      } else {
        setLoggedIn(false);
        setClientIn(null); // Reset user type when logged out
      }
    });
  }

  void setLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  void setClientIn(bool? value) {
    _isStudent = value;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
    _isStudent = null;
    setLoggedIn(false);
  }

  Future<void> checkUserType(String uid) async {
    DocumentSnapshot userDoc =
        await firestore.collection('students').doc(uid).get();
    if (userDoc.exists) {
      print('exist');
      setClientIn(true);
    } else {
      print('not exist');
      setClientIn(false);
    }
    print(_isStudent);
  }

  Widget getPage() {
    if (_loggedIn) {
      if (_isStudent != null) {
        if (_isStudent!) {
          return HomePageS();
        } else {
          return HomePageT();
        }
      } else {
        // Show a loading indicator while determining the user type
        return const CircularProgressIndicator();
      }
    } else {
      return LoginPage();
    }
  }
}
