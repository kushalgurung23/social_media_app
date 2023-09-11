import 'dart:convert';

import 'package:c_talent/data/models/all_news_posts.dart';

SingleNewsComments? singleNewsCommentsFromJson(String str) =>
    SingleNewsComments.fromJson(json.decode(str));

class SingleNewsComments {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<NewsComment>? comments;

  SingleNewsComments({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.comments,
  });

  factory SingleNewsComments.fromJson(Map<String, dynamic> json) =>
      SingleNewsComments(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        comments: json["comments"] == null
            ? []
            : List<NewsComment>.from(
                json["comments"]!.map((x) => NewsComment.fromJson(x))),
      );
}
