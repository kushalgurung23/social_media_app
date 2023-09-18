import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ChatConversationRepo {
  static Future<http.Response> getAllChatConversation(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      var url = "${kAPIURL}chats?page=$page&limit=$pageSize";

      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      return response;
    } on Exception {
      rethrow;
    }
  }

  static Future<http.Response> getOneChatConversation(
      {required String accessToken,
      required String page,
      required String pageSize,
      required String conversationId}) async {
    try {
      var url = "${kAPIURL}chats/$conversationId?page=$page&limit=$pageSize";

      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      return response;
    } on Exception {
      rethrow;
    }
  }
}
