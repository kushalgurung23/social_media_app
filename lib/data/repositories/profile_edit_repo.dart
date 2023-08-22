import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEditRepo {
  static Future editUserWithoutImage(
      {required Map bodyData,
      required String jwt,
      required String profileId}) async {
    var url = "${kAPIURL}users/$profileId";
    try {
      var response = await http.put(Uri.parse(url),
          body: jsonEncode(bodyData),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          });
      return response;
    } on Exception {
      throw Exception("Unable to update parent details.");
    }
  }

  static Future editUserWithImage(
      {required Map bodyData,
      required File? image,
      required String jwt,
      required String profileId,
      required AllImage? userProfileImage,
      required BuildContext context}) async {
    try {
      // Delete old image first
      if (userProfileImage != null) {
        String profileImageId = userProfileImage.id.toString();
        var imageDeleteUrl = "${kAPIURL}upload/files/$profileImageId";
        await http.delete(Uri.parse(imageDeleteUrl), headers: {
          'Authorization': 'Bearer $jwt',
        });
      }
      // upload new user image
      var imageUploadUrl = "${kAPIURL}upload";
      PickedFile imageFile = PickedFile(image!.path);
      // Length
      var imageBytes = await imageFile.readAsBytes();
      int length = imageBytes.length;

      // Stream
      http.ByteStream byteStream = http.ByteStream(imageFile.openRead());
      Stream<List<int>> stream = byteStream.cast();

      var request = http.MultipartRequest('POST', Uri.parse(imageUploadUrl));
      request.headers['Authorization'] = 'Bearer $jwt';
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields["ref"] = "plugin::users-permissions.user";
      request.fields["refId"] = profileId.toString();
      request.fields["field"] = 'profile_image';

      var profileImage = http.MultipartFile('files', stream, length,
          filename: image.path.split('/').last.toString(),
          contentType: MediaType('image', 'png'));
      request.files.add(profileImage);
      var response = await request.send();

      if (response.statusCode == 200 && context.mounted) {
        // Text details upload
        return await editUserWithoutImage(
            bodyData: bodyData, jwt: jwt, profileId: profileId);
      } else {
        return response;
      }
    } on Exception {
      throw Exception("Unable to update user details.");
    }
  }

  static Future updatePassword(
      {required Map bodyData,
      required String jwt,
      required String profileId}) async {
    var url = "${kAPIURL}users/$profileId";
    try {
      var response = await http.put(Uri.parse(url),
          body: jsonEncode(bodyData),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          });
      return response;
    } on Exception {
      throw Exception("Unable to update password.");
    }
  }

  static Future deleteUser(
      {required Map bodyData,
      required String jwt,
      required String profileId}) async {
    var url = "${kAPIURL}users/$profileId";
    try {
      var response = await http.delete(Uri.parse(url),
          body: jsonEncode(bodyData),
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json'
          });
      return response;
    } on Exception {
      throw Exception("Unable to delete user.");
    }
  }
}
