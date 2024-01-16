import 'dart:convert';

import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ServicesRepo {
  static Future<http.Response> getAllServices(
      {required String accessToken,
      required String page,
      required String pageSize,
      required bool isRecommendedServices}) async {
    try {
      String url = "${kAPIURL}services?page=$page&limit=$pageSize";
      if (isRecommendedServices == true) {
        url += "&is_recommend=1";
      }

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});

      return response;
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.Response> toggleServiceSave(
      {required String accessToken, required String serviceId}) async {
    try {
      String url = "${kAPIURL}services/toggle-save";
      http.Response response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({'service_id': serviceId}));
      return response;
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.Response> getSavedServices(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      String url = "${kAPIURL}services/saved?page=$page&limit=$pageSize";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});
      return response;
    } catch (err) {
      rethrow;
    }
  }
}
