// To parse this JSON data, do
//
//     final searchUser = searchUserFromJson(jsonString);

import 'dart:convert';

import 'package:spa_app/data/models/user_model.dart';

List<SearchUser> searchUserFromJson(String str) =>
    List<SearchUser>.from(json.decode(str).map((x) => SearchUser.fromJson(x)));

class SearchUser {
  SearchUser(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.confirmed,
      this.blocked,
      this.createdAt,
      this.updatedAt,
      this.userType,
      this.grade,
      this.teachingType,
      this.collegeType,
      this.teachingArea,
      this.region,
      this.category,
      this.centerName,
      this.profileImage,
      this.deviceToken});

  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userType;
  String? grade;
  String? teachingType;
  String? collegeType;
  String? teachingArea;
  String? region;
  String? category;
  String? centerName;
  AllImage? profileImage;
  String? deviceToken;

  factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userType: json["user_type"],
        grade: json["grade"],
        teachingType: json["teaching_type"],
        collegeType: json["college_type"],
        teachingArea: json["teaching_area"],
        region: json["region"],
        category: json["category"],
        centerName: json["center_name"],
        profileImage: json["profile_image"] == null
            ? null
            : AllImage.fromJson(json["profile_image"]),
        deviceToken: json["device_token"],
      );
}
