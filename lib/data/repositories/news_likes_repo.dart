import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsLikesRepo {
  static Future<http.Response> getAllNewsLikes(
      {required String accessToken,
      required String page,
      required String pageSize,
      required String newsPostId}) async {
    try {
      var url = "${kAPIURL}posts/$newsPostId/likes?page=$page&limit=$pageSize";

      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      return response;
    } on Exception {
      throw Exception('Unable to load news posts');
    }
  }
}
