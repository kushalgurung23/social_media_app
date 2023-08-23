import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsCommentRepo {
  static Future<http.Response> saveNewsComment(
      {required String bodyData, required String jwt}) async {
    var url = "${kAPIURL}comments";

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json'
        },
        body: bodyData);

    return response;
  }

  static Future<http.Response> getAllNewsComments(
      {required String accessToken,
      required String page,
      required String pageSize,
      required String newsPostId}) async {
    try {
      var url =
          "${kAPIURL}posts/$newsPostId/comments?page=$page&limit=$pageSize";

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
