import 'package:http/http.dart' as http;
import '../../constant/connection_url.dart';

class ProfilePostsRepo {
  static Future loadMyNewsTopics(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url =
        "${kAPIURL}posts/my-news-posts?limit=$pageSize&page=$pageNumber";
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my topics.");
    }
  }

  static Future loadMyBookmarkTopics(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url =
        "${kAPIURL}posts/my-bookmark-posts?limit=$pageSize&page=$pageNumber";
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my bookmark topics.");
    }
  }

  static Future<http.Response> getAllCreatedPosts(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      var url = "${kAPIURL}posts/my-created-posts?page=$page&limit=$pageSize";

      http.Response response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});

      return response;
    } catch (err) {
      rethrow;
    }
  }
}
