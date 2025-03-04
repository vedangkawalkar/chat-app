import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class NewMessage extends StatefulWidget{
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() {
    return _NewMessagestate();
  }
  }

  class _NewMessagestate extends State<NewMessage>{

    final _messagecontroller = TextEditingController();

    @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  void _submitmessage() async {
    final enteredmessage = _messagecontroller.text;

    if(enteredmessage.trim().isEmpty){
      return;
    }

    FocusScope.of(context).unfocus();
    _messagecontroller.clear();

final user = _firebase.currentUser!;
final userdata = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  FirebaseFirestore.instance.collection('chat').add({
    'text' : enteredmessage,
    'createddat':Timestamp.now(),
    'userid': user.uid,
    'username': userdata.data()!['username'],
    'userimg' : userdata.data()!['img_url'],
  });

  }

    @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children:[
          Expanded(
            child: TextField(
              controller: _messagecontroller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message.'
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
              onPressed:_submitmessage,
          ),
        ]
      ),
    );
  }
  }