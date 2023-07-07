import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsPostRepo {
  static Future<http.Response> getOneUpdateNewsPost(
      {required String jwt, required String newsPostId}) async {
    try {
      var url =
          "${kAPIURL}news-posts/$newsPostId?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&sort=createdAt:desc";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load one updated news posts');
    }
  }

  static Future<http.Response> getAllNewsPosts(
      {required String myId,
      required String jwt,
      required String page,
      required String pageSize}) async {
    try {
      var url =
          "${kAPIURL}news-posts?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&filters[\$and][0][\$or][0][report_news_posts][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][report_news_posts][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load news posts');
    }
  }

  static Future<http.Response> getAllNewsPostsLikes(
      {required String jwt, required String newsPostId}) async {
    try {
      var url =
          "${kAPIURL}news-posts/$newsPostId?populate[0]=news_post_likes.liked_by.profile_image&populate[1]=news_post_likes.liked_by.user_follower.followed_by&sort=createdAt:desc";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load news posts likes');
    }
  }

  static Future<http.Response> removeNewsPostSave(
      {required String jwt, required String newsPostSavedId}) async {
    try {
      var url = "${kAPIURL}news-post-saves/$newsPostSavedId";
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to remove news post save');
    }
  }

  static Future<http.Response> addNewsPostSave(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}news-post-saves";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to add news post save');
    }
  }

  static Future<http.Response> removeNewsPostLike(
      {required String jwt,
      required String newsPostLikeId,
      required Map bodyDataTwo,
      required String postId}) async {
    try {
      var url = "${kAPIURL}news-post-likes/$newsPostLikeId";
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      if (response.statusCode == 200) {
        var url = "${kAPIURL}news-posts/$postId";
        var response = await http.put(Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwt'
            },
            body: jsonEncode(bodyDataTwo));

        return response;
      } else {
        return response;
      }
    } on Exception {
      throw Exception('Unable to remove news post like');
    }
  }

  static Future<http.Response> addNewsPostLike(
      {required Map bodyDataOne,
      required String jwt,
      required Map bodyDataTwo,
      required String postId}) async {
    try {
      var url = "${kAPIURL}news-post-likes";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyDataOne));
      if (response.statusCode == 200) {
        var url = "${kAPIURL}news-posts/$postId";
        var response = await http.put(Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwt'
            },
            body: jsonEncode(bodyDataTwo));

        return response;
      } else {
        return response;
      }
    } on Exception {
      throw Exception('Unable to add news post like');
    }
  }

  static Future<http.Response> togglePostLikes(
      {required Map bodyDataOne,
      required String jwt,
      required String userId,
      required String postId,
      required Map bodyDataTwo}) async {
    try {
      var url = "${kAPIURL}users/$userId";
      var response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyDataOne));
      if (response.statusCode == 200) {
        var url = "${kAPIURL}news-posts/$postId";
        var response = await http.put(Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $jwt'
            },
            body: jsonEncode({"data": bodyDataTwo}));

        return response;
      } else {
        return response;
      }
    } on Exception {
      throw Exception('Unable to toggle like');
    }
  }
}
