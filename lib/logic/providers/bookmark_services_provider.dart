import 'dart:async';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/repositories/services/services_repo.dart';

class BookmarkServicesProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;
  BookmarkServicesProvider({required this.mainScreenProvider});

  AllServices? _bookmarkedServices;
  AllServices? get bookmarkedServices => _bookmarkedServices;

  StreamController<AllServices?> bookmarkedServStrmContrller =
      BehaviorSubject<AllServices>();

  // page and pageSize is used for pagination
  int bookmarkedServicesPageNumber = 1;
  int bookmarkedServicesPageSize = 10;
  // hasMore will be true until we have more data to fetch in the API
  bool bookmarkedServicesHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool bookmarkedServicesIsLoading = false;

  // This method will be called to get services
  Future<void> loadBookmarkedServices({required BuildContext context}) async {
    try {
      Response response = await ServicesRepo.getSavedServices(
          accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
          page: bookmarkedServicesPageNumber.toString(),
          pageSize: bookmarkedServicesPageSize.toString());
      if (response.statusCode == 200) {
        _bookmarkedServices = allServicesFromJson(response.body);
        if (_bookmarkedServices != null) {
          bookmarkedServStrmContrller.sink.add(_bookmarkedServices!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadBookmarkedServices(context: context);
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
  Future loadMoreBookmarkedServices({required BuildContext context}) async {
    bookmarkedServicesPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or if we don't have anymore new data
    //we will get exit from this method.
    if (bookmarkedServicesIsLoading || bookmarkedServicesHasMore == false) {
      return;
    }
    bookmarkedServicesIsLoading = true;
    Response response = await ServicesRepo.getSavedServices(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: bookmarkedServicesPageNumber.toString(),
        pageSize: bookmarkedServicesPageSize.toString());
    if (response.statusCode == 200) {
      final newSavedPosts = allServicesFromJson(response.body);

      if (newSavedPosts.services == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newSavedPosts.services!.length < bookmarkedServicesPageSize) {
        bookmarkedServicesHasMore = false;
      }
      _bookmarkedServices!.services = [
        ..._bookmarkedServices!.services!,
        ...newSavedPosts.services!
      ];
      bookmarkedServStrmContrller.sink.add(_bookmarkedServices!);
      // bookmarkedServicesIsLoading = false indicates that the loading is complete
      bookmarkedServicesIsLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreBookmarkedServices(context: context);
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

  Future<void> refreshBookmarkServices({required BuildContext context}) async {
    bookmarkedServicesIsLoading = false;
    bookmarkedServicesHasMore = true;
    bookmarkedServicesPageNumber = 1;
    if (_bookmarkedServices?.services != null) {
      _bookmarkedServices!.services!.clear();
    }
    notifyListeners();
    await loadBookmarkedServices(context: context);
  }

  void onBookmarkServiceToggleSuccess({required OneService oneService}) {
    if (_bookmarkedServices?.services == null) {
      return;
    }
    // IF USER HAS TOGGLED TO FALSE, THEN BACK TO TRUE INSIDE THE BOOKMARK SERVICES
    if (oneService.isSaved == 1) {
      ServicePost updatedServicePost = ServicePost(service: oneService);
      if (!_bookmarkedServices!.services!.contains(updatedServicePost)) {
        _bookmarkedServices!.services!.insert(0, updatedServicePost);
      }
    }
    // IF USER HAS UNSAVED THE SERVICE
    else {
      _bookmarkedServices!.services!
          .removeWhere((service) => service.service?.id == oneService.id);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    bookmarkedServStrmContrller.close();
    super.dispose();
  }
}
