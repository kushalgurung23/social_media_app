// To parse this JSON data, do
//
//     final loginSuccess = loginSuccessFromJson(jsonString);

import 'dart:convert';

import 'package:c_talent/data/models/user.dart';

LoginSuccess loginSuccessFromJson(String str) =>
    LoginSuccess.fromJson(json.decode(str));

String loginSuccessToJson(LoginSuccess data) => json.encode(data.toJson());

class LoginSuccess {
  String? status;
  UserObject? user;
  String? accessToken;
  String? refreshToken;

  LoginSuccess({
    this.status,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginSuccess.fromJson(Map<String, dynamic> json) => LoginSuccess(
        status: json["status"],
        user: json["user"] == null ? null : UserObject.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user": user?.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
