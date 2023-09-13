import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsPostRepo {
  static Future<http.Response> getAllNewsPosts(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      var url = "${kAPIURL}posts?page=$page&limit=$pageSize";

      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});

      return response;
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.Response> reportNewsPost(
      {required String bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}posts/report";
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

  static Future createNewPostWithoutImage(
      {required String title,
      required String content,
      required String accessJWT}) async {
    final Uri uri = Uri.http(kAPIURL, 'posts');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = "Bearer $accessJWT";
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields["title"] = title;
      request.fields["content"] = content;
      var response = await request.send();
      return response;
    } on Exception {
      rethrow;
    }
  }
}
