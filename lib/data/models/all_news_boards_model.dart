// To parse this JSON data, do
//
//     final allNewsBoards = allNewsBoardsFromJson(jsonString);

import 'dart:convert';

AllNewsBoards allNewsBoardsFromJson(String str) =>
    AllNewsBoards.fromJson(json.decode(str));

String allNewsBoardsToJson(AllNewsBoards data) => json.encode(data.toJson());

class AllNewsBoards {
  AllNewsBoards({
    this.data,
    this.meta,
  });

  List<NewsBoard>? data;
  Meta? meta;

  factory AllNewsBoards.fromJson(Map<String, dynamic> json) => AllNewsBoards(
        data: List<NewsBoard>.from(
            json["data"].map((x) => NewsBoard.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta!.toJson(),
      };
}

class NewsBoard {
  NewsBoard({
    this.id,
    this.attributes,
  });

  int? id;
  NewsBoardAttributes? attributes;

  factory NewsBoard.fromJson(Map<String, dynamic> json) => NewsBoard(
        id: json["id"],
        attributes: NewsBoardAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class NewsBoardAttributes {
  NewsBoardAttributes({
    this.title,
    this.firstParagraph,
    this.secondParagraph,
    this.thirdParagraph,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.leadingImage,
    this.firstImage,
    this.secondImage,
    this.thirdImage,
  });

  String? title;
  String? firstParagraph;
  String? secondParagraph;
  String? thirdParagraph;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  GeneralImageType? leadingImage;
  GeneralImageType? firstImage;
  GeneralImageType? secondImage;
  GeneralImageType? thirdImage;

  factory NewsBoardAttributes.fromJson(Map<String, dynamic> json) =>
      NewsBoardAttributes(
        title: json["title"],
        firstParagraph: json["first_paragraph"],
        secondParagraph: json["second_paragraph"],
        thirdParagraph: json["third_paragraph"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        leadingImage: json["leading_image"] == null
            ? null
            : GeneralImageType.fromJson(json["leading_image"]),
        firstImage: json["first_image"] == null
            ? null
            : GeneralImageType.fromJson(json["first_image"]),
        secondImage: json["second_image"] == null
            ? null
            : GeneralImageType.fromJson(json["second_image"]),
        thirdImage: json["third_image"] == null
            ? null
            : GeneralImageType.fromJson(json["third_image"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "first_paragraph": firstParagraph,
        "second_paragraph": secondParagraph,
        "third_paragraph": thirdParagraph,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "leading_image": leadingImage.toString(),
        "first_image": firstImage.toString(),
        "second_image": secondImage.toString(),
        "third_image": thirdImage.toString(),
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
  NewsBoardImageDataAttributes? attributes;

  factory NewsBoardImageData.fromJson(Map<String, dynamic> json) =>
      NewsBoardImageData(
        id: json["id"],
        attributes: NewsBoardImageDataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class NewsBoardImageDataAttributes {
  NewsBoardImageDataAttributes({
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

  factory NewsBoardImageDataAttributes.fromJson(Map<String, dynamic> json) =>
      NewsBoardImageDataAttributes(
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

class Meta {
  Meta({
    this.pagination,
  });

  Pagination? pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination == null ? null : pagination!.toJson(),
      };
}

class Pagination {
  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}
