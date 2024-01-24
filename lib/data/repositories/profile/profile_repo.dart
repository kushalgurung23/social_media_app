import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../constant/connection_url.dart';

class ProfileRepo {
  // load my news topics
  static Future loadMyNewsTopics(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url =
        "${kAPIURL}posts/my-news-posts?limit=$pageSize&page=$pageNumber";
    try {
      Response response = await http
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
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my bookmark topics.");
    }
  }
}
