//actual message page showing all the users and messages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifebalance/Chat/message.dart';
import 'package:lifebalance/auth/authService.dart';
import 'package:lifebalance/auth/signIn.dart';
import 'package:lifebalance/widgets/gradient_appbar.dart';
import 'package:lifebalance/widgets/theme.dart';

import 'chatTile.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          gradientBegin: theme.green,
          gradientEnd: theme.darkergreen,
          title: 'Messages'//AppBar(
          //backgroundColor: myPink,
          //title: Text("Messages"),
          //iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('conversations')
                  .document(currentUser.uid)
                  .collection('chats')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("no chat exit"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      final lastMessage = LastMessage(
                        userID: snapshot.data.documents[index].documentID,
                        message: snapshot.data.documents[index]
                        ['lastMessage'],
                        time: DateTime.fromMillisecondsSinceEpoch(snapshot.data.documents[index]['date'].millisecondsSinceEpoch).toIso8601String(), //ahh i see, thn should be fine after deletin

                      );
                      return ChatTile(lastMessage: lastMessage);
                    });
              },
            )));
  }
}
