import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class UserSearchRepo {
  static Future getSearchUsers(
      {required String jwt,
      required String username,
      required String myId,
      required String start,
      required String limit}) async {
    var url =
        "${kAPIURL}users?populate[0]=profile_image&populate[1]=got_searched_by.searched_by&filters[\$and][0][username][\$containsi]=$username&filters[\$and][1][\$or][0][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][users_blocked][blocked_to][id][\$null]=true&start=$start&limit=$limit";
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
