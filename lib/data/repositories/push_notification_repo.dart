import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class PushNotificationRepo {
  // Sending push notification
  static Future sendPushNotification(
      {required String bodyData, required String jwt}) async {
    try {
      var url = kPushNotificationUrl;
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    } on Exception {
      throw Exception("Unable to send email");
    }
  }

  // Adding notification in database
  static Future addNotification(
      {required Map bodyData, required String jwt}) async {
    var url = "${kAPIURL}notifications";
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));
      return response;
    } on Exception {
      throw Exception("Unable to add new notification.");
    }
  }

  // load follow notification
  static Future loadFollowNotification(
      {required String currentUserId,
      required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    var url =
        "${kAPIURL}notifications?populate[0]=sender.profile_image&filters[\$and][0][receiver][id][\$eq]=$currentUserId&filters[\$and][1][\$or][0][sender][got_blocked_from][blocked_by][id][\$ne]=$currentUserId&filters[\$and][1][\$or][1][sender][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][sender][users_blocked][blocked_to][id][\$ne]=$currentUserId&filters[\$and][2][\$or][1][sender][users_blocked][blocked_to][id][\$null]=true&sort=createdAt:desc&pagination[page]=$pageNumber&pagination[pageSize]=$pageSize";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to add follow notification.");
    }
  }

  static Future getOneUpdatedFollowNotification(
      {required String notificationId,
      required String currentUserId,
      required String jwt}) async {
    var url =
        "${kAPIURL}notifications/$notificationId?populate[0]=sender.profile_image&filters[\$and][0][\$or][0][sender][got_blocked_from][blocked_by][id][\$ne]=$currentUserId&filters[\$and][0][\$or][1][sender][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][1][\$or][0][sender][users_blocked][blocked_to][id][\$ne]=$currentUserId&filters[\$and][1][\$or][1][sender][users_blocked][blocked_to][id][\$null]=true";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to get updated follow notification.");
    }
  }

  static Future getCurrentUserLastFollowNotification(
      {required String currentUserId, required String jwt}) async {
    var url =
        "${kAPIURL}notifications?populate[0]=sender.profile_image&filters[\$and][0][receiver][id][\$eq]=$currentUserId&filters[\$and][1][\$or][0][sender][got_blocked_from][blocked_by][id][\$ne]=$currentUserId&filters[\$and][1][\$or][1][sender][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][sender][users_blocked][blocked_to][id][\$ne]=$currentUserId&filters[\$and][2][\$or][1][sender][users_blocked][blocked_to][id][\$null]=true&pagination[page]=1&pagination[pageSize]=1&sort=createdAt:desc";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to get current user latest follow notification.");
    }
  }

  static Future getUnreadFollowNotification(
      {required String currentUserId, required String jwt}) async {
    var url =
        "${kAPIURL}notifications?filters[\$and][0][receiver][id][\$eq]=$currentUserId&filters[\$and][1][\$or][0][sender][got_blocked_from][blocked_by][id][\$ne]=$currentUserId&filters[\$and][1][\$or][1][sender][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][sender][users_blocked][blocked_to][id][\$ne]=$currentUserId&filters[\$and][2][\$or][1][sender][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][is_read][\$eq]=false";
    try {
      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to get current user latest follow notification.");
    }
  }

  static Future<http.Response> readNotification(
      {required String jwt,
      required Map bodyData,
      required String notificationId}) async {
    try {
      var url = "${kAPIURL}notifications/$notificationId";
      var response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));
      return response;
    } on Exception {
      throw Exception('Unable to read notification');
    }
  }
}
