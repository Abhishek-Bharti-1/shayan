import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationProvider extends ChangeNotifier {
  String text = '';
  User? user;

  String get textMessage {
    return text;
  }

  String? getId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> submitAuthForm(String email, String password, bool isLogin,
      {String name = ''}) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) async {
          await value.user?.updateDisplayName(name);
          await value.user!.sendEmailVerification();
          return value;
        });
      }

      if (!isLogin) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set(
          {
            'name': name,
            'email': email,
            'healthState': 'NA',
            'questionNumber':-1,
            'isWatchConnected': false,
            'SSCreated': false,
            'diseaseType':'NA',
            'isCustomizedTimeline':'false',
            'isReady':'NA',
            'isWorryListOpened': false
          },
        );
      }

      if (isLogin) {
        text = 'Login successful';
      } else {
        text = 'Thank you for signing up!';
      }
          notifyListeners();

    } on PlatformException catch (err) {
      text = err.message.toString();
      notifyListeners();
    } catch (err) {
      text = err.toString();
      notifyListeners();
    }

    notifyListeners();
  }
}
