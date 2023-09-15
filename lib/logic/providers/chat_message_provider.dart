import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/data/repositories/chat/chat_conversation_repo.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ChatMessageProvider extends ChangeNotifier {
  late MainScreenProvider mainScreenProvider;
  ChatMessageProvider({required this.mainScreenProvider});

  // Load all conversations
  AllConversations? _allConversations;
  AllConversations? get allConversations => _allConversations;

  // conversationPageNumber and conversationPageSize is used for pagination
  int conversationPageNumber = 1;
  int conversationPageSize = 10;
  // conversationHasMore will be true until we have more data to fetch in the API
  bool conversationHasMore = true;
  // It will be true once we try to fetch more data.
  bool conversationIsLoading = false;

  // This method will be called to get initial conversations, when user is logged in
  Future<void> loadInitialConversations(
      {required BuildContext context,
      required StreamController<AllConversations?>
          allConversationsController}) async {
    try {
      Response response = await ChatConversationRepo.getAllChatConversation(
          accessToken: mainScreenProvider.currentAccessToken.toString(),
          page: conversationPageNumber.toString(),
          pageSize: conversationPageSize.toString());
      if (response.statusCode == 200) {
        _allConversations = allConversationsFromJson(response.body);
        if (_allConversations != null) {
          allConversationsController.sink.add(_allConversations!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialConversations(
                context: context,
                allConversationsController: allConversationsController);
          } else {
            return;
          }
        }
      } else {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: false, duration: const Duration(seconds: 4));
        }
        return;
      }
    } catch (err) {
      if (err.toString() == 'Connection refused') {
        EasyLoading.showInfo("Please check your internet connection.",
            duration: const Duration(seconds: 4), dismissOnTap: true);
      }
    }
  }

  // Loading more conversations when user reach maximum pageSize item of a page in listview
  Future loadMoreConversations(
      {required BuildContext context,
      required StreamController<AllConversations?>
          allConversationsController}) async {
    conversationPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (conversationIsLoading) {
      return;
    }
    conversationIsLoading = true;
    Response response = await ChatConversationRepo.getAllChatConversation(
        accessToken: mainScreenProvider.currentAccessToken.toString(),
        page: conversationPageNumber.toString(),
        pageSize: conversationPageSize.toString());
    if (response.statusCode == 200) {
      final newConversations = allConversationsFromJson(response.body);

      // conversationIsLoading = false indicates that the loading is complete
      conversationIsLoading = false;

      if (newConversations.conversations == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newConversations.conversations!.length < conversationPageSize) {
        conversationHasMore = false;
      }

      for (int i = 0; i < newConversations.conversations!.length; i++) {
        _allConversations!.conversations!
            .add(newConversations.conversations![i]);
      }
      allConversationsController.sink.add(_allConversations!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreConversations(
              context: context,
              allConversationsController: allConversationsController);
        } else {
          return;
        }
      }
    } else {
      return false;
    }
  }

  Future refreshAllConversations(
      {required BuildContext context,
      required StreamController<AllConversations?>
          allConversationsStreamController}) async {
    conversationIsLoading = false;
    conversationHasMore = true;
    conversationPageNumber = 1;
    if (_allConversations != null) {
      _allConversations!.conversations!.clear();
      allConversationsStreamController.sink.add(_allConversations!);
    }
    await loadInitialConversations(
        context: context,
        allConversationsController: allConversationsStreamController);
    notifyListeners();
  }
}
