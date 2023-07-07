import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/enum/news_board_enum.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/data/models/conversation_model.dart';
import 'package:spa_app/data/models/socket_message_model.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/data/repositories/device_token_repo.dart';
import 'package:spa_app/data/repositories/login_repo.dart';
import 'package:spa_app/data/repositories/push_notification_repo.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/main.dart';
import 'package:spa_app/presentation/components/further_studies/news_board_detail_screen.dart';
import 'package:spa_app/presentation/components/interest_class/interest_course_detail_screen.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_description_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:spa_app/presentation/views/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

class MainScreenProvider extends ChangeNotifier {
  // // Details of current user are added to sink of this controller
  StreamController<User> currentUserController = BehaviorSubject();

  // Last topic and bookmark topic of profile tab are stored in the sink of this controller
  StreamController<NewsPost?> profileNewsTopicStreamController =
      BehaviorSubject();

  // All news of selected user from profile tab are added to sink of this controller
  StreamController<User?> allProfileTopicController = BehaviorSubject();

  DateFormat format = DateFormat('yyyy-MM-dd');
  late SharedPreferences sharedPreferences;
  late bool rememberMeCheckBox;
  late bool isLogin;

  // Id, username and user type of current user
  String? userId,
      userName,
      userType,
      loginIdentifier,
      loginPassword,
      currentPassword,
      userDeviceToken;

  // JW Token of Strapi for authorization
  String? _jwt;
  String? get jwt => _jwt;

  void setJwToken({required String newJwt}) {
    _jwt = newJwt;
  }

  void initial() async {
    try {
      await Firebase.initializeApp();
      sharedPreferences = await SharedPreferences.getInstance();

      String? currentDeviceToken = await FirebaseMessaging.instance.getToken();
      isLogin = sharedPreferences.getBool('isLogin') ?? false;
      // If user has clicked on remember me while logging in, their login credentials will be stored.
      rememberMeCheckBox = sharedPreferences.getBool('rememberMe') ?? false;
      loginIdentifier = sharedPreferences.getString('login_identifier') ?? '';
      loginPassword = sharedPreferences.getString('login_password') ?? '';

      // if user is already logged in
      if (isLogin) {
        // the following two sharedPreferences are set to false, because if it is true notification badge won't be popped
        sharedPreferences.setBool("notification_tab_active_status", false);
        sharedPreferences.setBool("chatroom_active_status", false);
        sharedPreferences.remove('active_chat_username');
        userId = sharedPreferences.getString('id') ?? 'null';
        userName = sharedPreferences.getString('user_name') ?? 'null';
        userType = sharedPreferences.getString('user_type') ?? 'null';
        userDeviceToken = sharedPreferences.getString('device_token') ?? 'null';
        _jwt = sharedPreferences.getString('jwt') ?? 'null';
        currentPassword = sharedPreferences.getString('current_password');
        bool tokenValidCheck =
            await updateAndSetUserDetails(context: navigatorKey.currentContext);
        // IF TOKEN IS EXPIRED
        if (tokenValidCheck == false) {
          if (navigatorKey.currentContext != null &&
              navigatorKey.currentContext!.mounted) {
            Provider.of<DrawerProvider>(navigatorKey.currentContext!,
                    listen: false)
                .removeCredentials(context: navigatorKey.currentContext!);
          }
          return;
        }
        if (currentDeviceToken == userDeviceToken) {
          navigatorKey.currentState?.pushReplacementNamed(HomeScreen.id);
        } else {
          bool isUpdate = await updateUserDeviceToken(
              userId: userId.toString(),
              newDeviceToken: currentDeviceToken.toString());
          if (isUpdate) {
            navigatorKey.currentState?.pushReplacementNamed(HomeScreen.id);
          } else {
            throw Exception('Unable to update new device token');
          }
        }
      } else {
        // the following two sharedPreferences are set to false, because if it is true notification badge won't be popped
        sharedPreferences.setBool("notification_tab_active_status", false);
        sharedPreferences.setBool("chatroom_active_status", false);
        sharedPreferences.remove('active_chat_username');
        navigatorKey.currentState?.pushReplacementNamed(LoginScreen.id);
      }
      notifyListeners();
    } on SocketException {
      return;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> updateUserDeviceToken(
      {required String userId, required String? newDeviceToken}) async {
    final bodyData = {"device_token": newDeviceToken};
    Response response = await DeviceTokenRepo.updateDeviceToken(
        bodyData: bodyData,
        jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null',
        userId: userId);
    if (response.statusCode == 200) {
      if (newDeviceToken == null) {
        sharedPreferences.remove('device_token');
      } else {
        sharedPreferences.setString("device_token", newDeviceToken);
      }
      return true;
    } else {
      return false;
    }
  }

  // Current user object
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Setting and updating user details
  Future<bool> updateAndSetUserDetails(
      {bool setLikeSaveCommentFollow = true,
      required BuildContext? context}) async {
    Response userResponse = await LoginRepo.getLoggedInUserDetails(
        id: userId!, jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null');

    if (userResponse.statusCode == 200) {
      _currentUser = userFromJson(userResponse.body);
      // Add latest user data to sink of currentUserController
      currentUserController.sink.add(_currentUser!);
      if (setLikeSaveCommentFollow == true) {
        setLikedSavedIdList(_currentUser!);
        setFollowingFollowerList(_currentUser!);
      }
      notifyListeners();
      return true;
    } else if (userResponse.statusCode == 401 ||
        userResponse.statusCode == 403) {
      if (context != null && context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
      }
      return false;
    }
    return false;
  }

  // List of id that the current user follows
  List<int> followingIdList = [];

  // List of id that follows the current user
  List<int> followerIdList = [];

  void setFollowingFollowerList(User user) {
    int myId = int.parse(sharedPreferences.getString('id')!);
    if (user.userFollowing != null) {
      for (int i = 0; i < user.userFollowing!.length; i++) {
        if (!followingIdList.contains(user.userFollowing![i]!.followedTo!.id) &&
            user.userFollowing![i]!.followedTo!.id != myId) {
          followingIdList.add(user.userFollowing![i]!.followedTo!.id!);
        }
      }
    }
    if (user.userFollower != null) {
      for (int i = 0; i < user.userFollower!.length; i++) {
        if (!followerIdList.contains(user.userFollower![i]!.followedBy!.id) &&
            user.userFollower![i]!.followedBy!.id! != myId) {
          followerIdList.add(user.userFollower![i]!.followedBy!.id!);
        }
      }
    }

    notifyListeners();
  }

  // News Post
  List<int> likedPostIdList = [];
  List<int> savedNewsPostIdList = [];

  // Interest class
  List<int> savedInterestClassIdList = [];

  // Paper share
  List<int> savedPaperShareIdList = [];

  // Reported news posts
  List<int> reportedNewsPostidList = [];

  // Reported paper shares
  List<int> reportedPaperShareIdList = [];

  // Blocked users
  List<int> blockedUsersIdList = [];

  void setLikedSavedIdList(User user) {
    // news post like
    if (user.newsPostLikes != null) {
      for (int i = 0; i < user.newsPostLikes!.length; i++) {
        if (user.newsPostLikes![i]!.newsPost != null &&
            !likedPostIdList.contains(user.newsPostLikes![i]!.newsPost!.id)) {
          likedPostIdList.add(user.newsPostLikes![i]!.newsPost!.id!);
        }
      }
    }
    // news post save
    if (user.newsPostSaves != null) {
      for (int i = 0; i < user.newsPostSaves!.length; i++) {
        if (user.newsPostSaves![i]!.newsPost != null &&
            !savedNewsPostIdList
                .contains(user.newsPostSaves![i]!.newsPost!.id)) {
          savedNewsPostIdList.add(user.newsPostSaves![i]!.newsPost!.id!);
        }
      }
    }
    // interest class save
    if (user.interestClassSaves != null) {
      for (int i = 0; i < user.interestClassSaves!.length; i++) {
        if (user.interestClassSaves![i]!.interestClass != null &&
            !savedInterestClassIdList
                .contains(user.interestClassSaves![i]!.interestClass!.id!)) {
          savedInterestClassIdList
              .add(user.interestClassSaves![i]!.interestClass!.id!);
        }
      }
    }
    // paper share save
    if (user.paperShareSaves != null) {
      for (int i = 0; i < user.paperShareSaves!.length; i++) {
        if (user.paperShareSaves![i]!.paperShare != null &&
            !savedPaperShareIdList
                .contains(user.paperShareSaves![i]!.paperShare!.id)) {
          savedPaperShareIdList.add(user.paperShareSaves![i]!.paperShare!.id!);
        }
      }
    }

    // reported news posts
    if (user.reportedNewsPosts != null) {
      for (int i = 0; i < user.reportedNewsPosts!.length; i++) {
        if (user.reportedNewsPosts![i]!.newsPost != null &&
            !reportedNewsPostidList
                .contains(user.reportedNewsPosts![i]!.newsPost!.id)) {
          reportedNewsPostidList.add(user.reportedNewsPosts![i]!.newsPost!.id!);
        }
      }
    }

    // reported paper shares
    if (user.reportedPaperShares != null) {
      for (int i = 0; i < user.reportedPaperShares!.length; i++) {
        if (user.reportedPaperShares![i]!.paperShare != null &&
            !reportedPaperShareIdList
                .contains(user.reportedPaperShares![i]!.paperShare!.id)) {
          reportedPaperShareIdList
              .add(user.reportedPaperShares![i]!.paperShare!.id!);
        }
      }
    }

    // blocked users
    if (user.usersBlocked != null) {
      for (int i = 0; i < user.usersBlocked!.length; i++) {
        if (user.usersBlocked![i]!.blockedTo != null &&
            !blockedUsersIdList
                .contains(user.usersBlocked![i]!.blockedTo!.id)) {
          blockedUsersIdList.add(user.usersBlocked![i]!.blockedTo!.id!);
        }
      }
    }

    // get blocked form
    if (user.gotBlockedFrom != null) {
      for (int i = 0; i < user.gotBlockedFrom!.length; i++) {
        if (user.gotBlockedFrom![i]!.blockedBy != null &&
            !blockedUsersIdList
                .contains(user.gotBlockedFrom![i]!.blockedBy!.id)) {
          blockedUsersIdList.add(user.gotBlockedFrom![i]!.blockedBy!.id!);
        }
      }
    }

    removeReportedAndBlockedUsersNewsPostFromInitialLoad();
    notifyListeners();
  }

  // Reported news posts won't be displayed
  void removeReportedAndBlockedUsersNewsPostFromInitialLoad() {
    // Removing reports news post from created post
    for (int i = 0; i < reportedNewsPostidList.length; i++) {
      // Removing reported news post from created news post
      if (_currentUser!.createdPost != null) {
        _currentUser!.createdPost!.removeWhere((element) =>
            element != null &&
            element.id.toString() == reportedNewsPostidList[i].toString());
      }
      if (_currentUser!.newsPostSaves != null) {
        // Removing reported news post from saved news post
        _currentUser!.newsPostSaves!.removeWhere((element) =>
            element != null &&
            element.newsPost != null &&
            element.newsPost!.id.toString() ==
                reportedNewsPostidList[i].toString());
        if (savedNewsPostIdList.contains(reportedNewsPostidList[i])) {
          savedNewsPostIdList.remove(reportedNewsPostidList[i]);
        }
      }
    }

    for (int i = 0; i < blockedUsersIdList.length; i++) {
      // Removing blocked user's post from bookmarked news post
      if (_currentUser!.newsPostSaves != null) {
        _currentUser!.newsPostSaves!.removeWhere((element) =>
            element != null &&
            element.newsPost != null &&
            element.newsPost!.postedBy != null &&
            element.newsPost!.postedBy!.id.toString() ==
                blockedUsersIdList[i].toString());
        if (savedNewsPostIdList.contains(blockedUsersIdList[i])) {
          savedNewsPostIdList.remove(blockedUsersIdList[i]);
        }
      }
    }
    removeBlockedUserFromFollowFollowing();
    notifyListeners();
  }

  void removeBlockedUserFromFollowFollowing() {
    for (int i = 0; i < blockedUsersIdList.length; i++) {
      if (_currentUser!.userFollowing != null) {
        _currentUser!.userFollowing!.removeWhere((element) =>
            element != null &&
            element.followedTo != null &&
            element.followedTo!.id.toString() ==
                blockedUsersIdList[i].toString());
      }

      if (_currentUser!.userFollower != null) {
        _currentUser!.userFollower!.removeWhere((element) =>
            element != null &&
            element.followedBy != null &&
            element.followedBy!.id.toString() ==
                blockedUsersIdList[i].toString());
      }
    }
    currentUserController.sink.add(_currentUser!);
    notifyListeners();
  }

  void removeNewReportNews(
      {required String newsPostId, required BuildContext context}) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (_currentUser != null && !currentUserController.isClosed) {
      if (_currentUser!.createdPost != null) {
        _currentUser!.createdPost!.removeWhere((element) =>
            element != null && element.id.toString() == newsPostId);
        notifyListeners();
      }

      if (_currentUser!.newsPostSaves != null) {
        _currentUser!.newsPostSaves!.removeWhere((element) =>
            element != null &&
            element.newsPost != null &&
            element.newsPost!.id.toString() == newsPostId);
        if (savedNewsPostIdList.contains(int.parse(newsPostId))) {
          savedNewsPostIdList.remove(int.parse(newsPostId));
        }

        notifyListeners();
      }
      if (_currentUser!.createdPost!.length <= 6) {
        profileProvider.selectedProfileTopicIndex = 0;
        notifyListeners();
      }
      if (_currentUser!.newsPostSaves!.length <= 6) {
        profileProvider.selectedBookmarkedTopicIndex = 0;
        notifyListeners();
      }

      currentUserController.sink.add(_currentUser!);
      notifyListeners();
    }
  }

  void removeBlockedUsersNews(
      {required String otherUserId, required BuildContext context}) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (_currentUser != null && !currentUserController.isClosed) {
      if (_currentUser!.newsPostSaves != null) {
        _currentUser!.newsPostSaves!.removeWhere((element) =>
            element != null &&
            element.newsPost != null &&
            element.newsPost!.postedBy != null &&
            element.newsPost!.postedBy!.id.toString() == otherUserId);
        if (savedNewsPostIdList.contains(int.parse(otherUserId))) {
          savedNewsPostIdList.remove(int.parse(otherUserId));
        }

        notifyListeners();
      }
      if (_currentUser!.createdPost!.length <= 6) {
        profileProvider.selectedProfileTopicIndex = 0;
        notifyListeners();
      }
      if (_currentUser!.newsPostSaves!.length <= 6) {
        profileProvider.selectedBookmarkedTopicIndex = 0;
        notifyListeners();
      }

      currentUserController.sink.add(_currentUser!);
      notifyListeners();
    }
  }

  void setUserInfo({required User user, required BuildContext context}) {
    userId = user.id.toString();
    userName = user.username;
    userType = user.userType;
    userDeviceToken = user.deviceToken;
    _currentUser = user;
    setLikedSavedIdList(user);
    setFollowingFollowerList(user);

    // For profile tab
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.profileImage =
        user.profileImage == null ? 'null' : user.profileImage!.url!;
    profileProvider.userNameTextController.text = user.username!;
    profileProvider.userTypeTextController.text = user.userType!;
    profileProvider.regDateTextController.text =
        format.format(DateTime.parse(user.createdAt!.toString()));
    profileProvider.emailTextController.text = user.email!;
    notifyListeners();
  }

  // called when user logs out
  Future<void> removeUser() async {
    // Setting the device token to null in the server
    await updateUserDeviceToken(userId: userId!, newDeviceToken: null);
    _currentUser = null;
    userId = null;
    userName = null;
    userDeviceToken = null;
    userType = null;
    _jwt = null;
    currentPassword = null;
    notifyListeners();
  }

  bool? isDeleteCache;

  // This method will be called when user updates their details
  Future<void> finalizeUpdate(
      {required String userName,
      required String userType,
      required BuildContext? context}) async {
    this.userName = userName;
    this.userType = userType;
    await sharedPreferences.remove('user_name');
    await sharedPreferences.setString('user_name', userName);
    await sharedPreferences.remove('user_type');
    await sharedPreferences.setString('user_type', userType);
    await updateAndSetUserDetails(
        setLikeSaveCommentFollow: false, context: context);
    if (isDeleteCache == true) {
      await _deleteImageFromCache(image: currentUser!.profileImage!.url!);
      isDeleteCache = false;
    }
    notifyListeners();
  }

  // Cachne Network image optimization
  Future _deleteImageFromCache({required String image}) async {
    String url = kIMAGEURL + image;
    await CachedNetworkImage.evictFromCache(url);
  }

  late i_o.Socket socket;
  // socket connection
  void initialSocketConnection() {
    socket = i_o.io(
        kSocketIOUrl,
        i_o.OptionBuilder()
            .setTransports(['websocket'])
            .enableReconnection()
            .disableForceNew()
            .disableForceNewConnection()
            .disableMultiplex()
            .build());

    if (socket.connected == false) {
      socket.connect();
    }
  }

  void connectToSocketServer({required BuildContext context}) {
    //socket = i_o.io(kSocketIOUrl, <String, dynamic>{
    // 'transports': ['websocket'],
    // 'autoConnect': true,
    //});
    //socket.connect();
    socket.onConnect((data) {
      // Add socket user in socketio
      socket.emit("addUser", userId.toString());

      // Online users
      socket.on("getUsers", (data) => {});

      // Message sent by current user
      socket.on("getMessageForSender", (message) {
        int i = 0;
        try {
          if (i == 0) {
            i++;
            SocketMessage socketMessage = SocketMessage(
                senderId: message['senderId'],
                receiverUserId: message['receiverUserId'],
                message: message['message'],
                sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']));

            Provider.of<ChatMessageProvider>(context, listen: false)
                .addConversation(socketMessage: socketMessage);

            Provider.of<ChatMessageProvider>(context, listen: false)
                .updateOneConversationData(
                    context: context,
                    conversationId: message['conversationId'].toString());
          }
        } catch (e) {
          throw Exception(e.toString());
        }
      });

      // Message received by current user
      socket.on("getMessageForReceiver", (message) async {
        try {
          SocketMessage socketMessage = SocketMessage(
              senderId: message['senderId'],
              receiverUserId: message['receiverUserId'],
              message: message['message'],
              sentAt: message['sentAt'] == null
                  ? DateTime.now()
                  : DateTime.fromMillisecondsSinceEpoch(message['sentAt']));

          Provider.of<ChatMessageProvider>(context, listen: false)
              .addConversation(socketMessage: socketMessage);

          Conversation? allConversation =
              Provider.of<ChatMessageProvider>(context, listen: false)
                  .allConversation;
          if (allConversation != null) {
            final oneConversationData = allConversation.data!.firstWhereOrNull(
                (element) =>
                    element.id.toString() ==
                    message['conversationId'].toString());
            if (oneConversationData != null &&
                message['receiverUserId'].toString() == userId) {
              await Provider.of<ChatMessageProvider>(context, listen: false)
                  .updateLastTimeReadWhenReceivedMessage(
                      otherUsername: oneConversationData
                                  .attributes!.firstUser!.data!.id
                                  .toString() ==
                              userId
                          ? oneConversationData.attributes!.secondUser!.data!
                              .attributes!.username
                              .toString()
                          : oneConversationData
                              .attributes!.firstUser!.data!.attributes!.username
                              .toString(),
                      lastTextCreatedAt: DateTime.fromMillisecondsSinceEpoch(
                          message['sentAt']),
                      firstUserId: oneConversationData
                          .attributes!.firstUser!.data!.id
                          .toString(),
                      secondUser: oneConversationData
                          .attributes!.secondUser!.data!.id
                          .toString(),
                      receiverUserId: message['receiverUserId'],
                      context: context,
                      conversationId: message['conversationId'].toString());
            }
          }
        } catch (e) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).tryAgainLater,
              backgroundColor: Colors.red,
              contentColor: Colors.white);
          throw Exception(e.toString());
        }
      });
    });
    socket.onConnectError((data) => throw Exception('Connection Error: $data'));
    socket.onDisconnect((data) => null);
  }

  // Sending message to user
  void sendMessage(
      {required String receiverUserId,
      required String message,
      required String? otherUserDeviceToken,
      required String? conversationId,
      required BuildContext context}) {
    try {
      socket.emit('sendMessage', {
        'senderId': userId.toString(),
        'receiverUserId': receiverUserId,
        'message': message,
        'conversationId': conversationId,
        'jwt': jwt.toString()
      });

      Conversation? allConversation =
          Provider.of<ChatMessageProvider>(context, listen: false)
              .allConversation;
      if (allConversation != null) {
        final oneConversationData = allConversation.data!.firstWhereOrNull(
            (element) => element.id.toString() == conversationId.toString());
        if (oneConversationData != null) {
          if (otherUserDeviceToken != null || otherUserDeviceToken != '') {
            sendMessageReplyNotification(
                receiverUserId: receiverUserId,
                context: context,
                initiatorUsername: userName.toString(),
                receiverUserDeviceToken: otherUserDeviceToken);
          }
          Map bodyData;
          if (oneConversationData.attributes!.firstUser != null &&
              oneConversationData.attributes!.firstUser!.data!.id.toString() ==
                  userId.toString()) {
            bodyData = {
              "data": {"first_user_last_read": DateTime.now().toString()}
            };
          } else {
            bodyData = {
              "data": {"second_user_last_read": DateTime.now().toString()}
            };
          }
          Provider.of<ChatMessageProvider>(context, listen: false)
              .updateLastTimeRead(
                  context: context,
                  conversationId: conversationId.toString(),
                  bodyData: bodyData);
        } else {
          throw Exception('oneConversationDAta is null');
        }
      } else {
        throw Exception('allConversation is null');
      }
    } catch (e) {
      throw (Exception(e));
    }
  }

  // Send follow notification
  Future<void> sendFollowPushNotification(
      {required String receiverUserId,
      required BuildContext context,
      required String initiatorUsername,
      required String? receiverUserDeviceToken,
      required String? notificationAction}) async {
    if (receiverUserDeviceToken != null) {
      Map bodyData = {
        "memberId": receiverUserId,
        "token": receiverUserDeviceToken,
        "title": "P Daily",
        "body": notificationAction == 'follow'
            ? "$initiatorUsername started following you."
            : "$initiatorUsername unfollowed you."
      };
      http.Response response = await PushNotificationRepo.sendPushNotification(
          bodyData: jsonEncode(bodyData),
          jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null');
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["d"]["result"] == "Success") {
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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
            content:
                'Sorry, the notification was not sent. Please try again later.',
            backgroundColor: Colors.red,
            contentColor: Colors.white);
      }
    } else {
      return;
    }
  }

  // Chat message notification
  Future<void> sendMessageReplyNotification(
      {required String receiverUserId,
      required BuildContext context,
      required String initiatorUsername,
      required String? receiverUserDeviceToken}) async {
    if (receiverUserDeviceToken != null) {
      Map bodyData = {
        "memberId": receiverUserId,
        "token": receiverUserDeviceToken,
        "title": "P Daily",
        "body": "$initiatorUsername has sent you a message."
      };
      http.Response response = await PushNotificationRepo.sendPushNotification(
          bodyData: jsonEncode(bodyData),
          jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null');
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["d"]["result"] == "Success") {
      } else if (response.statusCode == 401 || response.statusCode == 403) {
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
            content:
                'Sorry, the message reply notification was not sent. Please try again later.',
            backgroundColor: Colors.red,
            contentColor: Colors.white);
      }
    } else {
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

// // Crude counter to make messages unique
//   int _messageCount = 0;

//   /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
//   String constructFCMPayload(String token) {
//     _messageCount++;
//     return jsonEncode({
//       'notification': {
//         'title': 'P Daily',
//         'body': 'This notification (#$_messageCount) was created via FCM!',
//       },
//       'priority': 'high',
//       'data': {
//         'via': 'FlutterFire Cloud Messaging!!!',
//         'count': _messageCount.toString(),
//       },
//       'to': token,
//     });
//   }

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

  void navigateRouteFromDynamicLink(
      {required Uri deepLink, required BuildContext context}) {
    // Checking for paper share
    var isPaperShare = deepLink.pathSegments.contains('papershare');
    if (isPaperShare) {
      String paperShareId = deepLink.queryParameters["id"].toString();
      try {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaperShareDescriptionScreen(
                    source: PaperShareSourceType.fromShare,
                    paperShareId: int.parse(paperShareId))));
      } catch (e) {
        throw Exception(
            "Error occured while navigating to paper share on running state");
      }
    }

    // Checking for interest class
    var isInterestClass = deepLink.pathSegments.contains('interestclass');
    if (isInterestClass) {
      String interestClassId = deepLink.queryParameters["id"].toString();
      try {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InterestCourseDetailScreen(
                      source: InterestClassSourceType.fromShare,
                      interestClassId: interestClassId,
                    )));
      } catch (e) {
        throw Exception(
            "Error occured while navigating to interest class on running state");
      }
    }

    // Checking for news board
    var isNewsBoard = deepLink.pathSegments.contains('newsboard');
    if (isNewsBoard) {
      String newsBoardId = deepLink.queryParameters["id"].toString();
      try {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewsBoardDetailScreen(
                      source: NewsBoardSourceType.fromShare,
                      newsBoardId: newsBoardId,
                    )));
      } catch (e) {
        throw Exception(
            "Error occured while navigating to news board on running state");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
    currentUserController.close();
    profileNewsTopicStreamController.close();
    allProfileTopicController.close();
  }
}
