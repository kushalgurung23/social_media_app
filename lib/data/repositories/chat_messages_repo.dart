import 'dart:convert';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;

class ChatMessagesRepo {
  static Future getCurrentUserAllConversation(
      {required String jwt,
      required String currentUserId,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}conversations?populate[0]=first_user.profile_image&populate[1]=second_user.profile_image&populate[2]=chat_messages.sender&populate[3]=chat_messages.receiver&filters[\$or][0][first_user][id][\$eq]=$currentUserId&filters[\$or][1][second_user][id][\$eq]=$currentUserId&pagination[page]=$page&pagination[pageSize]=$pageSize&sort=last_text_at:desc";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch all user conversations");
    }
  }

  // when we update chat message while onTap
  static Future getOneUpdatedCurrentUserConversation(
      {required String jwt, required String conversationId}) async {
    var url =
        "${kAPIURL}conversations/$conversationId?populate[0]=first_user.profile_image&populate[1]=second_user.profile_image&populate[2]=chat_messages.sender&populate[3]=chat_messages.receiver";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one updated user conversations");
    }
  }

  static Future getOneSelectedUserConversation(
      {required String jwt,
      required String currentUserId,
      required String otherUserId}) async {
    var url =
        "${kAPIURL}conversations?populate[0]=first_user.profile_image&populate[1]=second_user.profile_image&populate[2]=chat_messages.sender&populate[3]=chat_messages.receiver&filters[\$and][0][first_user][id][\$eq]=$currentUserId&filters[\$and][1][second_user][id][\$eq]=$otherUserId&filters[\$and][0][first_user][id][\$eq]=$otherUserId&filters[\$and][1][second_user][id][\$eq]=$currentUserId&sort=last_text_at:desc";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch selected user conversations");
    }
  }

  static Future startANewConversation(
      {required Map bodyData, required String jwt}) async {
    var url = "${kAPIURL}conversations";
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode({"data": bodyData}));
      return response;
    } on Exception {
      throw Exception("Unable to create new conversation");
    }
  }

  static Future<http.Response> deleteConversation(
      {required String conversationId, required String jwt}) async {
    var url = "${kAPIURL}conversations/$conversationId";
    try {
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});
      return response;
    } on Exception {
      throw Exception("Unable to delete conversation");
    }
  }

  static Future updateLastReadMessage(
      {required Map bodyData,
      required String jwt,
      required String conversationId}) async {
    var url = "${kAPIURL}conversations/$conversationId";
    try {
      var response = await http.put(Uri.parse(url),
          body: jsonEncode(bodyData),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          });
      return response;
    } on Exception {
      throw Exception("Unable to update last read message.");
    }
  }
}
