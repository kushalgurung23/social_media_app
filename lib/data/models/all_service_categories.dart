// To parse this JSON data, do
import 'dart:convert';

AllServiceCategories allServiceCategoriesFromJson(String str) =>
    AllServiceCategories.fromJson(json.decode(str));

String allServiceCategoriesToJson(AllServiceCategories data) =>
    json.encode(data.toJson());

class AllServiceCategories {
  final String? status;
  final List<Category>? categories;

  AllServiceCategories({
    this.status,
    this.categories,
  });

  factory AllServiceCategories.fromJson(Map<String, dynamic> json) =>
      AllServiceCategories(
        status: json["status"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  final int? id;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
