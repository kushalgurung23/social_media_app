import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:http/http.dart' as http;

class JsonWebTokenRepo {
  static Future<http.Response> generateNewAccessToken() async {
    try {
      String? refreshToken = await UserSecureStorage.getSecuredRefreshToken();
      print(refreshToken.toString() + " is ref token");
      String url = "${kAPIURL}auth/generate-new-access-token";
      http.Response response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $refreshToken"
      });
      return response;
    } on Exception {
      rethrow;
    }
  }
}
