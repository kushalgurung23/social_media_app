import 'dart:convert';

import 'package:c_talent/data/new_models/all_news_posts.dart';

NewsPostLikes newsPostLikesFromJson(String str) =>
    NewsPostLikes.fromJson(json.decode(str));

class NewsPostLikes {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Like>? likes;

  NewsPostLikes({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.likes,
  });

  factory NewsPostLikes.fromJson(Map<String, dynamic> json) => NewsPostLikes(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        likes: json["likes"] == null
            ? []
            : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
      );
}
