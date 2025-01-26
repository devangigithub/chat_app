//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class LoginController extends GetxController {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//
//   RxBool isLoad = false.obs;
//
//   Future<void> login() async {
//     isLoad.value = true;
//     try {
//       UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email.text,
//         password: password.text,
//       );
//       Get.toNamed("home_page");
//       print(" user ===> ${user.user}");
//     } on FirebaseAuthException catch (e) {
//       Get.snackbar("Error", e.code);
//     } catch (e) {
//       print("error $e");
//     }
//     isLoad.value = false;
//   }
//
//   Future<void> register() async {
//     isLoad.value = true;
//     try {
//       UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email.text,
//         password: password.text,
//       );
//       if (userCred.user != null) {
//         await FirebaseFirestore.instance.collection("users").doc(userCred.user?.uid).set(
//           {
//             "id": userCred.user?.uid,
//             "email": userCred.user?.email ?? "",
//           },
//         );
//
//         await FirebaseFirestore.instance.collection("users").add(
//           {
//             "id": userCred.user?.uid,
//             "email": userCred.user?.email ?? "",
//           },
//         );
//         Get.toNamed("home_page");
//       }
//     } on FirebaseAuthException catch (e) {
//       Get.snackbar("Error", e.code);
//       print("FirebaseAuthException $e");
//     } catch (e) {
//       print("Exception $e");
//     }
//     isLoad.value = false;
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../view/home_page.dart';
import '../view/userlist.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  void loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );


      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final name = userDoc.data()?['name'] ?? 'No Name';
      final userEmail = userCredential.user?.email ?? 'No Email';

      Get.offAll(() => HomePage(
        name: name,
        email: userEmail,
      ));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  void registerWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'User registered successfully!');
      Get.offAll(() => HomePage(
        name: name.trim(),
        email: email.trim(),
      ));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Login with Google
  void loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);

      final user = userCredential.user;
      String name = user?.displayName ?? 'No Name';
      String email = user?.email ?? 'No Email';

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        name = userDoc.data()?['name'] ?? name;
      }

      Get.offAll(() => HomePage(
        name: name,
        email: email,
      ));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}