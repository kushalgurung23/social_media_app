import 'dart:convert';
import 'package:spa_app/data/models/all_news_post_model.dart';

InterestClass interestClassFromJson(String str) =>
    InterestClass.fromJson(json.decode(str));

String interestClassToJson(InterestClass data) => json.encode(data.toJson());

class InterestClass {
  InterestClass({
    this.data,
    this.meta,
  });

  List<InterestClassData?>? data;
  Meta? meta;

  factory InterestClass.fromJson(Map<String, dynamic> json) => InterestClass(
        data: json["data"] == null
            ? null
            : List<InterestClassData>.from(
                json["data"].map((x) => InterestClassData.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
        "meta": meta?.toJson(),
      };
}

class InterestClassData {
  InterestClassData({
    this.id,
    this.attributes,
  });

  int? id;
  InterestClassAttributes? attributes;

  factory InterestClassData.fromJson(Map<String, dynamic> json) =>
      InterestClassData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : InterestClassAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class InterestClassAttributes {
  InterestClassAttributes(
      {this.title,
      this.type,
      this.targetAge,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.description,
      this.isRecommend,
      this.brand,
      this.mainImage,
      this.classImages,
      this.website,
      this.facebookLink,
      this.instagramLink,
      this.twitterLink,
      this.phoneNumber,
      this.interestClassSaves});

  String? title;
  String? type;
  String? targetAge;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? description;
  bool? isRecommend;
  String? brand;
  MainImage? mainImage;
  MultiImage? classImages;
  String? website;
  String? facebookLink;
  String? instagramLink;
  String? twitterLink;
  String? phoneNumber;
  InterestClassSaves? interestClassSaves;

  factory InterestClassAttributes.fromJson(Map<String, dynamic> json) =>
      InterestClassAttributes(
        title: json["title"],
        type: json["type"],
        targetAge: json["target_age"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        description: json["description"],
        isRecommend: json["is_recommend"],
        brand: json["brand"],
        mainImage: json["main_image"] == null
            ? null
            : MainImage.fromJson(json["main_image"]),
        classImages: json["class_images"] == null
            ? null
            : MultiImage.fromJson(json["class_images"]),
        website: json["website"],
        facebookLink: json["facebook_link"],
        instagramLink: json["instagram_link"],
        twitterLink: json["twitter_link"],
        phoneNumber: json["phone_number"],
        interestClassSaves: json["interest_class_saves"] == null
            ? null
            : InterestClassSaves.fromJson(json["interest_class_saves"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "target_age": targetAge,
        "createdAt": createdAt.toString(),
        "updatedAt": updatedAt.toString(),
        "publishedAt": publishedAt.toString(),
        "description": description,
        "is_recommend": isRecommend,
        "brand": brand == null ? null : brand!,
        "main_image": mainImage?.toJson(),
        "class_images": classImages?.toJson(),
        "website": website,
        "facebook_link": facebookLink,
        "instagram_link": instagramLink,
        "twitter_link": twitterLink,
        "phone_number": phoneNumber,
        "interest_class_saves":
            interestClassSaves == null ? null : interestClassSaves!.toJson(),
      };
}

class InterestClassSaves {
  InterestClassSaves({
    this.data,
  });

  List<InterestClassSavesData?>? data;

  factory InterestClassSaves.fromJson(Map<String, dynamic> json) =>
      InterestClassSaves(
        data: json["data"] == null
            ? null
            : List<InterestClassSavesData>.from(
                json["data"].map((x) => InterestClassSavesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x!.toJson())),
      };
}

class InterestClassSavesData {
  InterestClassSavesData({
    this.id,
    this.attributes,
  });

  int? id;
  InterestClassSavesAttributes? attributes;

  factory InterestClassSavesData.fromJson(Map<String, dynamic> json) =>
      InterestClassSavesData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : InterestClassSavesAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class InterestClassSavesAttributes {
  InterestClassSavesAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.savedBy,
  });

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  UserNoImage? savedBy;

  factory InterestClassSavesAttributes.fromJson(Map<String, dynamic> json) =>
      InterestClassSavesAttributes(
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
            : UserNoImage.fromJson(json["saved_by"]),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "publishedAt": publishedAt!.toIso8601String(),
        "saved_by": savedBy == null ? null : savedBy!.toJson(),
      };
}

class MainImage {
  MainImage({
    this.data,
  });

  MultiImageData? data;

  factory MainImage.fromJson(Map<String, dynamic> json) => MainImage(
        data:
            json["data"] == null ? null : MultiImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class UserNoImage {
  UserNoImage({
    this.data,
  });

  UserData? data;

  factory UserNoImage.fromJson(Map<String, dynamic> json) => UserNoImage(
      data: json["data"] == null ? null : UserData.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.attributes,
  });

  int? id;
  UserAttributes? attributes;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        attributes: UserAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes!.toJson(),
      };
}

class UserAttributes {
  UserAttributes(
      {this.username,
      this.email,
      this.provider,
      this.confirmed,
      this.blocked,
      this.createdAt,
      this.updatedAt,
      this.userType,
      this.grade,
      this.teachingType,
      this.collegeType,
      this.teachingArea,
      this.region,
      this.category,
      this.centerName,
      this.deviceToken});

  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userType;
  String? grade;
  String? teachingType;
  String? collegeType;
  String? teachingArea;
  String? region;
  String? category;
  String? centerName;
  String? deviceToken;

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
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
        userType: json["user_type"],
        grade: json["grade"],
        teachingType: json["teaching_type"],
        collegeType: json["college_type"],
        teachingArea: json["teaching_area"],
        region: json["region"],
        category: json["category"],
        centerName: json["center_name"].toString(),
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "user_type": userType,
        "grade": grade,
        "teaching_type": teachingType,
        "college_type": collegeType,
        "teaching_area": teachingArea,
        "region": region,
        "category": category,
        "center_name": centerName,
        "device_token": deviceToken,
      };
}

// One interest class
SingleInterestClass singleInterestClassFromJson(String str) =>
    SingleInterestClass.fromJson(json.decode(str));

String singleInterestClassToJson(SingleInterestClass data) =>
    json.encode(data.toJson());

class SingleInterestClass {
  SingleInterestClass({
    this.data,
    this.meta,
  });

  InterestClassData? data;
  Meta? meta;

  factory SingleInterestClass.fromJson(Map<String, dynamic> json) =>
      SingleInterestClass(
        data: json["data"] == null
            ? null
            : InterestClassData.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "meta": meta!.toJson(),
      };
}
