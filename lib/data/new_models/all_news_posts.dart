import 'dart:convert';

AllNewsPosts allNewsPostsFromJson(String str) =>
    AllNewsPosts.fromJson(json.decode(str));

String allNewsPostsToJson(AllNewsPosts data) => json.encode(data.toJson());

class AllNewsPosts {
  String? status;
  int? count;
  int? page;
  int? limit;
  List<Post>? posts;

  AllNewsPosts({
    this.status,
    this.count,
    this.page,
    this.limit,
    this.posts,
  });

  factory AllNewsPosts.fromJson(Map<String, dynamic> json) => AllNewsPosts(
        status: json["status"],
        count: json["count"],
        page: json["page"],
        limit: json["limit"],
        posts: json["posts"] == null
            ? []
            : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "page": page,
        "limit": limit,
        "posts": posts == null
            ? []
            : List<dynamic>.from(posts!.map((x) => x.toJson())),
      };
}

class Post {
  NewsPost? newsPost;

  Post({
    this.newsPost,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        newsPost: json["news_post"] == null
            ? null
            : NewsPost.fromJson(json["news_post"]),
      );

  Map<String, dynamic> toJson() => {
        "news_post": newsPost?.toJson(),
      };
}

class NewsPost {
  int? id;
  String? title;
  List<Image>? images;
  String? content;
  List<Comment>? comments;
  int? isLiked;
  int? isSaved;
  int? isActive;
  CommentBy? postedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likesCount;
  int? commentCount;

  NewsPost({
    this.id,
    this.title,
    this.images,
    this.content,
    this.comments,
    this.isLiked,
    this.isSaved,
    this.isActive,
    this.postedBy,
    this.createdAt,
    this.updatedAt,
    this.likesCount,
    this.commentCount,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) => NewsPost(
        id: json["id"],
        title: json["title"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        content: json["content"],
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        isLiked: json["is_liked"],
        isSaved: json["is_saved"],
        isActive: json["is_active"],
        postedBy: json["posted_by"] == null
            ? null
            : CommentBy.fromJson(json["posted_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        likesCount: json["likes_count"],
        commentCount: json["comment_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "content": content,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "is_liked": isLiked,
        "is_saved": isSaved,
        "is_active": isActive,
        "posted_by": postedBy?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "likes_count": likesCount,
        "comment_count": commentCount,
      };
}

class Comment {
  int? id;
  String? comment;
  CommentBy? commentBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    this.id,
    this.comment,
    this.commentBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        comment: json["comment"],
        commentBy: json["comment_by"] == null
            ? null
            : CommentBy.fromJson(json["comment_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "comment_by": commentBy?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class CommentBy {
  int? id;
  String? username;
  String? profilePicture;

  CommentBy({
    this.id,
    this.username,
    this.profilePicture,
  });

  factory CommentBy.fromJson(Map<String, dynamic> json) => CommentBy(
        id: json["id"],
        username: json["username"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_picture": profilePicture,
      };
}

class Image {
  int? id;
  String? url;

  Image({
    this.id,
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
