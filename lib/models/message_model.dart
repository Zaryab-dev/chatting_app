import '../Common/enums/message_enum.dart';

class Message {
  final String text, senderId, receiverId, messageId;
  final bool isSeen;
  final DateTime timeSent;
  final MessageEnum type;

  Message(
      {required this.text,
      required this.senderId,
      required this.messageId,
      required this.receiverId,
      required this.isSeen,
      required this.type,
      required this.timeSent});

  Map<String, dynamic> toMap () {
    return {
      "senderId": senderId,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    ); // Message
  }
}

