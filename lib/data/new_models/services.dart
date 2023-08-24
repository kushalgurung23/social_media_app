import 'dart:convert';

import 'package:intl/intl.dart';

Services servicesFromJson(String str) => Services.fromJson(json.decode(str));

String servicesToJson(Services data) => json.encode(data.toJson());

class Services {
  String? status;
  int? page;
  int? limit;
  int? count;
  List<ServiceObject>? services;

  Services({
    this.status,
    this.page,
    this.limit,
    this.count,
    this.services,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
        count: json["count"],
        services: json["services"] == null
            ? []
            : List<ServiceObject>.from(
                json["services"]!.map((x) => ServiceObject.fromJson(x))),
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

class ServiceObject {
  Service? service;

  ServiceObject({
    this.service,
  });

  factory ServiceObject.fromJson(Map<String, dynamic> json) => ServiceObject(
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "service": service?.toJson(),
      };
}

class Service {
  int? id;
  String? price;
  String? title;
  String? website;
  String? category;
  int? isSaved;
  String? location;
  int? isActive;
  DateTime? createdAt;
  String? mainImage;
  DateTime? updatedAt;
  String? description;
  int? isRecommend;
  String? phoneNumber;
  String? twitterLink;
  String? facebookLink;
  String? instagramLink;
  List<ServiceImage>? serviceImages;

  Service({
    this.id,
    this.price,
    this.title,
    this.website,
    this.category,
    this.isSaved,
    this.location,
    this.isActive,
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

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        price: json["price"],
        title: json["title"],
        website: json["website"],
        category: json["category"],
        isSaved: json["is_saved"],
        location: json["location"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["created_at"], true)
                .toLocal(),
        mainImage: json["main_image"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(json["updated_at"], true)
                .toLocal(),
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
        "is_active": isActive,
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
}

class ServiceImage {
  int? id;
  String? url;

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
