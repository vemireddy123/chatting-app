import 'package:chatapp/chats/message_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser(),

    //     // some problem is there
    //     builder: (context, futureSnapshot) {
    //   if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final  chatDocs = chatSnapshot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => MessageBubble(
            chatDocs[index].data()['text'],
            chatDocs[index].data()['username'],
            // chatDocs[index].data()['imageUrl'],
            chatDocs[index].data()['userId'] = user.uid,
            key: ValueKey(chatDocs[index].id),
          ),
          // itemBuilder: (context, index) => Text(
          //   chatDocs[index].data()['text'],
          // ),
        );
      },
    );
  }
}
