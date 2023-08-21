import 'dart:convert';
import 'package:c_talent/data/models/all_news_post_model.dart';

NewsPostLikes newsPostLikesFromJson(String str) =>
    NewsPostLikes.fromJson(json.decode(str));

String newsPostLikesToJson(NewsPostLikes data) => json.encode(data.toJson());

class NewsPostLikes {
  NewsPostLikes({
    this.data,
    this.meta,
  });

  NewsPostLikesData? data;
  Meta? meta;

  factory NewsPostLikes.fromJson(Map<String, dynamic> json) => NewsPostLikes(
        data: NewsPostLikesData.fromJson(json["data"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
        "meta": meta == null ? null : meta!.toJson(),
      };
}

class NewsPostLikesData {
  NewsPostLikesData({
    this.id,
    this.attributes,
  });

  int? id;
  NewsPostLikesAttributes? attributes;

  factory NewsPostLikesData.fromJson(Map<String, dynamic> json) =>
      NewsPostLikesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : NewsPostLikesAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class NewsPostLikesAttributes {
  NewsPostLikesAttributes(
      {this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.content,
      this.title,
      this.likeCount,
      this.newsPostLikes});

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? content;
  String? title;
  String? likeCount;
  AllNewsPostLikes? newsPostLikes;

  factory NewsPostLikesAttributes.fromJson(Map<String, dynamic> json) =>
      NewsPostLikesAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
        title: json["title"],
        likeCount: json["like_count"],
        newsPostLikes: json["news_post_likes"] == null
            ? null
            : AllNewsPostLikes.fromJson(json["news_post_likes"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "content": content,
        "title": title,
        "like_count": likeCount,
        "news_post_likes":
            newsPostLikes == null ? null : newsPostLikes!.toJson(),
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
