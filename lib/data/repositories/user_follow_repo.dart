import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class UserFollowRepo {
  static Future<http.Response> removeFollowing(
      {required String jwt, required String userFollowId}) async {
    try {
      var url = "${kAPIURL}user-follows/$userFollowId";
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to remove following');
    }
  }

  static Future<http.Response> addFollowing(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}user-follows";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to add following');
    }
  }
}
