import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewLoginRepo {
  static Future<http.Response> loginUser({required String bodyData}) async {
    try {
      String url = "${kAPIURL}auth/login";
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      throw Exception("Unable to login.");
    }
  }
}
