import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class LoginRepo {
  static String? _jwt;
  static String? get jwt => _jwt;

  static Future loginUser({required String bodyData}) async {
    try {
      var url = "${kAPIURL}auth/local";
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: bodyData);

      // If login is successful, we fetch all data by passing user id and jwt
      if (response.statusCode == 200) {
        final responseData = await jsonDecode(response.body);
        String newId = (responseData["user"]["id"]).toString();
        _jwt = responseData["jwt"];

        var urlAddress =
            "${kAPIURL}users/$newId?populate[0]=profile_image&populate[1]=user_following.followed_to.profile_image&populate[2]=user_follower.followed_by.profile_image&populate[3]=created_post.news_post_likes.liked_by&populate[4]=created_post.comments.comment_by&populate[5]=news_post_saves.news_post.news_post_likes.liked_by&populate[6]=news_post_saves.news_post.comments.comment_by&populate[7]=news_post_likes.news_post&populate[8]=interest_class_saves.interest_class&populate[9]=paper_share_saves.paper_share&populate[10]=reported_news_posts.news_post&populate[11]=reported_paper_shares.paper_share&populate[12]=users_blocked.blocked_to&populate[13]=got_blocked_from.blocked_by&populate[14]=news_post_saves.news_post.posted_by";

        var finalResponse = await http.get(Uri.parse(urlAddress),
            headers: {'Authorization': 'Bearer $_jwt'});

        return finalResponse;
        // Login unsuccessful
      } else {
        return response;
      }
    } on Exception {
      throw Exception("Unable to login.");
    }
  }

  static Future getLoggedInUserDetails(
      {required String id, required String jwt}) async {
    var url =
        "${kAPIURL}users/$id?populate[0]=profile_image&populate[1]=user_following.followed_to.profile_image&populate[2]=user_follower.followed_by.profile_image&populate[3]=created_post.news_post_likes.liked_by&populate[4]=created_post.comments.comment_by&populate[5]=news_post_saves.news_post.news_post_likes.liked_by&populate[6]=news_post_saves.news_post.comments.comment_by&populate[7]=news_post_likes.news_post&populate[8]=interest_class_saves.interest_class&populate[9]=paper_share_saves.paper_share&populate[10]=reported_news_posts.news_post&populate[11]=reported_paper_shares.paper_share&populate[12]=users_blocked.blocked_to&populate[13]=got_blocked_from.blocked_by&populate[14]=news_post_saves.news_post.posted_by";
    var response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

    return response;
  }
}
