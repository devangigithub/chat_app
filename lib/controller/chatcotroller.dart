// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChatController extends GetxController {
//   late Map<String, dynamic> arg;
//   TextEditingController msgController = TextEditingController();
//   ScrollController scrollController = ScrollController();
//
//   void jumpToEnd() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       var maxScrollExtent = scrollController.position.maxScrollExtent;
//       scrollController.jumpTo(maxScrollExtent);
//     });
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     arg = Get.arguments;
//     // Reset unread messages when entering the chat room
//     FirebaseFirestore.instance.collection("chat_room").doc(arg["chat_room_id"]).update({
//       "unread": 0,
//     });
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final TextEditingController messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'New Message',
          message.notification!.body ?? 'You have a new message',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String recipientId) async {
    if (messageController.text.trim().isEmpty) return;

    final messageData = {
      'senderId': currentUserId,
      'recipientId': recipientId,
      'text': messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await firestore.collection('chats').doc(chatId).collection('messages').add(messageData);

    DocumentSnapshot recipientSnapshot = await firestore.collection('users').doc(recipientId).get();
    String? recipientToken = recipientSnapshot['fcmToken'];
    String? senderName = FirebaseAuth.instance.currentUser?.displayName ?? 'Someone';

    if (recipientToken != null) {
       await sendNotification(
      // await sendPushNotification(
        recipientToken,
        senderName,
        messageController.text.trim(),
      );
    }

    messageController.clear();
  }

  Future<void> sendNotification(String token, String title, String body) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'to': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': body,
        },
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Future<void> sendPushNotification(String token, String title, String body) async {
  //   try {
  //     FirebaseMessaging.instance.sendMessage(
  //       to: token,
  //       data: {
  //         'title': title,
  //         'body': body,
  //       },
  //     );
  //   } catch (e) {
  //     print('Error sending notification: $e');
  //   }
  // }
}