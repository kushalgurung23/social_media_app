import 'dart:convert';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class DeviceTokenRepo {
  static Future updateDeviceToken(
      {required Map bodyData,
      required String jwt,
      required String userId}) async {
    var url = "${kAPIURL}users/$userId";
    try {
      var response = await http.put(Uri.parse(url),
          body: jsonEncode(bodyData),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          });
      return response;
    } on Exception {
      throw Exception("Unable to update device token.");
    }
  }
}
