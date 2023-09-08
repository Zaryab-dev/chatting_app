import 'package:flutter/material.dart';

import '../Common/enums/message_enum.dart';
import '../colors.dart';
import '../pages/chat/Widgets/display_text_image_gif.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date, required this.type,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: type == MessageEnum.TEXT?  const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ) : const EdgeInsets.all(4),
                child: DisplayTextImageGif(
                  message: message,
                  type: type,
                ),
              ),
              Positioned(
                bottom: type == MessageEnum.IMAGE ? 0 : 4,
                right: type == MessageEnum.IMAGE ? 1 : 10,
                child: type == MessageEnum.IMAGE? Container(
                  padding: const EdgeInsets.only(left: 12),
                  height: 30,
                  width: 60,
                  decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(8)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black26,
                            Colors.black.withOpacity(0.2)
                          ])
                  ),
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ) : Row(
                  children: [
                    Text(
                      date,
                      style: type == MessageEnum.IMAGE? const TextStyle(fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ) : const TextStyle(fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
