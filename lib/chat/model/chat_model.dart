class ChatMessage {
  String messageContent;
  String? userType;
  String messageType;
  bool? isFileImage;
  String? senderImage;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      this.userType,
      this.senderImage,
      this.isFileImage = false});
}
