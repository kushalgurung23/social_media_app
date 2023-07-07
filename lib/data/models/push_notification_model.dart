import 'dart:convert';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/data/models/conversation_model.dart';

PushNotification notificationFromJson(String str) =>
    PushNotification.fromJson(json.decode(str));

String notificationToJson(PushNotification data) => json.encode(data.toJson());

class PushNotification {
  PushNotification({
    this.data,
    this.meta,
  });

  List<NotificationData?>? data;
  Meta? meta;

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      PushNotification(
        data: List<NotificationData>.from(
                json["data"].map((x) => NotificationData.fromJson(x)))
            .where((e) =>
                e.attributes!.sender != null &&
                e.attributes!.sender!.data != null)
            .toList(),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
        "meta": meta!.toJson(),
      };
}

class NotificationData {
  NotificationData({
    this.id,
    this.attributes,
  });

  int? id;
  NotificationAttributes? attributes;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : NotificationAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class NotificationAttributes {
  NotificationAttributes(
      {this.createdAt,
      this.type,
      this.updatedAt,
      this.publishedAt,
      this.sender,
      this.isRead});

  DateTime? createdAt;
  String? type;
  DateTime? updatedAt;
  DateTime? publishedAt;
  bool? isRead;
  NotifyConversationUser? sender;

  factory NotificationAttributes.fromJson(Map<String, dynamic> json) =>
      NotificationAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        type: json["type"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        isRead: json["is_read"],
        sender: json["sender"] == null
            ? null
            : NotifyConversationUser.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "type": type,
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "sender": sender?.toJson(),
        "is_read": isRead == null ? null : isRead!,
      };
}

SingleNotification singleNotificationFromJson(String str) =>
    SingleNotification.fromJson(json.decode(str));

String singleNotificationToJson(SingleNotification data) =>
    json.encode(data.toJson());

class SingleNotification {
  SingleNotification({
    this.data,
    this.meta,
  });

  NotificationData? data;
  Meta? meta;

  factory SingleNotification.fromJson(Map<String, dynamic> json) =>
      SingleNotification(
        data: json["data"] == null
            ? null
            : NotificationData.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "meta": meta!.toJson(),
      };
}
