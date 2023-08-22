// To parse this JSON data, do
//
//     final promotion = promotionFromJson(jsonString);

import 'dart:convert';

import 'package:c_talent/data/models/all_news_post_model.dart';

Promotion promotionFromJson(String str) => Promotion.fromJson(json.decode(str));

String promotionToJson(Promotion data) => json.encode(data.toJson());

class Promotion {
  Promotion({
    this.data,
  });

  List<PromotionData>? data;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        data: List<PromotionData>.from(
            json["data"].map((x) => PromotionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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

class GeneralImageType {
  GeneralImageType({
    this.data,
  });

  NewsBoardImageData? data;

  factory GeneralImageType.fromJson(Map<String, dynamic> json) =>
      GeneralImageType(
        data: json["data"] == null
            ? null
            : NewsBoardImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class NewsBoardImageData {
  NewsBoardImageData({
    this.id,
    this.attributes,
  });

  int? id;
  GeneralImageAttributes? attributes;

  factory NewsBoardImageData.fromJson(Map<String, dynamic> json) =>
      NewsBoardImageData(
        id: json["id"],
        attributes: GeneralImageAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class GeneralImageAttributes {
  GeneralImageAttributes({
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  String? name;
  String? alternativeText;
  String? caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;
  String? previewUrl;
  String? provider;
  String? providerMetadata;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GeneralImageAttributes.fromJson(Map<String, dynamic> json) =>
      GeneralImageAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        size: json["size"].toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: json["provider"],
        providerMetadata: json["provider_metadata"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats == null ? null : formats!.toJson(),
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
      };
}

class Formats {
  Formats({
    this.thumbnail,
  });

  Thumbnail? thumbnail;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail == null ? null : thumbnail!.toJson(),
      };
}

class Thumbnail {
  Thumbnail({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.path,
    this.width,
    this.height,
    this.size,
    this.url,
  });

  String? name;
  String? hash;
  String? ext;
  String? mime;
  String? path;
  int? width;
  int? height;
  double? size;
  String? url;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        name: json["name"],
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        path: json["path"],
        width: json["width"],
        height: json["height"],
        size: json["size"].toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "path": path,
        "width": width,
        "height": height,
        "size": size,
        "url": url,
      };
}
