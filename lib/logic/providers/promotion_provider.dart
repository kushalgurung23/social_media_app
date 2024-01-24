import 'dart:async';

import 'package:c_talent/data/repositories/promotions/promotion_repo.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/all_promotions.dart';
import 'auth_provider.dart';
import 'drawer_provider.dart';

class PromotionProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  PromotionProvider({required this.mainScreenProvider});

  AllPromotions? _allPromotions;
  AllPromotions? get allPromotions => _allPromotions;

  StreamController<AllPromotions?> allPromotionsStreamController =
      BehaviorSubject<AllPromotions>();

  // promotionsPageNumber and promotionsPageSize is used for pagination
  int promotionsPageNumber = 1;
  int promotionsPageSize = 10;
  // promotionsHasMore will be true until we have more data to fetch in the API
  bool promotionsHasMore = true;
  // promotionsIsLoading will be true once we try to fetch more promotions.
  bool promotionsIsLoading = false;

  // This method will be called to get promotions
  Future<void> loadInitialPromotions({required BuildContext context}) async {
    try {
      Response response = await PromotionRepo.loadAllPromotions(
          jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
          pageNumber: promotionsPageNumber.toString(),
          pageSize: promotionsPageSize.toString());
      // AFTER REFRESHING, isRefreshingPromotions value will be set to false
      // WHEN TRUE, IT IS USED TO DISPLAY LOADING TEXT WIDGET
      if (isRefreshingPromotions == true) {
        isRefreshingPromotions = false;
      }
      if (response.statusCode == 200) {
        _allPromotions = allPromotionsFromJson(response.body);
        if (_allPromotions != null) {
          allPromotionsStreamController.sink.add(_allPromotions!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialPromotions(context: context);
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

  // Loading more promotions when user reach maximum pageSize item of a page in listview
  Future loadMorePromotions({required BuildContext context}) async {
    promotionsPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (promotionsIsLoading) {
      return;
    }
    promotionsIsLoading = true;
    Response response = await PromotionRepo.loadAllPromotions(
        jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
        pageNumber: promotionsPageNumber.toString(),
        pageSize: promotionsPageSize.toString());
    if (response.statusCode == 200) {
      final newPromotions = allPromotionsFromJson(response.body);

      if (newPromotions.promotions == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPromotions.promotions!.length < promotionsPageSize) {
        promotionsHasMore = false;
      }
      _allPromotions!.promotions = [
        ..._allPromotions!.promotions!,
        ...newPromotions.promotions!
      ];
      allPromotionsStreamController.sink.add(_allPromotions!);
      // promotionsIsLoading = false indicates that the loading is complete
      promotionsIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMorePromotions(context: context);
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

  bool isRefreshingPromotions = false;
  Future refreshPromotions({required BuildContext context}) async {
    isRefreshingPromotions = true;
    notifyListeners();
    promotionsIsLoading = false;
    promotionsHasMore = true;
    promotionsPageNumber = 1;
    if (_allPromotions?.promotions != null) {
      _allPromotions!.promotions!.clear();
    }
    await loadInitialPromotions(context: context);
    isRefreshingPromotions = false;
    notifyListeners();
  }

  @override
  void dispose() {
    allPromotionsStreamController.close();
    super.dispose();
  }
}
