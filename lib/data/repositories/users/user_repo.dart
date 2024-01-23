import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../constant/connection_url.dart';

class UserRepo {
  // load my details
  static Future loadMyDetails({required String jwt}) async {
    String url = "${kAPIURL}users/get-my-details";
    try {
      Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to load my details.");
    }
  }
}
