
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text('Notification'),
    ),
      body: Container(
        child: FirestoreAnimatedList(
    query: databaseReference.collection('Token').snapshots(),
    itemBuilder: (
    BuildContext context,
    DocumentSnapshot snapshot,
    Animation<double> animation,
    int index){
      return Card(
        color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            title: Text(snapshot.data['title']),
            subtitle:Text(snapshot.data['body']),
          ),
      );
    }
    ),
      ),
    );
  }
}
