class SocketMessage {
  final String? senderId, receiverUserId, message;
  final DateTime? sentAt;

  SocketMessage(
      {required this.senderId,
      required this.receiverUserId,
      required this.message,
      required this.sentAt});

  factory SocketMessage.fromJson(Map<String, dynamic> message) {
    return SocketMessage(
        senderId: message['senderId'],
        receiverUserId: message['receiverUserId'],
        message: message['message'],
        sentAt: message['sentAt'] == null
            ? null
            : DateTime.parse(message['sentAt']));
  }
}
