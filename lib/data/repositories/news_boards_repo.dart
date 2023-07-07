import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsBoardsRepo {
  static Future getAllNewsBoards(
      {required String jwt,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}news-boards?populate[0]=leading_image&populate[1]=first_image&populate[2]=second_image&populate[3]=third_image&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch news boards details.");
    }
  }

  static Future getOneNewsBoardFromSharedLink(
      {required String jwt, required String newsBoardId}) async {
    var url =
        "${kAPIURL}news-boards?populate[0]=leading_image&populate[1]=first_image&populate[2]=second_image&populate[3]=third_image&filters[id][\$eq]=$newsBoardId";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one news board details.");
    }
  }
}
