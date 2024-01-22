// To parse this JSON data, do
//
//     final allServices = allServicesFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

AllServices allServicesFromJson(String str) =>
    AllServices.fromJson(json.decode(str));

String allServicesToJson(AllServices data) => json.encode(data.toJson());

class AllServices {
  final String? status;
  final int? page;
  final int? limit;
  final int? count;
  List<ServicePost>? services;

  AllServices({
    this.status,
    this.page,
    this.limit,
    this.count,
    this.services,
  });

  factory AllServices.fromJson(Map<String, dynamic> json) => AllServices(
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
        count: json["count"],
        services: json["services"] == null
            ? []
            : List<ServicePost>.from(
                json["services"]!.map((x) => ServicePost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "limit": limit,
        "count": count,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class ServicePost {
  OneService? service;

  ServicePost({
    this.service,
  });

  factory ServicePost.fromJson(Map<String, dynamic> json) => ServicePost(
        service: json["service"] == null
            ? null
            : OneService.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "service": service?.toJson(),
      };
}

class OneService {
  final int? id;
  final String? price;
  final String? title;
  final String? website;
  final String? category;
  int? isSaved;
  final String? location;
  final DateTime? createdAt;
  final String? mainImage;
  final DateTime? updatedAt;
  final String? description;
  final int? isRecommend;
  final String? phoneNumber;
  final String? twitterLink;
  final String? facebookLink;
  final String? instagramLink;
  final List<ServiceImage>? serviceImages;

  OneService({
    this.id,
    this.price,
    this.title,
    this.website,
    this.category,
    this.isSaved,
    this.location,
    this.createdAt,
    this.mainImage,
    this.updatedAt,
    this.description,
    this.isRecommend,
    this.phoneNumber,
    this.twitterLink,
    this.facebookLink,
    this.instagramLink,
    this.serviceImages,
  });

  factory OneService.fromJson(Map<String, dynamic> json) => OneService(
        id: json["id"],
        price: json["price"],
        title: json["title"],
        website: json["website"],
        category: json["category"],
        isSaved: json["is_saved"],
        location: json["location"],
        createdAt: json["created_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["created_at"], true)
                .toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["updated_at"], true)
                .toLocal(),
        mainImage: json["main_image"],
        description: json["description"],
        isRecommend: json["is_recommend"],
        phoneNumber: json["phone_number"],
        twitterLink: json["twitter_link"],
        facebookLink: json["facebook_link"],
        instagramLink: json["instagram_link"],
        serviceImages: json["service_images"] == null
            ? []
            : List<ServiceImage>.from(
                json["service_images"]!.map((x) => ServiceImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "title": title,
        "website": website,
        "category": category,
        "is_saved": isSaved,
        "location": location,
        "created_at": createdAt?.toIso8601String(),
        "main_image": mainImage,
        "updated_at": updatedAt?.toIso8601String(),
        "description": description,
        "is_recommend": isRecommend,
        "phone_number": phoneNumber,
        "twitter_link": twitterLink,
        "facebook_link": facebookLink,
        "instagram_link": instagramLink,
        "service_images": serviceImages == null
            ? []
            : List<dynamic>.from(serviceImages!.map((x) => x.toJson())),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OneService &&
        id == other.id &&
        title == other.title &&
        phoneNumber == other.phoneNumber &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      phoneNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

class ServiceImage {
  final int? id;
  final String? url;

  ServiceImage({
    this.id,
    this.url,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) => ServiceImage(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
