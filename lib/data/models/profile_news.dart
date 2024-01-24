import 'dart:convert';
import 'package:intl/intl.dart';

AllProfileNews allProfileNewsFromJson(String str) =>
    AllProfileNews.fromJson(json.decode(str));

class AllProfileNews {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<ProfileNews>? news;

  AllProfileNews({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.news,
  });

  factory AllProfileNews.fromJson(Map<String, dynamic> json) => AllProfileNews(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        news: json["news"] == null
            ? []
            : List<ProfileNews>.from(
                json["news"]!.map((x) => ProfileNews.fromJson(x))),
      );
}

class ProfileNews {
  int? id;
  String? title;
  int? likeCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? savedAt;
  int? commentCount;
  CreatedBy? createdBy;

  ProfileNews(
      {this.id,
      this.title,
      this.likeCount,
      this.createdAt,
      this.updatedAt,
      this.savedAt,
      this.commentCount,
      this.createdBy});

  factory ProfileNews.fromJson(Map<String, dynamic> json) => ProfileNews(
        id: json["id"],
        title: json["title"],
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
        savedAt: json["saved_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["saved_at"], true)
                .toLocal(),
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        createdBy: json["created_by"] == null
            ? null
            : CreatedBy.fromJson(json["created_by"]),
      );
}

class CreatedBy {
  int? id;
  String? username;

  CreatedBy({
    this.id,
    this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        username: json["username"],
      );
}
