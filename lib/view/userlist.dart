// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class Userlist extends StatefulWidget {
//   const Userlist({super.key});
//
//   @override
//   State<Userlist> createState() => _UserlistState();
// }
//
// class _UserlistState extends State<Userlist> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.separated(
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(),
//             onTap: (){
//               Get.toNamed('/chat');
//             },
//             title: Text("$index"),
//             subtitle: Text("Text ${index+1}"),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return SizedBox(height: 10);
//         },
//         itemCount: 5,
//
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wharapp/view/chatpage.dart';

class Userlist extends StatelessWidget  {
  final String name;
  final String email;

  Userlist({required this.name, required this.email});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> getCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await firestore.collection('users').doc(user.uid).get();
      return snapshot.data()?['name'] ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: FutureBuilder<String>(
        future: getCurrentUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }
          return Text(snapshot.data ?? 'Unknown User');
        },
      ),),
      body: StreamBuilder(
        stream: firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 10,);
            },
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final userName = user.containsKey('name') ? user['name'] : 'Unknown';
              final userEmail = user.containsKey('email') ? user['email'] : '';
              final recipientId = users[index].id; // User ID

              String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
              String chatId = generateChatId(currentUserEmail, userEmail);

              return FutureBuilder<DocumentSnapshot?>(
                future: getLastMessage(chatId),
                builder: (context, messageSnapshot) {
                  String lastMessage = 'No messages yet';
                  if (messageSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(userName),
                      subtitle: Text(userEmail),
                      trailing: CircularProgressIndicator(),
                    );
                  }

                  if (messageSnapshot.hasData && messageSnapshot.data != null) {
                    final messageData = messageSnapshot.data?.data() as Map<String, dynamic>?;
                    if (messageData != null) {
                      lastMessage = messageData['text'] ?? 'No messages yet';
                    }
                  }

                  return ListTile(
                    title: Text(userName,style: TextStyle(fontSize: 20),),
                    leading: CircleAvatar(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white,fontSize: 23),
                      ),
                      backgroundColor: Colors.green, // Set any color for the avatar
                    ),
                    // subtitle: Text(userEmail),
                    subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                    // trailing: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis), // Last message
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatId: chatId,
                            recipientId: recipientId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String generateChatId(String recipientEmail, String currentEmail) {
    List<String> users = [recipientEmail, currentEmail];
    users.sort();
    return users.join('_');
  }


  Future<DocumentSnapshot?> getLastMessage(String chatId) async {
    var snapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      return snapshot.docs.first;
    }
  }
}