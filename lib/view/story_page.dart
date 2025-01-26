import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text('My Status'),
          subtitle: Text('Tap to add status update'),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text('Contact 1'),
          subtitle: Text('Yesterday, 9:00 PM'),
        ),
      ],
    );
  }
}




