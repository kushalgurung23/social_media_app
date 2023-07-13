import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/bookmark_interest_class_model.dart';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/data/repositories/interest_class_repo.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestClassProvider extends ChangeNotifier {
  late SharedPreferences sharedPreferences;
  late final MainScreenProvider mainScreenProvider;
  StreamController<InterestClass?> allInterestClassStreamController =
      BehaviorSubject();
  StreamController<InterestClass?> allRecommendClassStreamController =
      BehaviorSubject();
  StreamController<InterestClass?> searchInterestClassStreamController =
      BehaviorSubject();
  StreamController<InterestClass?> filterInterestClassStreamController =
      BehaviorSubject();
  StreamController<BookmarkInterestClass?>
      bookmarkInterestClassStreamController = BehaviorSubject();
  StreamController<InterestClass?> fromShareInterestClassStreamController =
      BehaviorSubject();
  late TextEditingController interestClassSearchTextController;
  InterestClassProvider({required this.mainScreenProvider}) {
    interestClassSearchTextController = TextEditingController();
    initial();
  }

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // page and pageSize is used for pagination
  int interestClassPage = 1;
  int interestClassPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool interestClassHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isInterestClassLoading = false;

  InterestClass? _interestClass;
  InterestClass? get interestClass => _interestClass;

  // Load interest class
  // sharedPreferences is initialized here because this method will be called from init state of Interest class
  Future<void> getInitialInterestClass({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await InterestClassRepo.getAllInterestClassCourses(
        page: interestClassPage.toString(),
        pageSize: interestClassPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _interestClass = interestClassFromJson(response.body);
      allInterestClassStreamController.sink.add(_interestClass);
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
      throw Exception('Unable to load interest class course');
    }
  }

  // Loading more interest class when user reach maximum pageSize item of a page in listview
  Future loadMoreInterestClass({required BuildContext context}) async {
    interestClassPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isInterestClassLoading) {
      return;
    }
    isInterestClassLoading = true;
    final response = await InterestClassRepo.getAllInterestClassCourses(
        page: interestClassPage.toString(),
        pageSize: interestClassPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      final newInterestClass = interestClassFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isInterestClassLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newInterestClass.data!.length < interestClassPageSize) {
        interestClassHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newInterestClass.data!.length; i++) {
        _interestClass!.data!.add(newInterestClass.data![i]);
      }
      allInterestClassStreamController.sink.add(_interestClass!);
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

  Future updateOneSelectedInterestClassForEveryStream(
      {required String interestClassId, required BuildContext context}) async {
    Response response =
        await InterestClassRepo.getOneUpdatedInterestClassCourse(
            jwt: sharedPreferences.getString('jwt') ?? 'null',
            interestClassId: interestClassId);
    if (response.statusCode == 200) {
      final oneInterestClass = singleInterestClassFromJson(response.body).data;
      if (oneInterestClass != null) {
        // FOR ALL INTEREST CLASSES
        if (_interestClass != null &&
            !allInterestClassStreamController.isClosed) {
          final allInterestClassIndex = _interestClass!.data!.indexWhere(
              (element) =>
                  element!.id.toString() == oneInterestClass.id.toString());
          if (allInterestClassIndex != -1) {
            _interestClass!.data![allInterestClassIndex] = oneInterestClass;
            allInterestClassStreamController.sink.add(_interestClass!);
            notifyListeners();
          }
        }

        // FOR FILTER INTEREST CLASSES
        if (_filterInterestClass != null &&
            !filterInterestClassStreamController.isClosed) {
          final filterClassIndex = _filterInterestClass!.data!.indexWhere(
              (element) =>
                  element!.id.toString() == oneInterestClass.id.toString());
          if (filterClassIndex != -1) {
            _filterInterestClass!.data![filterClassIndex] = oneInterestClass;
            filterInterestClassStreamController.sink.add(_filterInterestClass);
            notifyListeners();
            return true;
          }
        }

        // FOR RECOMMEND INTEREST CLASSES
        if (_recommendClass != null &&
            !allRecommendClassStreamController.isClosed) {
          final recommendClassIndex = _recommendClass!.data!.indexWhere(
              (element) =>
                  element!.id.toString() == oneInterestClass.id.toString());
          if (recommendClassIndex != -1) {
            _recommendClass!.data![recommendClassIndex] = oneInterestClass;
            allRecommendClassStreamController.sink.add(_recommendClass!);
            notifyListeners();
          }
        }

        // FOR SEARCH INTEREST CLASSES
        if (_searchInterestClass != null &&
            !searchInterestClassStreamController.isClosed) {
          final searchClassIndex = _searchInterestClass!.data!.indexWhere(
              (element) =>
                  element!.id.toString() == oneInterestClass.id.toString());
          if (searchClassIndex != -1) {
            _searchInterestClass!.data![searchClassIndex] = oneInterestClass;
            searchInterestClassStreamController.sink.add(_searchInterestClass);
            notifyListeners();
            return true;
          }
        }
      }
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

  bool isInterestClassRefresh = false;
  Future interestClassRefresh({required BuildContext context}) async {
    await recommendClassRefresh(context: context);
    isInterestClassRefresh = true;
    isInterestClassLoading = false;
    interestClassHasMore = true;
    interestClassPage = 1;
    if (_interestClass != null) {
      _interestClass!.data!.clear();
      allInterestClassStreamController.sink.add(_interestClass!);
    }
    if (context.mounted) {
      await getInitialInterestClass(context: context);
    }

    isInterestClassRefresh = false;
    notifyListeners();
  }

  // INTEREST CLASS FROM SHARED LINK
  InterestClass? _sharedInterestClass;
  InterestClass? get sharedInterestClass => _sharedInterestClass;

  // It will be called when we interest class from shared link
  Future<void> getOneInterestClassForSharedInterestClass(
      {required String interestClassId, required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await InterestClassRepo.getOneInterestClassCourseForSharedInterestClass(
            interestClassId: interestClassId,
            jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _sharedInterestClass = interestClassFromJson(response.body);
      fromShareInterestClassStreamController.sink.add(_sharedInterestClass);
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
      throw Exception('Unable to load one interest class course');
    }
  }

  // bookmark interest class
  BookmarkInterestClass? _bookmarkInterestClass;
  BookmarkInterestClass? get bookmarkInterestClass => _bookmarkInterestClass;

  // page and pageSize is used for pagination
  int bookmarkPage = 1;
  int bookmarkPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool bookmarkHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isBookmarkLoading = false;

  // Loading all bookmark interest class
  // It will be called from init state so sharedpreferences is initialized in this method
  Future<void> getInitialBookmarkInterestClass(
      {required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await InterestClassRepo.getBookmarkInterestClassCourses(
        page: 1.toString(),
        pageSize: bookmarkPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        currentUserId: mainScreenProvider.userId.toString());
    if (response.statusCode == 200) {
      _bookmarkInterestClass = bookmarkInterestClassFromJson(response.body);
      bookmarkInterestClassStreamController.sink.add(_bookmarkInterestClass!);
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
      throw Exception('Unable to load bookmark interest classes');
    }
  }

  // Loading more interest ckass when user reach maximum pageSize item of a page in listview
  Future loadMoreBookmarkInterestClasses(
      {required BuildContext context}) async {
    bookmarkPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isBookmarkLoading) {
      return;
    }
    isBookmarkLoading = true;
    final response = await InterestClassRepo.getBookmarkInterestClassCourses(
        page: bookmarkPage.toString(),
        pageSize: bookmarkPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        currentUserId: mainScreenProvider.userId.toString());
    if (response.statusCode == 200) {
      final newPaperShare = bookmarkInterestClassFromJson(response.body);

      // isBookmarkLoading = false indicates that the loading is complete
      isBookmarkLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPaperShare.data!.length < bookmarkPageSize) {
        bookmarkHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newPaperShare.data!.length; i++) {
        _bookmarkInterestClass!.data!.add(newPaperShare.data![i]);
      }
      bookmarkInterestClassStreamController.sink.add(_bookmarkInterestClass!);
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

  Future updateBookmarkInterestClasses({required BuildContext context}) async {
    if (_bookmarkInterestClass == null ||
        bookmarkInterestClassStreamController.isClosed) {
      return;
    } else {
      // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
      Response response =
          await InterestClassRepo.getBookmarkInterestClassCourses(
              page: 1.toString(),
              pageSize: _bookmarkInterestClass!.data!.length < bookmarkPageSize
                  ? bookmarkPageSize.toString()
                  : _bookmarkInterestClass!.data!.length.toString(),
              jwt:
                  sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
              currentUserId: mainScreenProvider.userId.toString());
      if (response.statusCode == 200) {
        _bookmarkInterestClass = bookmarkInterestClassFromJson(response.body);
        bookmarkInterestClassStreamController.sink.add(_bookmarkInterestClass!);
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
  }

  bool isBookmarkRefresh = false;
  Future bookmarkRefresh({required BuildContext context}) async {
    isBookmarkRefresh = true;
    isBookmarkLoading = false;
    bookmarkHasMore = true;
    bookmarkPage = 1;
    if (_bookmarkInterestClass != null) {
      _bookmarkInterestClass!.data!.clear();
      bookmarkInterestClassStreamController.sink.add(_bookmarkInterestClass!);
    }

    await getInitialBookmarkInterestClass(context: context);
    isBookmarkRefresh = false;
    notifyListeners();
  }

  // Recommend class

  // page and pageSize is used for pagination
  int recommendClassPage = 1;
  int recommendClassPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool recommendClassHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isRecommendClassLoading = false;

  InterestClass? _recommendClass;
  InterestClass? get recommendClass => _recommendClass;

  // Load initial recommend class
  // sharedPreferences is initialized here because this method will be called from init state of Interest class
  Future<void> getInitialRecommendClass({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await InterestClassRepo.getAllRecommendedInterestClassCourses(
            page: recommendClassPage.toString(),
            pageSize: recommendClassPageSize.toString(),
            jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _recommendClass = interestClassFromJson(response.body);
      allRecommendClassStreamController.sink.add(_recommendClass);
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
      throw Exception('Unable to load recommended interest class course');
    }
  }

  // Loading more recommend class when user reach maximum pageSize item of a page in listview
  Future loadMoreRecommendClass({required BuildContext context}) async {
    recommendClassPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isRecommendClassLoading) {
      return;
    }
    isRecommendClassLoading = true;
    final response =
        await InterestClassRepo.getAllRecommendedInterestClassCourses(
            page: recommendClassPage.toString(),
            pageSize: recommendClassPageSize.toString(),
            jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      final newRecommendClass = interestClassFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isRecommendClassLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newRecommendClass.data!.length < recommendClassPageSize) {
        recommendClassHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newRecommendClass.data!.length; i++) {
        _recommendClass!.data!.add(newRecommendClass.data![i]);
      }
      allRecommendClassStreamController.sink.add(_recommendClass!);
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

  bool isRecommendClassRefresh = false;
  Future recommendClassRefresh({required BuildContext context}) async {
    isRecommendClassRefresh = true;
    isRecommendClassLoading = false;
    recommendClassHasMore = true;
    recommendClassPage = 1;
    if (_recommendClass != null) {
      _recommendClass!.data!.clear();
      allRecommendClassStreamController.sink.add(_recommendClass!);
    }

    await getInitialRecommendClass(context: context);
    isRecommendClassRefresh = false;
    notifyListeners();
  }

  bool toggleSaveOnProcess = false;
  // save interest class
  Future<void> toggleInterestClassSave(
      {required String? savedInterestClassId,
      required BuildContext context,
      required String interestClassCourseId,
      required InterestClassSourceType source}) async {
    if (toggleSaveOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleSaveOnProcess == false) {
      toggleSaveOnProcess = true;
      Response response;
      if (mainScreenProvider.savedInterestClassIdList
              .contains(int.parse(interestClassCourseId)) &&
          savedInterestClassId != null) {
        mainScreenProvider.savedInterestClassIdList
            .remove(int.parse(interestClassCourseId));

        response = await InterestClassRepo.removeInterestClassSave(
            interestClassSaveId: savedInterestClassId.toString(),
            jwt: sharedPreferences.getString('jwt')!);
      } else {
        mainScreenProvider.savedInterestClassIdList
            .add(int.parse(interestClassCourseId));
        Map bodyData = {
          "data": {
            "saved_by": mainScreenProvider.userId,
            "interest_class": interestClassCourseId
          }
        };

        response = await InterestClassRepo.addInterestClassSave(
            bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      }
      notifyListeners();

      if (response.statusCode == 200) {
        if (source == InterestClassSourceType.fromShare && context.mounted) {
          await getOneInterestClassForSharedInterestClass(
              context: context, interestClassId: interestClassCourseId);
        }
        if (context.mounted) {
          await Future.wait([
            updateOneSelectedInterestClassForEveryStream(
                context: context, interestClassId: interestClassCourseId),
            updateBookmarkInterestClasses(context: context),
            // updating all interest classes so that other streams will get latest interest class details
          ]);
        }

        toggleSaveOnProcess = false;
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        toggleSaveOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        toggleSaveOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).tryAgainLater,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        }
      }
    }
    toggleSaveOnProcess = false;
    notifyListeners();
  }

  // Search interest class

  // page and pageSize is used for pagination
  int searchPage = 1;
  int searchPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool searchHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool isSearchLoading = false;

  InterestClass? _searchInterestClass;
  InterestClass? get searchInterestClass => _searchInterestClass;

  List<InterestClassData?> searchInterestClassList = [];

  int getInterestClassSearchCount(
      {required List<InterestClassData?> interestClassList}) {
    searchInterestClassList = interestClassList;
    return searchInterestClassList.length;
  }

  bool noRecord = false;

  Future searchForInterestClassCourses(
          {required String query, required BuildContext context}) async =>
      debounce(() async {
        // value of search page will be initialized back to 1, because it can be incremented while loading more search data
        searchPage = 1;

        // searchHasMore should be true in the beginning while searching for new keyword. It might have been changed to false, when there were no more data for previous keyword.
        if (searchHasMore == false) {
          searchHasMore = true;
        }

        // If there is no keyword in the search field, we won't call the server
        if (interestClassSearchTextController.text.trim() == '' &&
            query.trim() == '') {
          notifyListeners();
          return;
        }

        // if user has searched for keyword, remove the filtered list
        if (isFilterButtonClick == true) {
          isFilterButtonClick = false;
          filterCategoryType = null;
          filterTargetAge = null;
          notifyListeners();
        }

        Response response = await InterestClassRepo.searchInterestClassCourses(
            page: searchPage.toString(),
            pageSize: searchPageSize.toString(),
            jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
            interestClassTitle: query.trim().toLowerCase());
        if (response.statusCode == 200) {
          _searchInterestClass = interestClassFromJson(response.body);

          searchInterestClassStreamController.sink.add(_searchInterestClass);

          final filterInterestClassList =
              _searchInterestClass!.data!.where((element) {
            final titleLower = element!.attributes!.title!.trim().toLowerCase();
            final searchLower = query.trim().toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();
          searchInterestClassList = filterInterestClassList;
          if (searchInterestClassList.isNotEmpty) {
            noRecord = false;
          }
          if (searchInterestClassList.isEmpty) {
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
          throw Exception("Error occured while searching interest class");
        }
      });

  // Loading more interest classes when user reach maximum pageSize item of a page in listview
  Future loadMoreSearchResults(
      {required String query, required BuildContext context}) async {
    if (searchHasMore == false) {
      return;
    }
    searchPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isSearchLoading) {
      return;
    }
    isSearchLoading = true;
    Response response = await InterestClassRepo.searchInterestClassCourses(
        page: searchPage.toString(),
        pageSize: searchPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        interestClassTitle: query.trim().toLowerCase());
    if (response.statusCode == 200) {
      final newSearchResults = interestClassFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isSearchLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newSearchResults.data!.length < searchPageSize) {
        searchHasMore = false;
      }

      for (int i = 0; i < newSearchResults.data!.length; i++) {
        _searchInterestClass!.data!.add(newSearchResults.data![i]);
      }
      searchInterestClassList = _searchInterestClass!.data!;
      searchInterestClassStreamController.sink.add(_searchInterestClass!);
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

  Timer? debouncer;
  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 800),
  }) {
    // To make sure only one request is going to the server per 0.8 second
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  // filter interest class section

  // page and pageSize is used for pagination
  int filterPageNumber = 1;
  int filterPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool filterHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool isfilterLoading = false;

  InterestClass? _filterInterestClass;
  InterestClass? get filterInterestClass => _filterInterestClass;

  List<InterestClassData?> filterInterestClassList = [];

  // returns the count of snapshot data in listview
  int getFilterInterestClassCount(
      {required List<InterestClassData?> interestClassList}) {
    filterInterestClassList = interestClassList;
    return filterInterestClassList.length;
  }

  bool filterNoRecord = false;
  String? filterCategoryType, filterTargetAge;

  Map<String, String> getCategoryTypeList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).signature: "Signature",
      AppLocalizations.of(context).indulgence: "Indulgence"
    };
  }

  void setFilterCategoryType({required String newValue}) {
    filterCategoryType = newValue;
    notifyListeners();
  }

  void setFilterTargetAge({required String newValue}) {
    filterTargetAge = newValue;
    notifyListeners();
  }

  bool isFilterButtonClick = false;
  Future<void> filterAllInterestClass({required BuildContext context}) async {
    if (filterCategoryType == null && filterTargetAge == null) {
      Navigator.pop(context);
      return;
    } else {
      isFilterButtonClick = true;

      // value of filter page will be initialized back to 1, because it can be incremented while loading more filter data
      filterPageNumber = 1;

      // filterHasMore should be true in the beginning while filtering new keyword. It might have been changed to false, when there were no more data for previous keyword.
      if (filterHasMore == false) {
        filterHasMore = true;
      }

      Response response = await InterestClassRepo.filterInterestClassCourses(
          page: filterPageNumber.toString(),
          pageSize: filterPageSize.toString(),
          jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
          interestClassCategoryType: filterCategoryType,
          interestClassTargetAge: filterTargetAge);

      if (response.statusCode == 200) {
        _filterInterestClass = interestClassFromJson(response.body);
        filterInterestClassStreamController.sink.add(_filterInterestClass);
        filterInterestClassList = _filterInterestClass!.data!;
        if (filterInterestClassList.isNotEmpty) {
          filterNoRecord = false;
        }
        if (filterInterestClassList.isEmpty) {
          filterNoRecord = true;
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
        throw Exception("Error occured while filtering interest class");
      }
      notifyListeners();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  // Loading more filter interest class when user reach maximum pageSize item of a page in listview
  Future loadMoreFilterResults({required BuildContext context}) async {
    if (filterHasMore == false) {
      return;
    }
    filterPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isfilterLoading) {
      return;
    }
    isfilterLoading = true;
    Response response = await InterestClassRepo.filterInterestClassCourses(
        page: filterPageNumber.toString(),
        pageSize: filterPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        interestClassCategoryType: filterCategoryType,
        interestClassTargetAge: filterTargetAge);
    if (response.statusCode == 200) {
      final newFilterResults = interestClassFromJson(response.body);

      // isfilterLoading = false indicates that the loading is complete
      isfilterLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence filterHasMore = false
      if (newFilterResults.data!.length < filterPageSize) {
        filterHasMore = false;
      }
      for (int i = 0; i < newFilterResults.data!.length; i++) {
        _filterInterestClass!.data!.add(newFilterResults.data![i]);
      }
      filterInterestClassList = _filterInterestClass!.data!;
      filterInterestClassStreamController.sink.add(_filterInterestClass!);
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

  void resetFilter({required BuildContext context}) {
    isFilterButtonClick = false;
    filterCategoryType = null;
    filterTargetAge = null;
    notifyListeners();
    Navigator.pop(context);
  }

  void showSnackBar(
      {required BuildContext context,
      required String content,
      required Color backgroundColor,
      required Color contentColor}) {
    final snackBar = SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: backgroundColor,
        onVisible: () {},
        behavior: SnackBarBehavior.fixed,
        content: Text(
          content,
          style: TextStyle(
            color: contentColor,
            fontFamily: kHelveticaMedium,
            fontSize: SizeConfig.defaultSize * 1.6,
          ),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    notifyListeners();
  }

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

  // Share service and creating dynamic links
  Future<void> shareService(
      {required String? serviceId, required BuildContext context}) async {
    if (serviceId == null) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          backgroundColor: Colors.red,
          contentColor: Colors.white);
      return;
    }
    final dynamicLinkParameters = DynamicLinkParameters(

        /// when user opens on web browser
        link: Uri.parse("$dynamicLink/service?id=$serviceId"),

        /// live URL
        uriPrefix: dynamicLink,

        /// when user opens on android
        androidParameters: const AndroidParameters(
          packageName: packageName,
          minimumVersion: 0,
        ),

        /// when user opens on ios
        /// On IOS, it isn't tested yet
        iosParameters: const IOSParameters(
          bundleId: packageName,
          minimumVersion: '1.0.0',
          appStoreId: appStoreId,
        ));

    Uri link =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParameters);
    Share.share(link.toString());
  }

  @override
  void dispose() {
    allInterestClassStreamController.close();
    allRecommendClassStreamController.close();
    interestClassSearchTextController.dispose();
    searchInterestClassStreamController.close();
    filterInterestClassStreamController.close();
    bookmarkInterestClassStreamController.close();
    fromShareInterestClassStreamController.close();
    super.dispose();
  }
}
