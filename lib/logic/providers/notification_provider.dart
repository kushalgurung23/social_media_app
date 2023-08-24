import 'dart:async';
import 'dart:convert';
import 'package:c_talent/data/new_models/all_news_posts.dart';
import 'package:c_talent/data/repositories/news_post_repo.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/models/promotion_model.dart';
import 'package:c_talent/data/models/push_notification_model.dart';
import 'package:c_talent/data/repositories/promotion_repo.dart';
import 'package:c_talent/data/repositories/push_notification_repo.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  StreamController<PushNotification?> pushNotificationStreamController =
      BehaviorSubject();
  StreamController<Promotion?> promotionStreamController = BehaviorSubject();
  late final MainScreenProvider mainScreenProvider;

  NotificationProvider({required this.mainScreenProvider});

  String returnMessage({required String type, required BuildContext context}) {
    if (type == 'follow') {
      return AppLocalizations.of(context).startedFollowingYou;
    } else {
      return AppLocalizations.of(context).unfollowedYou;
    }
  }

  Widget returnIcon({required String type}) {
    if (type == 'reply') {
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

  String getMessageTabHeading(
      {required int index, required BuildContext context}) {
    if (index == 0) {
      return AppLocalizations.of(context).followNotifications;
    } else {
      return AppLocalizations.of(context).promotions;
    }
  }

  // NOTIFICATION
  PushNotification? _pushNotification;
  PushNotification? get pushNotification => _pushNotification;

  // page and pageSize is used for pagination
  int notificationPageNumber = 1;
  int notificationPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool notificationHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool notificationIsLoading = false;

  // This method will be called to gets push notification
  Future loadInitialPushNotification({required BuildContext context}) async {
    http.Response response = await PushNotificationRepo.loadFollowNotification(
        pageNumber: 1.toString(),
        pageSize: notificationPageSize.toString(),
        jwt: mainScreenProvider.currentAccessToken.toString(),
        currentUserId: mainScreenProvider.currentUserId ?? '');
    if (response.statusCode == 200) {
      _pushNotification = notificationFromJson(response.body);
      pushNotificationStreamController.sink.add(_pushNotification!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      return false;
    }
  }

  // Loading more notifications when user reach maximum pageSize item of a page in listview
  Future loadMorePushNotifications({required BuildContext context}) async {
    notificationPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (notificationIsLoading) {
      return;
    }
    notificationIsLoading = true;
    http.Response response = await PushNotificationRepo.loadFollowNotification(
        pageNumber: notificationPageNumber.toString(),
        pageSize: notificationPageSize.toString(),
        jwt: mainScreenProvider.currentAccessToken.toString(),
        currentUserId: mainScreenProvider.currentAccessToken.toString());
    if (response.statusCode == 200) {
      final newNotifications = notificationFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      notificationIsLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNotifications.data!.length < notificationPageSize) {
        notificationHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newNotifications.data!.length; i++) {
        _pushNotification!.data!.add(newNotifications.data![i]);
      }
      pushNotificationStreamController.sink.add(_pushNotification!);
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

  Future updateSelectedNotification(
      {required String notificationId, required BuildContext context}) async {
    if (_pushNotification == null ||
        pushNotificationStreamController.isClosed) {
      return;
    }
    http.Response response =
        await PushNotificationRepo.getOneUpdatedFollowNotification(
            jwt: mainScreenProvider.currentAccessToken.toString(),
            notificationId: notificationId,
            currentUserId: mainScreenProvider.currentUserId ?? '');
    if (response.statusCode == 200) {
      final oneNotification = singleNotificationFromJson(response.body).data;
      if (oneNotification != null) {
        final notificationIndex = _pushNotification!.data!.indexWhere(
            (element) =>
                element!.id.toString() == oneNotification.id.toString());
        if (notificationIndex != -1) {
          _pushNotification!.data![notificationIndex] = oneNotification;
          pushNotificationStreamController.sink.add(_pushNotification!);
          notifyListeners();
        }

        return true;
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
      return false;
    }
  }

  Future updateCurrentUserLatestNotification(
      {required BuildContext context}) async {
    if (_pushNotification == null ||
        pushNotificationStreamController.isClosed) {
      return;
    }
    http.Response response =
        await PushNotificationRepo.getCurrentUserLastFollowNotification(
            jwt: mainScreenProvider.currentAccessToken.toString(),
            currentUserId: mainScreenProvider.currentUserId ?? '');
    if (response.statusCode == 200 &&
        notificationFromJson(response.body).data != null &&
        notificationFromJson(response.body).data!.isNotEmpty) {
      // We will only get one notification, so we will initialize newNotification with 0 index
      final newNotification = notificationFromJson(response.body).data![0];
      if (newNotification != null) {
        _pushNotification!.data!.insert(0, newNotification);
        // to prevent same data from displaying twice
        if (notificationHasMore == true &&
            _pushNotification!.data!.length >= 16) {
          _pushNotification!.data!.removeLast();
        }
        pushNotificationStreamController.sink.add(_pushNotification!);
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
    }
  }

  void notificationOnTap(
      {required BuildContext context,
      required String notificationSenderId,
      required String notificationId,
      required bool isRead}) async {
    if (isRead == false) {
      Map bodyData = {
        "data": {"is_read": true}
      };
      PushNotificationRepo.readNotification(
          jwt: mainScreenProvider.currentAccessToken.toString(),
          notificationId: notificationId,
          bodyData: bodyData);
    }

    if (context.mounted) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                  otherUserId: int.parse(notificationSenderId))));
    }
    if (context.mounted) {
      refreshPushNotification(context: context);
    }
  }

  bool isNotificationRefresh = false;
  Future refreshPushNotification({required BuildContext context}) async {
    isNotificationRefresh = true;
    notificationIsLoading = false;
    notificationHasMore = true;
    notificationPageNumber = 1;
    if (_pushNotification != null) {
      _pushNotification!.data!.clear();
      pushNotificationStreamController.sink.add(_pushNotification!);
    }
    await loadInitialPushNotification(context: context);
    isNotificationRefresh = false;
    notifyListeners();
  }

  // PROMOTION
  Promotion? _promotion;
  Promotion? get promotion => _promotion;

  // page and pageSize is used for pagination
  int promotionPageNumber = 1;
  int promotionPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool promotionHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool promotionIsLoading = false;

  // Loading initial promotions
  // It will be called from init state so sharedpreferences is initialized in this method
  Future<void> getInitialPromotions({required BuildContext context}) async {
    final response = await PromotionRepo.getAllPromotions(
        page: 1.toString(),
        pageSize: promotionPageSize.toString(),
        jwt: mainScreenProvider.currentAccessToken.toString());
    if (response.statusCode == 200) {
      _promotion = promotionFromJson(response.body);
      promotionStreamController.sink.add(_promotion!);
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
      throw Exception('Unable to load initial promotions');
    }
  }

  // Loading more promotions when user reach maximum pageSize item of a page in listview
  Future loadMorePromotions({required BuildContext context}) async {
    promotionPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (promotionIsLoading) {
      return;
    }
    promotionIsLoading = true;
    final response = await PromotionRepo.getAllPromotions(
        page: promotionPageNumber.toString(),
        pageSize: promotionPageSize.toString(),
        jwt: mainScreenProvider.currentAccessToken.toString());
    if (response.statusCode == 200) {
      final newPromotions = promotionFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      promotionIsLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPromotions.data!.length < promotionPageSize) {
        promotionHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newPromotions.data!.length; i++) {
        _promotion!.data!.add(newPromotions.data![i]);
      }
      promotionStreamController.sink.add(_promotion!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      return false;
    }
  }

  bool isPromotionRefresh = false;
  Future refreshPromotion({required BuildContext context}) async {
    isPromotionRefresh = true;
    promotionIsLoading = false;
    promotionHasMore = true;
    promotionPageNumber = 1;
    if (_promotion != null) {
      _promotion!.data!.clear();
      promotionStreamController.sink.add(_promotion!);
    }
    await getInitialPromotions(context: context);
    isPromotionRefresh = false;
    notifyListeners();
  }

  @override
  void dispose() {
    pushNotificationStreamController.close();
    promotionStreamController.close();
    super.dispose();
  }
}
