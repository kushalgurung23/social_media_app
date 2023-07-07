import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/conversation_model.dart';
import 'package:spa_app/data/models/socket_message_model.dart';
import 'package:spa_app/data/repositories/chat_messages_repo.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/components/chat/chat_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatMessageProvider extends ChangeNotifier {
  late SharedPreferences sharedPreferences =
      mainScreenProvider.sharedPreferences;
  late final MainScreenProvider mainScreenProvider;
  late TextEditingController chatTextController;
  StreamController<Conversation?> allConversationStreamController =
      BehaviorSubject();

  ChatMessageProvider({required this.mainScreenProvider}) {
    initial();
    chatTextController = TextEditingController();
  }

  Future initial() async {
    sharedPreferences = mainScreenProvider.sharedPreferences;
  }

// Selected other user chat conversation
  Conversation? _oneConversation;
  Conversation? get oneConversationersation => _oneConversation;

  Future<void> loadOneUserConversation(
      {required String otherUserId, required BuildContext context}) async {
    await initial();
    Response loadConversationResponse =
        await ChatMessagesRepo.getOneSelectedUserConversation(
            jwt: sharedPreferences.getString('jwt') ?? 'null',
            currentUserId: mainScreenProvider.userId!,
            otherUserId: otherUserId);
    if (loadConversationResponse.statusCode == 200) {
      _oneConversation = conversationFromJson(loadConversationResponse.body);
      notifyListeners();
      // If there is already previous conversation with the other user, we will navigate to chat screen and continue from the last conversation
      if (_oneConversation!.data!.length.toString() == '1') {
        navigateToChatScreenFromOtherUserProfile(context: context);
      }
      // If there is no previous conversation, we will create a new conversation first, and then navigate to chat screen
      else {
        Map conversationBodyData = {
          "first_user": mainScreenProvider.userId.toString(),
          "second_user": otherUserId
        };

        Response createConversationResponse =
            await ChatMessagesRepo.startANewConversation(
          bodyData: conversationBodyData,
          jwt: sharedPreferences.getString('jwt') ?? 'null',
        );
        // if new conversation is created
        if (createConversationResponse.statusCode == 200) {
          // then we will load the conversation info
          Response loadAfterCreatingConversationResponse =
              await ChatMessagesRepo.getOneSelectedUserConversation(
                  jwt: sharedPreferences.getString('jwt') ?? 'null',
                  currentUserId: mainScreenProvider.userId!,
                  otherUserId: otherUserId);
          // if we are able to load conversation info,
          if (loadAfterCreatingConversationResponse.statusCode == 200) {
            _oneConversation = conversationFromJson(
                loadAfterCreatingConversationResponse.body);
            if (_allConversation != null && _oneConversation != null) {
              _allConversation!.data!.add(_oneConversation!.data![0]);
              allConversationStreamController.sink.add(_allConversation!);
              notifyListeners();
            }

            if (_oneConversation!.data!.length.toString() == '1') {
              if (_allConversation == null) {
                _allConversation = _oneConversation;
                allConversationStreamController.sink.add(_allConversation!);
                notifyListeners();
              }

              navigateToChatScreenFromOtherUserProfile(context: context);
            } else {
              showSnackBar(
                  context: context,
                  content: AppLocalizations.of(context).tryAgainLater,
                  backgroundColor: Colors.red,
                  contentColor: Colors.white);
              throw Exception('Conversation data is not equal to 1');
            }
          } else if (loadAfterCreatingConversationResponse.statusCode == 401 ||
              loadAfterCreatingConversationResponse.statusCode == 403) {
            if (context.mounted) {
              EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
                  dismissOnTap: false, duration: const Duration(seconds: 4));
              Provider.of<DrawerProvider>(context, listen: false)
                  .removeCredentials(context: context);
            }
          } else {
            showSnackBar(
                context: context,
                content: AppLocalizations.of(context).tryAgainLater,
                backgroundColor: Colors.red,
                contentColor: Colors.white);
            throw Exception(
                'Unable to load conversation after creating new conversation');
          }
        } else if (createConversationResponse.statusCode == 401 ||
            createConversationResponse.statusCode == 403) {
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
              backgroundColor: Colors.red,
              contentColor: Colors.white);
          throw Exception('Unable to create new conversation');
        }
      }
    } else if (loadConversationResponse.statusCode == 401 ||
        loadConversationResponse.statusCode == 403) {
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
          backgroundColor: Colors.red,
          contentColor: Colors.white);
      throw Exception('Unable to create new conversation');
    }
  }

  Future<void> updateLastTimeRead(
      {required String conversationId,
      required Map bodyData,
      required BuildContext context}) async {
    Response response = await ChatMessagesRepo.updateLastReadMessage(
      conversationId: conversationId,
      bodyData: bodyData,
      jwt: sharedPreferences.getString('jwt') ?? 'null',
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      throw Exception('unable to update time');
    }
  }

  Future<void> updateLastTimeReadWhenReceivedMessage(
      {required String otherUsername,
      required DateTime lastTextCreatedAt,
      required String firstUserId,
      required String secondUser,
      required String receiverUserId,
      required BuildContext context,
      required String conversationId}) async {
    // updateOneConversationData will first update the latest message received and display in last message text area
    await updateOneConversationData(
            conversationId: conversationId, context: context)
        .then((value) async {
      DateTime lastReadDateTime = lastTextCreatedAt.isAfter(DateTime.now())
          ? lastTextCreatedAt
          : DateTime.now();

      Map bodyData;

      await sharedPreferences.reload();
      if (sharedPreferences.getString('active_chat_username') ==
          otherUsername) {
        // if we are first user
        if (firstUserId == receiverUserId &&
            receiverUserId == mainScreenProvider.userId) {
          bodyData = {
            "data": {
              "first_user_last_read":
                  lastReadDateTime.add(const Duration(seconds: 1)).toString()
            }
          };
          // update the last time read for first user
          await updateLastTimeRead(
              conversationId: conversationId,
              bodyData: bodyData,
              context: context);
          notifyListeners();
        }
        // if we are second user
        else if (secondUser == receiverUserId &&
            receiverUserId == mainScreenProvider.userId) {
          bodyData = {
            "data": {
              "second_user_last_read":
                  lastReadDateTime.add(const Duration(seconds: 1)).toString()
            }
          };
          //  update the last time read for second user
          await updateLastTimeRead(
              conversationId: conversationId,
              bodyData: bodyData,
              context: context);
          notifyListeners();
        }
      } else {
        return;
      }
    });
    // finally this will help to update last time read, so that the color of container will be back to white if message is already seen
    await updateOneConversationData(
        conversationId: conversationId, context: context);
    notifyListeners();
  }

  Future<void> updateOneConversationData(
      {required String conversationId, required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response =
        await ChatMessagesRepo.getOneUpdatedCurrentUserConversation(
            conversationId: conversationId,
            jwt: sharedPreferences.getString('jwt') ?? 'null');
    if (response.statusCode == 200) {
      final oneConversation = singleConversationFromJson(response.body).data;
      if (oneConversation != null && _allConversation != null) {
        final conversationIndex = _allConversation!.data!.indexWhere(
            (element) =>
                element.id.toString() == oneConversation.id.toString());
        if (conversationIndex != -1) {
          _allConversation!.data![conversationIndex] = oneConversation;
          if (_allConversation != null && _allConversation!.data != null) {
            _allConversation!.data!.sort((a, b) {
              if (b.attributes!.lastTextAt == null &&
                  a.attributes!.lastTextAt == null) {
                return 0;
              } else if (a.attributes!.lastTextAt == null) {
                return -1;
              } else if (b.attributes!.lastTextAt == null) {
                return 1;
              } else {
                return b.attributes!.lastTextAt!
                    .compareTo(a.attributes!.lastTextAt!);
              }
            });
          }
          allConversationStreamController.sink.add(_allConversation);
          notifyListeners();
        }
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    }
  }

  Future<void> navigateToChatScreenFromChatroom(
      {required bool isFirstUser,
      required String myImageUrl,
      required String otherUserImageUrl,
      required List<ConversationMessagesData>? messageConversationList,
      required String otherUserId,
      required String otherUsername,
      required TextEditingController chatTextEditingController,
      required String conversationId,
      required String? otherUserDeviceToken,
      required BuildContext context}) async {
    // stores the username of other user that the current user is currently chatting with
    sharedPreferences.setString('active_chat_username', otherUsername);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  otherUserDeviceToken: otherUserDeviceToken,
                  myImageUrl: myImageUrl,
                  otherUserImageUrl: otherUserImageUrl,
                  messageConversationList: messageConversationList,
                  otherUserId: otherUserId,
                  otherUsername: otherUsername,
                  chatTextEditingController: chatTextEditingController,
                  conversationId: conversationId,
                )));
    Map bodyData;
    if (isFirstUser) {
      bodyData = {
        "data": {
          "first_user_last_read": DateTime.now().toString(),
        }
      };
    } else {
      bodyData = {
        "data": {
          "second_user_last_read": DateTime.now().toString(),
        }
      };
    }
    await updateLastTimeRead(
        context: context, conversationId: conversationId, bodyData: bodyData);
    await updateOneConversationData(
        conversationId: conversationId, context: context);
    notifyListeners();
  }

  void navigateToChatScreenFromOtherUserProfile(
      {required BuildContext context}) async {
    String currentUserId =
        Provider.of<MainScreenProvider>(context, listen: false)
            .userId
            .toString();
    final conversationData = _oneConversation!.data![0];
    final firstUser = conversationData.attributes!.firstUser!.data!;
    final secondUser = conversationData.attributes!.secondUser!.data!;
    String otherUsername = firstUser.id.toString() != currentUserId
        ? firstUser.attributes!.username.toString()
        : secondUser.attributes!.username.toString();
    sharedPreferences.setString('active_chat_username', otherUsername);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  otherUserDeviceToken: firstUser.id.toString() == currentUserId
                      ? secondUser.attributes!.deviceToken
                      : firstUser.attributes!.deviceToken,
                  myImageUrl: firstUser.id.toString() == currentUserId &&
                          firstUser.attributes!.profileImage!.data != null
                      ? firstUser
                          .attributes!.profileImage!.data!.attributes!.url
                          .toString()
                      : secondUser.id.toString() == currentUserId &&
                              secondUser.attributes!.profileImage!.data != null
                          ? secondUser
                              .attributes!.profileImage!.data!.attributes!.url
                              .toString()
                          : 'null',
                  otherUserImageUrl: firstUser.id.toString() != currentUserId &&
                          firstUser.attributes!.profileImage!.data != null
                      ? firstUser
                          .attributes!.profileImage!.data!.attributes!.url
                          .toString()
                      : secondUser.id.toString() != currentUserId &&
                              secondUser.attributes!.profileImage!.data != null
                          ? secondUser
                              .attributes!.profileImage!.data!.attributes!.url
                              .toString()
                          : 'null',
                  messageConversationList: conversationData
                      .attributes!.chatMessages!.data!.reversed
                      .toList(),
                  otherUserId: firstUser.id.toString() != currentUserId
                      ? firstUser.id.toString()
                      : secondUser.id.toString(),
                  otherUsername: otherUsername,
                  chatTextEditingController:
                      Provider.of<ChatMessageProvider>(context, listen: false)
                          .chatTextController,
                  conversationId: conversationData.id.toString(),
                )));
    Map bodyData;
    if (firstUser.id.toString() == currentUserId) {
      bodyData = {
        "data": {"first_user_last_read": DateTime.now().toString()}
      };
    } else {
      bodyData = {
        "data": {"second_user_last_read": DateTime.now().toString()}
      };
    }
    await updateLastTimeRead(
        context: context,
        conversationId: conversationData.id.toString(),
        bodyData: bodyData);
    await updateOneConversationData(
        context: context, conversationId: conversationData.id.toString());
    notifyListeners();
  }

  void goBackFromUserChatScreen({required BuildContext context}) {
    if (chatTextController.text != '') {
      chatTextController.clear();
    }
    sharedPreferences.remove('active_chat_username');
    Navigator.pop(context);
  }

  void navigateToOtherUserProfile(
      {required BuildContext context, required int otherUserId}) {
    sharedPreferences.remove('active_chat_username');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OtherUserProfileScreen(otherUserId: otherUserId)));
  }

  Conversation? _allConversation;
  Conversation? get allConversation => _allConversation;

  // page and pageSize is used for pagination
  int page = 1;
  int pageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool hasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isLoading = false;

  Future loadInitialAllConversations({required BuildContext context}) async {
    await initial();

    Response response = await ChatMessagesRepo.getCurrentUserAllConversation(
        page: 1.toString(),
        pageSize: _allConversation != null && _allConversation!.data!.isNotEmpty
            ? _allConversation!.data!.length.toString()
            : pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        currentUserId: mainScreenProvider.userId!);
    if (response.statusCode == 200) {
      _allConversation = conversationFromJson(response.body);
      allConversationStreamController.sink.add(_allConversation!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return false;
      }
    } else {
      return false;
    }
  }

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future loadMoreConversation({required BuildContext context}) async {
    page++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isLoading) {
      return;
    }
    isLoading = true;
    Response response = await ChatMessagesRepo.getCurrentUserAllConversation(
        page: page.toString(),
        pageSize: pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        currentUserId: mainScreenProvider.userId!);
    if (response.statusCode == 200) {
      final newConversations = conversationFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newConversations.data!.length < pageSize) {
        hasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newConversations.data!.length; i++) {
        _allConversation!.data!.add(newConversations.data![i]);
      }
      allConversationStreamController.sink.add(_allConversation!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return false;
      }
    } else {
      return false;
    }
  }

  bool isRefresh = false;
  Future refresh({required BuildContext context}) async {
    isRefresh = true;
    isLoading = false;
    hasMore = true;
    page = 1;
    if (_allConversation != null) {
      _allConversation!.data!.clear();
      allConversationStreamController.sink.add(_allConversation!);
    }

    await loadInitialAllConversations(context: context);
    isRefresh = false;
    notifyListeners();
  }

  // selected user chat conversation
  // ignore: prefer_final_fields
  List<SocketMessage> _socketMessageList = [];

  List<SocketMessage> get socketMessageList => List.from(_socketMessageList);

  void storeAllConversation(
      {required List<ConversationMessagesData>? messageConversationList}) {
    _socketMessageList.clear();
    if (messageConversationList == null) {
      return;
    } else if (messageConversationList.isNotEmpty) {
      for (int i = 0; i < messageConversationList.length; i++) {
        final socketMessage = SocketMessage(
            senderId: messageConversationList[i]
                .attributes!
                .sender!
                .data!
                .id
                .toString(),
            receiverUserId: messageConversationList[i]
                .attributes!
                .receiver!
                .data!
                .id
                .toString(),
            message: messageConversationList[i].attributes!.text,
            sentAt: messageConversationList[i].attributes!.createdAt!);
        if (!_socketMessageList.contains(socketMessage)) {
          _socketMessageList.add(socketMessage);
        }
      }
    }
  }

  void addConversation({required SocketMessage socketMessage}) {
    int i = 0;
    if (!_socketMessageList.contains(socketMessage) && i == 0) {
      i++;
      _socketMessageList.insert(0, socketMessage);
      notifyListeners();
    } else {
      return;
    }
  }

  void clearSocketMessage() {
    _socketMessageList.clear();
  }

  void createConversationIdAgain(
      {required String otherUserId, required BuildContext context}) async {
    Map conversationBodyData = {
      "first_user": mainScreenProvider.userId.toString(),
      "second_user": otherUserId,
    };

    Response createConversationResponse =
        await ChatMessagesRepo.startANewConversation(
      bodyData: conversationBodyData,
      jwt: sharedPreferences.getString('jwt') ?? 'null',
    );
    if (createConversationResponse.statusCode == 200) {
      return;
    } else if (createConversationResponse.statusCode == 401 ||
        createConversationResponse.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    }
  }

  bool isChatMessageReverse = false;

  // this method will be called to reverse the singlechildscrollview to bottom
  void changeReverse({bool fromInitial = false, required bool isReverse}) {
    if (isChatMessageReverse == isReverse) {
      return;
    } else {
      isChatMessageReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  // CHAT MESSAGE NOTIFICATION BADGE

  bool messageNotificationBadge = false;

  void setChatMessageNotification() {
    messageNotificationBadge = true;
    sharedPreferences.setBool("chat_message_push_notification", true);
    notifyListeners();
  }

  void removeChatMessageNotificationBadge() {
    messageNotificationBadge = false;
    sharedPreferences.setBool("chat_message_push_notification", false);
    notifyListeners();
  }

  // When we are in the chatroom screen, we don't want to show notification badge in the notification bell
  void setCurrentlyOnChatroomScreen() {
    sharedPreferences.setBool("chatroom_active_status", true);
    notifyListeners();
  }

  void removeCurrentlyOnChatroomScreen() {
    sharedPreferences.setBool("chatroom_active_status", false);
    notifyListeners();
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

  String convertDateTimeForChat(DateTime input) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final inputDate = DateTime(input.year, input.month, input.day);
    if (inputDate == today) {
      return DateFormat('hh:mm a').format(input).toString();
    } else {
      return (DateFormat.yMd().add_jm().format(input)).toString();
    }
  }

  @override
  void dispose() {
    allConversationStreamController.close();
    chatTextController.dispose();
    super.dispose();
  }
}
