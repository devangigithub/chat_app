//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wharapp/controller/chatcotroller.dart';
//
// class ChatPage extends StatelessWidget {
//   final ChatController controller = Get.put(ChatController());
//
//   ChatPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${controller.arg["email"]}"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("users")
//                     .doc(controller.arg["receiver_id"])
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var otherUser = snapshot.data?.data() as Map<String, dynamic>;
//                     return Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text((otherUser["isOnline"] == true) ? "Online" : "Offline"),
//                         Icon(
//                           Icons.circle,
//                           size: 12,
//                           color: (otherUser["isOnline"] == true) ? Colors.green : Colors.red,
//                         ),
//                       ],
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 }),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Chat Messages
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("message")
//                     .where("chat_room_id", isEqualTo: controller.arg["chat_room_id"])
//                     .orderBy('time')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var msgList = snapshot.data?.docs ?? [];
//                     controller.jumpToEnd();
//                     return ListView.builder(
//                       itemCount: msgList.length,
//                       controller: controller.scrollController,
//                       itemBuilder: (context, index) {
//                         var msg = msgList[index];
//                         Map<String, dynamic> data = msg.data() as Map<String, dynamic>;
//
//                         bool isSender = data["sender"] == FirebaseAuth.instance.currentUser?.uid;
//
//                         return Align(
//                           alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: isSender ? Colors.blueAccent : Colors.grey,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.2),
//                             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                             padding: const EdgeInsets.all(10),
//                             child: Text(
//                               data["msg"] ?? "",
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 }),
//           ),
//
//           // Message Input
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.msgController,
//                   decoration: const InputDecoration(
//                     hintText: "Type a message",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () async {
//                   if (controller.msgController.text.trim().isNotEmpty) {
//                     await FirebaseFirestore.instance.collection("message").add({
//                       "msg": controller.msgController.text,
//                       "time": DateTime.now(),
//                       "chat_room_id": controller.arg["chat_room_id"],
//                       "sender": FirebaseAuth.instance.currentUser?.uid,
//                       "receiver": controller.arg["receiver_id"]
//                     });
//                     await FirebaseFirestore.instance
//                         .collection("chat_room")
//                         .doc(controller.arg["chat_room_id"])
//                         .update({
//                       "last_msg": controller.msgController.text,
//                       "unread": FieldValue.increment(1),
//                     });
//                     controller.msgController.clear();
//                   }
//                 },
//                 icon: const Icon(Icons.send),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/chatcotroller.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String recipientId;
  final ChatController chatController = Get.put(ChatController());

  ChatPage({required this.chatId, required this.recipientId});

  Future<Map<String, String>> getRecipientDetails() async {
    final recipientData = await chatController.firestore.collection('users').doc(recipientId).get();
    if (recipientData.exists) {
      return {
        'name': recipientData.data()?['name'] ?? 'Unknown',
        'email': recipientData.data()?['email'] ?? '',
      };
    }
    return {'name': 'Unknown', 'email': ''};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {

            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'email',
                child: FutureBuilder<Map<String, String>>(
                  future: getRecipientDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    if (snapshot.hasError) {
                      return Text('Error');
                    }

                    final recipientEmail = snapshot.data?['email'] ?? 'No Email';
                    return Text(recipientEmail);
                  },
                ),
              ),
            ],
          ),
        ],
        title: FutureBuilder<Map<String, String>>(
          future: getRecipientDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  CircleAvatar(
                    child: Text(''),
                  ),
                  SizedBox(width: 10),
                  Text('Loading...'),
                ],
              );
            }
            if (snapshot.hasError) {
              return Row(
                children: [
                  CircleAvatar(
                    child: Text(''),
                  ),
                  SizedBox(width: 10),
                  Text('Error'),
                ],
              );
            }

            final recipientName = snapshot.data?['name'] ?? 'Unknown';
            final firstLetter = recipientName.isNotEmpty ? recipientName[0].toUpperCase() : '';

            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green, // Custom color
                  child: Text(
                    firstLetter,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  recipientName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            );
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatController.getMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    final message = messages?[index];
                    final isSender = message?['senderId'] == chatController.currentUserId;
                    final timestamp = message?['timestamp']?.toDate(); // Assuming timestamp is a Firebase Timestamp

                    final formattedTime = timestamp != null
                        ? DateFormat('hh:mm a').format(timestamp)
                        : '';

                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.green[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message?['text'] ?? '',
                          style: TextStyle(color: isSender ? Colors.white : Colors.black),
                        ),

                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: chatController.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  // onPressed: () => chatController.sendMessage(chatId, recipientId),
                  onPressed: () {
                    if (chatController.messageController.text.trim().isNotEmpty) {
                      chatController.sendMessage(chatId, recipientId);
                      chatController.messageController.clear();
                    }
                  },
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}