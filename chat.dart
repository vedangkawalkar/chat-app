import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  void pushnot()async{
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // final token = await fcm.getToken();
    // print(token);
    fcm.subscribeToTopic('chat');
  }
  
  @override
  void initState() {
    super.initState();
    
    pushnot();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutterchat'),
        actions: [
          IconButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.exit_to_app),color: Theme.of(context).colorScheme.primary,)
        ]
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessages(
            
            ),
          ),
          NewMessage(

          ),
        ],
      )
      // const Center(
      //   child: Text('Logged in!'),
      // )
    );
  }
}