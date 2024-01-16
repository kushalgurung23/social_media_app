import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/data/repositories/services/services_repo.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import '../../data/enum/all.dart';
import '../../presentation/views/services/service_description_screen.dart';
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
          pageSize: servicesPageSize.toString(),
          isRecommendedServices: false);
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
        pageSize: servicesPageSize.toString(),
        isRecommendedServices: false);
    if (response.statusCode == 200) {
      final servicesPosts = allServicesFromJson(response.body);

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
      // servicesIsLoading = false indicates that the loading is complete
      servicesIsLoading = false;
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
    await Future.wait([loadInitialServices(context: context)]);
  }

  AllServices? _recommendedServices;
  AllServices? get recommendedServices => _recommendedServices;

  StreamController<AllServices?> recommendedServStrmContrller =
      BehaviorSubject<AllServices>();

  // page and pageSize is used for pagination
  int recmdServicesPageNumber = 1;
  int recmdServicesPageSize = 10;
  // hasMore will be true until we have more data to fetch in the API
  bool recmdServicesHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool recmdServicesIsLoading = false;

  // This method will be called to get services
  Future<void> loadRecommendedServices({required BuildContext context}) async {
    try {
      Response response = await ServicesRepo.getAllServices(
          accessToken: mainScreenProvider.currentAccessToken.toString(),
          page: recmdServicesPageNumber.toString(),
          pageSize: recmdServicesPageSize.toString(),
          isRecommendedServices: true);
      if (response.statusCode == 200) {
        _recommendedServices = allServicesFromJson(response.body);
        if (_recommendedServices != null) {
          recommendedServStrmContrller.sink.add(_recommendedServices!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadRecommendedServices(context: context);
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
  Future loadMoreRecommendedServices({required BuildContext context}) async {
    recmdServicesPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (recmdServicesIsLoading) {
      return;
    }
    recmdServicesIsLoading = true;
    Response response = await ServicesRepo.getAllServices(
        accessToken: mainScreenProvider.currentAccessToken.toString(),
        page: recmdServicesPageSize.toString(),
        pageSize: recmdServicesPageSize.toString(),
        isRecommendedServices: true);
    if (response.statusCode == 200) {
      final servicesPosts = allServicesFromJson(response.body);

      if (servicesPosts.services == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (servicesPosts.services!.length < recmdServicesPageSize) {
        recmdServicesHasMore = false;
      }
      _recommendedServices!.services = [
        ..._recommendedServices!.services!,
        ...servicesPosts.services!
      ];
      recommendedServStrmContrller.sink.add(_recommendedServices!);
      // recmdServicesIsLoading = false indicates that the loading is complete
      recmdServicesIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreRecommendedServices(context: context);
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

  Future refreshRecommendedServices({required BuildContext context}) async {
    recmdServicesIsLoading = false;
    recmdServicesHasMore = true;
    recmdServicesPageNumber = 1;
    if (_recommendedServices != null) {
      _recommendedServices!.services!.clear();
    }
    notifyListeners();
    await Future.wait([loadRecommendedServices(context: context)]);
  }

  Future<void> refreshAllServices({required BuildContext context}) async {
    await Future.wait([
      refreshServices(context: context),
      refreshRecommendedServices(context: context)
    ]);
  }

  bool isFilterBtnClick = false;

  // CAROUSEL
  // current carousel image index
  int activeImageIndex = 0;

  void changeDotIndex({required int newIndex}) {
    activeImageIndex = newIndex;
    notifyListeners();
  }

  void resetActiveDotIndex() {
    activeImageIndex = 0;
    notifyListeners();
  }

  void goToServicesDescriptionScreen(
      {required BuildContext context,
      required OneService? service,
      required ServiceToggleType serviceToggleType}) {
    if (service == null) {
      EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
          duration: const Duration(seconds: 3));
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceDescriptionScreen(
                service: service, serviceToggleType: serviceToggleType)));
  }

  // TOGGLE SERVICES SAVE FEATURE

  bool toggleSaveOnProcess = false;
  Future<void> toggleServiceSave(
      {required BuildContext context,
      required OneService oneService,
      required ServiceToggleType serviceToggleType}) async {
    int? currentSaveStatus = oneService.isSaved ?? 0;
    // This method will be called when toggle save will be failed, in order to keep original status
    void onToggleSaveFailed() {
      oneService.isSaved = currentSaveStatus;
      toggleSaveOnProcess = false;
      notifyListeners();
    }

    try {
      if (toggleSaveOnProcess == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        toggleSaveOnProcess = true;
        if (currentSaveStatus == 1) {
          oneService.isSaved = 0;
        } else {
          oneService.isSaved = 1;
        }
        notifyListeners();

        Response response = await ServicesRepo.toggleServiceSave(
            accessToken: mainScreenProvider.currentAccessToken.toString(),
            serviceId: oneService.id.toString());

        if (response.statusCode == 200 && context.mounted) {
          // IF toggled save in ALL Services, we should also changed isSaved state in RECOMMENDED services
          onToggleSaveSuccess(
              oneService: oneService, serviceToggleType: serviceToggleType);
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          onToggleSaveFailed();

          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return toggleServiceSave(
                context: context,
                oneService: oneService,
                serviceToggleType: serviceToggleType);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
            return;
          }
        } else if ((jsonDecode(response.body))["status"] == 'Error') {
          onToggleSaveFailed();
          if (context.mounted) {
            EasyLoading.showInfo((jsonDecode(response.body))["msg"],
                dismissOnTap: false, duration: const Duration(seconds: 4));
          }
        } else {
          onToggleSaveFailed();
          if (context.mounted) {
            EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
                dismissOnTap: false, duration: const Duration(seconds: 4));
          }
        }
      }
    } catch (e) {
      onToggleSaveFailed();
      EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
          dismissOnTap: false, duration: const Duration(seconds: 4));
    }
  }

  void onToggleSaveSuccess(
      {required ServiceToggleType serviceToggleType,
      required OneService oneService}) {
    if (serviceToggleType == ServiceToggleType.allService &&
        _recommendedServices?.services != null) {
      ServicePost? toBeUpdatedService = _recommendedServices!.services!
          .firstWhereOrNull(
              (foundService) => foundService.service?.id == oneService.id);
      if (toBeUpdatedService != null && toBeUpdatedService.service != null) {
        toBeUpdatedService.service!.isSaved = oneService.isSaved;
      }
    }
    // IF toggled save in RECOMMENDED Services, we should also changed isSaved state in ALL services
    else if (serviceToggleType == ServiceToggleType.recommendService &&
        _allServices?.services != null) {
      ServicePost? toBeUpdatedService = _allServices!.services!
          .firstWhereOrNull(
              (foundService) => foundService.service?.id == oneService.id);
      if (toBeUpdatedService != null && toBeUpdatedService.service != null) {
        toBeUpdatedService.service!.isSaved = oneService.isSaved;
      }
    }
    toggleSaveOnProcess = false;
    notifyListeners();
  }

  @override
  void dispose() {
    allServicesStreamController.close();
    recommendedServStrmContrller.close();
    super.dispose();
  }
}
