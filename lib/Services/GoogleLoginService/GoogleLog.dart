import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'package:smsq/Screens/Home.dart';
import 'package:smsq/const/Theme.dart';

class LoginGoogle {
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    // Create a new provider
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    try {
      UserCredential userCredential;
      if (Platform.isAndroid || Platform.isIOS) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await userCredential.user?.updateProfile(
            displayName: googleUser?.displayName,
            photoURL: googleUser?.photoUrl);
      } else {
        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      }
      String uid = userCredential.user!.uid;
      print(userCredential.user!.email);
      print(userCredential.user!.photoURL);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('X-token', uid);
      prefs.setString('E-mail', userCredential.user!.email!);
      prefs.setString('USer-name', userCredential.user!.displayName!);
      prefs.setString('P-photo', userCredential.user!.photoURL!);
      await userCredential.user?.updateProfile(
          displayName: userCredential.user?.displayName,
          photoURL: userCredential.user?.photoURL);
      if (uid.isNotEmpty) {
        navigateToTop(
          context,
          HomeScreen(
            prefs: prefs,
          ),
        );
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomeScreen(
        //         prefs: prefs,
        //       ),
        //     ),
        //     (route) => false);
      }
    } catch (e) {
      print("Error during sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during sign-in')),
      );
    }
  }
}
