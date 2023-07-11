import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User(
      {required this.id,
      required this.username,
      this.centerName,
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
      this.userFollowing,
      this.userFollower,
      this.createdPost,
      this.newsPostLikes,
      this.deviceToken,
      this.newsPostSaves,
      this.paperShareSaves,
      this.reportedNewsPosts,
      this.reportedPaperShares,
      this.usersBlocked,
      this.interestClassSaves,
      this.gotBlockedFrom});

  int? id;
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
  AllImage? profileImage;
  List<UserFollow?>? userFollowing;
  List<UserFollow?>? userFollower;
  List<UserPost?>? createdPost;
  List<UserPostSaveLike?>? newsPostSaves;
  List<UserPostSaveLike?>? newsPostLikes;
  String? deviceToken;
  List<PaperShareSave?>? paperShareSaves;
  List<InterestClassSave?>? interestClassSaves;
  List<ReportedNewsPost?>? reportedNewsPosts;
  List<ReportedPaperShare?>? reportedPaperShares;
  List<UsersBlocked?>? usersBlocked;
  List<GotBlockedFrom?>? gotBlockedFrom;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
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
            ? AllImage.fromJson(json["profile_image"])
            : null,
        userFollowing: json["user_following"] == null
            ? null
            : List<UserFollow>.from(
                    json["user_following"].map((x) => UserFollow.fromJson(x)))
                .where((element) => element.followedTo != null)
                .toList(),
        userFollower: json["user_follower"] == null
            ? null
            : List<UserFollow>.from(
                    json["user_follower"].map((x) => UserFollow.fromJson(x)))
                .where((element) => element.followedBy != null)
                .toList(),
        createdPost: json["created_post"] == null
            ? null
            : List<UserPost>.from(
                json["created_post"].map((x) => UserPost.fromJson(x))),
        interestClassSaves: json["interest_class_saves"] == null
            ? null
            : List<InterestClassSave>.from(json["interest_class_saves"]
                .map((x) => InterestClassSave.fromJson(x))),
        deviceToken: json["device_token"],
        newsPostSaves: json["news_post_saves"] == null
            ? null
            : List<UserPostSaveLike>.from(json["news_post_saves"]
                .map((x) => UserPostSaveLike.fromJson(x))),
        newsPostLikes: json["news_post_likes"] == null
            ? null
            : List<UserPostSaveLike>.from(json["news_post_likes"]
                .map((x) => UserPostSaveLike.fromJson(x))),
        paperShareSaves: json["paper_share_saves"] == null
            ? null
            : List<PaperShareSave>.from(json["paper_share_saves"]
                .map((x) => PaperShareSave.fromJson(x))),
        reportedNewsPosts: json["reported_news_posts"] == null
            ? null
            : List<ReportedNewsPost>.from(json["reported_news_posts"]
                .map((x) => ReportedNewsPost.fromJson(x))),
        reportedPaperShares: json["reported_paper_shares"] == null
            ? null
            : List<ReportedPaperShare>.from(json["reported_paper_shares"]
                .map((x) => ReportedPaperShare.fromJson(x))),
        usersBlocked: json["users_blocked"] == null
            ? null
            : List<UsersBlocked>.from(
                json["users_blocked"].map((x) => UsersBlocked.fromJson(x))),
        gotBlockedFrom: json["got_blocked_from"] == null
            ? null
            : List<GotBlockedFrom>.from(json["got_blocked_from"]
                .map((x) => GotBlockedFrom.fromJson(x))),
      );
}

class UsersBlocked {
  UsersBlocked({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.blockedTo,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SecondUser? blockedTo;

  factory UsersBlocked.fromJson(Map<String, dynamic> json) => UsersBlocked(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        blockedTo: json["blocked_to"] == null
            ? null
            : SecondUser.fromJson(json["blocked_to"]),
      );
}

class GotBlockedFrom {
  GotBlockedFrom({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.blockedBy,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SecondUser? blockedBy;

  factory GotBlockedFrom.fromJson(Map<String, dynamic> json) => GotBlockedFrom(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        blockedBy: json["blocked_by"] == null
            ? null
            : SecondUser.fromJson(json["blocked_by"]),
      );
}

class ReportedPaperShare {
  ReportedPaperShare({
    this.id,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.paperShare,
  });

  int? id;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  PaperShare? paperShare;

  factory ReportedPaperShare.fromJson(Map<String, dynamic> json) =>
      ReportedPaperShare(
        id: json["id"],
        reason: json["reason"],
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
            : PaperShare.fromJson(json["paper_share"]),
      );
}

class ReportedNewsPost {
  ReportedNewsPost({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.reason,
    this.newsPost,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? reason;
  UserPost? newsPost;

  factory ReportedNewsPost.fromJson(Map<String, dynamic> json) =>
      ReportedNewsPost(
        id: json["id"],
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
        newsPost: json["news_post"] == null
            ? null
            : UserPost.fromJson(json["news_post"]),
      );
}

class UserPostSaveLike {
  UserPostSaveLike({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.newsPost,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  UserPost? newsPost;

  factory UserPostSaveLike.fromJson(Map<String, dynamic> json) =>
      UserPostSaveLike(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        newsPost: json["news_post"] == null
            ? null
            : UserPost.fromJson(json["news_post"]),
      );
}

class InterestClassSave {
  InterestClassSave({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.interestClass,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  UserInterestClassSave? interestClass;

  factory InterestClassSave.fromJson(Map<String, dynamic> json) =>
      InterestClassSave(
        id: json["id"],
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
            : UserInterestClassSave.fromJson(json["interest_class"]),
      );
}

class UserInterestClassSave {
  UserInterestClassSave({
    this.id,
    this.brand,
    this.type,
    this.title,
    this.price,
    this.description,
    this.isRecommend,
    this.website,
    this.facebookLink,
    this.instagramLink,
    this.twitterLink,
    this.phoneNumber,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  int? id;
  String? brand;
  String? type;
  String? title;
  String? price;
  String? description;
  bool? isRecommend;
  String? website;
  String? facebookLink;
  String? instagramLink;
  String? twitterLink;
  String? phoneNumber;
  String? location;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;

  factory UserInterestClassSave.fromJson(Map<String, dynamic> json) =>
      UserInterestClassSave(
        id: json["id"],
        brand: json["brand"],
        type: json["type"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        isRecommend: json["is_recommend"],
        website: json["website"],
        facebookLink: json["facebook_link"],
        instagramLink: json["instagram_link"],
        twitterLink: json["twitter_link"],
        phoneNumber: json["phone_number"],
        location: json["location"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
      );
}

class UserFollow {
  UserFollow({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.followedBy,
    this.followedTo,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  SecondUser? followedBy;
  SecondUser? followedTo;

  factory UserFollow.fromJson(Map<String, dynamic> json) => UserFollow(
        id: json["id"],
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
            : SecondUser.fromJson(json["followed_by"]),
        followedTo: json["followed_to"] == null
            ? null
            : SecondUser.fromJson(json["followed_to"]),
      );
}

class SecondUser {
  SecondUser({
    this.id,
    this.username,
    this.email,
    this.provider,
    this.confirmed,
    this.blocked,
    this.createdAt,
    this.updatedAt,
    this.grade,
    this.userType,
    this.teachingType,
    this.collegeType,
    this.teachingArea,
    this.region,
    this.category,
    this.centerName,
    this.deviceToken,
    this.profileImage,
  });

  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? grade;
  String? userType;
  String? teachingType;
  String? collegeType;
  String? teachingArea;
  String? region;
  String? category;
  String? centerName;
  String? deviceToken;
  AllImage? profileImage;

  factory SecondUser.fromJson(Map<String, dynamic> json) => SecondUser(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        grade: json["grade"],
        userType: json["user_type"],
        teachingType: json["teaching_type"],
        collegeType: json["college_type"],
        teachingArea: json["teaching_area"],
        region: json["region"],
        category: json["category"],
        centerName: json["center_name"],
        deviceToken: json["device_token"],
        profileImage: json["profile_image"] == null
            ? null
            : AllImage.fromJson(json["profile_image"]),
      );
}

class AllImage {
  AllImage({
    required this.id,
    required this.name,
    required this.alternativeText,
    required this.caption,
    required this.width,
    required this.height,
    required this.formats,
    required this.hash,
    required this.ext,
    required this.mime,
    required this.size,
    required this.url,
    required this.previewUrl,
    required this.provider,
    required this.providerMetadata,
    required this.createdAt,
    required this.updatedAt,
  });

  String? id;
  String? name;
  String? alternativeText;
  String? caption;
  String? width;
  String? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  String? size;
  String? url;
  String? previewUrl;
  String? provider;
  String? providerMetadata;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AllImage.fromJson(Map<String, dynamic> json) => AllImage(
        id: json["id"].toString(),
        name: json["name"].toString(),
        alternativeText: json["alternativeText"].toString(),
        caption: json["caption"].toString(),
        width: json["width"].toString(),
        height: json["height"].toString(),
        formats:
            json["formats"] != null ? Formats.fromJson(json["formats"]) : null,
        hash: json["hash"].toString(),
        ext: json["ext"].toString(),
        mime: json["mime"].toString(),
        size: json["size"].toString(),
        url: json["url"].toString(),
        previewUrl: json["previewUrl"].toString(),
        provider: json["provider"].toString(),
        providerMetadata: json["provider_metadata"].toString(),
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );
}

class Formats {
  Formats({
    required this.thumbnail,
    required this.large,
    required this.medium,
    required this.small,
  });

  Large? thumbnail;
  Large? large;
  Large? medium;
  Large? small;

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] != null
            ? Large.fromJson(json["thumbnail"])
            : null,
        large: json["large"] != null ? Large.fromJson(json["large"]) : null,
        medium: json["medium"] != null ? Large.fromJson(json["medium"]) : null,
        small: json["small"] != null ? Large.fromJson(json["small"]) : null,
      );
}

class Large {
  Large({
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
  String? width;
  String? height;
  String? size;
  String? url;

  factory Large.fromJson(Map<String, dynamic> json) => Large(
        name: json["name"].toString(),
        hash: json["hash"].toString(),
        ext: json["ext"].toString(),
        mime: json["mime"].toString(),
        path: json["path"].toString(),
        width: json["width"].toString(),
        height: json["height"].toString(),
        size: json["size"].toString(),
        url: json["url"].toString(),
      );
}

class UserPost {
  UserPost(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.content,
      this.title,
      this.comments,
      this.image,
      this.likeCount,
      this.newsPostSaves,
      this.postedBy,
      this.newsPostLikes});

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? content;
  String? title;
  String? likeCount;
  List<UserComment?>? comments;
  List<AllImage?>? image;
  List<TopicSave?>? newsPostSaves;
  List<TopicLike?>? newsPostLikes;
  SecondUser? postedBy;

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
        title: json["title"],
        likeCount: json["like_count"],
        comments: json["comments"] == null
            ? null
            : List<UserComment>.from(
                json["comments"].map((x) => UserComment.fromJson(x))),
        image: json["image"] != null
            ? List<AllImage>.from(
                json["image"].map((x) => AllImage.fromJson(x)))
            : null,
        newsPostSaves: json["news_post_saves"] == null
            ? null
            : List<TopicSave>.from(
                json["news_post_saves"].map((x) => TopicSave.fromJson(x))),
        newsPostLikes: json["news_post_likes"] == null
            ? null
            : List<TopicLike>.from(
                json["news_post_likes"].map((x) => TopicLike.fromJson(x))),
        postedBy: json["posted_by"] == null
            ? null
            : SecondUser.fromJson(json["posted_by"]),
      );
}

class TopicSave {
  TopicSave({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.savedBy,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  User? savedBy;

  factory TopicSave.fromJson(Map<String, dynamic> json) => TopicSave(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        savedBy:
            json["saved_by"] == null ? null : User.fromJson(json["saved_by"]),
      );
}

class TopicLike {
  TopicLike({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.likedBy,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  User? likedBy;

  factory TopicLike.fromJson(Map<String, dynamic> json) => TopicLike(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        likedBy:
            json["liked_by"] == null ? null : User.fromJson(json["liked_by"]),
      );
}

class UserComment {
  UserComment({
    this.id,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.commentBy,
  });

  int? id;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  User? commentBy;

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
        id: json["id"],
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
            : User.fromJson(json["comment_by"]),
      );
}

class PaperShareSave {
  PaperShareSave({
    this.id,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.paperShare,
  });

  int? id;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  PaperShare? paperShare;

  factory PaperShareSave.fromJson(Map<String, dynamic> json) => PaperShareSave(
        id: json["id"],
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
        paperShare: json["paper_share"] == null
            ? null
            : PaperShare.fromJson(json["paper_share"]),
      );
}

class PaperShare {
  PaperShare({
    this.id,
    this.topic,
    this.content,
    this.subject,
    this.level,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  int? id;
  String? topic;
  String? content;
  String? subject;
  String? level;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;

  factory PaperShare.fromJson(Map<String, dynamic> json) => PaperShare(
        id: json["id"],
        topic: json["topic"],
        content: json["content"],
        subject: json["subject"],
        level: json["level"],
        type: json["type"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
      );
}
