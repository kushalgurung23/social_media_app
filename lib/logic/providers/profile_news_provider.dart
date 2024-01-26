import 'dart:async';
import 'package:c_talent/data/repositories/profile/profile_posts_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/models/profile_news.dart';
import 'package:c_talent/data/repositories/profile/profile_repo.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ProfileNewsProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  ProfileNewsProvider({required this.mainScreenProvider});

  AllProfileNews? _myProfileNews;
  AllProfileNews? get myProfileNews => _myProfileNews;

  StreamController<AllProfileNews?> myProfileNewsStreamController =
      BehaviorSubject<AllProfileNews>();

  // myProfileNewsPageNum and myProfileNewsPageSize is used for pagination
  int myProfileNewsPageNum = 1;
  int myProfileNewsPageSize = 6;
  // myProfileNewsHasMore will be true until we have more data to fetch in the API
  bool myProfileNewsHasMore = true;
  // myProfileNewsIsLoading will be true once we try to fetch more profile news.
  bool myProfileNewsIsLoading = false;

  // This method will be called to get profile news
  Future<void> loadMyInitialProfileNews({required BuildContext context}) async {
    try {
      Response response = await ProfilePostsRepo.loadMyNewsTopics(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: myProfileNewsPageNum.toString(),
          pageSize: myProfileNewsPageSize.toString());
      // AFTER REFRESHING, isRefreshingProfileNews value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingMyProfileNews == true) {
        isRefreshingMyProfileNews = false;
      }
      if (response.statusCode == 200) {
        _myProfileNews = allProfileNewsFromJson(response.body);
        if (_myProfileNews != null) {
          myProfileNewsStreamController.sink.add(_myProfileNews!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadMyInitialProfileNews(context: context);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
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
            duration: const Duration(seconds: 5), dismissOnTap: true);
      }
    }
  }

  // Loading more profile news when user reach maximum pageSize item
  Future loadMoreMyProfileNews({required BuildContext context}) async {
    myProfileNewsPageNum++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data, we will get exit from this method.
    if (myProfileNewsIsLoading || myProfileNewsHasMore == false) {
      return;
    }
    myProfileNewsIsLoading = true;
    Response response = await ProfilePostsRepo.loadMyNewsTopics(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: myProfileNewsPageNum.toString(),
        pageSize: myProfileNewsPageSize.toString());
    if (response.statusCode == 200) {
      final newProfileNews = allProfileNewsFromJson(response.body);

      if (newProfileNews.news == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newProfileNews.news!.length < myProfileNewsPageSize) {
        myProfileNewsHasMore = false;
      }
      _myProfileNews!.news = [
        ..._myProfileNews!.news!,
        ...newProfileNews.news!
      ];

      myProfileNewsStreamController.sink.add(_myProfileNews!);
      // profileNewsIsLoading = false indicates that the loading is complete
      myProfileNewsIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreMyProfileNews(context: context);
        } else {
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
      }
    } else {
      return false;
    }
  }

  bool isRefreshingMyProfileNews = false;
  Future refreshMyProfileNews({required BuildContext context}) async {
    isRefreshingMyProfileNews = true;
    notifyListeners();
    myProfileNewsIsLoading = false;
    myProfileNewsHasMore = true;
    myProfileNewsPageNum = 1;
    if (_myProfileNews?.news != null) {
      _myProfileNews!.news!.clear();
    }
    await loadMyInitialProfileNews(context: context);
    isRefreshingMyProfileNews = false;
    notifyListeners();
  }

  int selectedMyProfileTopicIndex = 0;
  Future<void> changeMySelectedProfileTopic(
      {required bool isAdd, required BuildContext context}) async {
    if (isAdd) {
      // print('profileNewsPageNum $profileNewsPageNum');
      // print('available page is ${(_profileNews!.count! / 6).ceil()}');
      selectedMyProfileTopicIndex++;
      // print(selectedProfileTopicIndex);
      if (selectedMyProfileTopicIndex == myProfileNewsPageNum &&
          _myProfileNews?.count != null &&
          myProfileNewsPageNum < (_myProfileNews!.count! / 6).ceil()) {
        await loadMoreMyProfileNews(context: context);
      }
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedMyProfileTopicIndex >= 1) {
        selectedMyProfileTopicIndex--;
      }
    }
    if (context.mounted) {
      scrollToItemLastTopic(context: context);
    }
    notifyListeners();
  }

  AllProfileNews? _bkmarkProfileNews;
  AllProfileNews? get bkmarkProfileNews => _bkmarkProfileNews;

  StreamController<AllProfileNews?> bkmarkProfileNewsStreamController =
      BehaviorSubject<AllProfileNews>();

  // bkmarkProfileNewsPageNum and bkmarkProfileNewsPageSize is used for pagination
  int bkmarkProfileNewsPageNum = 1;
  int bkmarkProfileNewsPageSize = 6;
  // bkmarkProfileNewsHasMore will be true until we have more data to fetch in the API
  bool bkmarkProfileNewsHasMore = true;
  // bkmarkProfileNewsIsLoading will be true once we try to fetch more profile news.
  bool bkmarkProfileNewsIsLoading = false;

  // This method will be called to get bookmarked news
  Future<void> loadInitialBookmarkProfileNews(
      {required BuildContext context}) async {
    try {
      Response response = await ProfilePostsRepo.loadMyBookmarkTopics(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: bkmarkProfileNewsPageNum.toString(),
          pageSize: bkmarkProfileNewsPageSize.toString());
      // AFTER REFRESHING, isRefreshingBookmarkNews value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingBookmarkNews == true) {
        isRefreshingBookmarkNews = false;
      }
      if (response.statusCode == 200) {
        _bkmarkProfileNews = allProfileNewsFromJson(response.body);
        if (_bkmarkProfileNews != null) {
          bkmarkProfileNewsStreamController.sink.add(_bkmarkProfileNews!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialBookmarkProfileNews(context: context);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
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
            duration: const Duration(seconds: 5), dismissOnTap: true);
      }
    }
  }

  // Loading more profile news when user reach maximum pageSize item
  Future loadMoreBookmarkProfileNews({required BuildContext context}) async {
    bkmarkProfileNewsPageNum++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data, we will get exit from this method.
    if (bkmarkProfileNewsIsLoading || bkmarkProfileNewsHasMore == false) {
      return;
    }
    bkmarkProfileNewsIsLoading = true;
    Response response = await ProfilePostsRepo.loadMyBookmarkTopics(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: bkmarkProfileNewsPageNum.toString(),
        pageSize: bkmarkProfileNewsPageSize.toString());
    if (response.statusCode == 200) {
      final newProfileNews = allProfileNewsFromJson(response.body);

      if (newProfileNews.news == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newProfileNews.news!.length < bkmarkProfileNewsPageSize) {
        bkmarkProfileNewsHasMore = false;
      }
      _bkmarkProfileNews!.news = [
        ..._bkmarkProfileNews!.news!,
        ...newProfileNews.news!
      ];

      bkmarkProfileNewsStreamController.sink.add(_bkmarkProfileNews!);
      // bkmarkProfileNewsIsLoading = false indicates that the loading is complete
      bkmarkProfileNewsIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreBookmarkProfileNews(context: context);
        } else {
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
      }
    } else {
      return false;
    }
  }

  bool isRefreshingBookmarkNews = false;
  Future refreshBookmarkProfileNews({required BuildContext context}) async {
    isRefreshingBookmarkNews = true;
    notifyListeners();
    bkmarkProfileNewsIsLoading = false;
    bkmarkProfileNewsHasMore = true;
    bkmarkProfileNewsPageNum = 1;
    if (_bkmarkProfileNews?.news != null) {
      _bkmarkProfileNews!.news!.clear();
    }
    await loadInitialBookmarkProfileNews(context: context);
    isRefreshingBookmarkNews = false;
    notifyListeners();
  }

  int selectedBookmarkedTopicIndex = 0;

  Future<void> changeBookmarkedTopic(
      {required bool isAdd, required BuildContext context}) async {
    if (isAdd) {
      selectedBookmarkedTopicIndex++;

      if (selectedBookmarkedTopicIndex == bkmarkProfileNewsPageNum &&
          _bkmarkProfileNews?.count != null &&
          bkmarkProfileNewsPageNum < (_bkmarkProfileNews!.count! / 6).ceil()) {
        await loadMoreBookmarkProfileNews(context: context);
      }
    }

    // GO BACK
    else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedBookmarkedTopicIndex >= 1) {
        selectedBookmarkedTopicIndex--;
      }
    }
    if (context.mounted) {
      scrollToItemBookmarkedTopic(context: context);
    }
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
    if (selectedMyProfileTopicIndex != 0) {
      selectedMyProfileTopicIndex = 0;
    }
    if (selectedBookmarkedTopicIndex != 0) {
      selectedBookmarkedTopicIndex = 0;
    }
    notifyListeners();
  }

  int selectedOtherProfileTopicIndex = 0;

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

  void resetOtherUserLastTopicIndex() {
    if (selectedOtherProfileTopicIndex != 0) {
      selectedOtherProfileTopicIndex = 0;
    }
    notifyListeners();
  }

  Future otherProfileScroll({required BuildContext context}) async {
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    myProfileNewsStreamController.close();
    bkmarkProfileNewsStreamController.close();
    super.dispose();
  }
}
