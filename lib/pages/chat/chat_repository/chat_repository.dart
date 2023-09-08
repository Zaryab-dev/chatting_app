import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../Common/enums/message_enum.dart';
import '../../../Common/firebase_storage_repository.dart';
import '../../../Common/utils.dart';
import '../../../models/chat_contact_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('Users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromJson(userData.data()!);

        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Chats')
        .doc(receiverUserId)
        .collection('Messages')
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      final List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToChatSubCollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    String receiverUserId,
    DateTime timeSent,
  ) async {
    var receiverChatContact = ChatContact(
        contactId: senderUserData.uid,
        timeSent: timeSent,
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        lastMessage: text);
    await firestore
        .collection('Users')
        .doc(receiverUserId)
        .collection('Chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        lastMessage: text);
    await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection(
      {required String messageId,
      required String receiverUserId,
      required String username,
      required String receiverUsername,
      required String text,
      required DateTime timeSent,
      required MessageEnum messageType}) async {
    final message = Message(
        text: text,
        senderId: auth.currentUser!.uid,
        messageId: messageId,
        receiverId: receiverUserId,
        isSeen: false,
        type: messageType,
        timeSent: timeSent);

    await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Chats')
        .doc(receiverUserId)
        .collection('Messages')
        .doc(messageId)
        .set(message.toMap());
    await firestore
        .collection('Users')
        .doc(receiverUserId)
        .collection('Chats')
        .doc(auth.currentUser!.uid)
        .collection('Messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection("Users").doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      _saveDataToChatSubCollection(
        senderUser,
        receiverUserData,
        text,
        receiverUserId,
        timeSent,
      );

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(
          messageId: messageId,
          receiverUserId: receiverUserId,
          username: senderUser.name,
          receiverUsername: receiverUserData.name,
          text: text,
          timeSent: timeSent,
          messageType: MessageEnum.TEXT);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String imageUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .saveFileToFirestore(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
              file);
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection("Users").doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);

      String contactMSG;
      switch (messageEnum) {
        case MessageEnum.IMAGE:
          contactMSG = '📷 Photo';
          break;
        case MessageEnum.VIDEO:
          contactMSG = '📸 Video';
          break;
        case MessageEnum.AUDIO:
          contactMSG = ' Audio';
          break;
        case MessageEnum.GIF:
          contactMSG = 'GIF';
          break;
        default:
          contactMSG = 'GIF';
      }

      _saveDataToChatSubCollection(senderUserData, receiverUserData, contactMSG,
          receiverUserId, timeSent);
      _saveMessageToMessageSubCollection(
          messageId: messageId,
          receiverUserId: receiverUserId,
          username: senderUserData.name,
          receiverUsername: receiverUserData.name,
          text: imageUrl,
          timeSent: timeSent,
          messageType: messageEnum);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
