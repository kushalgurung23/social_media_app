import 'dart:convert';
import 'package:c_talent/data/models/all_news_post_model.dart';

NewsPostLikesss newsPostLikesssFromJson(String str) =>
    NewsPostLikesss.fromJson(json.decode(str));

String newsPostLikesToJson(NewsPostLikesss data) => json.encode(data.toJson());

class NewsPostLikesss {
  NewsPostLikesss({
    this.data,
    this.meta,
  });

  NewsPostLikesData? data;
  Meta? meta;

  factory NewsPostLikesss.fromJson(Map<String, dynamic> json) =>
      NewsPostLikesss(
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
      this.likeCount});

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? content;
  String? title;
  String? likeCount;

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
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "content": content,
        "title": title,
        "like_count": likeCount,
      };
}

class Meta {
  Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta();

  Map<String, dynamic> toJson() => {};
}
