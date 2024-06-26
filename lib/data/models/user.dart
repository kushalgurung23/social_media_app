import 'dart:convert';

import 'package:intl/intl.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? status;
  UserObject? user;

  User({
    this.status,
    this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        user: json["user"] == null ? null : UserObject.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user?.toJson(),
      };
}

class UserObject {
  int? id;
  String? email;
  String? password;
  String? username;
  int? isActive;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isVerified;
  DateTime? verifiedOn;
  List<DeviceToken>? deviceToken;
  String? profilePicture;
  int? createdPostsCount;
  int? followerCount;
  int? followingCount;

  UserObject(
      {this.id,
      this.email,
      this.password,
      this.username,
      this.isActive,
      this.userType,
      this.createdAt,
      this.updatedAt,
      this.isVerified,
      this.verifiedOn,
      this.deviceToken,
      this.profilePicture,
      this.createdPostsCount,
      this.followerCount,
      this.followingCount});

  factory UserObject.fromJson(Map<String, dynamic> json) => UserObject(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        isActive: json["is_active"],
        userType: json["user_type"],
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
        isVerified: json["is_verified"],
        verifiedOn: json["verified_on"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["verified_on"], true)
                .toLocal(),
        deviceToken: json["device_token"] == null
            ? []
            : List<DeviceToken>.from(
                json["device_token"]!.map((x) => DeviceToken.fromJson(x))),
        profilePicture: json["profile_picture"],
        createdPostsCount: json["created_posts_count"],
        followerCount: json["follower_count"],
        followingCount: json["following_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "username": username,
        "is_active": isActive,
        "user_type": userType,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_verified": isVerified,
        "verified_on": verifiedOn?.toIso8601String(),
        "device_token": deviceToken == null
            ? []
            : List<dynamic>.from(deviceToken!.map((x) => x.toJson())),
        "profile_picture": profilePicture,
        "created_posts_count": createdPostsCount,
        "follower_count": followerCount,
        "following_count": followingCount
      };
}

class DeviceToken {
  int? id;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deviceToken;

  DeviceToken({
    this.id,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deviceToken,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) => DeviceToken(
        id: json["id"],
        isActive: json["is_active"],
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
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "device_token": deviceToken,
      };
}
