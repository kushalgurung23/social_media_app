import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/data/repositories/services/services_repo.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_provider.dart';
import 'drawer_provider.dart';

class ServicesProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  ServicesProvider({required this.mainScreenProvider});
  // Load news post
  AllServices? _allServices;
  AllServices? get allServices => _allServices;

  StreamController<AllServices?> allServicesStreamController =
      BehaviorSubject<AllServices>();

  // page and pageSize is used for pagination
  int servicesPageNumber = 1;
  int servicesPageSize = 10;
  // hasMore will be true until we have more data to fetch in the API
  bool servicesHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool servicesIsLoading = false;

  // This method will be called to get services
  Future<void> loadInitialServices({required BuildContext context}) async {
    try {
      Response response = await ServicesRepo.getAllServices(
          accessToken: mainScreenProvider.currentAccessToken.toString(),
          page: servicesPageNumber.toString(),
          pageSize: servicesPageSize.toString());
      if (response.statusCode == 200) {
        _allServices = allServicesFromJson(response.body);
        if (_allServices != null) {
          allServicesStreamController.sink.add(_allServices!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialServices(context: context);
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

  // Loading more services when user reach maximum pageSize item of a page in listview
  Future loadMoreServices({required BuildContext context}) async {
    servicesPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (servicesIsLoading) {
      return;
    }
    servicesIsLoading = true;
    Response response = await ServicesRepo.getAllServices(
        accessToken: mainScreenProvider.currentAccessToken.toString(),
        page: servicesPageSize.toString(),
        pageSize: servicesPageSize.toString());
    if (response.statusCode == 200) {
      final servicesPosts = allServicesFromJson(response.body);

      // servicesIsLoading = false indicates that the loading is complete
      servicesIsLoading = false;

      if (servicesPosts.services == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (servicesPosts.services!.length < servicesPageSize) {
        servicesHasMore = false;
      }
      _allServices!.services = [
        ..._allServices!.services!,
        ...servicesPosts.services!
      ];
      allServicesStreamController.sink.add(_allServices!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreServices(context: context);
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

  Future refreshServices({required BuildContext context}) async {
    servicesIsLoading = false;
    servicesHasMore = true;
    servicesPageNumber = 1;
    if (_allServices != null) {
      _allServices!.services!.clear();
    }
    notifyListeners();
    await loadInitialServices(context: context);
  }

  bool isFilterBtnClick = false;

  @override
  void dispose() {
    allServicesStreamController.close();
    super.dispose();
  }
}
