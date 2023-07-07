import 'dart:async';
import 'dart:convert';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spa_app/data/constant/color_constant.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/bookmark_paper_share_model.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/data/repositories/paper_share_repo.dart';
import 'package:spa_app/data/repositories/report_news_post_repo.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
//import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/paper_share/bookmark_paper_share_description.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_description_screen.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaperShareProvider extends ChangeNotifier {
  StreamController<AllPaperShare> paperShareStreamController =
      BehaviorSubject();
  StreamController<AllPaperShare> searchPaperStreamController =
      BehaviorSubject();
  StreamController<AllPaperShare> filterShareStreamController =
      BehaviorSubject();
  StreamController<BookmarkPaperShare> bookmarkShareStreamController =
      BehaviorSubject();
  StreamController<AllPaperShare> fromSharePaperShareStreamController =
      BehaviorSubject();
  late SharedPreferences sharedPreferences;
  late final MainScreenProvider mainScreenProvider;
  GlobalKey<FormState> paperShareKey = GlobalKey<FormState>();
  late TextEditingController contentTextController,
      paperShareDiscussTextController,
      paperShareSearchTextController;

  PaperShareProvider({required this.mainScreenProvider}) {
    contentTextController = TextEditingController();
    paperShareDiscussTextController = TextEditingController();
    paperShareSearchTextController = TextEditingController();
  }

  String? filterSubject, filterLevel, filterSemester;

  Map<String, String> getSubjectList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).chineseLanguage: "Chinese",
      AppLocalizations.of(context).englishLanguage: "English",
      AppLocalizations.of(context).mathematics: "Mathematics",
      AppLocalizations.of(context).generalStudies: "General Studies"
    };
  }

  Map<String, String> getLevelList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).primary1: "Primary 1",
      AppLocalizations.of(context).primary2: "Primary 2",
      AppLocalizations.of(context).primary3: "Primary 3",
      AppLocalizations.of(context).primary4: "Primary 4",
      AppLocalizations.of(context).primary5: "Primary 5",
      AppLocalizations.of(context).primary6: "Primary 6",
    };
  }

  Map<String, String> getSemesterList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).firstSemester: "First Semester",
      AppLocalizations.of(context).secondSemester: "Second Semester",
    };
  }

  void setFilterSubject({required String newValue}) {
    filterSubject = newValue;
    notifyListeners();
  }

  void setFilterLevel({required String newValue}) {
    filterLevel = newValue;
    notifyListeners();
  }

  void setFilterSemester({required String newValue}) {
    filterSemester = newValue;
    notifyListeners();
  }

  List<PaperShare> allPaperShareList = [];

  // Dropdown values
  String? newSubject, newLevel, newSemester;

  void setNewSubject(
      {required String newValue, required BuildContext context}) {
    newSubject = newValue;
    toggleSubjectValidation(value: newValue, context: context);
    notifyListeners();
  }

  void setNewLevel({required String newValue, required BuildContext context}) {
    newLevel = newValue;
    toggleLevelValidation(value: newValue, context: context);
    notifyListeners();
  }

  void setNewSemester(
      {required String newValue, required BuildContext context}) {
    newSemester = newValue;
    toggleSemesterValidation(value: newValue, context: context);
    notifyListeners();
  }

  String? subjectErrorMessage;
  String? toggleSubjectValidation(
      {required String value, required BuildContext context}) {
    try {
      if (value == 'null') {
        subjectErrorMessage = AppLocalizations.of(context).selectASubject;
        return null;
      } else {
        subjectErrorMessage = null;
        return null;
      }
    } finally {
      notifyListeners();
    }
  }

  String? levelErrorMessage;
  String? toggleLevelValidation(
      {required String value, required BuildContext context}) {
    try {
      if (value == 'null') {
        levelErrorMessage = AppLocalizations.of(context).selectALevel;
        return null;
      } else {
        levelErrorMessage = null;
        return null;
      }
    } finally {
      notifyListeners();
    }
  }

  String? semesterErrorMessage;
  String? toggleSemesterValidation(
      {required String value, required BuildContext context}) {
    try {
      if (value == 'null') {
        semesterErrorMessage = AppLocalizations.of(context).selectASemester;
        return null;
      } else {
        semesterErrorMessage = null;
        return null;
      }
    } finally {
      notifyListeners();
    }
  }

  // Paper Share reset
  bool? isReset;

  // isReset = true will reset, and remove all entered data and validation from paper share
  void resetPaperShare({required BuildContext context}) {
    isReset = true;
    notifyListeners();
    clearText(context: context);
  }

  // isReset = false will remove reset and check for validation while posting new paper share.
  void removeReset() {
    isReset = false;
    notifyListeners();
  }

  void clearText({required BuildContext context}) {
    contentTextController.text = "";
    newSubject = null;
    newLevel = null;
    newSemester = null;
    imageFileList!.clear();
    toggleSubjectValidation(value: 'reset', context: context);
    toggleLevelValidation(value: 'reset', context: context);
    toggleSemesterValidation(value: 'reset', context: context);
    notifyListeners();
  }

  void goBack({required BuildContext context}) {
    isReset = false;
    clearText(context: context);
    stopLoading();
    Navigator.of(context).pop();
  }

  AllPaperShare? _allPaperShare;
  AllPaperShare? get allPaperShare => _allPaperShare;

  // page and pageSize is used for pagination
  int page = 1;
  int pageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool hasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isLoading = false;

  // Loading all paper share
  // It will be called from init state so sharedpreferences is initialized in this method
  Future<void> getInitialPaperShares({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await PaperShareRepo.getAllPaperShares(
        myId: sharedPreferences.getString('id') ??
            mainScreenProvider.userId.toString(),
        page: page.toString(),
        pageSize: pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ??
            mainScreenProvider.jwt.toString());
    if (response.statusCode == 200) {
      _allPaperShare = paperShareFromJson(response.body);
      paperShareStreamController.sink.add(_allPaperShare!);
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
      throw Exception('Unable to load paper shares');
    }
  }

  // Loading more paper share when user reach maximum pageSize item of a page in listview
  Future loadMorePaperShare({required BuildContext context}) async {
    page++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isLoading) {
      return;
    }
    isLoading = true;
    final response = await PaperShareRepo.getAllPaperShares(
        myId: sharedPreferences.getString('id') ??
            mainScreenProvider.userId.toString(),
        page: page.toString(),
        pageSize: pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      final newPaperShare = paperShareFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPaperShare.data.length < pageSize) {
        hasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newPaperShare.data.length; i++) {
        _allPaperShare!.data.add(newPaperShare.data[i]);
      }
      paperShareStreamController.sink.add(_allPaperShare!);
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

  Future updateOnePaperShareForAllStreams(
      {required String paperShareId, required BuildContext context}) async {
    Response response = await PaperShareRepo.getOneUpdatedPaperShare(
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        paperShareId: paperShareId);
    if (response.statusCode == 200) {
      final onePaperShare = singlePaperShareFromJson(response.body).data;
      if (onePaperShare != null) {
        // FOR ALL PAPER SHARES
        if (_allPaperShare != null && !paperShareStreamController.isClosed) {
          final allPaperShareIndex = _allPaperShare!.data.indexWhere(
              (element) =>
                  element.id.toString() == onePaperShare.id.toString());
          if (allPaperShareIndex != -1) {
            _allPaperShare!.data[allPaperShareIndex] = onePaperShare;
            paperShareStreamController.sink.add(_allPaperShare!);
            notifyListeners();
          }
        }

        // FOR FILTER PAPER SHARES
        if (_filterPaperShare != null &&
            !filterShareStreamController.isClosed) {
          final filterPaperShareIndex = _filterPaperShare!.data.indexWhere(
              (element) =>
                  element.id.toString() == onePaperShare.id.toString());
          if (filterPaperShareIndex != -1) {
            _filterPaperShare!.data[filterPaperShareIndex] = onePaperShare;
            filterShareStreamController.sink.add(_filterPaperShare!);
            notifyListeners();
          }
        }

        // FOR SEARCH PAPER SHARES
        if (_searchPaperShare != null &&
            !searchPaperStreamController.isClosed) {
          final searchPaperShareIndex = _searchPaperShare!.data.indexWhere(
              (element) =>
                  element.id.toString() == onePaperShare.id.toString());
          if (searchPaperShareIndex != -1) {
            _searchPaperShare!.data[searchPaperShareIndex] = onePaperShare;
            searchPaperStreamController.sink.add(_searchPaperShare!);
            notifyListeners();
          }
        }
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

  bool isRefresh = false;
  Future refresh({required BuildContext context}) async {
    isRefresh = true;
    isLoading = false;
    hasMore = true;
    page = 1;
    if (_allPaperShare != null) {
      _allPaperShare!.data.clear();
      paperShareStreamController.sink.add(_allPaperShare!);
    }

    await getInitialPaperShares(context: context);
    isRefresh = false;
    notifyListeners();
  }

  // PAPER SHARE FROM SHARED LINK
  AllPaperShare? _sharedPaperShare;
  AllPaperShare? get sharedPaperShare => _sharedPaperShare;

  // It will be called when we open paper share from shared link
  Future<void> getOnePaperShareForSharedLink(
      {required String paperShareId, required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await PaperShareRepo.getOnePaperShareForSharedLink(
        paperShareId: paperShareId,
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _sharedPaperShare = paperShareFromJson(response.body);
      fromSharePaperShareStreamController.sink.add(_sharedPaperShare!);
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
      throw Exception('Unable to load one paper share');
    }
  }

  // bookmark paper share
  BookmarkPaperShare? _bookmarkPaperShare;
  BookmarkPaperShare? get bookmarkPaperShare => _bookmarkPaperShare;

  // page and pageSize is used for pagination
  int bookmarkPage = 1;
  int bookmarkPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool bookmarkHasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isBookmarkLoading = false;

  // Loading all bookmark paper share
  // It will be called from init state so sharedpreferences is initialized in this method
  Future<void> getInitialBookmarkPaperShares(
      {required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await PaperShareRepo.getBookmarkPaperShares(
        page: 1.toString(),
        pageSize: bookmarkPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        currentUserId: mainScreenProvider.userId.toString());
    if (response.statusCode == 200) {
      _bookmarkPaperShare = bookmarkPaperShareFromJson(response.body);
      bookmarkShareStreamController.sink.add(_bookmarkPaperShare!);
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
      throw Exception('Unable to load bookmark paper shares');
    }
  }

  // Loading more paper share when user reach maximum pageSize item of a page in listview
  Future loadMoreBookmarkPaperShare({required BuildContext context}) async {
    bookmarkPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isBookmarkLoading) {
      return;
    }
    isBookmarkLoading = true;
    final response = await PaperShareRepo.getBookmarkPaperShares(
        page: bookmarkPage.toString(),
        pageSize: bookmarkPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        currentUserId: mainScreenProvider.userId.toString());
    if (response.statusCode == 200) {
      final newPaperShare = bookmarkPaperShareFromJson(response.body);

      // isBookmarkLoading = false indicates that the loading is complete
      isBookmarkLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newPaperShare.data!.length < bookmarkPageSize) {
        bookmarkHasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newPaperShare.data!.length; i++) {
        _bookmarkPaperShare!.data!.add(newPaperShare.data![i]);
      }
      bookmarkShareStreamController.sink.add(_bookmarkPaperShare!);
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

  Future updateBookmarkPaperShare({required BuildContext context}) async {
    if (_bookmarkPaperShare == null || bookmarkShareStreamController.isClosed) {
      return;
    } else {
      // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
      Response response = await PaperShareRepo.getBookmarkPaperShares(
          page: 1.toString(),
          pageSize: _bookmarkPaperShare!.data!.length < bookmarkPageSize
              ? bookmarkPageSize.toString()
              : _bookmarkPaperShare!.data!.length.toString(),
          jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
          currentUserId: mainScreenProvider.userId.toString());
      if (response.statusCode == 200) {
        _bookmarkPaperShare = bookmarkPaperShareFromJson(response.body);
        bookmarkShareStreamController.sink.add(_bookmarkPaperShare!);
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
  }

  bool isBookmarkRefresh = false;
  Future bookmarkRefresh({required BuildContext context}) async {
    isBookmarkRefresh = true;
    isBookmarkLoading = false;
    bookmarkHasMore = true;
    bookmarkPage = 1;
    if (_bookmarkPaperShare != null) {
      _bookmarkPaperShare!.data!.clear();
      bookmarkShareStreamController.sink.add(_bookmarkPaperShare!);
    }

    await getInitialBookmarkPaperShares(context: context);
    isBookmarkRefresh = false;
    notifyListeners();
  }

  bool toggleSaveOnProcess = false;

  // save paper share
  Future<void> togglePaperShareSave(
      {required String? savedPaperShareId,
      required BuildContext context,
      required String paperShareId,
      required PaperShareSourceType source}) async {
    if (toggleSaveOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleSaveOnProcess == false) {
      toggleSaveOnProcess = true;
      Response response;
      if (mainScreenProvider.savedPaperShareIdList
              .contains(int.parse(paperShareId)) &&
          savedPaperShareId != null) {
        mainScreenProvider.savedPaperShareIdList
            .remove(int.parse(paperShareId));
        response = await PaperShareRepo.removePaperShareSave(
            paperShareSavedId: savedPaperShareId,
            jwt: sharedPreferences.getString('jwt')!);
      } else {
        mainScreenProvider.savedPaperShareIdList.add(int.parse(paperShareId));
        Map bodyData = {
          "data": {
            "saved_by": mainScreenProvider.userId,
            "paper_share": paperShareId
          }
        };

        response = await PaperShareRepo.addPaperShareSave(
            bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      }
      if (response.statusCode == 200) {
        if (source == PaperShareSourceType.fromShare) {
          await getOnePaperShareForSharedLink(
              paperShareId: paperShareId, context: context);
        }
        // if toggling is done from bookmark, bookmark paper share will be updated first
        if (source == PaperShareSourceType.bookmark) {
          await Future.wait([
            updateBookmarkPaperShare(context: context),
            updateOnePaperShareForAllStreams(
                paperShareId: paperShareId, context: context),
          ]);
        } else {
          await Future.wait([
            updateOnePaperShareForAllStreams(
                paperShareId: paperShareId, context: context),
            updateBookmarkPaperShare(context: context)
          ]);
        }
        toggleSaveOnProcess = false;
        notifyListeners();
      } else {
        toggleSaveOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
    toggleSaveOnProcess = false;
    notifyListeners();
  }

  //discuss paper share
  Future<void> sendPaperShareDiscuss(
      {required BuildContext context,
      required String paperShareId,
      required PaperShareSourceType source}) async {
    try {
      String body = jsonEncode({
        "data": {
          "discussed_by": sharedPreferences.getString('id')!,
          "content": paperShareDiscussTextController.text,
          "paper_share": paperShareId
        }
      });

      Response commentResponse = await PaperShareRepo.savePostShareDiscussion(
          bodyData: body, jwt: sharedPreferences.getString('jwt')!);
      if (commentResponse.statusCode == 200) {
        paperShareDiscussTextController.clear();
        FocusScope.of(context).unfocus();
        if (source == PaperShareSourceType.fromShare) {
          await getOnePaperShareForSharedLink(
              paperShareId: paperShareId, context: context);
        }
        // if comment is posted from bookmark, bookmark paper share will be updated first
        if (source == PaperShareSourceType.bookmark) {
          await Future.wait([
            updateBookmarkPaperShare(context: context),
            updateOnePaperShareForAllStreams(
                paperShareId: paperShareId, context: context),
          ]);
        } else {
          await Future.wait([
            updateOnePaperShareForAllStreams(
                paperShareId: paperShareId, context: context),
            updateBookmarkPaperShare(context: context)
          ]);
        }
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).commentPosted,
            backgroundColor: const Color(0xFF5545CF),
            contentColor: Colors.white);

        notifyListeners();
      } else if (commentResponse.statusCode == 401 ||
          commentResponse.statusCode == 403) {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    } on Exception {
      throw (Exception);
    }
  }

  bool isPaperShareReverse = false;

  // this method will be called to reverse the singlechildscrollview to see all comments
  void changeReverse({bool fromInitial = false, required bool isReverse}) {
    if (isPaperShareReverse == isReverse) {
      return;
    } else {
      isPaperShareReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  // new paper share
  // Multiple picture selection
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectMultiImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList?.addAll(selectedImages);
    }
    notifyListeners();
  }

  void removeSelectedImage({required int index}) {
    imageFileList!.removeAt(index);
    notifyListeners();
  }

  void showPaperImageError({
    required BuildContext context,
  }) {
    showSnackBar(
        context: context,
        content: AppLocalizations.of(context).selectAnImage,
        contentColor: Colors.white,
        backgroundColor: Colors.red);
  }

  bool isPostClick = false;

  void stopLoading() {
    if (isPostClick == true) {
      isPostClick = false;
    }
    notifyListeners();
  }

  void showLoading() {
    if (isPostClick == false) {
      isPostClick = true;
      notifyListeners();
    }
  }

  Future<void> createNewPaperShare(
      {required BuildContext buildContext,
      required BuildContext context}) async {
    try {
      showLoading();
      Map bodyData = {
        'subject': newSubject,
        'level': newLevel,
        'semester': newSemester,
        'content': contentTextController.text,
        'posted_by': mainScreenProvider.userId.toString(),
      };

      final streamedResponse = await PaperShareRepo.createPaperShare(
          bodyData: bodyData,
          imageList: imageFileList!,
          jwt: sharedPreferences.getString('jwt')!);
      Response createResponse = await Response.fromStream(streamedResponse);
      if (createResponse.statusCode == 200) {
        String createdPaperShareId =
            jsonDecode(createResponse.body)["data"]["id"].toString();
        Response getResponse = await PaperShareRepo.getOneUpdatedPaperShare(
            jwt: sharedPreferences.getString('jwt') ?? 'null',
            paperShareId: createdPaperShareId);
        if (getResponse.statusCode == 200) {
          final onePaperShare = singlePaperShareFromJson(getResponse.body).data;
          if (onePaperShare != null &&
              _allPaperShare != null &&
              !paperShareStreamController.isClosed) {
            _allPaperShare!.data.insert(0, onePaperShare);
            // to prevent same data from displaying twice
            if (hasMore == true && _allPaperShare!.data.length >= 16) {
              _allPaperShare!.data.removeLast();
            }
            paperShareStreamController.sink.add(_allPaperShare!);
          }
        } else if (getResponse.statusCode == 401 ||
            getResponse.statusCode == 403) {
          if (context.mounted) {
            EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
                dismissOnTap: false, duration: const Duration(seconds: 4));
            Provider.of<DrawerProvider>(context, listen: false)
                .removeCredentials(context: context);
            return;
          }
        }
        showSnackBar(
            context: buildContext,
            content: AppLocalizations.of(context).createdSuccessfully,
            backgroundColor: const Color(0xFF5545CF),
            contentColor: Colors.white);
        goBack(context: buildContext);
      } else if (createResponse.statusCode == 401 ||
          createResponse.statusCode == 403) {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        showSnackBar(
            context: buildContext,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
      stopLoading();
    } on Exception {
      showSnackBar(
          context: buildContext,
          content: AppLocalizations.of(context).checkAllDetails,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // Search interest class

  // page and pageSize is used for pagination
  int searchPage = 1;
  int searchPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool searchHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool isSearchLoading = false;

  AllPaperShare? _searchPaperShare;

  List<PaperShare?> searchPaperShareList = [];

  int getPaperShareSearchCount({required List<PaperShare?> paperShareList}) {
    searchPaperShareList = paperShareList;
    return searchPaperShareList.length;
  }

  bool noSearchRecord = false;

  Future searchForPaperShares(
          {required String query, required BuildContext context}) async =>
      debounce(() async {
        // value of search page will be initialized back to 1, because it can be incremented while loading more search data
        searchPage = 1;

        // searchHasMore should be true in the beginning while searching for new keyword. It might have been changed to false, when there were no more data for previous keyword.
        if (searchHasMore == false) {
          searchHasMore = true;
        }

        // If there is no keyword in the search field, we won't call the server
        if (paperShareSearchTextController.text.trim() == '' &&
            query.trim() == '') {
          notifyListeners();
          return;
        }

        // if user has searched for keyword, remove the filtered list
        if (isFilterButtonClick == true) {
          isFilterButtonClick = false;
          filterSubject = null;
          filterLevel = null;
          filterSemester = null;
          notifyListeners();
        }

        Response response = await PaperShareRepo.searchAllPaperShares(
            myId:
                sharedPreferences.getString('id') ?? mainScreenProvider.userId!,
            page: searchPage.toString(),
            pageSize: searchPageSize.toString(),
            jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
            paperShareContentKeyword: query.trim().toLowerCase());
        if (response.statusCode == 200) {
          _searchPaperShare = paperShareFromJson(response.body);
          searchPaperStreamController.sink.add(_searchPaperShare!);

          final filterPaperShareList = _searchPaperShare!.data.where((element) {
            final titleLower =
                element.attributes!.content!.trim().toLowerCase();
            final searchLower = query.trim().toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();
          searchPaperShareList = filterPaperShareList;
          if (searchPaperShareList.isNotEmpty) {
            noSearchRecord = false;
          }
          if (searchPaperShareList.isEmpty) {
            noSearchRecord = true;
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
          throw Exception("Error occured while searching paper share");
        }
      });

  // Loading more paper shares when user reach maximum pageSize item of a page in listview
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
    Response response = await PaperShareRepo.searchAllPaperShares(
        myId: sharedPreferences.getString('id') ?? mainScreenProvider.userId!,
        page: searchPage.toString(),
        pageSize: searchPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!,
        paperShareContentKeyword: query.trim().toLowerCase());
    if (response.statusCode == 200) {
      final newSearchResults = paperShareFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isSearchLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newSearchResults.data.length < searchPageSize) {
        searchHasMore = false;
      }

      for (int i = 0; i < newSearchResults.data.length; i++) {
        _searchPaperShare!.data.add(newSearchResults.data[i]);
      }
      searchPaperShareList = _searchPaperShare!.data;
      searchPaperStreamController.sink.add(_searchPaperShare!);
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

  // filter paper share

  // page and pageSize is used for pagination
  int filterPageNumber = 1;
  int filterPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool filterHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool isfilterLoading = false;

  AllPaperShare? _filterPaperShare;

  List<PaperShare?> filterPaperShareList = [];

  // returns the count of snapshot data in listview
  int getFilterPaperShareCount({required List<PaperShare?> paperShareList}) {
    filterPaperShareList = paperShareList;
    return filterPaperShareList.length;
  }

  // Filter paper share
  bool isFilterButtonClick = false;

  void resetFilter({required BuildContext context}) {
    isFilterButtonClick = false;
    filterSubject = null;
    filterLevel = null;
    filterSemester = null;
    notifyListeners();
    Navigator.pop(context);
  }

  bool filterNoRecord = false;

  Future<void> filterAllPaperShare({required BuildContext context}) async {
    if (filterSubject == null &&
        filterLevel == null &&
        filterSemester == null) {
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

      Response response = await PaperShareRepo.filterAllPaperShares(
          myId: sharedPreferences.getString('id') ??
              mainScreenProvider.userId.toString(),
          page: filterPageNumber.toString(),
          pageSize: filterPageSize.toString(),
          jwt: sharedPreferences.getString('jwt') ??
              mainScreenProvider.jwt.toString(),
          subject: filterSubject,
          semester: filterSemester,
          level: filterLevel);

      if (response.statusCode == 200) {
        _filterPaperShare = paperShareFromJson(response.body);
        filterShareStreamController.sink.add(_filterPaperShare!);
        filterPaperShareList = _filterPaperShare!.data;
        if (filterPaperShareList.isNotEmpty) {
          filterNoRecord = false;
        }
        if (filterPaperShareList.isEmpty) {
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
        throw Exception("Error occured while filtering paper share");
      }
      notifyListeners();
      Navigator.pop(context);
    }
  }

  // Loading more filter paper shares when user reach maximum pageSize item of a page in listview
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
    Response response = await PaperShareRepo.filterAllPaperShares(
        myId: sharedPreferences.getString('id') ??
            mainScreenProvider.userId.toString(),
        page: filterPageNumber.toString(),
        pageSize: filterPageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ??
            mainScreenProvider.jwt.toString(),
        subject: filterSubject,
        semester: filterSemester,
        level: filterLevel);
    if (response.statusCode == 200) {
      final newFilterResults = paperShareFromJson(response.body);

      // isfilterLoading = false indicates that the loading is complete
      isfilterLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence filterHasMore = false
      if (newFilterResults.data.length < filterPageSize) {
        filterHasMore = false;
      }
      for (int i = 0; i < newFilterResults.data.length; i++) {
        _filterPaperShare!.data.add(newFilterResults.data[i]);
      }
      filterPaperShareList = _filterPaperShare!.data;
      filterShareStreamController.sink.add(_filterPaperShare!);
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

  // REPORT PAPER SHARE
  String? reportPaperShareReasonType;
  String? reportPaperShareOtherReason;

  void setPaperShareReason(
      {required BuildContext context, required String paperShareReportReason}) {
    if (mainScreenProvider
        .getReportOptionList(context: context)
        .values
        .toList()
        .contains(paperShareReportReason)) {
      reportPaperShareReasonType = paperShareReportReason;
      notifyListeners();
    }
  }

  void setPaperShareReportOtherReason(
      {required String paperShareReportOtherReason}) {
    reportPaperShareOtherReason = paperShareReportOtherReason;
  }

  void resetPaperShareReportOption() {
    reportPaperShareReasonType = null;
    reportPaperShareOtherReason = null;
    notifyListeners();
  }

  List<String> getReportPaperShareOptionList({required BuildContext context}) {
    return [AppLocalizations.of(context).report];
  }

  int totalInitialPaperShareList = 15;
  Future<void> reportPaperShare(
      {required BuildContext context,
      required String paperShareId,
      required String reason}) async {
    if (!mainScreenProvider.reportedPaperShareIdList
        .contains(int.parse(paperShareId))) {
      mainScreenProvider.reportedPaperShareIdList.add(int.parse(paperShareId));

      notifyListeners();
      Map bodyData = {
        "data": {
          'reported_by': sharedPreferences.getString('id').toString(),
          'paper_share': paperShareId,
          'reason': reason
        }
      };
      Response reportResponse = await ReportAndBlockRepo.reportPaperShare(
          bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      if (reportResponse.statusCode == 200) {
        removePostAfterReport(context: context, paperShareId: paperShareId);
      } else if (reportResponse.statusCode == 401 ||
          reportResponse.statusCode == 403) {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    } else {
      removePostAfterReport(context: context, paperShareId: paperShareId);
    }
  }

  int totalInitialSearchPaperShare = 15;
  int totalInitialFilterPaperShare = 15;
  int totalInitialBookmarkPaperShare = 15;

  void removePostAfterReport(
      {required String paperShareId, required BuildContext context}) {
    // NORMAL PAPER SHARE
    if (_allPaperShare != null && !paperShareStreamController.isClosed) {
      PaperShare? paperShare = _allPaperShare!.data
          .firstWhereOrNull((element) => element.id.toString() == paperShareId);
      if (paperShare != null) {
        _allPaperShare!.data
            .removeWhere((element) => element.id.toString() == paperShareId);
        if (_allPaperShare!.data.length <= 15 && hasMore == true) {
          totalInitialPaperShareList--;
          notifyListeners();
        }
      }

      paperShareStreamController.sink.add(_allPaperShare!);
    }

    // SEARCH PAPER SHARE
    if (_searchPaperShare != null && !searchPaperStreamController.isClosed) {
      PaperShare? paperShare = _searchPaperShare!.data
          .firstWhereOrNull((element) => element.id.toString() == paperShareId);
      if (paperShare != null) {
        _searchPaperShare!.data
            .removeWhere((element) => element.id.toString() == paperShareId);
        if (_searchPaperShare!.data.length <= 15 && searchHasMore == true) {
          totalInitialSearchPaperShare--;
          notifyListeners();
        }
      }

      searchPaperStreamController.sink.add(_searchPaperShare!);
    }

    // FILTER PAPER SHARE
    if (_filterPaperShare != null && !filterShareStreamController.isClosed) {
      PaperShare? paperShare = _filterPaperShare!.data
          .firstWhereOrNull((element) => element.id.toString() == paperShareId);
      if (paperShare != null) {
        _filterPaperShare!.data
            .removeWhere((element) => element.id.toString() == paperShareId);
        if (_filterPaperShare!.data.length <= 15 && filterHasMore == true) {
          totalInitialFilterPaperShare--;
          notifyListeners();
        }
      }

      filterShareStreamController.sink.add(_filterPaperShare!);
    }

    // BOOKMARK PAPER SHARE
    if (_bookmarkPaperShare != null && !filterShareStreamController.isClosed) {
      BookmarkPaperShareData? bookmarkedPaperShareData =
          _bookmarkPaperShare!.data!.firstWhereOrNull((element) =>
              element != null &&
              element.attributes != null &&
              element.attributes!.paperShare != null &&
              element.attributes!.paperShare!.data != null &&
              element.attributes!.paperShare!.data!.id.toString() ==
                  paperShareId);

      if (bookmarkedPaperShareData != null) {
        _bookmarkPaperShare!.data!.removeWhere((element) =>
            element != null &&
            element.attributes != null &&
            element.attributes!.paperShare != null &&
            element.attributes!.paperShare!.data != null &&
            element.attributes!.paperShare!.data!.id.toString() ==
                paperShareId);
        if (_bookmarkPaperShare!.data!.length <= 15 &&
            bookmarkHasMore == true) {
          totalInitialBookmarkPaperShare--;
          notifyListeners();
        }
      }

      bookmarkShareStreamController.sink.add(_bookmarkPaperShare!);
    }

    Navigator.of(context).pop();
    resetPaperShareReportOption();
    showSnackBar(
        context: context,
        content: AppLocalizations.of(context).reportedSuccessfully,
        contentColor: Colors.white,
        backgroundColor: kPrimaryColor);
    goBack(context: context);
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

  // Paper share rule
// If the user is just viewing the paper share rules, isJustView value will be true
  /*Future displayPaperShareRules(
      {required BuildContext mainContext, required bool isJustView}) {
    return showDialog(
        context: mainContext,
        builder: (context) {
          return Builder(builder: (context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context).rule,
                  style: TextStyle(
                    fontFamily: kHelveticaMedium,
                    fontSize: SizeConfig.defaultSize * 2.1,
                  ),
                ),
              ),
              content: Scrollbar(
                trackVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.defaultSize * 0.8),
                    child: Text(
                      AppLocalizations.of(context).termsAndConditionsContent,
                      style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.3,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
                    child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        offset: const Offset(0, 3),
                        borderRadius: 6,
                        blurRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        keepBoxShadow: true,
                        height: SizeConfig.defaultSize * 4.5,
                        width: SizeConfig.defaultSize * 21.4,
                        onPress: () async {
                          if (isJustView) {
                            Navigator.of(context).pop();
                          }
                          // If user is actually posting new paper share
                          else {
                            Navigator.of(context).pop();
                            await createNewPaperShare(
                                buildContext: mainContext,
                                context: mainContext);
                          }
                        },
                        text: AppLocalizations.of(context).understand,
                        textColor: Colors.white,
                        buttonColor: const Color(0xFF5545CF),
                        borderColor: const Color(0xFFC5966F),
                        fontFamily: kHelveticaRegular),
                  ),
                )
              ],
            );
          });
        });
  }*/

  void navigateToPaperDescription(
      {required BuildContext context,
      required String? savedPaperShareId,
      required int paperShareId,
      required PaperShareSourceType? source}) {
    if (source == PaperShareSourceType.bookmark) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookmarkPaperShareDescriptionScreen(
                    savedPaperShareId: savedPaperShareId,
                    paperShareId: paperShareId,
                    source: source!,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaperShareDescriptionScreen(
                    paperShareId: paperShareId,
                    source: source!,
                  )));
    }

    notifyListeners();
  }

  // When user clicks on user detail from discuss section
  Future<void> viewUserProfile(
      {required int discussedById,
      required BuildContext context,
      required int fromIndex,
      required int goToindex}) async {
    if (discussedById != int.parse(mainScreenProvider.userId!)) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                    otherUserId: discussedById,
                  )));
    } else {
      await Navigator.pushNamed(context, MyProfileScreen.id);
    }
    changeReverse(isReverse: true);
  }

  // Share paper share and creating dynamic links
  Future<void> sharePaper(
      {required String? paperShareId, required BuildContext context}) async {
    if (paperShareId == null) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          backgroundColor: Colors.red,
          contentColor: Colors.white);
      return;
    }
    final dynamicLinkParameters = DynamicLinkParameters(

        /// when user opens on web browser
        link: Uri.parse(dynamicLink + "/papershare?id=" + paperShareId),

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
    contentTextController.dispose();
    paperShareDiscussTextController.dispose();
    paperShareStreamController.close();
    paperShareSearchTextController.dispose();
    searchPaperStreamController.close();
    filterShareStreamController.close();
    bookmarkShareStreamController.close();
    fromSharePaperShareStreamController.close();
    super.dispose();
  }
}
