import 'dart:convert';

import 'package:spa_app/data/models/all_news_post_model.dart';

AllPaperShare paperShareFromJson(String str) =>
    AllPaperShare.fromJson(json.decode(str));

String paperShareToJson(AllPaperShare data) => json.encode(data.toJson());

class AllPaperShare {
  AllPaperShare({
    required this.data,
    required this.meta,
  });

  List<PaperShare> data;
  Meta meta;

  factory AllPaperShare.fromJson(Map<String, dynamic> json) => AllPaperShare(
        data: List<PaperShare>.from(
            json["data"].map((x) => PaperShare.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

SinglePaperShare singlePaperShareFromJson(String str) =>
    SinglePaperShare.fromJson(json.decode(str));

String singlePaperShareToJson(SinglePaperShare data) =>
    json.encode(data.toJson());

class SinglePaperShare {
  SinglePaperShare({
    this.data,
    this.meta,
  });

  PaperShare? data;
  Meta? meta;

  factory SinglePaperShare.fromJson(Map<String, dynamic> json) =>
      SinglePaperShare(
        data: json["data"] == null ? null : PaperShare.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "meta": meta!.toJson(),
      };
}

class PaperShare {
  PaperShare({
    required this.id,
    required this.attributes,
  });

  int? id;
  PaperShareAttributes? attributes;

  factory PaperShare.fromJson(Map<String, dynamic> json) => PaperShare(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PaperShareAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PaperShareAttributes {
  PaperShareAttributes(
      {this.content,
      this.subject,
      this.level,
      this.semester,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.image,
      this.paperShareDiscusses,
      this.savedPaperShare});

  String? content;
  String? subject;
  String? level;
  String? semester;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  MultiImage? image;
  PaperShareDiscusses? paperShareDiscusses;
  SavedPaperShare? savedPaperShare;

  factory PaperShareAttributes.fromJson(Map<String, dynamic> json) =>
      PaperShareAttributes(
        content: json["content"],
        subject: json["subject"],
        semester: json["semester"],
        level: json["level"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        image: json["paper_media"] == null
            ? null
            : MultiImage.fromJson(json["paper_media"]),
        paperShareDiscusses: json["paper_share_discusses"] == null
            ? null
            : PaperShareDiscusses.fromJson(json["paper_share_discusses"]),
        savedPaperShare: json["saved_paper_share"] == null
            ? null
            : SavedPaperShare.fromJson(json["saved_paper_share"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "subject": subject,
        "level": level,
        "semester": semester,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "paper_media": image?.toJson(),
        "paper_share_discusses": paperShareDiscusses?.toJson(),
        "saved_paper_share": savedPaperShare?.toJson()
      };
}

class SavedPaperShare {
  SavedPaperShare({
    this.data,
  });

  List<SavedPaperShareData?>? data;

  factory SavedPaperShare.fromJson(Map<String, dynamic> json) =>
      SavedPaperShare(
        data: List<SavedPaperShareData>.from(
            json["data"].map((x) => SavedPaperShareData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class SavedPaperShareData {
  SavedPaperShareData({
    this.id,
    this.attributes,
  });

  int? id;
  SavedPaperShareAttributes? attributes;

  factory SavedPaperShareData.fromJson(Map<String, dynamic> json) =>
      SavedPaperShareData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : SavedPaperShareAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class SavedPaperShareAttributes {
  SavedPaperShareAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.savedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SavedBy? savedBy;

  factory SavedPaperShareAttributes.fromJson(Map<String, dynamic> json) =>
      SavedPaperShareAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        savedBy: json["saved_by"] == null
            ? null
            : SavedBy.fromJson(json["saved_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "saved_by": savedBy == null ? null : savedBy!.toJson(),
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

class PaperShareDiscusses {
  PaperShareDiscusses({
    required this.data,
  });

  List<PaperShareDiscussesData?>? data;

  factory PaperShareDiscusses.fromJson(Map<String, dynamic> json) =>
      PaperShareDiscusses(
        data: json["data"] == null
            ? null
            : List<PaperShareDiscussesData>.from(
                json["data"].map((x) => PaperShareDiscussesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class PaperShareDiscussesData {
  PaperShareDiscussesData({
    this.id,
    this.attributes,
  });

  int? id;
  PaperDiscussesAttributes? attributes;

  factory PaperShareDiscussesData.fromJson(Map<String, dynamic> json) =>
      PaperShareDiscussesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PaperDiscussesAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PaperDiscussesAttributes {
  PaperDiscussesAttributes({
    this.content,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.discussedBy,
  });

  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  DiscussedBy? discussedBy;

  factory PaperDiscussesAttributes.fromJson(Map<String, dynamic> json) =>
      PaperDiscussesAttributes(
        content: json["content"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        discussedBy: DiscussedBy.fromJson(json["discussed_by"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "discussed_by": discussedBy?.toJson(),
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

class Meta {
  Meta({
    this.pagination,
  });

  Pagination? pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
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
