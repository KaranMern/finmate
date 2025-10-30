import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class FirestoreService {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.first == ConnectivityResult.none) {
        Fluttertoast.showToast(msg: "No internet connection");
        throw FirebaseAuthException(
          code: 'no-internet',
          message: 'No internet connection. Please check your network.',
        );
      }
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      print("eeeeeeeeee");
      print(e);
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google sign-in failed: $e',
      );
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'email-sign-in-failed',
        message: 'Email sign-in failed: $e',
      );
    }
  }
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
     try {
        return await auth.createUserWithEmailAndPassword(
            email: email, password: password);
     } catch (e) {
        throw FirebaseAuthException(
           code: 'email-registration-failed',
           message: 'User registration failed: $e',
        );
     }
  }
}
