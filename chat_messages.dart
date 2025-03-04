import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget{
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatesusr = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createddat',descending: true,).snapshots(),
    
      builder:(ctx,chatsnapshots){
        if (chatsnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    
        if (!chatsnapshots.hasData || chatsnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }
    
        if (chatsnapshots.hasError) {
          return const Center(
            child: Text('Something Went Wrong...'),
          );
        }

        final loadedmsg = chatsnapshots.data!.docs;
    
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedmsg.length,
          itemBuilder: (ctx,index){
            final chatmsg = loadedmsg[index].data();
            final nextmsg = index + 1 < loadedmsg.length ? loadedmsg[index].data() : null;
            
            final currentmsguserid = chatmsg['userid'];
            final nextmsguserid = nextmsg != null ? nextmsg['userid'] : null;
            final nextuserissame = nextmsguserid == currentmsguserid;

            if (nextuserissame) {
              return MessageBubble.next(
                message: chatmsg['text'],
                isMe:authenticatesusr.uid == currentmsguserid ,
              );
            }else{
              return MessageBubble.first(
                userImage:chatmsg['userimg'] ,
                username: chatmsg['username'],
                message:  chatmsg['text'],
                isMe:authenticatesusr.uid == currentmsguserid ,
              );
            }
          }
          // =>Text(loadedmsg[index].data()['text']
        );
      },
    );
  }
}