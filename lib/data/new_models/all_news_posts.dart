import 'dart:convert';

AllNewsPosts allNewsPostsFromJson(String str) =>
    AllNewsPosts.fromJson(json.decode(str));

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
}

class NewsPost {
  int? id;
  String? title;
  List<NewsPostImage>? images;
  String? content;
  List<Comment>? comments;
  List<Like>? likes;
  int? isLiked;
  int? isSaved;
  int? isActive;
  By? postedBy;
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
    this.likes,
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
            : List<NewsPostImage>.from(
                json["images"]!.map((x) => NewsPostImage.fromJson(x))),
        content: json["content"],
        likes: json["likes"] == null
            ? []
            : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
        comments: json["comments"] == null
            ? []
            : List<Comment>.from(
                json["comments"]!.map((x) => Comment.fromJson(x))),
        isLiked: json["is_liked"],
        isSaved: json["is_saved"],
        isActive: json["is_active"],
        postedBy:
            json["posted_by"] == null ? null : By.fromJson(json["posted_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        likesCount: json["likes_count"],
        commentCount: json["comment_count"],
      );
}

class Comment {
  int? id;
  String? comment;
  By? commentBy;
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
        commentBy:
            json["comment_by"] == null ? null : By.fromJson(json["comment_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}

class By {
  int? id;
  String? username;
  String? profilePicture;
  String? userType;

  By({this.id, this.username, this.profilePicture, this.userType});

  factory By.fromJson(Map<String, dynamic> json) => By(
        id: json["id"],
        username: json["username"],
        profilePicture: json["profile_picture"],
        userType: json["user_type"],
      );
}

class NewsPostImage {
  int? id;
  String? url;

  NewsPostImage({
    this.id,
    this.url,
  });

  factory NewsPostImage.fromJson(Map<String, dynamic> json) => NewsPostImage(
        id: json["id"],
        url: json["url"],
      );
}

class Like {
  int? id;
  By? likedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Like({
    this.id,
    this.likedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        likedBy:
            json["liked_by"] == null ? null : By.fromJson(json["liked_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
