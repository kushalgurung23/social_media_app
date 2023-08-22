import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/interest_class_enum.dart';
import 'package:c_talent/data/models/all_news_post_model.dart';
import 'package:c_talent/data/models/conversation_model.dart';
import 'package:c_talent/data/models/socket_message_model.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/main.dart';
import 'package:c_talent/presentation/components/interest_class/interest_course_detail_screen.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:c_talent/presentation/views/login_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

class MainScreenProvider extends ChangeNotifier {
  // // Details of current user are added to sink of this controller
  StreamController<User> currentUserController = BehaviorSubject();

  String? currentUserId, currentAccessToken;
  bool? isKeepUserLoggedIn;

  void saveUserLoginDetails(
      {required String currentUserId,
      required String currentAccessToken,
      required bool isKeepUserLoggedIn}) {
    currentUserId = currentUserId;
    currentAccessToken = currentAccessToken;
    isKeepUserLoggedIn = isKeepUserLoggedIn;
  }

  void removeUserLoginDetails() {
    currentUserId = null;
    currentAccessToken = null;
    isKeepUserLoggedIn = null;
  }

  // Last topic and bookmark topic of profile tab are stored in the sink of this controller
  // StreamController<NewsPost?> profileNewsTopicStreamController =
  //     BehaviorSubject();

  // All news of selected user from profile tab are added to sink of this controller
  StreamController<User?> allProfileTopicController = BehaviorSubject();

  DateFormat format = DateFormat('yyyy-MM-dd');

  void initial() async {
    try {
      await Firebase.initializeApp();
      // if user is already logged in
      bool isLogin =
          await UserSecureStorage.getSecuredIsLoggedInStatus() ?? false;
      if (isLogin) {
        currentUserId = await UserSecureStorage.getSecuredUserId() ?? '';
        currentAccessToken =
            await UserSecureStorage.getSecuredAccessToken() ?? '';
        isKeepUserLoggedIn = isLogin;
        // the following two sharedPreferences are set to false, because if it is true notification badge won't be popped
        if (navigatorKey.currentContext != null) {
          Provider.of<BottomNavProvider>(navigatorKey.currentContext!,
                  listen: false)
              .setBottomIndex(index: 0, context: navigatorKey.currentContext!);
          navigatorKey.currentState?.pushReplacementNamed(HomeScreen.id);
        }
      } else {
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

  // Current user object

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

  Future<void> connectToSocketServer({required BuildContext context}) async {
    String? userId = currentUserId;
    if (userId == null) {
      EasyLoading.showInfo("Sorry, please try again later.",
          dismissOnTap: true, duration: const Duration(seconds: 3));
      return;
    }
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
  Future<void> sendMessage(
      {required String receiverUserId,
      required String message,
      required String? otherUserDeviceToken,
      required String? conversationId,
      required BuildContext context}) async {
    try {
      // String? userId = mainScreenProvider.currentUserId;
      // if (userId == null) {
      //   EasyLoading.showInfo("Sorry, please try again later.",
      //       dismissOnTap: true, duration: const Duration(seconds: 3));
      //   return;
      // }
      // socket.emit('sendMessage', {
      //   'senderId': userId.toString(),
      //   'receiverUserId': receiverUserId,
      //   'message': message,
      //   'conversationId': conversationId,
      //   'jwt': jwt.toString()
      // });
      // final chatMessageProvider =
      //     Provider.of<ChatMessageProvider>(context, listen: false);
      // Conversation? allConversation = chatMessageProvider.allConversation;
      // chatMessageProvider.chatTextController.clear();
      // if (allConversation != null) {
      //   final oneConversationData = allConversation.data!.firstWhereOrNull(
      //       (element) => element.id.toString() == conversationId.toString());
      //   if (oneConversationData != null) {
      //     if (otherUserDeviceToken != null || otherUserDeviceToken != '') {
      //       sendMessageReplyNotification(
      //           receiverUserId: receiverUserId,
      //           context: context,
      //           initiatorUsername: userName.toString(),
      //           receiverUserDeviceToken: otherUserDeviceToken);
      //     }
      //     Map bodyData;
      //     if (oneConversationData.attributes!.firstUser != null &&
      //         oneConversationData.attributes!.firstUser!.data!.id.toString() ==
      //             userId.toString()) {
      //       bodyData = {
      //         "data": {"first_user_last_read": DateTime.now().toString()}
      //       };
      //     } else {
      //       bodyData = {
      //         "data": {"second_user_last_read": DateTime.now().toString()}
      //       };
      //     }
      //     Provider.of<ChatMessageProvider>(context, listen: false)
      //         .updateLastTimeRead(
      //             context: context,
      //             conversationId: conversationId.toString(),
      //             bodyData: bodyData);
      //   } else {
      //     throw Exception('oneConversationDAta is null');
      //   }
      // } else {
      //   throw Exception('allConversation is null');
      // }
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
    // if (receiverUserDeviceToken != null) {
    //   Map bodyData = {
    //     "token": receiverUserDeviceToken,
    //     "title": "C Talent",
    //     "body": notificationAction == 'follow'
    //         ? "$initiatorUsername started following you."
    //         : "$initiatorUsername unfollowed you."
    //   };
    //   http.Response response = await PushNotificationRepo.sendPushNotification(
    //       bodyData: jsonEncode(bodyData),
    //       jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null');
    //   if (response.statusCode == 401 || response.statusCode == 403) {
    //     if (context.mounted) {
    //       EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
    //           dismissOnTap: false, duration: const Duration(seconds: 4));
    //       Provider.of<DrawerProvider>(context, listen: false)
    //           .removeCredentials(context: context);
    //       return;
    //     }
    //   }
    // } else {
    //   return;
    // }
  }

  // Chat message notification
  Future<void> sendMessageReplyNotification(
      {required String receiverUserId,
      required BuildContext context,
      required String initiatorUsername,
      required String? receiverUserDeviceToken}) async {
    // if (receiverUserDeviceToken != null) {
    //   Map bodyData = {
    //     "token": receiverUserDeviceToken,
    //     "title": "C Talent",
    //     "body": "$initiatorUsername has sent you a message."
    //   };
    //   http.Response response = await PushNotificationRepo.sendPushNotification(
    //       bodyData: jsonEncode(bodyData),
    //       jwt: jwt ?? sharedPreferences.getString('jwt') ?? 'null');
    //   if (response.statusCode == 401 || response.statusCode == 403) {
    //     if (context.mounted) {
    //       EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
    //           dismissOnTap: false, duration: const Duration(seconds: 4));
    //       Provider.of<DrawerProvider>(context, listen: false)
    //           .removeCredentials(context: context);
    //       return;
    //     }
    //   }
    // } else {
    //   return;
    // }
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

  void navigateRouteFromDynamicLink(
      {required Uri deepLink, required BuildContext context}) {
    // Checking for service
    var isInterestClass = deepLink.pathSegments.contains('service');
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
      {required List<XFile> imageFileList}) async {
    List<File> compressedPostImages = [];
    // Compressing each image
    for (int i = 0; i < imageFileList.length; i++) {
      final imageFile = File(imageFileList[i].path);

      final compressedImage = await compressImage(imageFile);
      if (compressedImage != null) {
        compressedPostImages.add(compressedImage);
      }
    }
    return compressedPostImages;
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
    currentUserController.close();
    // profileNewsTopicStreamController.close();
    allProfileTopicController.close();
  }
}
