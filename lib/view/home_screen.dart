// //
// // import 'dart:typed_data';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:get/get.dart';
// // import 'package:wharapp/controller/homecotroller.dart';
// // import 'package:timezone/data/latest_all.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// //
// // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// //
// // class homePage extends StatefulWidget {
// //   const homePage({super.key});
// //
// //   @override
// //   State<homePage> createState() => _homePageState();
// // }
// //
// //
// //
// // class _homePageState extends State<homePage> {
// //   HomeController controller = Get.put(HomeController());
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initNotification();
// //     FirebaseMessaging.onMessage.listen(
// //           (event) {
// //         print("Notification title  => ${event.notification?.title}");
// //         print("Notification desc   => ${event.notification?.body}");
// //         controller.showAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
// //         // controller.showScheduleAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
// //       },
// //
// //     );
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("${FirebaseAuth.instance.currentUser?.email ?? ""}"),
// //         actions: [
// //           IconButton(
// //               onPressed: () {
// //                 FirebaseAuth.instance.signOut();
// //                 Navigator.pushReplacementNamed(context, "/");
// //               },
// //               icon: Icon(Icons.logout)),
// //           IconButton(
// //               onPressed: () {
// //                 // controller.showScheduleAppNotification("hello ${DateTime.now()}", "All good morning");
// //                  controller.showBigPictureAppNotification("hello", "Flutter Image");
// //                 // controller.showMediaAppNotification("Hello <b>Bhavik</b>", "Hello <b>Flutter</b>");
// //               },
// //               icon: Icon(Icons.notifications))
// //         ],
// //       ),
// //       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
// //           stream: FirebaseFirestore.instance.collection("chat_room").snapshots(),
// //           builder: (context, snapshot) {
// //             if (snapshot.hasData) {
// //               List<QueryDocumentSnapshot<Map<String, dynamic>>> chatRoom = snapshot.data?.docs ?? [];
// //               return ListView.builder(
// //                 itemCount: chatRoom.length,
// //                 itemBuilder: (context, index) {
// //                   Map<String, dynamic> room = chatRoom[index].data();
// //                   return ListTile(
// //                     title: Text("${room["user_b_email"]}"),
// //                     subtitle: Text("${room["last_msg"]}"),
// //                     trailing: ((int.tryParse("${room["unread"]}") ?? 0) > 0)
// //                         ? CircleAvatar(
// //                       child: Text("${room["unread"]}"),
// //                     )
// //                         : null,
// //                   );
// //                 },
// //               );
// //             } else {
// //               return CircularProgressIndicator();
// //             }
// //           }),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           Get.toNamed("/users_page");
// //         },
// //         child: Icon(Icons.person),
// //       ),
// //
// //     );
// //   }
// //
// //   void initNotification() {
// //     flutterLocalNotificationsPlugin.initialize(
// //       InitializationSettings(
// //         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
// //       ),
// //     );
// //   }
// //
// // }
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:wharapp/controller/homecotroller.dart';
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   HomeController controller = Get.put(HomeController());
//
//   @override
//   void initState() {
//     super.initState();
//     initNotification();
//     FirebaseMessaging.onMessage.listen(
//           (event) {
//         print("Notification title  => ${event.notification?.title}");
//         print("Notification desc   => ${event.notification?.body}");
//         controller.showAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
//         // controller.showScheduleAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${FirebaseAuth.instance.currentUser?.email ?? ""}"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacementNamed(context, "/");
//               },
//               icon: Icon(Icons.logout)),
//           IconButton(
//               onPressed: () {
//                 // controller.showScheduleAppNotification("hello ${DateTime.now()}", "All good morning");
//                 // controller.showBigPictureAppNotification("hello", "Flutter Image");
//                 controller.showMediaAppNotification("Hello <b>Bhavik</b>", "Hello <b>Flutter</b>");
//               },
//               icon: Icon(Icons.notifications))
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//           stream: FirebaseFirestore.instance.collection("chat_room").snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<QueryDocumentSnapshot<Map<String, dynamic>>> chatRoom = snapshot.data?.docs ?? [];
//               return ListView.builder(
//                 itemCount: chatRoom.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> room = chatRoom[index].data();
//                   return ListTile(
//                     title: Text("${room["user_b_email"]}"),
//                     subtitle: Text("${room["last_msg"]}"),
//                     trailing: ((int.tryParse("${room["unread"]}") ?? 0) > 0)
//                         ? CircleAvatar(
//                       child: Text("${room["unread"]}"),
//                     )
//                         : null,
//                   );
//                 },
//               );
//             } else {
//               return CircularProgressIndicator();
//             }
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           Get.toNamed("users_page");
//         },
//         child: Icon(Icons.person),
//       ),
//     );
//   }
//
//   void initNotification() {
//     flutterLocalNotificationsPlugin.initialize(
//       InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       ),
//     );
//   }
// }
//
