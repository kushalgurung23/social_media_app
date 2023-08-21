import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _securedUserId = 'user_id';
  static const _securedAccessToken = 'access_token';
  static const _securedRefreshToken = 'refresh_token';
  static const _isKeepUserLoggedIn = 'is_keep_user_logged_in';
  static Future secureAndSaveUserDetails(
      {required String userId,
      required String refreshToken,
      required String accessToken,
      required bool isKeepUserLoggedIn}) async {
    await Future.wait([
      _storage.write(key: _securedUserId, value: userId),
      _storage.write(key: _securedAccessToken, value: accessToken),
      _storage.write(key: _securedRefreshToken, value: refreshToken),
      _storage.write(
          key: _isKeepUserLoggedIn, value: jsonEncode(isKeepUserLoggedIn)),
    ]);
  }

  static Future<String?> getSecuredUserId() async {
    return await _storage.read(key: _securedUserId);
  }

  static Future<String?> getSecuredAccessToken() async {
    return await _storage.read(key: _securedAccessToken);
  }

  static Future<String?> getSecuredRefreshToken() async {
    return await _storage.read(key: _securedRefreshToken);
  }

  static Future<bool?> getSecuredIsLoggedInStatus() async {
    final isLoggedInStatus = await _storage.read(key: _isKeepUserLoggedIn);
    return bool.fromEnvironment(
        json.decode(isLoggedInStatus.toString()).toString());
  }

  static Future<void> removeSecuredUserDetails() async {
    await _storage.deleteAll();
  }
}
