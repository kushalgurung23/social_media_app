import 'dart:convert';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/data/models/paper_share_model.dart';

BookmarkInterestClass bookmarkInterestClassFromJson(String str) =>
    BookmarkInterestClass.fromJson(json.decode(str));

String bookmarkInterestClassToJson(BookmarkInterestClass data) =>
    json.encode(data.toJson());

class BookmarkInterestClass {
  BookmarkInterestClass({
    this.data,
    this.meta,
  });

  List<BookmarkInterestClassData?>? data;
  Meta? meta;

  factory BookmarkInterestClass.fromJson(Map<String, dynamic> json) =>
      BookmarkInterestClass(
        data: json["data"] == null
            ? null
            : List<BookmarkInterestClassData>.from(
                json["data"].map((x) => BookmarkInterestClassData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
        "meta": meta!.toJson(),
      };
}

class BookmarkInterestClassData {
  BookmarkInterestClassData({
    this.id,
    this.attributes,
  });

  int? id;
  BookmarkInterestClassAttributes? attributes;

  factory BookmarkInterestClassData.fromJson(Map<String, dynamic> json) =>
      BookmarkInterestClassData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : BookmarkInterestClassAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class BookmarkInterestClassAttributes {
  BookmarkInterestClassAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.interestClass,
    this.savedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SavedInterestClass? interestClass;
  SavedBy? savedBy;

  factory BookmarkInterestClassAttributes.fromJson(Map<String, dynamic> json) =>
      BookmarkInterestClassAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        interestClass: json["interest_class"] == null
            ? null
            : SavedInterestClass.fromJson(json["interest_class"]),
        savedBy: json["saved_by"] == null
            ? null
            : SavedBy.fromJson(json["saved_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "interest_class": interestClass!.toJson(),
        "saved_by": savedBy!.toJson(),
      };
}

class SavedInterestClass {
  SavedInterestClass({
    this.data,
  });

  InterestClassData? data;

  factory SavedInterestClass.fromJson(Map<String, dynamic> json) =>
      SavedInterestClass(
        data: json["data"] == null
            ? null
            : InterestClassData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}
