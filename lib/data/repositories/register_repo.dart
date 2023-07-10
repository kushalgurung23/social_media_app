import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class RegisterRepo {
  static Future registerUser({required String bodyData}) async {
    try {
      var url = "${kAPIURL}auth/local/register";
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      throw Exception("Unable to register user.");
    }
  }

  static Future searchDuplicateIdentifier(
      {required String username, required String emailAddress}) async {
    try {
      var url =
          "${kAPIURL}users?filters[\$or][0][username][\$eq]=$username&filters[\$or][1][email][\$eq]=$emailAddress";
      var response = await http.get(Uri.parse(url));
      return response;
    } on Exception {
      throw Exception("Unable to search for duplicate username or email.");
    }
  }

  static Future sendEmailConfirmation({required String bodyData}) async {
    try {
      var url = kEmailRegistrationUrl;
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);
      return response;
    } on Exception {
      throw Exception("Unable to send email");
    }
  }
}
