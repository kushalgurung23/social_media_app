import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class FurtherStudiesRepo {
  static Future<http.Response> getStudentPopularNewsPosts(
      {required String myId,
      required String jwt,
      required String page,
      required String pageSize}) async {
    try {
      var url =
          "${kAPIURL}news-posts?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&populate[5]=discuss_comment_counts.visited_by&filters[\$and][0][\$or][0][report_news_posts][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][report_news_posts][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][posted_by][user_type][\$eq]=Student&sort=like_count:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load student popular news posts');
    }
  }

  static Future<http.Response> getOneUpdatedStudentPopularNewsPosts(
      {required String myId,
      required String jwt,
      required String studentNewsPostId}) async {
    try {
      var url =
          "${kAPIURL}news-posts/$studentNewsPostId?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&populate[5]=discuss_comment_counts.visited_by&filters[\$and][0][\$or][0][report_news_posts][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][report_news_posts][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][posted_by][user_type][\$eq]=Student&sort=like_count:desc";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load one updated student popular news posts');
    }
  }

  static Future<http.Response> getParentPopularNewsPosts(
      {required String myId,
      required String jwt,
      required String page,
      required String pageSize}) async {
    try {
      var url =
          "${kAPIURL}news-posts?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&populate[5]=discuss_comment_counts.visited_by&filters[\$and][0][\$or][0][report_news_posts][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][report_news_posts][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][posted_by][user_type][\$eq]=Parent&sort=like_count:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load parent popular news posts');
    }
  }

  static Future<http.Response> getOneUpdatedParentPopularNewsPosts(
      {required String myId,
      required String jwt,
      required String parentNewsPostId}) async {
    try {
      var url =
          "${kAPIURL}news-posts/$parentNewsPostId?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=news_post_saves.saved_by&populate[4]=comments.comment_by.profile_image&populate[5]=discuss_comment_counts.visited_by&filters[\$and][0][\$or][0][report_news_posts][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][report_news_posts][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][posted_by][user_type][\$eq]=Parent&sort=like_count:desc";

      var response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to load one updated parent popular news posts');
    }
  }

  static Future<http.Response> createCommentCount(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}discuss-comment-counts";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception(
          'Unable to create comment count record in discuss comment count collection type');
    }
  }

  static Future<http.Response> updateCommentCount(
      {required Map bodyData,
      required String jwt,
      required String discussCommentId}) async {
    try {
      var url = "${kAPIURL}discuss-comment-counts/$discussCommentId";
      var response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception(
          'Unable to update comment count record in discuss comment count collection type');
    }
  }
}
