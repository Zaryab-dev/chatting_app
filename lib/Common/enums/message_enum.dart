enum MessageEnum {
  TEXT('text'),
  VIDEO('video'),
  AUDIO('audio'),
  GIF('gif'),
  IMAGE('image');

  const MessageEnum(this.type);

  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.TEXT;
      case 'image':
        return MessageEnum.IMAGE;
      case 'video':
        return MessageEnum.VIDEO;
      case 'audio':
        return MessageEnum.AUDIO;
      case 'gif':
        return MessageEnum.GIF;
      default:
        return MessageEnum.TEXT;
    }
  }
}
