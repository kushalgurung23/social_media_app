import 'dart:async';
import 'dart:convert';
import 'package:c_talent/data/models/all_push_notifications.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/repositories/push_notifications/push_notification_repo.dart';
import '../../presentation/helper/size_configuration.dart';
import 'auth_provider.dart';
import 'drawer_provider.dart';

class PushNotificationProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  PushNotificationProvider({required this.mainScreenProvider});

  String returnMessage({required String type, required BuildContext context}) {
    if (type == 'follow') {
      return AppLocalizations.of(context).startedFollowingYou;
    } else if (type == 'unfollow') {
      return AppLocalizations.of(context).unfollowedYou;
    } else if (type == 'comment') {
      return 'commented on your post.';
    } else {
      return 'liked your post.';
    }
  }

  Widget returnIcon({required String type}) {
    if (type == 'comment') {
      return SvgPicture.asset(
        "assets/svg/comment.svg",
        width: SizeConfig.defaultSize * 1.3,
        height: SizeConfig.defaultSize * 1.3,
      );
    } else if (type == 'follow' || type == 'unfollow') {
      return Transform.translate(
        offset: const Offset(-2, 0),
        child: SvgPicture.asset(
          "assets/svg/person_follow.svg",
          width: SizeConfig.defaultSize * 1.2,
          height: SizeConfig.defaultSize * 1.3,
        ),
      );
    } else {
      return SvgPicture.asset(
        "assets/svg/heart.svg",
        width: SizeConfig.defaultSize * 1.3,
        height: SizeConfig.defaultSize * 1.3,
      );
    }
  }

  AllPushNotifications? _allPushNotifications;
  AllPushNotifications? get allPushNotifications => _allPushNotifications;

  StreamController<AllPushNotifications?> allPushNotificationStreamController =
      BehaviorSubject<AllPushNotifications>();

  // pushNotificationPageNumber and pushNotificationPageSize is used for pagination
  int pushNotificationPageNumber = 1;
  int pushNotificationPageSize = 10;
  // pushNotificationHasMore will be true until we have more data to fetch in the API
  bool pushNotificationHasMore = true;
  // pushNotificationIsLoading will be true once we try to fetch more notifications.
  bool pushNotificationIsLoading = false;

  // This method will be called to get push notifications
  Future<void> loadInitialPushNotifications(
      {required BuildContext context}) async {
    try {
      Response response = await PushNotificationRepo.loadPushNotification(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: pushNotificationPageNumber.toString(),
          pageSize: pushNotificationPageSize.toString());
// AFTER REFRESHING, isRefreshingNotification value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingNotification == true) {
        isRefreshingNotification = false;
      }
      if (response.statusCode == 200) {
        _allPushNotifications = allPushNotificationsFromJson(response.body);
        if (_allPushNotifications != null) {
          allPushNotificationStreamController.sink.add(_allPushNotifications!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialPushNotifications(context: context);
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

  // Loading more push notifications when user reach maximum pageSize item of a page in listview
  Future loadMorePushNotifications({required BuildContext context}) async {
    pushNotificationPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (pushNotificationIsLoading) {
      return;
    }
    pushNotificationIsLoading = true;
    Response response = await PushNotificationRepo.loadPushNotification(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: pushNotificationPageNumber.toString(),
        pageSize: pushNotificationPageSize.toString());
    if (response.statusCode == 200) {
      final newPushNotifications = allPushNotificationsFromJson(response.body);

      if (newPushNotifications.notifications == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPushNotifications.notifications!.length <
          pushNotificationPageSize) {
        pushNotificationHasMore = false;
      }
      _allPushNotifications!.notifications = [
        ..._allPushNotifications!.notifications!,
        ...newPushNotifications.notifications!
      ];
      allPushNotificationStreamController.sink.add(_allPushNotifications!);
      // pushNotificationIsLoading = false indicates that the loading is complete
      pushNotificationIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMorePushNotifications(context: context);
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

  bool isRefreshingNotification = false;
  Future refreshPushNotifications({required BuildContext context}) async {
    isRefreshingNotification = true;
    notifyListeners();
    pushNotificationIsLoading = false;
    pushNotificationHasMore = true;
    pushNotificationPageNumber = 1;
    if (_allPushNotifications?.notifications != null) {
      _allPushNotifications!.notifications!.clear();
    }
    await loadInitialPushNotifications(context: context);
    isRefreshingNotification = false;
    notifyListeners();
  }

  // READ NOTIFICATION
  bool readNotificationOnProcess = false;

  Future<void> readNotification(
      {required PushNotification pushNotification,
      required BuildContext context}) async {
    int? currentReadStatus = pushNotification.isRead;
    // IF ALREADY READ, RETURN
    if (currentReadStatus == 1) {
      return;
    }
    // THIS METHOD IS CALLED WHEN READ NOTIFICATION FAILS TO KEEP ORIGINAL STATE
    void onReadNotificationFailed() {
      // if error occurs, keep current save status
      pushNotification.isRead = currentReadStatus;
      readNotificationOnProcess = false;
      notifyListeners();
    }

    try {
      if (readNotificationOnProcess == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        readNotificationOnProcess = true;
        if (currentReadStatus != 1) {
          pushNotification.isRead = 1;
        }
        notifyListeners();
        Response response = await PushNotificationRepo.readPushNotification(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            notificationId: pushNotification.id.toString());

        if (response.statusCode == 200 && context.mounted) {
          readNotificationOnProcess = false;
          notifyListeners();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          onReadNotificationFailed();

          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return readNotification(
                pushNotification: pushNotification, context: context);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
            return;
          }
        } else if ((jsonDecode(response.body))["status"] == 'Error') {
          onReadNotificationFailed();
          if (context.mounted) {
            EasyLoading.showInfo((jsonDecode(response.body))["msg"],
                dismissOnTap: false, duration: const Duration(seconds: 4));
          }
        } else {
          onReadNotificationFailed();
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: false, duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      onReadNotificationFailed();
      EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
          dismissOnTap: false, duration: const Duration(seconds: 4));
    }
  }

  @override
  void dispose() {
    allPushNotificationStreamController.close();
    super.dispose();
  }
}
