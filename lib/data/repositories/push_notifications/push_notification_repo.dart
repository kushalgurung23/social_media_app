import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../constant/connection_url.dart';

class PushNotificationRepo {
  // Send push notification
  static Future sendPushNotification(
      {required String bodyData, required String jwt}) async {
    try {
      String url = "${kAPIURL}push-notifications";
      Response response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    } on Exception {
      throw Exception("Unable to send push notification");
    }
  }

  // load push notification
  static Future loadPushNotification(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url =
        "${kAPIURL}push-notifications?page=$pageNumber&limit=$pageSize";
    try {
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load push notifications.");
    }
  }

  static Future readPushNotification(
      {required String jwt, required String notificationId}) async {
    String url = "${kAPIURL}push-notifications/$notificationId";
    try {
      Response response = await http
          .patch(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to read push notification.");
    }
  }
}
