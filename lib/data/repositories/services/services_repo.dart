import 'dart:convert';

import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/enum/all.dart';
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

  static Future<http.Response> searchServices(
      {required String accessToken,
      required String page,
      required String pageSize,
      required String? searchKeyword,
      required String? filterValue,
      required ServicesFilterType servicesFilterType}) async {
    try {
      String url = "${kAPIURL}services?";
      if (servicesFilterType == ServicesFilterType.search &&
          searchKeyword != null) {
        url += "search=$searchKeyword&";
      } else if (servicesFilterType == ServicesFilterType.category &&
          filterValue != null) {
        url += "category=$filterValue&";
      }
      url += "page=$page&limit=$pageSize";
      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});
      return response;
    } catch (err) {
      rethrow;
    }
  }
}
