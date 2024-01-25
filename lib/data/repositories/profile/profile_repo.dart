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

  static Future loadMyFollowings(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url = "${kAPIURL}users/followings?limit=$pageSize&page=$pageNumber";
    try {
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my followings.");
    }
  }

  static Future loadMyFollowers(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url = "${kAPIURL}users/followers?limit=$pageSize&page=$pageNumber";
    try {
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my followers.");
    }
  }
}
