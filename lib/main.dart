//
// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:wharapp/firebase_options.dart';
// import 'package:wharapp/view/chatpage.dart';
// import 'package:wharapp/view/home_screen.dart';
// import 'package:wharapp/view/login_page.dart';
// import 'package:wharapp/view/userspage.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       // home: LoginPage(),
//       initialRoute: FirebaseAuth.instance.currentUser?.uid != null ? "home_page" : "/",
//       getPages: [
//         GetPage(
//           name: "/",
//           page: () => LoginPage(),
//         ),
//         GetPage(
//           name: "/home_page",
//           page: () => HomePage(),
//         ),
//         GetPage(
//           name: "/users_page",
//           page: () => UsersPage(),
//         ),
//         // GetPage(
//         //   name: "/chat_page",
//         //   page: () => ChatPage(),
//         // )
//       ],
//     );
//   }
// }
//
//



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wharapp/view/chatpage.dart';
import 'package:wharapp/view/home_page.dart';
import 'package:wharapp/view/login_page.dart';
import 'package:wharapp/view/userlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await FirebaseMessaging.instance.subscribeToTopic('all');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Auth Example',
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      initialRoute: FirebaseAuth.instance.currentUser?.uid != null ? "home_page" : "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => LoginPage(),
        ),
        GetPage(
          name: "/home_page",
          page: () => HomePage(name: '',email: "",),
        ),
        GetPage(
          name: "/users_page",
          page: () => Userlist(name: "",email: "",),
        ),
        GetPage(
          name: "/chat_page",
          page: () => ChatPage(chatId: '', recipientId: '',),
        )
      ],
    );
  }
}










