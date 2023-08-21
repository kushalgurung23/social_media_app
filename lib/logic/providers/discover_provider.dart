import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:c_talent/data/models/search_user_model.dart';
import 'package:c_talent/data/repositories/user_search_repo.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverProvider extends ChangeNotifier {
  late TextEditingController searchUserTextController;
  late final MainScreenProvider mainScreenProvider;
  DiscoverProvider({required this.mainScreenProvider}) {
    searchUserTextController = TextEditingController();
  }
  StreamController<List<SearchUser>> searchUserStreamController =
      BehaviorSubject();

  // if false, then discover part one will be displayed
  bool isSearchClick = false;

  // When back button is clicked from discover part two, discover part one will be displayed
  void backArrowClick({required BuildContext context}) {
    if (isSearchClick == false) {
      isSearchClick = true;
    } else {
      isSearchClick = false;
    }
    FocusScope.of(context).unfocus();
    searchUserTextController.clear();
    notifyListeners();
  }

  void textFieldToggle() {
    if (isSearchClick == false) {
      isSearchClick = true;
    }
    notifyListeners();
  }

  Future<void> cancelSearch({required BuildContext context}) async {
    await Future.delayed(const Duration(milliseconds: 0), () {
      FocusScope.of(context).unfocus();
      searchUserTextController.clear();
    });
    isSearchClick = false;
    notifyListeners();
  }

  // User search
  List<SearchUser> searchedUserList = [];

  int getUserCount({required List<SearchUser> allUser}) {
    searchedUserList = allUser;
    return searchedUserList.length;
  }

  int searchUserPageStart = 0;
  int searchUserPageLimit = 15;
  bool searchUserHasMore = true;
  bool searchUserIsLoading = false;

  bool noRecord = false;

  // if search field is empty, don't hit request
  bool emptySearchField = false;
  Future searchUser(
          {required String query, required BuildContext context}) async =>
      debounce(() async {
        if (searchUserTextController.text.trim() == '' && query.trim() == '') {
          emptySearchField = true;
          notifyListeners();
          return;
        }
        if (emptySearchField == true) {
          emptySearchField = false;
        }
        final response = await UserSearchRepo.getSearchUsers(
            myId: mainScreenProvider.userId.toString(),
            jwt: mainScreenProvider.jwt.toString(),
            username: query.trim().toLowerCase(),
            start: searchUserPageStart.toString(),
            limit: searchUserPageLimit.toString());
        if (response.statusCode == 200) {
          final allUsers = searchUserFromJson(response.body);
          searchUserStreamController.sink.add(allUsers);
          final filterUserList = allUsers.where((element) {
            final contentLower = element.username!.trim().toLowerCase();
            final searchLower = query.trim().toLowerCase();
            return contentLower.contains(searchLower);
          }).toList();
          searchedUserList = filterUserList;
          if (searchedUserList.isNotEmpty) {
            noRecord = false;
          } else if (searchedUserList.isEmpty) {
            noRecord = true;
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
          throw Exception(
              ((jsonDecode(response.body))["error"]["message"]).toString());
        }
      });

  Future loadMoreSearchUsers({required BuildContext context}) async {
    if (searchUserIsLoading) {
      return;
    }
    searchUserPageStart = searchUserPageStart + 15;
    searchUserIsLoading = true;
    final response = await UserSearchRepo.getSearchUsers(
        myId: mainScreenProvider.userId.toString(),
        jwt: mainScreenProvider.jwt!,
        username: searchUserTextController.text.trim().toLowerCase(),
        start: searchUserPageStart.toString(),
        limit: searchUserPageLimit.toString());
    if (response.statusCode == 200) {
      final newSearchUsers = searchUserFromJson(response.body);

      // loading is complete
      searchUserIsLoading = false;

      // If the newly added data is less than our default pageLimit, it means we won't have further more data. Hence hasMore = false
      if (newSearchUsers.length < searchUserPageLimit) {
        searchUserHasMore = false;
      }

      if (newSearchUsers.isNotEmpty) {
        for (int i = 0; i < newSearchUsers.length; i++) {
          searchedUserList.add(newSearchUsers[i]);
        }
        searchUserStreamController.sink.add(searchedUserList);
        final filterUserList = searchedUserList.where((element) {
          final contentLower = element.username!.trim().toLowerCase();
          final searchLower =
              searchUserTextController.text.trim().toLowerCase();
          return contentLower.contains(searchLower);
        }).toList();
        searchedUserList = filterUserList;
        if (searchedUserList.isNotEmpty) {
          noRecord = false;
        } else if (searchedUserList.isEmpty) {
          noRecord = true;
        }
        notifyListeners();
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      throw Exception(
          ((jsonDecode(response.body))["error"]["message"]).toString());
    }
  }

  bool isSearchUserRefresh = false;
  Future searchUserRefresh() async {
    isSearchUserRefresh = true;
    searchUserIsLoading = false;
    searchUserHasMore = true;
    searchUserPageStart = 0;
    if (searchedUserList.isNotEmpty) {
      searchedUserList.clear();
      searchUserStreamController.sink.add(searchedUserList);
    }
    isSearchUserRefresh = false;
  }

  Timer? debouncer;

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 800),
  }) {
    // To make sure only one request is going to the server per second
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  void dispose() {
    searchUserStreamController.close();
    debouncer?.cancel();
    super.dispose();
  }
}
