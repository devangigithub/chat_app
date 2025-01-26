// import 'dart:math';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:http/http.dart' as http;
// import 'package:wharapp/view/home_screen.dart';
//
// class HomeController extends GetxController {
//   late AppLifecycleListener appLifecycleListener;
//
//   @override
//   void onInit() {
//     super.onInit();
//     appLifecycleListener = AppLifecycleListener(
//       onStateChange: (value) {
//         print("AppLifecycleListener $value");
//         if (value == AppLifecycleState.resumed) {
//           // FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((value) {
//           //   var data = value.data();
//           //   print("user Data $data");
//           // });
//
//           FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
//             "isOnline": true,
//           });
//           // user is onLine
//         } else if (value == AppLifecycleState.paused) {
//           FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
//             "isOnline": false,
//           });
//           // user is offLine
//         }
//       },
//     );
//     updateFirebaseToken();
//     // appLifecycleListener.dispose();
//   }
//
//   Future<void> updateFirebaseToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(
//       {
//         "fcmToken": token,
//       },
//
//     );
//     print("Firebase Token: $token");
//   }
//
//   void showAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//         ),
//       ),
//     );
//   }
//
//   void showScheduleAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       desc,
//       tz.TZDateTime.now(tz.local).add(Duration(minutes: 2)),
//       // tz.TZDateTime(tz.local, 2025,1,20,10,30),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           icon: "@mipmap/ic_launcher",
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.alarmClock,
//     );
//   }
//
//   void showBigPictureAppNotification(String title, String desc) async {
//     var uint8List =
//     await _getByteArrayFromUrl("https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp");
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           styleInformation: BigPictureStyleInformation(ByteArrayAndroidBitmap(uint8List)),
//         ),
//       ),
//     );
//   }
//
//   void showMediaAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           styleInformation: MediaStyleInformation(
//             htmlFormatContent: true,
//             htmlFormatTitle: true,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<Uint8List> _getByteArrayFromUrl(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     return response.bodyBytes;
//   }
// }

import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:wharapp/view/home_screen.dart';

import '../view/home_page.dart';

class HomeController extends GetxController {
  late AppLifecycleListener appLifecycleListener;

  @override
  void onInit() {
    super.onInit();
    appLifecycleListener = AppLifecycleListener(
      onStateChange: (value) {
        print("AppLifecycleListener $value");
        if (value == AppLifecycleState.resumed) {
          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid ?? "").get().then((value) {
            var data = value.data();
            print("user Data $data");
          });

          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
            "isOnline": true,
          });
          // user is onLine
        } else if (value == AppLifecycleState.paused) {
          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
            "isOnline": false,
          });
          // user is offLine
        }
      },
    );
    updateFirebaseToken();

  }

  Future<void> updateFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid ?? "").update(
      {
        "fcmToken": token,
      },
    );
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "fcmToken": newToken,
      });
    });
  }




  void showAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
        ),
      ),
    );
  }

  void showScheduleAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      desc,
      tz.TZDateTime.now(tz.local).add(Duration(minutes: 2)),
      // tz.TZDateTime(tz.local, 2025,1,20,10,30),
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          icon: "@mipmap/ic_launcher",
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  void showBigPictureAppNotification(String title, String desc) async {
    var uint8List =
    await _getByteArrayFromUrl("https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp");
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          styleInformation: BigPictureStyleInformation(ByteArrayAndroidBitmap(uint8List)),
        ),
      ),
    );
  }

  void showMediaAppNotification(String title, String desc) async {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      desc,
      NotificationDetails(
        android: AndroidNotificationDetails(
          "Chat",
          "ChatApp",
          styleInformation: MediaStyleInformation(
            htmlFormatContent: true,
            htmlFormatTitle: true,
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}

// import 'dart:math';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:http/http.dart' as http;
// import 'package:wharapp/view/home_screen.dart';
//
// class HomeController extends GetxController {
//   late AppLifecycleListener appLifecycleListener;
//
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void onInit() {
//     super.onInit();
//     appLifecycleListener = AppLifecycleListener(
//       onStateChange: (value) {
//         print("AppLifecycleListener $value");
//         if (value == AppLifecycleState.resumed) {
//           updateUserOnlineStatus(true);
//         } else if (value == AppLifecycleState.paused) {
//           updateUserOnlineStatus(false);
//         }
//       },
//     );
//     updateFirebaseToken();
//   }
//
//   Future<void> updateFirebaseToken() async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
//
//     if (userId.isNotEmpty) {
//       FirebaseFirestore.instance.collection("users").doc(userId).update(
//         {
//           "fcmToken": token,
//         },
//       );
//     }
//
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//       String userId = FirebaseAuth.instance.currentUser!.uid;
//       await FirebaseFirestore.instance.collection("users").doc(userId).update({
//         "fcmToken": newToken,
//       });
//     });
//   }
//
//   Future<void> updateUserOnlineStatus(bool isOnline) async {
//     String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
//     if (userId.isNotEmpty) {
//       FirebaseFirestore.instance.collection("users").doc(userId).update({
//         "isOnline": isOnline,
//       });
//       if (isOnline) {
//         FirebaseFirestore.instance.collection("users").doc(userId).get().then((value) {
//           var data = value.data();
//           print("User Data: $data");
//         }).catchError((error) {
//           print("Error fetching user data: $error");
//         });
//       }
//     }
//   }
//
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         showNotification(
//           message.notification!.title ?? 'New Notification',
//           message.notification!.body ?? '',
//         );
//       }
//     });
//
//     FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
//   }
//
//   static Future<void> backgroundMessageHandler(RemoteMessage message) async {
//     print('Background message: ${message.notification?.title}');
//     showNotification(message.notification?.title ?? 'Background Notification', message.notification?.body ?? '');
//   }
//
//   static Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default',
//       channelDescription: 'This channel is used for default notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   void showAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//         ),
//       ),
//     );
//   }
//
//   void showScheduleAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       desc,
//       tz.TZDateTime.now(tz.local).add(Duration(minutes: 2)),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           icon: "@mipmap/ic_launcher",
//         ),
//       ),
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.alarmClock,
//     );
//   }
//
//   void showBigPictureAppNotification(String title, String desc) async {
//     var uint8List = await _getByteArrayFromUrl(
//         "https://cdn.prod.website-files.com/654366841809b5be271c8358/659efd7c0732620f1ac6a1d6_why_flutter_is_the_future_of_app_development%20(1).webp");
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           styleInformation: BigPictureStyleInformation(ByteArrayAndroidBitmap(uint8List)),
//         ),
//       ),
//     );
//   }
//
//   void showMediaAppNotification(String title, String desc) async {
//     flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       desc,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Chat",
//           "ChatApp",
//           styleInformation: MediaStyleInformation(
//             htmlFormatContent: true,
//             htmlFormatTitle: true,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<Uint8List> _getByteArrayFromUrl(String url) async {
//     final http.Response response = await http.get(Uri.parse(url));
//     return response.bodyBytes;
//   }
// }
