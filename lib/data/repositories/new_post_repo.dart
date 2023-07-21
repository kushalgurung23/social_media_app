import 'dart:convert';
import 'dart:io';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class NewPostRepo {
  static Future createNewPost(
      {required Map bodyData, required String jwt}) async {
    var url = "${kAPIURL}news-posts";
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwt'
          },
          body: jsonEncode({"data": bodyData}));
      return response;
    } on Exception {
      throw Exception("Unable to create new post.");
    }
  }

  static Future createNewPostWithImage(
      {required Map bodyData,
      required List<File> imageList,
      required String jwt}) async {
    var url = "${kAPIURL}news-posts";
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
        var postImage = http.MultipartFile('files.image', stream, length,
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
