import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/repositories/profile/profile_repo.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/all_followers.dart';
import '../../data/models/all_followings.dart';
import 'auth_provider.dart';
import 'drawer_provider.dart';

class ProfileFollowProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  ProfileFollowProvider({required this.mainScreenProvider});

  AllFollowings? _profileFollowings;
  AllFollowings? get profileFollowings => _profileFollowings;

  StreamController<AllFollowings?> profileFollowingsStreamController =
      BehaviorSubject<AllFollowings>();

  // profileFollowingPageNum and profileFollowingPageSize is used for pagination
  int profileFollowingPageNum = 1;
  int profileFollowingPageSize = 10;
  // hasMoreFollowings will be true until we have more data to fetch in the API
  bool hasMoreFollowings = true;
  // isLoadingFollowings will be true once we try to fetch more profile followings.
  bool isLoadingFollowings = false;

  // This method will be called to get profile followings
  Future<void> loadInitialProfileFollowings(
      {required BuildContext context}) async {
    try {
      Response response = await ProfileFollowRepo.loadMyFollowings(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: profileFollowingPageNum.toString(),
          pageSize: profileFollowingPageSize.toString());
      // AFTER REFRESHING, isRefreshingProfileFollowings value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingProfileFollowings == true) {
        isRefreshingProfileFollowings = false;
      }
      if (response.statusCode == 200) {
        _profileFollowings = allFollowingsFromJson(response.body);
        if (_profileFollowings != null) {
          profileFollowingsStreamController.sink.add(_profileFollowings!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialProfileFollowings(context: context);
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

  // Loading more profile followings when user reach maximum pageSize item
  Future loadMoreProfileFollowings({required BuildContext context}) async {
    profileFollowingPageNum++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data, we will get exit from this method.
    if (isLoadingFollowings || hasMoreFollowings == false) {
      return;
    }
    isLoadingFollowings = true;
    Response response = await ProfileFollowRepo.loadMyFollowings(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: profileFollowingPageNum.toString(),
        pageSize: profileFollowingPageSize.toString());
    if (response.statusCode == 200) {
      final newFollowings = allFollowingsFromJson(response.body);

      if (newFollowings.followings == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newFollowings.followings!.length < profileFollowingPageSize) {
        hasMoreFollowings = false;
      }
      _profileFollowings!.followings = [
        ..._profileFollowings!.followings!,
        ...newFollowings.followings!
      ];

      profileFollowingsStreamController.sink.add(_profileFollowings!);
      // isLoadingFollowings = false indicates that the loading is complete
      isLoadingFollowings = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreProfileFollowings(context: context);
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

  bool isRefreshingProfileFollowings = false;
  Future refreshProfileFollowings({required BuildContext context}) async {
    isRefreshingProfileFollowings = true;
    notifyListeners();
    isLoadingFollowings = false;
    hasMoreFollowings = true;
    profileFollowingPageNum = 1;
    if (_profileFollowings?.followings != null) {
      _profileFollowings!.followings!.clear();
    }
    await loadInitialProfileFollowings(context: context);
    isRefreshingProfileFollowings = false;
    notifyListeners();
  }

  AllFollowers? _profileFollowers;
  AllFollowers? get profileFollowers => _profileFollowers;

  StreamController<AllFollowers?> profileFollowersStreamController =
      BehaviorSubject<AllFollowers>();

  // profileFollowersPageNum and profileFollowersPageSize is used for pagination
  int profileFollowersPageNum = 1;
  int profileFollowersPageSize = 10;
  // hasMoreFollowers will be true until we have more data to fetch in the API
  bool hasMoreFollowers = true;
  // isLoadingFollowers will be true once we try to fetch more profile followers.
  bool isLoadingFollowers = false;

  // This method will be called to get profile followers
  Future<void> loadInitialProfileFollowers(
      {required BuildContext context}) async {
    try {
      Response response = await ProfileFollowRepo.loadMyFollowers(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: profileFollowersPageNum.toString(),
          pageSize: profileFollowersPageSize.toString());
      // AFTER REFRESHING, isRefreshingProfileFollowers value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingProfileFollowers == true) {
        isRefreshingProfileFollowers = false;
      }
      if (response.statusCode == 200) {
        _profileFollowers = allFollowersFromJson(response.body);
        if (_profileFollowers != null) {
          profileFollowersStreamController.sink.add(_profileFollowers!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialProfileFollowers(context: context);
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

  // Loading more profile followers when user reach maximum pageSize item
  Future loadMoreProfileFollowers({required BuildContext context}) async {
    profileFollowersPageNum++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data, we will get exit from this method.
    if (isLoadingFollowers || hasMoreFollowers == false) {
      print('no need to call');
      return;
    }
    isLoadingFollowers = true;
    Response response = await ProfileFollowRepo.loadMyFollowers(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: profileFollowersPageNum.toString(),
        pageSize: profileFollowersPageSize.toString());
    if (response.statusCode == 200) {
      final newFollowers = allFollowersFromJson(response.body);

      if (newFollowers.followers == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newFollowers.followers!.length < profileFollowersPageSize) {
        hasMoreFollowers = false;
      }
      _profileFollowers!.followers = [
        ..._profileFollowers!.followers!,
        ...newFollowers.followers!
      ];

      profileFollowersStreamController.sink.add(_profileFollowers!);
      // isLoadingFollowers = false indicates that the loading is complete
      isLoadingFollowers = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreProfileFollowers(context: context);
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

  bool isRefreshingProfileFollowers = false;
  Future refreshProfileFollowers({required BuildContext context}) async {
    isRefreshingProfileFollowers = true;
    notifyListeners();
    isLoadingFollowers = false;
    hasMoreFollowers = true;
    profileFollowersPageNum = 1;
    if (_profileFollowers?.followers != null) {
      _profileFollowers!.followers!.clear();
    }
    await loadInitialProfileFollowers(context: context);
    isRefreshingProfileFollowers = false;
    notifyListeners();
  }

  @override
  void dispose() {
    profileFollowingsStreamController.close();
    profileFollowersStreamController.close();
    super.dispose();
  }
}
