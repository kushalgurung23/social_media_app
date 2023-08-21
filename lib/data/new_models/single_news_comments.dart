import 'dart:convert';

import 'package:c_talent/data/new_models/all_news_posts.dart';

SingleNewsComments singleNewsCommentsFromJson(String str) =>
    SingleNewsComments.fromJson(json.decode(str));

String singleNewsCommentsToJson(SingleNewsComments data) =>
    json.encode(data.toJson());

class SingleNewsComments {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Comment>? comments;

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
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "page": page,
        "limit": limit,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
      };
}
