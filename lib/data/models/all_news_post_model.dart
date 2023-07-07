import 'dart:convert';

AllNewsPost allNewsPostFromJson(String str) =>
    AllNewsPost.fromJson(json.decode(str));

String allNewsPostToJson(AllNewsPost data) => json.encode(data.toJson());

class AllNewsPost {
  AllNewsPost({
    required this.data,
    required this.meta,
  });

  List<NewsPost>? data;
  Meta meta;

  factory AllNewsPost.fromJson(Map<String, dynamic> json) => AllNewsPost(
        data:
            List<NewsPost>.from(json["data"].map((x) => NewsPost.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class NewsPost {
  NewsPost({
    required this.id,
    required this.attributes,
  });

  int? id;
  NewsPostAttribute? attributes;

  factory NewsPost.fromJson(Map<String, dynamic> json) => NewsPost(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : NewsPostAttribute.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

SingleNewsPost singleNewsPostFromJson(String str) =>
    SingleNewsPost.fromJson(json.decode(str));

String singleNewsPostToJson(SingleNewsPost data) => json.encode(data.toJson());

class SingleNewsPost {
  SingleNewsPost({
    this.data,
    this.meta,
  });

  NewsPost? data;
  Meta? meta;

  factory SingleNewsPost.fromJson(Map<String, dynamic> json) => SingleNewsPost(
        data: json["data"] == null ? null : NewsPost.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "meta": meta!.toJson(),
      };
}

class NewsPostAttribute {
  NewsPostAttribute(
      {required this.createdAt,
      required this.updatedAt,
      required this.publishedAt,
      required this.content,
      required this.title,
      this.image,
      required this.postedBy,
      required this.comments,
      this.discussCommentCounts,
      this.newsPostSaves,
      this.newsPostLikes,
      this.reportNewsPosts,
      this.likeCount});

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? content;
  String? title;
  String? likeCount;
  MultiImage? image;
  NewsPostUser? postedBy;
  Comments? comments;
  AllNewsPostSaves? newsPostSaves;
  AllNewsPostLikes? newsPostLikes;
  DiscussCommentCounts? discussCommentCounts;
  ReportNewsPosts? reportNewsPosts;

  factory NewsPostAttribute.fromJson(Map<String, dynamic> json) =>
      NewsPostAttribute(
          createdAt: json["createdAt"] == null
              ? null
              : DateTime.parse(json["createdAt"]),
          updatedAt: json["updatedAt"] == null
              ? null
              : DateTime.parse(json["updatedAt"]),
          publishedAt: json["publishedAt"] == null
              ? null
              : DateTime.parse(json["publishedAt"]),
          content: json["content"].toString(),
          title: json["title"].toString(),
          likeCount: json["like_count"],
          image:
              json["image"] == null ? null : MultiImage.fromJson(json["image"]),
          postedBy: json["posted_by"] == null
              ? null
              : NewsPostUser.fromJson(json["posted_by"]),
          comments: json["comments"] == null
              ? null
              : Comments.fromJson(json["comments"]),
          newsPostSaves: json["news_post_saves"] == null
              ? null
              : AllNewsPostSaves.fromJson(json["news_post_saves"]),
          newsPostLikes: json["news_post_likes"] == null
              ? null
              : AllNewsPostLikes.fromJson(json["news_post_likes"]),
          discussCommentCounts: json["discuss_comment_counts"] == null
              ? null
              : DiscussCommentCounts.fromJson(json["discuss_comment_counts"]),
          reportNewsPosts: json["report_news_posts"] == null
              ? null
              : ReportNewsPosts.fromJson(json["report_news_posts"]));

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "content": content,
        "title": title,
        "like_count": likeCount,
        "image": image == null ? null : image!.toJson(),
        "posted_by": postedBy == null ? null : postedBy!.toJson(),
        "comments": comments == null ? null : comments!.toJson(),
        "discuss_comment_counts": discussCommentCounts == null
            ? null
            : discussCommentCounts!.toJson(),
        "news_post_saves":
            newsPostSaves == null ? null : newsPostSaves!.toJson(),
        "news_post_likes":
            newsPostLikes == null ? null : newsPostLikes!.toJson(),
        "report_news_posts": reportNewsPosts?.toJson(),
      };
}

class AllNewsPostSaves {
  AllNewsPostSaves({
    this.data,
  });

  List<NewsPostSavesData?>? data;

  factory AllNewsPostSaves.fromJson(Map<String, dynamic> json) =>
      AllNewsPostSaves(
        data: json["data"] == null
            ? null
            : List<NewsPostSavesData>.from(
                json["data"].map((x) => NewsPostSavesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class NewsPostSavesData {
  NewsPostSavesData({
    this.id,
    this.attributes,
  });

  int? id;
  NewsPostSaveAttributes? attributes;

  factory NewsPostSavesData.fromJson(Map<String, dynamic> json) =>
      NewsPostSavesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : NewsPostSaveAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class NewsPostSaveAttributes {
  NewsPostSaveAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.savedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  NewsPostUser? savedBy;

  factory NewsPostSaveAttributes.fromJson(Map<String, dynamic> json) =>
      NewsPostSaveAttributes(
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
            : NewsPostUser.fromJson(json["saved_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "saved_by": savedBy!.toJson(),
      };
}

class AllNewsPostLikes {
  AllNewsPostLikes({
    this.data,
  });

  List<AllNewsPostLikesData?>? data;

  factory AllNewsPostLikes.fromJson(Map<String, dynamic> json) =>
      AllNewsPostLikes(
        data: json["data"] == null
            ? null
            : List<AllNewsPostLikesData>.from(
                json["data"].map((x) => AllNewsPostLikesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class AllNewsPostLikesData {
  AllNewsPostLikesData({
    this.id,
    this.attributes,
  });

  int? id;
  NewsPostLikeAttributes? attributes;

  factory AllNewsPostLikesData.fromJson(Map<String, dynamic> json) =>
      AllNewsPostLikesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : NewsPostLikeAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class NewsPostLikeAttributes {
  NewsPostLikeAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.likedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  NewsPostUser? likedBy;

  factory NewsPostLikeAttributes.fromJson(Map<String, dynamic> json) =>
      NewsPostLikeAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        likedBy: json["liked_by"] == null
            ? null
            : NewsPostUser.fromJson(json["liked_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "liked_by": likedBy!.toJson(),
      };
}

class UserFollower {
  UserFollower({
    this.data,
  });

  List<UserFollowerData?>? data;

  factory UserFollower.fromJson(Map<String, dynamic> json) => UserFollower(
        data: List<UserFollowerData>.from(
            json["data"].map((x) => UserFollowerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}

class UserFollowerData {
  UserFollowerData({
    this.id,
    this.attributes,
  });

  int? id;
  UserFollowerAttributes? attributes;

  factory UserFollowerData.fromJson(Map<String, dynamic> json) =>
      UserFollowerData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : UserFollowerAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class UserFollowerAttributes {
  UserFollowerAttributes(
      {this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.followedBy,
      this.followedTo});

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  NewsPostUser? followedBy;
  NewsPostUser? followedTo;

  factory UserFollowerAttributes.fromJson(Map<String, dynamic> json) =>
      UserFollowerAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        followedBy: json["followed_by"] == null
            ? null
            : NewsPostUser.fromJson(json["followed_by"]),
        followedTo: json["followed_to"] == null
            ? null
            : NewsPostUser.fromJson(json["followed_to"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt":
            publishedAt == null ? null : publishedAt!.toIso8601String(),
        "followed_by": followedBy == null ? null : followedBy!.toJson(),
        "followed_to": followedTo == null ? null : followedTo!.toJson(),
      };
}

class Comments {
  Comments({
    required this.data,
  });

  List<CommentsData>? data;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        data: List<CommentsData>.from(
            json["data"].map((x) => CommentsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CommentsData {
  CommentsData({
    required this.id,
    required this.attributes,
  });

  int? id;
  CommentsAttributes? attributes;

  factory CommentsData.fromJson(Map<String, dynamic> json) => CommentsData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : CommentsAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class CommentsAttributes {
  CommentsAttributes({
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.commentBy,
  });

  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  NewsPostUser? commentBy;

  factory CommentsAttributes.fromJson(Map<String, dynamic> json) =>
      CommentsAttributes(
        content: json["content"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        commentBy: json["comment_by"] == null
            ? null
            : NewsPostUser.fromJson(json["comment_by"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "comment_by": commentBy == null ? null : commentBy!.toJson(),
      };
}

class NewsPostUser {
  NewsPostUser({
    required this.data,
  });

  UserData? data;

  factory NewsPostUser.fromJson(Map<String, dynamic> json) => NewsPostUser(
        data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class UserData {
  UserData({
    required this.id,
    required this.attributes,
  });

  int? id;
  UserAttributes? attributes;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : UserAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class UserAttributes {
  UserAttributes(
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
      this.deviceToken,
      this.userFollower});

  String? username;
  String? email;
  String? centerName;
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
  SingleImage? profileImage;
  String? deviceToken;
  // user follower is used for news post likes to follow/unfollow user from news post likes screens
  UserFollower? userFollower;

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
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
            ? SingleImage.fromJson(json["profile_image"])
            : null,
        deviceToken: json["device_token"],
        userFollower: json["user_follower"] != null
            ? UserFollower.fromJson(json["user_follower"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "center_name": centerName,
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
        "device_token": deviceToken,
        "user_follower": userFollower!.toJson()
      };
}

class UserList {
  UserList({
    required this.data,
  });

  List<UserData>? data;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        data:
            List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SingleImage {
  SingleImage({
    required this.data,
  });

  SingleImageData? data;

  factory SingleImage.fromJson(Map<String, dynamic> json) => SingleImage(
        data: json["data"] == null
            ? null
            : SingleImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class SingleImageData {
  SingleImageData({
    this.id,
    required this.attributes,
  });

  int? id;
  SingleImageAttributes? attributes;

  factory SingleImageData.fromJson(Map<String, dynamic> json) =>
      SingleImageData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : SingleImageAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class SingleImageAttributes {
  SingleImageAttributes({
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

  factory SingleImageAttributes.fromJson(Map<String, dynamic> json) =>
      SingleImageAttributes(
        name: json["name"].toString(),
        alternativeText: json["alternativeText"].toString(),
        caption: json["caption"].toString(),
        width: json["width"],
        height: json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"].toString(),
        ext: json["ext"].toString(),
        mime: json["mime"].toString(),
        size: json["size"].toDouble(),
        url: json["url"].toString(),
        previewUrl: json["previewUrl"].toString(),
        provider: json["provider"].toString(),
        providerMetadata: json["provider_metadata"].toString(),
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
    required this.thumbnail,
    required this.large,
    required this.medium,
    required this.small,
  });

  ImageSize? thumbnail;
  ImageSize? large;
  ImageSize? medium;
  ImageSize? small;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] == null
            ? null
            : ImageSize.fromJson(json["thumbnail"]),
        large: json["large"] == null ? null : ImageSize.fromJson(json["large"]),
        medium:
            json["medium"] == null ? null : ImageSize.fromJson(json["medium"]),
        small: json["small"] == null ? null : ImageSize.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail == null ? null : thumbnail!.toJson(),
        "large": large == null ? null : large!.toJson(),
        "medium": medium == null ? null : medium!.toJson(),
        "small": small == null ? null : small!.toJson(),
      };
}

class ImageSize {
  ImageSize({
    required this.name,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.path,
    required this.width,
    required this.height,
    required this.size,
    required this.url,
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

  factory ImageSize.fromJson(Map<String, dynamic> json) => ImageSize(
        name: json["name"].toString(),
        hash: json["hash"].toString(),
        ext: json["ext"].toString(),
        mime: json["mime"].toString(),
        path: json["path"].toString(),
        width: json["width"],
        height: json["height"],
        size: json["size"].toDouble(),
        url: json["url"].toString(),
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
    required this.pagination,
  });

  Pagination? pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination == null ? null : pagination!.toJson(),
      };
}

class MultiImage {
  MultiImage({
    this.data,
  });

  List<MultiImageData?>? data;

  factory MultiImage.fromJson(Map<String, dynamic> json) => MultiImage(
        data: json["data"] == null
            ? null
            : List<MultiImageData>.from(
                json["data"].map((x) => MultiImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class MultiImageData {
  MultiImageData({
    this.id,
    this.attributes,
  });

  int? id;
  MultiImageAttributes? attributes;

  factory MultiImageData.fromJson(Map<String, dynamic> json) => MultiImageData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : MultiImageAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes == null ? null : attributes!.toJson(),
      };
}

class MultiImageAttributes {
  MultiImageAttributes({
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

  factory MultiImageAttributes.fromJson(Map<String, dynamic> json) =>
      MultiImageAttributes(
        name: json["name"].toString(),
        alternativeText: json["alternativeText"].toString(),
        caption: json["caption"].toString(),
        width: json["width"],
        height: json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"].toString(),
        ext: json["ext"].toString(),
        mime: json["mime"].toString(),
        size: json["size"].toDouble(),
        url: json["url"].toString(),
        previewUrl: json["previewUrl"].toString(),
        provider: json["provider"].toString(),
        providerMetadata: json["provider_metadata"].toString(),
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

class Pagination {
  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  int page;
  int pageSize;
  int pageCount;
  int total;

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

class DiscussCommentCounts {
  DiscussCommentCounts({
    this.data,
  });

  List<DiscussCommentCountsData?>? data;

  factory DiscussCommentCounts.fromJson(Map<String, dynamic> json) =>
      DiscussCommentCounts(
        data: List<DiscussCommentCountsData>.from(
            json["data"].map((x) => DiscussCommentCountsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class DiscussCommentCountsData {
  DiscussCommentCountsData({
    this.id,
    this.attributes,
  });

  int? id;
  DiscussCommentCountsAttributes? attributes;

  factory DiscussCommentCountsData.fromJson(Map<String, dynamic> json) =>
      DiscussCommentCountsData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : DiscussCommentCountsAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class DiscussCommentCountsAttributes {
  DiscussCommentCountsAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.commentCountWhenVisited,
    this.visitedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? commentCountWhenVisited;
  VisitedBy? visitedBy;

  factory DiscussCommentCountsAttributes.fromJson(Map<String, dynamic> json) =>
      DiscussCommentCountsAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        commentCountWhenVisited: json["createdAt"] == null
            ? null
            : json["comment_count_when_visited"],
        visitedBy: json["visited_by"] == null
            ? null
            : VisitedBy.fromJson(json["visited_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "comment_count_when_visited": commentCountWhenVisited,
        "visited_by": visitedBy!.toJson(),
      };
}

class VisitedBy {
  VisitedBy({
    this.data,
  });

  List<UserData?>? data;

  factory VisitedBy.fromJson(Map<String, dynamic> json) => VisitedBy(
        data:
            List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class ReportNewsPosts {
  ReportNewsPosts({
    this.data,
  });

  List<ReportNewsPostsData?>? data;

  factory ReportNewsPosts.fromJson(Map<String, dynamic> json) =>
      ReportNewsPosts(
        data: json["data"] == null
            ? null
            : List<ReportNewsPostsData>.from(
                json["data"].map((x) => ReportNewsPostsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class ReportNewsPostsData {
  ReportNewsPostsData({
    this.id,
    this.attributes,
  });

  int? id;
  ReportNewsPostsAttributes? attributes;

  factory ReportNewsPostsData.fromJson(Map<String, dynamic> json) =>
      ReportNewsPostsData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : ReportNewsPostsAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class ReportNewsPostsAttributes {
  ReportNewsPostsAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.reason,
    this.reportedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? reason;
  NewsPostUser? reportedBy;

  factory ReportNewsPostsAttributes.fromJson(Map<String, dynamic> json) =>
      ReportNewsPostsAttributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        reason: json["reason"],
        reportedBy: json["reported_by"] == null
            ? null
            : NewsPostUser.fromJson(json["reported_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "reason": reason,
        "reported_by": reportedBy?.toJson(),
      };
}
