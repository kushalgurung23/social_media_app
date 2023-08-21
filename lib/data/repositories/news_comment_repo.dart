import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class NewsCommentRepo {
  static Future saveNewsComment(
      {required String bodyData, required String jwt}) async {
    var url = "${kAPIURL}comments";

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwt',
          'Content-Type': 'application/json'
        },
        body: bodyData);

    return response;
  }
}
