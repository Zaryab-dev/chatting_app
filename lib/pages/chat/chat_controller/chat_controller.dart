import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Common/enums/message_enum.dart';
import '../../../models/chat_contact_model.dart';
import '../../../models/message_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../chat_repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    receiverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!));
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    receiverUserId,
    MessageEnum messageEnum,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageEnum: messageEnum,
              ref: ref),
        );
  }
}
