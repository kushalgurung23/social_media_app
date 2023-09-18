import 'dart:convert';
import 'package:c_talent/data/models/all_conversations.dart';

AllChatMessages allChatMessagesFromJson(String str) =>
    AllChatMessages.fromJson(json.decode(str));

class AllChatMessages {
  String? status;
  List<ChatMessage>? chatMessages;

  AllChatMessages({
    this.status,
    this.chatMessages,
  });

  factory AllChatMessages.fromJson(Map<String, dynamic> json) =>
      AllChatMessages(
        status: json["status"],
        chatMessages: json["chat_messages"] == null
            ? []
            : List<ChatMessage>.from(
                json["chat_messages"]!.map((x) => ChatMessage.fromJson(x))),
      );
}
