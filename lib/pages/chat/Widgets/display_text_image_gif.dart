import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../Common/enums/message_enum.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.TEXT
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(imageUrl: message));
  }
}
