
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wharapp/view/home_screen.dart';
import 'package:wharapp/main.dart';
import 'package:wharapp/view/story_page.dart';
import 'package:wharapp/view/userlist.dart';

import '../controller/homecotroller.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String email;

  const HomePage({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class _HomePageState extends State<HomePage> {
  HomeController controller = Get.put(HomeController());
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [

  Userlist(name: '',email: "",),
     StatusPage(),

   ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initNotification();
    initializeFirebaseMessaging();
    FirebaseMessaging.onMessage.listen(
          (event) {
        print("Notification title  => ${event.notification?.title}");
        print("Notification desc   => ${event.notification?.body}");
        controller.showAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
        // controller.showScheduleAppNotification(event.notification?.title ?? "", event.notification?.body ?? "");
      },
    );
  }

  Future<void> initializeFirebaseMessaging() async {
    // Request permission for iOS
    await FirebaseMessaging.instance.requestPermission();

    // Get the device's FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      // Save the FCM token to Firestore under the current user
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid ?? '').set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,

        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.logout,color: Colors.white,)),
          IconButton(
              onPressed: () {
                // controller.showScheduleAppNotification("hello ${DateTime.now()}", "All good morning");
                controller.showBigPictureAppNotification("hello", "Flutter Image");
                // controller.showMediaAppNotification("Hello <b>Bhavik</b>", "Hello <b>Flutter</b>");
              },
              icon: Icon(Icons.notifications,color: Colors.white,))
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Status',
          ),

        ],
      ),
    );
  }


  void initNotification() {
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }
}





