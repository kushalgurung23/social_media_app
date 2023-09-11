import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class RegisterRepo {
  static Future<http.Response> registerUser({required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/register";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      rethrow;
    }
  }

  static Future<http.Response> verifyEmail({required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/verify-email";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      rethrow;
    }
  }
}
