// To parse this JSON data, do
//
//     final allFollowers = allFollowersFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

AllFollowers allFollowersFromJson(String str) =>
    AllFollowers.fromJson(json.decode(str));

class AllFollowers {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Follower>? followers;

  AllFollowers({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.followers,
  });

  factory AllFollowers.fromJson(Map<String, dynamic> json) => AllFollowers(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        followers: json["followers"] == null
            ? []
            : List<Follower>.from(
                json["followers"]!.map((x) => Follower.fromJson(x))),
      );
}

class Follower {
  int? id;
  String? email;
  String? username;
  String? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? isFollowed;
  FollowDetails? followDetails;
  String? profilePicture;

  Follower({
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

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
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
