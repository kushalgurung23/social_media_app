import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ReportAndBlockRepo {
  static Future<http.Response> reportNewsPost(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}report-news-posts";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to report news posts');
    }
  }

  static Future<http.Response> reportPaperShare(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}report-paper-shares";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to report paper share');
    }
  }

  static Future<http.Response> blockUser(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}user-blocks";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to block user');
    }
  }

  static Future<http.Response> unblockUser(
      {required Map bodyData,
      required String jwt,
      required String userBlockId}) async {
    try {
      var url = "${kAPIURL}user-blocks/$userBlockId";
      var response = await http.delete(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to block user');
    }
  }
}
