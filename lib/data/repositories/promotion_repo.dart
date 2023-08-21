import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class PromotionRepo {
  static Future getAllPromotions(
      {required String jwt,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}promotions?populate=image&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch promotions.");
    }
  }
}
