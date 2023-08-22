// To parse this JSON data, do
//
//     final conversation = conversationFromJson(jsonString);

import 'dart:convert';

import 'package:c_talent/data/models/all_news_post_model.dart';

Conversation conversationFromJson(String str) =>
    Conversation.fromJson(json.decode(str));

String conversationToJson(Conversation data) => json.encode(data.toJson());

class Conversation {
  Conversation({
    this.data,
  });

  List<ConversationData>? data;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        data: List<ConversationData>.from(
            json["data"].map((x) => ConversationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

SingleConversation singleConversationFromJson(String str) =>
    SingleConversation.fromJson(json.decode(str));

String singleConversationToJson(SingleConversation data) =>
    json.encode(data.toJson());

class SingleConversation {
  SingleConversation({
    this.data,
  });

  ConversationData? data;

  factory SingleConversation.fromJson(Map<String, dynamic> json) =>
      SingleConversation(
        data: json["data"] == null
            ? null
            : ConversationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class ConversationData {
  ConversationData({
    this.id,
    this.attributes,
  });

  int? id;
  ConversationAttributes? attributes;

  factory ConversationData.fromJson(Map<String, dynamic> json) =>
      ConversationData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : ConversationAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class ConversationAttributes {
  ConversationAttributes(
      {this.updatedAt,
      this.createdAt,
      this.publishedAt,
      this.firstUser,
      this.secondUser,
      this.chatMessages,
      this.firstUserLastRead,
      this.secondUserLastRead,
      this.lastTextAt});

  DateTime? updatedAt;
  DateTime? createdAt;
  DateTime? publishedAt;
  DateTime? lastTextAt;
  NotifyConversationUser? firstUser;
  NotifyConversationUser? secondUser;
  ConversationMessages? chatMessages;
  DateTime? firstUserLastRead;
  DateTime? secondUserLastRead;

  factory ConversationAttributes.fromJson(Map<String, dynamic> json) =>
      ConversationAttributes(
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        firstUser: json["first_user"] == null
            ? null
            : NotifyConversationUser.fromJson(json["first_user"]),
        secondUser: json["second_user"] == null
            ? null
            : NotifyConversationUser.fromJson(json["second_user"]),
        chatMessages: json["chat_messages"] == null
            ? null
            : ConversationMessages.fromJson(json["chat_messages"]),
        firstUserLastRead: json["first_user_last_read"] == null
            ? null
            : DateTime.parse(json["first_user_last_read"]),
        secondUserLastRead: json["second_user_last_read"] == null
            ? null
            : DateTime.parse(json["second_user_last_read"]),
        lastTextAt: json["last_text_at"] == null
            ? null
            : DateTime.parse(json["last_text_at"]),
      );

  Map<String, dynamic> toJson() => {
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "first_user": firstUser?.toJson(),
        "second_user": secondUser?.toJson(),
        "chat_messages": chatMessages?.toJson(),
        "first_user_last_read": updatedAt?.toIso8601String(),
        "second_user_last_read": createdAt?.toIso8601String(),
        "last_text_at": lastTextAt?.toIso8601String()
      };
}

class ConversationMessages {
  ConversationMessages({
    this.data,
  });

  List<ConversationMessagesData>? data;

  factory ConversationMessages.fromJson(Map<String, dynamic> json) =>
      ConversationMessages(
        data: List<ConversationMessagesData>.from(
            json["data"].map((x) => ConversationMessagesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ConversationMessagesData {
  ConversationMessagesData({
    this.id,
    this.attributes,
  });

  int? id;
  ConversationChatAttributes? attributes;

  factory ConversationMessagesData.fromJson(Map<String, dynamic> json) =>
      ConversationMessagesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : ConversationChatAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class ConversationChatAttributes {
  ConversationChatAttributes(
      {this.text,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.receiver,
      this.sender});

  String? text;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  NotifyConversationUser? receiver;
  NotifyConversationUser? sender;

  factory ConversationChatAttributes.fromJson(Map<String, dynamic> json) =>
      ConversationChatAttributes(
        text: json["text"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        receiver: json["receiver"] == null
            ? null
            : NotifyConversationUser.fromJson(json["receiver"]),
        sender: json["sender"] == null
            ? null
            : NotifyConversationUser.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "receiver": receiver?.toJson(),
        "sender": sender?.toJson(),
      };
}

class NotifyConversationUser {
  NotifyConversationUser({
    required this.data,
  });

  UserData? data;

  factory NotifyConversationUser.fromJson(Map<String, dynamic> json) =>
      NotifyConversationUser(
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class UserData {
  UserData({
    required this.id,
    required this.attributes,
  });

  int? id;
  UserAttributes? attributes;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : UserAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class UserAttributes {
  UserAttributes(
      {required this.username,
      required this.email,
      required this.provider,
      required this.confirmed,
      required this.blocked,
      required this.createdAt,
      required this.updatedAt,
      required this.userType,
      required this.grade,
      required this.teachingType,
      required this.collegeType,
      required this.teachingArea,
      required this.region,
      required this.category,
      required this.profileImage,
      this.centerName,
      this.deviceToken});

  String? username;
  String? email;
  String? centerName;
  String? provider;
  bool? confirmed;
  bool? blocked;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? grade;
  String? teachingType;
  String? collegeType;
  String? teachingArea;
  String? region;
  String? category;
  String? userType;
  String? profileImage;
  String? deviceToken;

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
        username: json["username"].toString(),
        centerName: json["center_name"].toString(),
        email: json["email"].toString(),
        provider: json["provider"].toString(),
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        userType: json["user_type"].toString(),
        grade: json["grade"].toString(),
        teachingType: json["teaching_type"].toString(),
        collegeType: json["college_type"].toString(),
        teachingArea: json["teaching_area"].toString(),
        region: json["region"].toString(),
        category: json["category"].toString(),
        profileImage: json["profile_image"],
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "center_name": centerName,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "user_type": userType,
        "grade": grade,
        "teaching_type": teachingType,
        "college_type": collegeType,
        "teaching_area": teachingArea,
        "region": region,
        "category": category,
        "profile_image": profileImage,
        "device_token": deviceToken
      };
}
