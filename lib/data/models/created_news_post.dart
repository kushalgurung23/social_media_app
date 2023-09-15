import 'dart:convert';

import 'package:c_talent/data/models/all_news_posts.dart';

CreatedNewsPost createdNewsPostFromJson(String str) =>
    CreatedNewsPost.fromJson(json.decode(str));

class CreatedNewsPost {
  String? status;
  Post? post;

  CreatedNewsPost({
    this.status,
    this.post,
  });

  factory CreatedNewsPost.fromJson(Map<String, dynamic> json) =>
      CreatedNewsPost(
        status: json["status"],
        post: Post.fromJson(json["post"]),
      );
}
