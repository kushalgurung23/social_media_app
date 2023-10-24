import 'dart:convert';

import 'package:intl/intl.dart';

AllConversations allConversationsFromJson(String str) =>
    AllConversations.fromJson(json.decode(str));

class AllConversations {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Conversation>? conversations;

  AllConversations({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.conversations,
  });

  factory AllConversations.fromJson(Map<String, dynamic> json) =>
      AllConversations(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        conversations: json["conversations"] == null
            ? []
            : List<Conversation>.from(
                json["conversations"]!.map((x) => Conversation.fromJson(x))),
      );
}

class Conversation {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  ChatMessage? chatMessage;

  Conversation({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.chatMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["created_at"], true)
                .toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["updated_at"], true)
                .toLocal(),
        chatMessage: json["chat_message"] == null
            ? null
            : ChatMessage.fromJson(json["chat_message"]),
      );
}

ChatMessage chatMessageFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

class ChatMessage {
  int? id;
  String? text;
  ConversationUser? sender;
  ConversationUser? receiver;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? hasReceiverSeen;

  ChatMessage({
    this.id,
    this.text,
    this.sender,
    this.receiver,
    this.createdAt,
    this.updatedAt,
    this.hasReceiverSeen,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        text: json["text"],
        sender: json["sender"] == null
            ? null
            : ConversationUser.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : ConversationUser.fromJson(json["receiver"]),
        createdAt: json["created_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["created_at"], true)
                .toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["updated_at"], true)
                .toLocal(),
        hasReceiverSeen: json["has_receiver_seen"],
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        id == other.id &&
        text == other.text &&
        sender == other.sender &&
        receiver == other.receiver &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        hasReceiverSeen == other.hasReceiverSeen;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      sender.hashCode ^
      receiver.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      hasReceiverSeen.hashCode;
}

class ConversationUser {
  int? id;
  String? username;
  String? profilePicture;
  List<DeviceToken>? deviceTokens;

  ConversationUser({
    this.id,
    this.username,
    this.profilePicture,
    this.deviceTokens,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> json) =>
      ConversationUser(
        id: json["id"],
        username: json["username"],
        profilePicture: json["profile_picture"],
        deviceTokens: json["device_tokens"] == null
            ? []
            : List<DeviceToken>.from(
                json["device_tokens"]!.map((x) => DeviceToken.fromJson(x))),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConversationUser &&
        id == other.id &&
        username == other.username &&
        profilePicture == other.profilePicture;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ profilePicture.hashCode;
}

class DeviceToken {
  int? id;
  String? deviceToken;

  DeviceToken({
    this.id,
    this.deviceToken,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) => DeviceToken(
        id: json["id"],
        deviceToken: json["device_token"],
      );
}
