import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ServicesRepo {
  static Future<http.Response> getAllServices(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      var url = "${kAPIURL}services?page=$page&limit=$pageSize";

      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});

      return response;
    } catch (err) {
      rethrow;
    }
  }
}
