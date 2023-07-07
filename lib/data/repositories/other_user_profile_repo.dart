import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class OtherUserProfileRepo {
  static Future getOtherUserProfile(
      {required String jwt, required String profileId}) async {
    var url =
        "${kAPIURL}users/$profileId?populate[0]=profile_image&populate[1]=user_following.followed_to.profile_image&populate[2]=user_follower.followed_by.profile_image&populate[3]=created_post.news_post_likes.liked_by&populate[4]=created_post.comments.comment_by";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch user details.");
    }
  }
}
