import 'dart:io';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class NewsPostRepo {
  static Future<http.Response> getAllNewsPosts(
      {required String accessToken,
      required String page,
      required String pageSize}) async {
    try {
      var url = "${kAPIURL}posts?page=$page&limit=$pageSize";

      var response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer $accessToken'});

      return response;
    } catch (err) {
      rethrow;
    }
  }

  static Future<http.Response> reportNewsPost(
      {required String bodyData, required String jwt}) async {
    try {
      var url = "${kAPIURL}posts/report";
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: bodyData);
      return response;
    } catch (err) {
      rethrow;
    }
  }

  static Future createNewPostWithoutImage(
      {required String title,
      required String content,
      required String accessJWT}) async {
    const url = "${kAPIURL}posts";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = "Bearer $accessJWT";
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields["title"] = title;
      request.fields["content"] = content;
      var response = await request.send();
      return response;
    } on Exception {
      rethrow;
    }
  }

  static Future createNewPostWithImage(
      {required String title,
      required String content,
      required String accessJWT,
      required List<File> imageList}) async {
    const url = "${kAPIURL}posts";
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = "Bearer $accessJWT";
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields["title"] = title;
      request.fields["content"] = content;
      for (int i = 0; i < imageList.length; i++) {
        // Length
        var imageData = await imageList[i].readAsBytes();
        int length = imageData.length;
        // Stream
        PickedFile imageFile = PickedFile(imageList[i].path);
        http.ByteStream byteStream = http.ByteStream(imageFile.openRead());
        Stream<List<int>> stream = byteStream.cast();
        var postImage = http.MultipartFile('image', stream, length,
            filename: imageList[i].path.split('/').last.toString(),
            contentType: MediaType('image', 'png'));
        request.files.add(postImage);
      }
      var response = await request.send();
      return response;
    } on Exception {
      throw Exception("Unable to create new post.");
    }
  }
}
