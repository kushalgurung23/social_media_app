import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _securedUserId = 'user_id';
  static const _securedAccessToken = 'access_token';
  static const _securedRefreshToken = 'refresh_token';
  static const _isKeepUserLoggedIn = 'is_keep_user_logged_in';
  // static const _userProfilePicture = 'user_profile_picture';
  // static const _securedUsername = 'user_name';

  static Future secureAndSaveUserDetails({
    required String userId,
    // required String currentUsername,
    required String refreshToken,
    required String accessToken,
    required bool isKeepUserLoggedIn,
    // required String? profilePicture
  }) async {
    await Future.wait([
      _storage.write(key: _securedUserId, value: userId),
      _storage.write(key: _securedAccessToken, value: accessToken),
      _storage.write(key: _securedRefreshToken, value: refreshToken),
      _storage.write(
          key: _isKeepUserLoggedIn, value: jsonEncode(isKeepUserLoggedIn)),
      // _storage.write(key: _userProfilePicture, value: profilePicture),
      // _storage.write(key: _securedUsername, value: currentUsername),
    ]);
  }

  static Future setNewAccessToken({required String newAccessToken}) async {
    await _storage.write(key: _securedAccessToken, value: newAccessToken);
  }

  static Future<void> setIsUserLoggedIn(
      {required bool isKeepUserLoggedIn}) async {
    await _storage.write(
        key: _isKeepUserLoggedIn, value: jsonEncode(isKeepUserLoggedIn));
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
    return jsonDecode(isLoggedInStatus.toString());
  }

  // static Future<String?> getSecuredProfilePicture() async {
  //   return await _storage.read(key: _userProfilePicture);
  // }

  // static Future<String?> getSecuredUsername() async {
  //   return await _storage.read(key: _securedUsername);
  // }

  static Future<void> removeSecuredUserDetails() async {
    await _storage.deleteAll();
  }
}
