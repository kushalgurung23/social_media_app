import 'dart:convert';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class PaperShareRepo {
  static Future getOnePaperShareForSharedLink(
      {required String paperShareId, required String jwt}) async {
    var url =
        "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[id][\$eq]=$paperShareId";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one paper share details.");
    }
  }

  static Future getOneUpdatedPaperShare(
      {required String jwt, required String paperShareId}) async {
    var url =
        "${kAPIURL}paper-shares/$paperShareId?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch one updated paper share's details.");
    }
  }

  static Future getAllPaperShares(
      {required String jwt,
      required String myId,
      required String page,
      required String pageSize}) async {
    var url =
        "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch paper share details.");
    }
  }

  static Future getBookmarkPaperShares(
      {required String jwt,
      required String page,
      required String pageSize,
      required String currentUserId}) async {
    var url =
        "${kAPIURL}paper-share-saves?populate[0]=paper_share.paper_media&populate[1]=paper_share.paper_share_discusses.discussed_by.profile_image&populate[2]=saved_by&filters[\$and][0][\$or][0][paper_share][reports_received][reported_by][id][\$ne]=$currentUserId&filters[\$and][0][\$or][1][paper_share][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][paper_share][posted_by][got_blocked_from][blocked_by][id][\$ne]=$currentUserId&filters[\$and][1][\$or][1][paper_share][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][paper_share][posted_by][users_blocked][blocked_to][id][\$ne]=$currentUserId&filters[\$and][2][\$or][1][paper_share][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][saved_by][id][\$eq]=$currentUserId&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch bookmark paper share details.");
    }
  }

  static Future<http.Response> removePaperShareSave(
      {required String jwt, required String paperShareSavedId}) async {
    try {
      var url = "${kAPIURL}paper-share-saves/$paperShareSavedId";
      var response = await http
          .delete(Uri.parse(url), headers: {'Authorization': 'Bearer $jwt'});

      return response;
    } on Exception {
      throw Exception('Unable to remove paper share save');
    }
  }

  static Future<http.Response> addPaperShareSave(
      {required Map bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}paper-share-saves";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode(bodyData));

      return response;
    } on Exception {
      throw Exception('Unable to add paper share save');
    }
  }

  static Future savePostShareDiscussion(
      {required String bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}paper-share-discusses";

      var response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          },
          body: bodyData);

      return response;
    } on Exception {
      throw Exception('Unable to toggle like/save');
    }
  }

  static Future createPaperShare(
      {required Map bodyData,
      required List<XFile> imageList,
      required String jwt}) async {
    var url = "${kAPIURL}paper-shares";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $jwt';
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields["data"] = jsonEncode(bodyData);

      for (int i = 0; i < imageList.length; i++) {
        // Length
        var imageData = await imageList[i].readAsBytes();
        int length = imageData.length;
        // Stream
        PickedFile imageFile = PickedFile(imageList[i].path);
        http.ByteStream byteStream = http.ByteStream(imageFile.openRead());
        Stream<List<int>> stream = byteStream.cast();
        var postImage = http.MultipartFile('files.paper_media', stream, length,
            filename: imageList[i].path.split('/').last.toString(),
            contentType: MediaType('image', 'png'));
        request.files.add(postImage);
      }
      var response = await request.send();
      return response;
    } on Exception {
      throw Exception("Unable to create new paper share.");
    }
  }

  static Future searchAllPaperShares(
      {required String jwt,
      required String myId,
      required String page,
      required String pageSize,
      required String paperShareContentKeyword}) async {
    var url =
        "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][content][\$containsi]=$paperShareContentKeyword&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to fetch paper share details.");
    }
  }

  static Future filterAllPaperShares(
      {required String jwt,
      required String myId,
      required String page,
      required String pageSize,
      required String? subject,
      required String? level,
      required String? semester}) async {
    String url;
    // subject
    if (subject != null && level == null && semester == null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][subject][\$containsi]=$subject&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // level
    else if (subject == null && level != null && semester == null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][level][\$containsi]=$level&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // semester
    else if (subject == null && level == null && semester != null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][semester][\$containsi]=$semester&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // subject and level
    else if (subject != null && level != null && semester == null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][subject][\$containsi]=$subject&filters[\$and][4][level][\$containsi]=$level&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // subject and semester
    else if (subject != null && level == null && semester != null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][subject][\$containsi]=$subject&filters[\$and][4][semester][\$containsi]=$semester&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // level and semester
    else if (subject == null && level != null && semester != null) {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][level][\$containsi]=$level&filters[\$and][4][semester][\$containsi]=$semester&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }
    // subject level semester
    else {
      url =
          "${kAPIURL}paper-shares?populate[0]=paper_media&populate[1]=paper_share_discusses.discussed_by.profile_image&populate[2]=saved_paper_share.saved_by&filters[\$and][0][\$or][0][reports_received][reported_by][id][\$ne]=$myId&filters[\$and][0][\$or][1][reports_received][reported_by][id][\$null]=true&filters[\$and][1][\$or][0][posted_by][got_blocked_from][blocked_by][id][\$ne]=$myId&filters[\$and][1][\$or][1][posted_by][got_blocked_from][blocked_by][id][\$null]=true&filters[\$and][2][\$or][0][posted_by][users_blocked][blocked_to][id][\$ne]=$myId&filters[\$and][2][\$or][1][posted_by][users_blocked][blocked_to][id][\$null]=true&filters[\$and][3][subject][\$containsi]=$subject&filters[\$and][4][level][\$containsi]=$level&filters[\$and][5][semester][\$containsi]=$semester&sort=createdAt:desc&pagination[page]=$page&pagination[pageSize]=$pageSize";
    }

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $jwt',
      });
      return response;
    } on Exception {
      throw Exception("Unable to filter paper share details.");
    }
  }
}
