import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsSaveRepo {
  static Future<http.Response> toggleNewsPostSave(
      {required String bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}posts/toggle-save";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);

      return response;
    } catch (err) {
      rethrow;
    }
  }
}
