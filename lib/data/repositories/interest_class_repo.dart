import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class InterestClassRepo {
  static Future getAllInterestClassCourses(
      {required String jwt,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch interest class courses.");
    }
  }

  static Future getOneInterestClassCourseForSharedInterestClass(
      {required String jwt, required String interestClassId}) async {
    var url =
        "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[id][\$eq]=$interestClassId";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one interest class course");
    }
  }

  static Future getOneUpdatedInterestClassCourse(
      {required String jwt, required String interestClassId}) async {
    var url =
        "${kAPIURL}interest-classes/$interestClassId?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one interest class course");
    }
  }

  static Future getBookmarkInterestClassCourses(
      {required String jwt,
      required String page,
      required String pageSize,
      required String currentUserId}) async {
    var url =
        "${kAPIURL}interest-class-saves?populate[0]=interest_class.main_image&populate[1]=interest_class.class_images&populate[2]=saved_by&filters[saved_by][id][\$eq]=$currentUserId&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch bookmark interest class courses.");
    }
  }

  static Future getAllRecommendedInterestClassCourses(
      {required String jwt,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[is_recommend][\$eq]=true&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch interest class courses.");
    }
  }

  static Future<http.Response> addInterestClassSave(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}interest-class-saves";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to add interest class save');
    }
  }

  static Future<http.Response> removeInterestClassSave(
      {required String jwt, required String interestClassSaveId}) async {
    try {
      var url = "${kAPIURL}interest-class-saves/$interestClassSaveId";
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to remove interest class save');
    }
  }

  // search interest class
  static Future searchInterestClassCourses(
      {required String jwt,
      required String page,
      required String pageSize,
      required String interestClassTitle}) async {
    var url =
        "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[title][\$containsi]=$interestClassTitle&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to search interest class courses.");
    }
  }

  // filter interest class
  static Future filterInterestClassCourses(
      {required String jwt,
      required String page,
      required String pageSize,
      required String? interestClassCategoryType,
      required String? interestClassTargetAge}) async {
    String url;

    if (interestClassCategoryType != null && interestClassTargetAge == null) {
      url =
          "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[type][\$containsi]=$interestClassCategoryType&pagination[page]=$page&pagination[pageSize]=$pageSize";
    } else if (interestClassCategoryType == null &&
        interestClassTargetAge != null) {
      url =
          "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[target_age][\$containsi]=$interestClassTargetAge&pagination[page]=$page&pagination[pageSize]=$pageSize";
    } else {
      url =
          "${kAPIURL}interest-classes?populate[0]=main_image&populate[1]=class_images&populate[2]=interest_class_saves.saved_by&filters[\$and][0][type][\$containsi]=$interestClassCategoryType&filters[\$and][1][target_age][\$containsi]=$interestClassTargetAge&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to filter interest class courses.");
    }
  }
}
