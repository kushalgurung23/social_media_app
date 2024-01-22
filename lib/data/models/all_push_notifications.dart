import 'dart:convert';
import 'package:intl/intl.dart';

AllPushNotifications allPushNotificationsFromJson(String str) =>
    AllPushNotifications.fromJson(json.decode(str));

String allPushNotificationsToJson(AllPushNotifications data) =>
    json.encode(data.toJson());

class AllPushNotifications {
  String? status;
  int? page;
  int? limit;
  int? count;
  List<PushNotification>? notifications;

  AllPushNotifications({
    this.status,
    this.page,
    this.limit,
    this.count,
    this.notifications,
  });

  factory AllPushNotifications.fromJson(Map<String, dynamic> json) =>
      AllPushNotifications(
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
        count: json["count"],
        notifications: json["notifications"] == null
            ? []
            : List<PushNotification>.from(json["notifications"]!
                .map((x) => PushNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "limit": limit,
        "count": count,
        "notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
      };
}

class PushNotification {
  int? id;
  Sender? sender;
  int? isRead;
  String? category;
  DateTime? createdAt;
  DateTime? updatedAt;

  PushNotification({
    this.id,
    this.sender,
    this.isRead,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      PushNotification(
        id: json["id"],
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        isRead: json["is_read"],
        category: json["category"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender?.toJson(),
        "is_read": isRead,
        "category": category,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Sender {
  int? id;
  String? username;
  String? userType;
  String? profilePicture;

  Sender({
    this.id,
    this.username,
    this.userType,
    this.profilePicture,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        username: json["username"],
        userType: json["user_type"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "user_type": userType,
        "profile_picture": profilePicture,
      };
}
