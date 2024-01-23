import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:c_talent/data/constant/color_constant.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/main.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:c_talent/presentation/views/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/login_success.dart';
import '../../data/repositories/users/user_repo.dart';

class MainScreenProvider extends ChangeNotifier {
  // String? currentUserId,
  //     currentAccessToken,
  //     currentProfilePicture,
  //     currentUsername;
  bool? isKeepUserLoggedIn;

  // THIS OBJECT WILL STORE LOGGED IN USER DETAILS
  late LoginSuccess _loginSuccess;
  LoginSuccess get loginSuccess => _loginSuccess;

  StreamController<LoginSuccess> loginSuccessStreamController =
      BehaviorSubject<LoginSuccess>();

  void saveUserLoginDetails(
      {required LoginSuccess loginSuccess, required bool isKeepUserLoggedIn}) {
    this.isKeepUserLoggedIn = isKeepUserLoggedIn;
    _loginSuccess = loginSuccess;
    // this.currentUserId = currentUserId;
    // this.currentAccessToken = currentAccessToken;
    // this.currentProfilePicture = currentProfilePicture;
    // currentUsername = username;
  }

  void setNewAccessToken({required String newAccessToken}) {
    // currentAccessToken = newAccessToken;
    _loginSuccess.accessToken = newAccessToken;
  }

  void removeUserLoginDetails() {
    isKeepUserLoggedIn = null;
    _loginSuccess = LoginSuccess();
    // currentUserId = null;
    // currentAccessToken = null;
    // currentProfilePicture = null;
    // currentUsername = null;
  }

  void initial() async {
    try {
      await Firebase.initializeApp();
      // if user is already logged in
      bool isLogin =
          await UserSecureStorage.getSecuredIsLoggedInStatus() ?? false;
      if (navigatorKey.currentContext != null) {
        // THIS WILL ALLOW USER TO REFRESH ACCESS TOKEN WHEN THEY RE-LOGIN
        // Refresh access token allowed once after re-login.
        Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false)
            .setCanRefreshToken(canRefreshingToken: true);
      }
      if (isLogin) {
        isKeepUserLoggedIn = isLogin;
        // currentUserId = await UserSecureStorage.getSecuredUserId() ?? '';
        // currentProfilePicture =
        //     await UserSecureStorage.getSecuredProfilePicture();
        // currentUsername = await UserSecureStorage.getSecuredUsername();

        // the following two sharedPreferences are set to false, because if it is true notification badge won't be popped
        if (navigatorKey.currentContext != null) {
          await getMyDetails();
          Provider.of<BottomNavProvider>(navigatorKey.currentContext!,
                  listen: false)
              .setBottomIndex(index: 0, context: navigatorKey.currentContext!);
          navigatorKey.currentState?.pushReplacementNamed(HomeScreen.id);
        }
      } else {
        removeUserLoginDetails();
        navigatorKey.currentState?.pushReplacementNamed(LoginScreen.id);
      }
      notifyListeners();
    } on SocketException {
      EasyLoading.showInfo(
          "Sorry, an error occurred. Please restart the application.",
          dismissOnTap: false,
          duration: const Duration(seconds: 10));
      return;
    } catch (e) {
      EasyLoading.showInfo(
          "Sorry, an error occurred. Please restart the application.\nError: $e",
          dismissOnTap: false,
          duration: const Duration(seconds: 10));
    }
  }

  Future<void> getMyDetails() async {
    String accessToken = await UserSecureStorage.getSecuredAccessToken() ?? '';
    Response response = await UserRepo.loadMyDetails(jwt: accessToken);
    if (response.statusCode == 200) {
      _loginSuccess = loginSuccessFromJson(response.body);
      loginSuccessStreamController.sink.add(_loginSuccess);
      // THIS API DOES NOT RETURN ACCESS TOKEN
      _loginSuccess.accessToken = accessToken;
      notifyListeners();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (navigatorKey.currentContext != null &&
          navigatorKey.currentContext!.mounted) {
        bool isTokenRefreshed = await Provider.of<AuthProvider>(
                navigatorKey.currentContext!,
                listen: false)
            .refreshAccessToken(context: navigatorKey.currentContext!);
        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true) {
          return getMyDetails();
        } else {
          await Provider.of<DrawerProvider>(navigatorKey.currentContext!,
                  listen: false)
              .logOut(context: navigatorKey.currentContext!);
          return;
        }
      }
    } else {
      if (navigatorKey.currentContext != null &&
          navigatorKey.currentContext!.mounted) {
        // translate
        EasyLoading.showInfo('Please restart the application',
            dismissOnTap: false, duration: const Duration(seconds: 15));
      }
      return;
    }
  }

  Map<String, String> getReportOptionList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).itsSpam: "It's spam",
      AppLocalizations.of(context).nudityOrSexualActivity:
          "Nudity or sexual activity",
      AppLocalizations.of(context).hateSpeech: "Hate speech",
      AppLocalizations.of(context).falseInformation: "False information",
      AppLocalizations.of(context).bullyingOrHarassment:
          "Bullying or harassment",
      AppLocalizations.of(context).scamOrFraud: "Scam or fraud",
      AppLocalizations.of(context).violenceOrDangerousOrganizations:
          "Violence or dangerous organizations",
      AppLocalizations.of(context).intellectualPropertyViolation:
          "Intellectual property violation",
      AppLocalizations.of(context).saleOfIllegalOrRegulatedGoods:
          "Sale of illegal or regulated goods",
      AppLocalizations.of(context).suicideOrSelfInjury:
          "Suicide or self-injury",
      AppLocalizations.of(context).other: "Other",
    };
  }

  void showSnackBar(
      {required BuildContext context,
      required String content,
      required Color backgroundColor,
      required Color contentColor}) {
    final snackBar = SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: backgroundColor,
        onVisible: () {},
        behavior: SnackBarBehavior.fixed,
        content: Text(
          content,
          style: TextStyle(
            color: contentColor,
            fontFamily: kHelveticaMedium,
            fontSize: SizeConfig.defaultSize * 1.6,
          ),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    notifyListeners();
  }

  String convertDateTimeToAgo(DateTime input, BuildContext context) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inSeconds < 60) {
      return AppLocalizations.of(context).justNow;
    } else if (diff.inSeconds >= 60 && diff.inMinutes < 2) {
      return '${diff.inMinutes} ${AppLocalizations.of(context).minuteAgo}';
    } else if (diff.inMinutes >= 2 && diff.inMinutes < 60) {
      return '${diff.inMinutes} ${AppLocalizations.of(context).minutesAgo}';
    } else if (diff.inMinutes >= 60 && diff.inHours < 2) {
      return '${diff.inHours} ${AppLocalizations.of(context).hourAgo}';
    } else if (diff.inHours >= 2 && diff.inHours < 24) {
      return '${diff.inHours} ${AppLocalizations.of(context).hoursAgo}';
    } else if (diff.inHours >= 24 && diff.inDays < 2) {
      return '${diff.inDays} ${AppLocalizations.of(context).dayAgo}';
    } else if (diff.inDays >= 2 && diff.inDays <= 6) {
      return '${diff.inDays} ${AppLocalizations.of(context).daysAgo}';
    } else {
      return (DateFormat.yMMMd().format(input)).toString();
    }
  }

  // PACKAGE INFO
  // CFBundleDisplayName on iOS, application/label on Android

  String? _appName;
  String? get appName => _appName;

  // bundleIdentifier on iOS, getPackageName on Android
  String? _packageName;
  String? get packageName => _packageName;

  // CFBundleShortVersionString on iOS, versionName on Android
  String? _version;
  String? get version => _version;

  // CFBundleVersion on iOS, versionCode on Android
  String? _buildNumber;
  String? get buildNumber => _buildNumber;

  void loadAppPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    notifyListeners();
  }

  // IMAGE COMPRESS
  Future<File?> compressImage(File image) async {
    final imageName = image.absolute.path.split('/').last.toString();
    final result = await FlutterImageCompress.compressWithFile(
        image.absolute.path,
        quality: 60);
    if (result != null) {
      Uint8List imageInUnit8List = result; // store unit8List image here ;
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/$imageName').create();
      file.writeAsBytesSync(imageInUnit8List);
      return file;
    } else {
      return null;
    }
  }

  Future<List<File>> compressAllImage(
      {required List<XFile?> imageFileList}) async {
    List<File> compressedPostImages = [];
    // Compressing each image
    for (int i = 0; i < imageFileList.length; i++) {
      if (imageFileList[i] == null) {
        continue;
      }
      final imageFile = File(imageFileList[i]!.path);

      final compressedImage = await compressImage(imageFile);
      if (compressedImage != null) {
        compressedPostImages.add(compressedImage);
      }
    }
    return compressedPostImages;
  }

  void showCustomAlertDialog(
      {required BuildContext context,
      required String title,
      required String description,
      required String okButtonText,
      required VoidCallback onOkClick,
      required bool isOneButton,
      required String? cancelButtonText,
      Color backgroundColor = kPrimaryColor,
      required VoidCallback? onCancelClick}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2,
                    vertical: SizeConfig.defaultSize * 2),
                titlePadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2,
                    vertical: SizeConfig.defaultSize * 2),
                title: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: kHelveticaMedium,
                      fontSize: SizeConfig.defaultSize * 1.8),
                ),
                content: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.8),
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  isOneButton == true
                      ? const SizedBox()
                      : TextButton(
                          onPressed: onCancelClick,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize,
                                vertical: SizeConfig.defaultSize * 0.5),
                            child: Text(
                              cancelButtonText.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.defaultSize * 1.8,
                                  fontFamily: kHelveticaRegular),
                            ),
                          ),
                        ),
                  ElevatedButton(
                      onPressed: onOkClick,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize,
                            vertical: SizeConfig.defaultSize * 0.5),
                        child: Text(
                          okButtonText,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.defaultSize * 1.8,
                              fontFamily: kHelveticaRegular),
                        ),
                      )),
                ],
              ));
        });
      },
    );
  }
}
