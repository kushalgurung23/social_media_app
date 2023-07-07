// To parse this JSON data, do
//
//     final promotion = promotionFromJson(jsonString);

import 'dart:convert';

import 'package:spa_app/data/models/all_news_boards_model.dart';

Promotion promotionFromJson(String str) => Promotion.fromJson(json.decode(str));

String promotionToJson(Promotion data) => json.encode(data.toJson());

class Promotion {
  Promotion({
    this.data,
    this.meta,
  });

  List<PromotionData>? data;
  Meta? meta;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        data: List<PromotionData>.from(
            json["data"].map((x) => PromotionData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta!.toJson(),
      };
}

class PromotionData {
  PromotionData({
    this.id,
    this.attributes,
  });

  int? id;
  PromotionAttributes? attributes;

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PromotionAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PromotionAttributes {
  PromotionAttributes({
    this.title,
    this.subTitle,
    this.promotionLink,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.image,
  });

  String? title;
  String? subTitle;
  String? promotionLink;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  GeneralImageType? image;

  factory PromotionAttributes.fromJson(Map<String, dynamic> json) =>
      PromotionAttributes(
        title: json["title"],
        subTitle: json["sub_title"],
        promotionLink: json["promotion_link"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        image: json["image"] == null
            ? null
            : GeneralImageType.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "promotion_link": promotionLink,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "image": image?.toJson(),
      };
}
