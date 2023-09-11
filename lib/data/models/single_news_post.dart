import 'dart:convert';

import 'package:c_talent/data/models/all_news_posts.dart';

SingleNewsPost singleNewsPostFromJson(String str) =>
    SingleNewsPost.fromJson(json.decode(str));

String singleNewsPostToJson(SingleNewsPost data) => json.encode(data.toJson());

class SingleNewsPost {
  String? status;
  NewsPost? newsPost;

  SingleNewsPost({
    this.status,
    this.newsPost,
  });

  factory SingleNewsPost.fromJson(Map<String, dynamic> json) => SingleNewsPost(
        status: json["status"],
        newsPost: json["news_post"] == null
            ? null
            : NewsPost.fromJson(json["news_post"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
