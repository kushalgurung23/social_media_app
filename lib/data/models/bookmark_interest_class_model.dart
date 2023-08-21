import 'dart:convert';
import 'package:c_talent/data/models/all_news_post_model.dart';
import 'package:c_talent/data/models/interest_class_model.dart';

BookmarkInterestClass bookmarkInterestClassFromJson(String str) =>
    BookmarkInterestClass.fromJson(json.decode(str));

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
}

class SavedBy {
  SavedBy({
    this.data,
  });

  DiscussedByData? data;

  factory SavedBy.fromJson(Map<String, dynamic> json) => SavedBy(
      data:
          json["data"] == null ? null : DiscussedByData.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class DiscussedBy {
  DiscussedBy({
    this.data,
  });

  DiscussedByData? data;

  factory DiscussedBy.fromJson(Map<String, dynamic> json) => DiscussedBy(
        data: json["data"] == null
            ? null
            : DiscussedByData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class DiscussedByData {
  DiscussedByData({
    this.id,
    this.attributes,
  });

  int? id;
  DiscussedByAttributes? attributes;

  factory DiscussedByData.fromJson(Map<String, dynamic> json) =>
      DiscussedByData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : DiscussedByAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class DiscussedByAttributes {
  DiscussedByAttributes(
      {required this.username,
      required this.email,
      required this.provider,
      required this.confirmed,
      required this.blocked,
      required this.createdAt,
      required this.updatedAt,
      required this.userType,
      required this.grade,
      required this.teachingType,
      required this.collegeType,
      required this.teachingArea,
      required this.region,
      required this.category,
      required this.profileImage,
      this.centerName,
      this.deviceToken});

  String? username;
  String? centerName;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? grade;
  String? teachingType;
  String? collegeType;
  String? teachingArea;
  String? region;
  String? category;
  String? userType;
  PaperMedia? profileImage;
  String? deviceToken;

  factory DiscussedByAttributes.fromJson(Map<String, dynamic> json) =>
      DiscussedByAttributes(
        username: json["username"].toString(),
        centerName: json["center_name"].toString(),
        email: json["email"].toString(),
        provider: json["provider"].toString(),
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        userType: json["user_type"].toString(),
        grade: json["grade"].toString(),
        teachingType: json["teaching_type"].toString(),
        collegeType: json["college_type"].toString(),
        teachingArea: json["teaching_area"].toString(),
        region: json["region"].toString(),
        category: json["category"].toString(),
        profileImage: json["profile_image"] != null
            ? PaperMedia.fromJson(json["profile_image"])
            : null,
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "user_type": userType,
        "grade": grade,
        "teaching_type": teachingType,
        "college_type": collegeType,
        "teaching_area": teachingArea,
        "region": region,
        "category": category,
        "profile_image": profileImage?.toJson(),
        "center_name": centerName,
        "device_token": deviceToken
      };
}

class PaperMedia {
  PaperMedia({
    required this.data,
  });

  PaperMediaData? data;

  factory PaperMedia.fromJson(Map<String, dynamic> json) => PaperMedia(
        data:
            json["data"] == null ? null : PaperMediaData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class PaperMediaData {
  PaperMediaData({
    this.id,
    this.attributes,
  });

  int? id;
  PaperMediaAttributes? attributes;

  factory PaperMediaData.fromJson(Map<String, dynamic> json) => PaperMediaData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PaperMediaAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PaperMediaAttributes {
  PaperMediaAttributes({
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
  MediaFormat? formats;
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

  factory PaperMediaAttributes.fromJson(Map<String, dynamic> json) =>
      PaperMediaAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: json["formats"] == null
            ? null
            : MediaFormat.fromJson(json["formats"]),
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
        "formats": formats?.toJson(),
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

class MediaFormat {
  MediaFormat({
    this.thumbnail,
  });

  Thumbnail? thumbnail;

  factory MediaFormat.fromJson(Map<String, dynamic> json) => MediaFormat(
        thumbnail: json["thumbnail"] == null
            ? null
            : Thumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail?.toJson(),
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
