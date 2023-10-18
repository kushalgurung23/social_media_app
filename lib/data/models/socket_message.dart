import 'package:intl/intl.dart';

class SocketMessage {
  final String? chatId, sender, receiver, text, conversationId;
  final DateTime? sentAt;

  SocketMessage(
      {required this.chatId,
      required this.sender,
      required this.receiver,
      required this.text,
      required this.conversationId,
      required this.sentAt});

  factory SocketMessage.fromJson(Map<String, dynamic> message) {
    return SocketMessage(
        chatId: message['chatId'],
        sender: message['sender'],
        receiver: message['receiver'],
        text: message['text'],
        conversationId: message['conversationId'],
        sentAt: message['sentAt'] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(message["sentAt"], true)
                .toLocal());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SocketMessage &&
        chatId == other.chatId &&
        sender == other.sender &&
        receiver == other.receiver &&
        text == other.text &&
        conversationId == other.conversationId &&
        sentAt == other.sentAt;
  }

  @override
  int get hashCode =>
      chatId.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      text.hashCode ^
      conversationId.hashCode ^
      sentAt.hashCode;
}
