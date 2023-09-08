import 'package:chatting_app/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';
import '../pages/chat/chat_controller/chat_controller.dart';
import 'my_message_card.dart';


class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({Key? key,required this.receiverUserId}) : super(key: key, );

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }if(snapshot.hasError) {
            return const Center(child: Text('ERROR'),);
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);
              if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent, type: messageData.type,
                );
              }
              return SenderMessageCard(
                type: messageData.type,
                message: messageData.text,
                date: timeSent,
              );
            },
          );
        }
    );
  }
}
