import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  var _enteredMessages = '';

  void _sendMessages() async {
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessages,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()['username'],
    });
    _controller.clear();
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'send a message...'),
              onChanged: (value) {
                _enteredMessages = value;
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessages.trim().isEmpty ? null : _sendMessages,
          )
        ],
      ),
    );
  }
}
