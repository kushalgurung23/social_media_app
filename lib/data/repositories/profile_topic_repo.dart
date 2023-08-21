import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ProfileTopicRepo {
  static Future getOneProfileTopic(
      {required String jwt, required String topicId}) async {
    var url =
        "${kAPIURL}news-posts/$topicId?populate[0]=image&populate[1]=posted_by.profile_image&populate[2]=news_post_likes.liked_by.profile_image&populate[3]=comments.comment_by.profile_image&populate[4]=news_post_saves.saved_by";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch topic.");
    }
  }

  static Future getSelectedUserAllProfileTopic(
      {required String jwt, required String userId}) async {
    var url =
        "${kAPIURL}users/$userId?populate[0]=profile_image&populate[1]=created_post.image&populate[2]=created_post.news_post_likes.liked_by.profile_image&populate[3]=created_post.comments.comment_by.profile_image&populate[4]=created_post.news_post_saves.saved_by";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch all topic.");
    }
  }
}
