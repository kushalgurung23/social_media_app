import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordRepo {
  static Future<http.Response> sendForgotPasswordCode(
      {required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/forgot-password";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      rethrow;
    }
  }

  static Future<http.Response> verifyForgotPasswordCode(
      {required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/check-password-forgot-token";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      rethrow;
    }
  }

  static Future<http.Response> resetNewPassword(
      {required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/reset-password";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      rethrow;
    }
  }
}
