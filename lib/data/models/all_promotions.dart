// To parse this JSON data, do
//
//     final allPromotions = allPromotionsFromJson(jsonString);

import 'dart:convert';

AllPromotions allPromotionsFromJson(String str) =>
    AllPromotions.fromJson(json.decode(str));

String allPromotionsToJson(AllPromotions data) => json.encode(data.toJson());

class AllPromotions {
  String? status;
  int? page;
  int? limit;
  int? count;
  List<Promotion>? promotions;

  AllPromotions({
    this.status,
    this.page,
    this.limit,
    this.count,
    this.promotions,
  });

  factory AllPromotions.fromJson(Map<String, dynamic> json) => AllPromotions(
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
        count: json["count"],
        promotions: json["promotions"] == null
            ? []
            : List<Promotion>.from(
                json["promotions"]!.map((x) => Promotion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "limit": limit,
        "count": count,
        "promotions": promotions == null
            ? []
            : List<dynamic>.from(promotions!.map((x) => x.toJson())),
      };
}

class Promotion {
  int? id;
  String? title;
  dynamic image;
  String? subTitle;
  String? promotionalLink;
  DateTime? createdAt;
  DateTime? updatedAt;

  Promotion({
    this.id,
    this.title,
    this.image,
    this.subTitle,
    this.promotionalLink,
    this.createdAt,
    this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        subTitle: json["sub_title"],
        promotionalLink: json["promotional_link"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "sub_title": subTitle,
        "promotional_link": promotionalLink,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
