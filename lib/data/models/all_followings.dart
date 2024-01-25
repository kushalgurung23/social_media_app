import 'dart:convert';

import 'package:intl/intl.dart';

AllFollowings allFollowingsFromJson(String str) =>
    AllFollowings.fromJson(json.decode(str));

class AllFollowings {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Following>? followings;

  AllFollowings({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.followings,
  });

  factory AllFollowings.fromJson(Map<String, dynamic> json) => AllFollowings(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        followings: json["followings"] == null
            ? []
            : List<Following>.from(
                json["followings"]!.map((x) => Following.fromJson(x))),
      );
}

class Following {
  int? id;
  String? email;
  String? username;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isFollowed;
  FollowDetails? followDetails;
  String? profilePicture;

  Following({
    this.id,
    this.email,
    this.username,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.isFollowed,
    this.followDetails,
    this.profilePicture,
  });

  factory Following.fromJson(Map<String, dynamic> json) => Following(
        id: json["id"],
        email: json["email"],
        username: json["username"],
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
        isFollowed: json["is_followed"],
        followDetails: json["follow_details"] == null
            ? null
            : FollowDetails.fromJson(json["follow_details"]),
        profilePicture: json["profile_picture"],
      );
}

class FollowDetails {
  DateTime? createdAt;
  DateTime? updatedAt;

  FollowDetails({
    this.createdAt,
    this.updatedAt,
  });

  factory FollowDetails.fromJson(Map<String, dynamic> json) => FollowDetails(
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
}
