import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../constant/connection_url.dart';

class PromotionRepo {
  // load push notification
  static Future loadAllPromotions(
      {required String jwt,
      required String pageNumber,
      required String pageSize}) async {
    String url = "${kAPIURL}promotions?page=$pageNumber&limit=$pageSize";
    try {
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load promotions.");
    }
  }
}
