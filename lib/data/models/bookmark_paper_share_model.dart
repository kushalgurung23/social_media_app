import 'dart:convert';
import 'package:spa_app/data/models/paper_share_model.dart';

BookmarkPaperShare bookmarkPaperShareFromJson(String str) =>
    BookmarkPaperShare.fromJson(json.decode(str));

String bookmarkPaperShareToJson(BookmarkPaperShare data) =>
    json.encode(data.toJson());

class BookmarkPaperShare {
  BookmarkPaperShare({
    this.data,
    this.meta,
  });

  List<BookmarkPaperShareData?>? data;
  Meta? meta;

  factory BookmarkPaperShare.fromJson(Map<String, dynamic> json) =>
      BookmarkPaperShare(
        data: List<BookmarkPaperShareData>.from(
            json["data"].map((x) => BookmarkPaperShareData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
        "meta": meta!.toJson(),
      };
}

class BookmarkPaperShareData {
  BookmarkPaperShareData({
    this.id,
    this.attributes,
  });

  int? id;
  BookmarkPaperShareAttributes? attributes;

  factory BookmarkPaperShareData.fromJson(Map<String, dynamic> json) =>
      BookmarkPaperShareData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : BookmarkPaperShareAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class BookmarkPaperShareAttributes {
  BookmarkPaperShareAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.paperShare,
    this.savedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SavedPaperShare? paperShare;
  SavedBy? savedBy;

  factory BookmarkPaperShareAttributes.fromJson(Map<String, dynamic> json) =>
      BookmarkPaperShareAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        paperShare: json["paper_share"] == null
            ? null
            : SavedPaperShare.fromJson(json["paper_share"]),
        savedBy: json["saved_by"] == null
            ? null
            : SavedBy.fromJson(json["saved_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "paper_share": paperShare!.toJson(),
        "saved_by": savedBy == null ? null : savedBy!.toJson(),
      };
}

class SavedPaperShare {
  SavedPaperShare({
    this.data,
  });

  PaperShare? data;

  factory SavedPaperShare.fromJson(Map<String, dynamic> json) =>
      SavedPaperShare(
        data: json["data"] == null ? null : PaperShare.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}
