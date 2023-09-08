import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Common/enums/message_enum.dart';
import '../Common/pick_image.dart';
import '../colors.dart';
import '../pages/chat/chat_controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String uid;

  const BottomChatField({super.key, required this.uid});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShownButton = false;
  final _messageController = TextEditingController();

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(context, file, widget.uid, messageEnum);
  }

  void selectImage() async{
    File? file = await pickImageFromGallery(context);
    if(file!= null) {
      sendFileMessage(file, MessageEnum.IMAGE);
    }
  }
  void selectVideo() async{
    File? video = await pickVideoFromGallery(context);
    if(video!= null) {
      sendFileMessage(video, MessageEnum.VIDEO);
    }
  }

  void sendTextMessage() {
    if (isShownButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(context, _messageController.text.trim(), widget.uid);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  isShownButton = true;
                  setState(() {});
                } else {
                  isShownButton = false;
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: SizedBox(
                    width: size.width * 0.01,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ))),
                suffixIcon: Container(
                  // color: Colors.red,
                  width: size.width * 0.26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: selectVideo,
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                hintText: 'Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: messageColor,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShownButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
