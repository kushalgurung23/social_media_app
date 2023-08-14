import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/user_follow_enum.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/data/repositories/other_user_profile_repo.dart';
import 'package:spa_app/data/repositories/profile_edit_repo.dart';
import 'package:spa_app/data/repositories/push_notification_repo.dart';
import 'package:spa_app/data/repositories/report_news_post_repo.dart';
import 'package:spa_app/data/repositories/user_follow_repo.dart';
import 'package:spa_app/logic/providers/bottom_nav_provider.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:spa_app/presentation/views/login_screen.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileProvider extends ChangeNotifier {
  final format = DateFormat('yyyy-MM-dd');
  GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  late TextEditingController profileTopicTextEditingController;
  late SharedPreferences sharedPreferences;

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  late TextEditingController userNameTextController,
      emailTextController,
      userTypeTextController,
      regDateTextController,
      oldPasswordTextController,
      newPasswordTextController,
      confirmNewPasswordTextController;

  String? profileImage;

  late final MainScreenProvider mainScreenProvider;

  ProfileProvider({required this.mainScreenProvider}) {
    initial();
    super.notifyListeners();
    profileTopicTextEditingController = TextEditingController();
    userNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    userTypeTextController = TextEditingController();
    regDateTextController = TextEditingController();
    oldPasswordTextController = TextEditingController();
    newPasswordTextController = TextEditingController();
    confirmNewPasswordTextController = TextEditingController();
    setUserDetails();
  }

  // This method will update all saved user details
  setUserDetails() {
    if (mainScreenProvider.currentUser != null) {
      profileImage = mainScreenProvider.currentUser!.profileImage == null
          ? 'null'
          : mainScreenProvider.currentUser!.profileImage!.url!;
      userNameTextController.text = mainScreenProvider.currentUser!.username!;
      userTypeTextController.text = mainScreenProvider.currentUser!.userType!;
      regDateTextController.text = format.format(DateTime.parse(
          mainScreenProvider.currentUser!.createdAt!.toString()));
      emailTextController.text = mainScreenProvider.currentUser!.email!;
      notifyListeners();
    }
  }

  int selectedProfileTopicIndex = 0;
  int selectedBookmarkedTopicIndex = 0;
  int selectedOtherProfileTopicIndex = 0;

  void changeSelectedProfileTopic(
      {required bool isAdd, required BuildContext context}) {
    if (isAdd) {
      selectedProfileTopicIndex++;
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedProfileTopicIndex >= 1) {
        selectedProfileTopicIndex--;
      }
    }
    scrollToItemLastTopic(context: context);
    notifyListeners();
  }

  void changeBookmarkedTopic(
      {required bool isAdd, required BuildContext context}) {
    if (isAdd) {
      selectedBookmarkedTopicIndex++;
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedBookmarkedTopicIndex >= 1) {
        selectedBookmarkedTopicIndex--;
      }
    }
    scrollToItemBookmarkedTopic(context: context);
    notifyListeners();
  }

  // Scrolling to top while changing listview in last topic container
  Future scrollToItemLastTopic({required BuildContext context}) async {
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 500));
  }

  // Scrolling to top while changing listview in bookmarked topic container
  Future scrollToItemBookmarkedTopic({required BuildContext context}) async {
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 500));
  }

  void resetTopicSelectedIndex() {
    if (selectedProfileTopicIndex != 0) {
      selectedProfileTopicIndex = 0;
    }
    if (selectedBookmarkedTopicIndex != 0) {
      selectedBookmarkedTopicIndex = 0;
    }
    notifyListeners();
  }

  void resetOtherUserLastTopicIndex() {
    if (selectedOtherProfileTopicIndex != 0) {
      selectedOtherProfileTopicIndex = 0;
    }
    notifyListeners();
  }

  void changeSelectedOtherProfileTopic(
      {required bool isAdd, required BuildContext context}) async {
    if (isAdd) {
      selectedOtherProfileTopicIndex++;
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedOtherProfileTopicIndex >= 1) {
        selectedOtherProfileTopicIndex--;
      }
    }
    otherProfileScroll(context: context);
    notifyListeners();
  }

  Future otherProfileScroll({required BuildContext context}) async {
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 500));
  }

  bool toggleFollowOnProcess = false;
  Future<void> toggleUserFollow(
      {required UserFollowSource userFollowSource,
      String? newsPostId,
      StreamController<User>? otherUserStreamController,
      required String? userFollowId,
      required int otherUserId,
      required String? otherUserDeviceToken,
      required BuildContext context,
      required bool setLikeSaveCommentFollow}) async {
    if (toggleFollowOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleFollowOnProcess == false) {
      toggleFollowOnProcess = true;
      Response response;

      String jwt = sharedPreferences.getString('jwt') ?? 'null';
      String myId = sharedPreferences.getString('id') ?? 'null';
      String notificationAction = '';
      if (mainScreenProvider.followingIdList.contains(otherUserId) &&
          userFollowId != null) {
        notificationAction = 'unfollow';
        mainScreenProvider.followingIdList.remove(otherUserId);
        response = await UserFollowRepo.removeFollowing(
            userFollowId: userFollowId, jwt: jwt);
      } else {
        notificationAction = 'follow';
        mainScreenProvider.followingIdList.add(otherUserId);
        Map bodyData = {
          "data": {"followed_to": otherUserId.toString(), "followed_by": myId}
        };
        response =
            await UserFollowRepo.addFollowing(bodyData: bodyData, jwt: jwt);
      }
      notifyListeners();

      if (response.statusCode == 200) {
        // if user follow/unfollow is done from news post liked screen, update will be made there first
        if (userFollowSource == UserFollowSource.newsLikedScreen &&
            newsPostId != null &&
            context.mounted) {
          Provider.of<NewsAdProvider>(context, listen: false)
              .getNewsPostLikes(newsPostId: newsPostId, context: context);
          notifyListeners();
        } else if (userFollowSource == UserFollowSource.otherUserScreen &&
            otherUserStreamController != null) {
          getOtherUserProfile(
              otherUserId: otherUserId.toString(),
              context: context,
              otherUserStreamController: otherUserStreamController);
          notifyListeners();
        }
        if (context.mounted) {
          await Future.wait([
            mainScreenProvider.updateAndSetUserDetails(
                context: context,
                setLikeSaveCommentFollow: setLikeSaveCommentFollow)
          ]);
        }
        notifyListeners();
        // sending push notification if device token of receiver user is not null.
        // if null, we can assume they have logged out of the app
        if (otherUserDeviceToken != null || otherUserDeviceToken != '') {
          if (context.mounted) {
            await mainScreenProvider.sendFollowPushNotification(
                notificationAction: notificationAction,
                receiverUserId: otherUserId.toString(),
                receiverUserDeviceToken: otherUserDeviceToken,
                context: context,
                initiatorUsername: mainScreenProvider.userName.toString());
          }
        }
        // Add notification in database
        Map notificationBodyData = {
          "data": {
            "sender": mainScreenProvider.userId.toString(),
            "receiver": otherUserId.toString(),
            "type": notificationAction
          }
        };
        Response notificationResponse =
            await PushNotificationRepo.addNotification(
                bodyData: notificationBodyData, jwt: jwt);
        if (notificationResponse.statusCode == 200) {
          // SUCCESS
          toggleFollowOnProcess = false;
          notifyListeners();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          toggleFollowOnProcess = false;
          notifyListeners();
          if (context.mounted) {
            EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
                dismissOnTap: false, duration: const Duration(seconds: 4));
            Provider.of<DrawerProvider>(context, listen: false)
                .removeCredentials(context: context);
            return;
          }
        } else {
          toggleFollowOnProcess = false;
          notifyListeners();
          throw Exception(
              'notification addition unsuccessful${notificationResponse.statusCode}');
        }
        toggleFollowOnProcess = false;
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        toggleFollowOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        toggleFollowOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).tryAgainLater,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        }
      }
    }
    toggleFollowOnProcess = false;
    notifyListeners();
  }

  String getLike({required int likeCount, required BuildContext context}) {
    if (likeCount == 1) {
      return "1 ${AppLocalizations.of(context).like}";
    } else if (likeCount <= 3) {
      return "$likeCount ${AppLocalizations.of(context).likes}";
    } else if (likeCount == 4) {
      return "+${likeCount - 3} ${AppLocalizations.of(context).like}";
    } else {
      return "+${likeCount - 3} ${AppLocalizations.of(context).likes}";
    }
  }

  String? gender;
  List<String> typeList = ['Parent', 'Student', 'Tutor', 'Center'];

  void setGender({required String newValue}) {
    gender = newValue;
    notifyListeners();
  }

  String? validateUserName(
      {required String value, required BuildContext context}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return 'White spaces are not allowed for username';
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterUsername;
    } else if (value.trim().length < 6) {
      return 'Enter at least 6 characters';
    } else if (value.length >= 51) {
      return 'User name cannot have more than 50 characters';
    } else {
      return null;
    }
  }

  String? validatePhoneNumber(
      {required String value, required BuildContext context}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterPhoneNumber;
    } else if (value.length != 8) {
      return AppLocalizations.of(context).enter8DigitPhoneNum;
    } else {
      return null;
    }
  }

  String? validateEmail(
      {required String value, required BuildContext context}) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value)) {
      return AppLocalizations.of(context).enterValidEmail;
    } else {
      return null;
    }
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

  // Navigate back from profile edit screen
  Future goBackFromProfileEdit({required BuildContext context}) async {
    if (image != null) {
      image = null;
    }
    await setUserDetails();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  User? _otherUser;
  User? get otherUser => _otherUser;

  Future<void> getOtherUserProfile(
      {required String otherUserId,
      required BuildContext context,
      required StreamController<User> otherUserStreamController}) async {
    final response = await OtherUserProfileRepo.getOtherUserProfile(
        jwt: sharedPreferences.getString('jwt')!, profileId: otherUserId);
    if (response.statusCode == 200) {
      if (!otherUserStreamController.isClosed) {
        User? user = userFromJson(response.body);
        for (int i = 0;
            i < mainScreenProvider.reportedNewsPostidList.length;
            i++) {
          if (user.createdPost != null) {
            user.createdPost!.removeWhere((element) =>
                element != null &&
                element.id.toString() ==
                    mainScreenProvider.reportedNewsPostidList[i].toString());
          }
        }
        _otherUser = user;
        if (_otherUser != null) {
          otherUserStreamController.sink.add(_otherUser!);
        } else {
          if (context.mounted) {
            showSnackBar(
                context: context,
                content: AppLocalizations.of(context).usersCouldNotLoad,
                contentColor: Colors.white,
                backgroundColor: Colors.red);
          }
        }
      }
      notifyListeners();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      if (context.mounted) {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).usersCouldNotLoad,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
  }

  void removeReportOtherUserProfile(
      {required String newsPostId,
      required StreamController otherUserStreamController,
      required BuildContext context}) {
    if (_otherUser != null && !otherUserStreamController.isClosed) {
      _otherUser!.createdPost!.removeWhere(
          (element) => element != null && element.id.toString() == newsPostId);
      if (_otherUser!.createdPost!.length <= 6) {
        Provider.of<ProfileProvider>(context, listen: false)
            .selectedOtherProfileTopicIndex = 0;
        notifyListeners();
      }
      otherUserStreamController.sink.add(_otherUser!);

      notifyListeners();
    }
  }

  void removeBlockOtherUserProfile(
      {required String otherUserId,
      required StreamController otherUserStreamController,
      required BuildContext context}) {
    if (_otherUser != null && !otherUserStreamController.isClosed) {
      _otherUser!.createdPost!.removeWhere((element) =>
          element != null &&
          element.postedBy != null &&
          element.postedBy!.id.toString() == otherUserId);
      if (_otherUser!.createdPost!.length <= 6) {
        Provider.of<ProfileProvider>(context, listen: false)
            .selectedOtherProfileTopicIndex = 0;
        notifyListeners();
      }
      otherUserStreamController.sink.add(_otherUser!);

      notifyListeners();
    }
  }

  bool isUpdateClick = false;

  void turnOffUpdateLoading() {
    if (isUpdateClick == true) {
      isUpdateClick = false;

      notifyListeners();
    }
  }

  void turnOnUpdateLoading() {
    if (isUpdateClick == false) {
      isUpdateClick = true;
      notifyListeners();
    }
  }

  Future<void> updateUserDetails({required BuildContext context}) async {
    turnOnUpdateLoading();
    Map bodyData = {
      'username': userNameTextController.text,
      'user_type': userTypeTextController.text,
    };

    late Response editResponse;
    if (image == null) {
      editResponse = await ProfileEditRepo.editUserWithoutImage(
          bodyData: bodyData,
          jwt: sharedPreferences.getString('jwt')!,
          profileId: sharedPreferences.getString('id')!);
    } else {
      editResponse = await ProfileEditRepo.editUserWithImage(
          userProfileImage: mainScreenProvider.currentUser!.profileImage,
          bodyData: bodyData,
          image: image,
          jwt: sharedPreferences.getString('jwt')!,
          context: context,
          profileId: sharedPreferences.getString('id')!);
    }

    if (editResponse.statusCode == 200 && context.mounted) {
      await Future.wait([
        Provider.of<NewsAdProvider>(context, listen: false)
            .updateAllNewsPosts(context: context),
        setNewUsername(),
        mainScreenProvider.finalizeUpdate(
            context: context,
            userName: userNameTextController.text,
            userType: userTypeTextController.text)
      ]);
      if (context.mounted) {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).updatedSuccessfully,
            backgroundColor: const Color(0xFFA08875),
            contentColor: Colors.white);
        goBackFromProfileEdit(context: context);
      }
      turnOffUpdateLoading();
    } else if (editResponse.statusCode == 401 ||
        editResponse.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else if (editResponse.statusCode == 400 &&
        (jsonDecode(editResponse.body))["error"]["message"] ==
            "email must be a valid email") {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).enterValidEmail,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
    turnOffUpdateLoading();
  }

  //For keeping username in login text field if remember me is clicked
  Future<void> setNewUsername() async {
    sharedPreferences.setString(
        'login_identifier', userNameTextController.text);
  }

  bool isPasswordChangeButtonClick = false;

  void removePasswordChangeLoader() {
    if (isPasswordChangeButtonClick == true) {
      isPasswordChangeButtonClick = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void showPasswordChangeLoader() {
    if (isPasswordChangeButtonClick == false) {
      isPasswordChangeButtonClick = true;
      notifyListeners();
    }
  }

  // password update
  Future<void> updatePassword({required BuildContext context}) async {
    showPasswordChangeLoader();
    Map bodyData = {
      'password': confirmNewPasswordTextController.text,
    };

    final editResponse = await ProfileEditRepo.updatePassword(
        bodyData: bodyData,
        jwt: sharedPreferences.getString('jwt')!,
        profileId: sharedPreferences.getString('id')!);

    if (editResponse.statusCode == 200 && context.mounted) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).passwordChanged,
          backgroundColor: const Color(0xFFA08875),
          contentColor: Colors.white);
      setNewPassword(context: context);
    } else if (editResponse.statusCode == 401 ||
        editResponse.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
    removePasswordChangeLoader();
  }

  void setNewPassword({required BuildContext context}) {
    sharedPreferences.setString(
        'current_password', confirmNewPasswordTextController.text);
    sharedPreferences.setString(
        'login_password', confirmNewPasswordTextController.text);
    goBackFromPasswordChange(context: context);
  }

  // Image section
  File? image;
  final picker = ImagePicker();

  // IMAGE WILL BE CROPPED AND COMPRESSED
  Future chooseImage({required BuildContext context}) async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null && context.mounted) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context).photo,
            toolbarColor: const Color(0xFFA08875),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            activeControlsWidgetColor: const Color(0xFFA08875),
          ),
          IOSUiSettings(
            title: AppLocalizations.of(context).photo,
          ),
        ],
      );
      if (croppedFile != null) {
        File croppedImage = File(croppedFile.path);
        image = await mainScreenProvider.compressImage(croppedImage);
      }
    }

    notifyListeners();
  }

  // Password change
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool oldPasswordVisibility = true;
  bool newPasswordVisibility = true;
  bool confirmNewPasswordVisibility = true;

  void toggleOldPasswordVisibility() {
    if (oldPasswordVisibility == false) {
      oldPasswordVisibility = true;
    } else if (oldPasswordVisibility == true) {
      oldPasswordVisibility = false;
    }
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    if (newPasswordVisibility = false) {
      newPasswordVisibility = true;
    } else if (newPasswordVisibility == true) {
      newPasswordVisibility = false;
    }
    notifyListeners();
  }

  void toggleConfirmNewPasswordVisibility() {
    if (confirmNewPasswordVisibility == false) {
      confirmNewPasswordVisibility = true;
    } else if (confirmNewPasswordVisibility == true) {
      confirmNewPasswordVisibility = false;
    }
    notifyListeners();
  }

  String? validateOldPassword(
      {required String value, required BuildContext context}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterOldPassword;
    } else if (value != sharedPreferences.getString("current_password")) {
      return AppLocalizations.of(context).oldPasswordDoNotMatch;
    } else {
      return null;
    }
  }

  String? validateNewPassword(
      {required String value, required BuildContext context}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterNewPassword;
    } else if (value.length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (confirmNewPasswordTextController.text.isNotEmpty &&
        newPasswordTextController.text !=
            confirmNewPasswordTextController.text) {
      return AppLocalizations.of(context).passwordDonotMatchWithEachOther;
    } else {
      return null;
    }
  }

  String? validateConfirmNewPassword(
      {required String value, required BuildContext context}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterNewPasswordAgain;
    } else if (value.length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (newPasswordTextController.text !=
        confirmNewPasswordTextController.text) {
      return AppLocalizations.of(context).passwordDonotMatchWithEachOther;
    } else {
      return null;
    }
  }

  bool validateForDifferentPassword({required BuildContext context}) {
    if (oldPasswordTextController.text ==
        confirmNewPasswordTextController.text) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).passwordShouldNotMatch,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
      return false;
    } else {
      return true;
    }
  }

  // BLOCK USER
  List<String> getUserBlockOptionList({required BuildContext context}) {
    return [AppLocalizations.of(context).blockAccount];
  }

  Future<void> blockUser({
    required BuildContext context,
    required String otherUserId,
    required bool isOtherUserProfile,
    required StreamController? otherUserStreamController,
  }) async {
    if (!mainScreenProvider.blockedUsersIdList
        .contains(int.parse(otherUserId))) {
      Map bodyData = {
        "data": {
          'blocked_by': sharedPreferences.getString('id').toString(),
          'blocked_to': otherUserId
        }
      };
      Response reportResponse = await ReportAndBlockRepo.blockUser(
          bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      if (reportResponse.statusCode == 200 && context.mounted) {
        mainScreenProvider.blockedUsersIdList.add(int.parse(otherUserId));
        mainScreenProvider.updateAndSetUserDetails(
          context: context,
        );
        notifyListeners();
        final newsAdProvider =
            Provider.of<NewsAdProvider>(context, listen: false);
        newsAdProvider.refreshNewsPosts(context: context);
        Navigator.of(context).pop();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).accountBlockedSuccessfully,
            backgroundColor: const Color(0xFFA08875),
            contentColor: Colors.white);
      } else if (reportResponse.statusCode == 401 ||
          reportResponse.statusCode == 403) {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    } else {
      mainScreenProvider.updateAndSetUserDetails(
        context: context,
      );
    }
  }

  // UNBLOCK USER
  Future<void> unblockUser({
    required BuildContext context,
    required String userBlockId,
    required String otherUserId,
    required StreamController? otherUserStreamController,
  }) async {
    Map bodyData = {};
    Response reportResponse = await ReportAndBlockRepo.unblockUser(
        bodyData: bodyData,
        jwt: sharedPreferences.getString('jwt')!,
        userBlockId: userBlockId);
    if (reportResponse.statusCode == 200 && context.mounted) {
      mainScreenProvider.blockedUsersIdList.remove(int.parse(otherUserId));
      mainScreenProvider.updateAndSetUserDetails(
        context: context,
      );
      notifyListeners();
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).accountUnblockedSuccessfully,
          backgroundColor: const Color(0xFFA08875),
          contentColor: Colors.white);
    } else if (reportResponse.statusCode == 401 ||
        reportResponse.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // my profile option list
  List<String> getMyProfileOptionList({required BuildContext context}) {
    return [
      AppLocalizations.of(context).blockedAccounts,
      AppLocalizations.of(context).deleteAccount
    ];
  }

  // delete user
  Future<bool> deleteUser({required BuildContext context}) async {
    final deleteResponse = await ProfileEditRepo.deleteUser(
        bodyData: {},
        jwt: sharedPreferences.getString('jwt')!,
        profileId: sharedPreferences.getString('id')!);

    if (deleteResponse.statusCode == 200 && context.mounted) {
      Provider.of<BottomNavProvider>(context, listen: false)
          .setBottomIndex(index: 0, context: context);

      final fln = FlutterLocalNotificationsPlugin();
      fln.cancelAll();

      final mainScreenProvider =
          Provider.of<MainScreenProvider>(context, listen: false);
      await sharedPreferences.setBool('isLogin', false);
      mainScreenProvider.isLogin =
          sharedPreferences.getBool('isLogin') ?? false;
      sharedPreferences.remove('id');
      sharedPreferences.remove('user_name');
      sharedPreferences.remove('user_type');
      sharedPreferences.remove('jwt');
      sharedPreferences.remove('current_password');
      sharedPreferences.remove('device_token');
      sharedPreferences.setBool('follow_push_notification', false);
      sharedPreferences.setBool("notification_tab_active_status", false);
      sharedPreferences.setBool("chatroom_active_status", false);

      sharedPreferences.remove('rememberMe');
      sharedPreferences.remove('login_identifier');
      sharedPreferences.remove('login_password');

      await mainScreenProvider.removeUser();

      mainScreenProvider.followerIdList.clear();
      mainScreenProvider.followingIdList.clear();
      mainScreenProvider.likedPostIdList.clear();
      mainScreenProvider.savedNewsPostIdList.clear();
      mainScreenProvider.savedInterestClassIdList.clear();

      mainScreenProvider.loginIdentifier = '';
      mainScreenProvider.loginPassword = '';
      mainScreenProvider.rememberMeCheckBox = false;

      if (context.mounted) {
        final newsAdProvider =
            Provider.of<NewsAdProvider>(context, listen: false);
        newsAdProvider.newsCommentControllerList.clear();

        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).accountDeleted,
            backgroundColor: const Color(0xFFA08875),
            contentColor: Colors.white);

        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.id, (route) => false);
      }
      return true;
    } else if (deleteResponse.statusCode == 401 ||
        deleteResponse.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
      }
      return false;
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).unsuccessfulTryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
      return false;
    }
  }

  // Navigate back from profile edit screen
  goBack({required BuildContext context}) {
    if (image != null) {
      image = null;
    }
    setUserDetails();
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  void goBackFromPasswordChange({required BuildContext context}) {
    clearPasswordChangeData();
    Navigator.pop(context);
  }

  void clearPasswordChangeData() {
    oldPasswordTextController.clear();
    newPasswordTextController.clear();
    confirmNewPasswordTextController.clear();
    oldPasswordVisibility = true;
    newPasswordVisibility = true;
    confirmNewPasswordVisibility = true;
  }

  // Chat icon click
  void startChatWithOneUser(
      {required String otherUserId, required BuildContext context}) async {
    await Provider.of<ChatMessageProvider>(context, listen: false)
        .loadOneUserConversation(otherUserId: otherUserId, context: context);
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    emailTextController.dispose();
    userTypeTextController.dispose();
    regDateTextController.dispose();
    oldPasswordTextController.dispose();
    newPasswordTextController.dispose();
    confirmNewPasswordTextController.dispose();
    super.dispose();
  }
}
