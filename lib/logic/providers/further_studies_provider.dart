import 'dart:async';
import 'dart:convert';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/all_news_boards_model.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/data/repositories/further_studies_repo.dart';
import 'package:spa_app/data/repositories/news_boards_repo.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/components/further_studies/further_discuss_description_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class FurtherStudiesProvider extends ChangeNotifier {
  // News boards in further studies tab
  StreamController<AllNewsBoards?> allNewsBoardsStreamController =
      BehaviorSubject();
  StreamController<AllNewsBoards?> fromShareNewsBoardStreamController =
      BehaviorSubject();
  late TextEditingController discussTextController;
  late SharedPreferences sharedPreferences;
  late final MainScreenProvider mainScreenProvider;
  FurtherStudiesProvider({required this.mainScreenProvider}) {
    discussTextController = TextEditingController();
    initial();
  }

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  bool isParentAsk = true;

  void goToParentAsk({required BuildContext context}) async {
    isParentAsk = true;
    parentRefresh(context: context);
    notifyListeners();
  }

  void goToStudentAsk({required BuildContext context}) async {
    isParentAsk = false;
    studentRefresh(context: context);
    notifyListeners();
  }

  AllNewsBoards? _allNewsBoards;
  AllNewsBoards? get allNewsBoards => _allNewsBoards;

  // page and pageSize is used for pagination
  int page = 1;
  int pageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool hasMore = true;
  // It will be true once we try to fetch more conversations.
  bool isLoading = false;

  // Load news boards
  // sharedPreferences is initialized here because this method will be called from init state of Further Studies tab
  Future<void> getInitialNewsBoards({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await NewsBoardsRepo.getAllNewsBoards(
        page: page.toString(),
        pageSize: pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _allNewsBoards = allNewsBoardsFromJson(response.body);
      allNewsBoardsStreamController.sink.add(_allNewsBoards);
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
      throw Exception('Unable to load news boards');
    }
  }

  Future loadMoreNewsBoards({required BuildContext context}) async {
    page++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isLoading) {
      return;
    }
    isLoading = true;
    final response = await NewsBoardsRepo.getAllNewsBoards(
        page: page.toString(),
        pageSize: pageSize.toString(),
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      final newNewsBoards = allNewsBoardsFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsBoards.data!.length < pageSize) {
        hasMore = false;
        notifyListeners();
      }

      for (int i = 0; i < newNewsBoards.data!.length; i++) {
        _allNewsBoards!.data!.add(newNewsBoards.data![i]);
      }
      allNewsBoardsStreamController.sink.add(_allNewsBoards!);
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

  Future updateAllNewsBoards({required BuildContext context}) async {
    if (_allNewsBoards == null || allNewsBoardsStreamController.isClosed) {
      return;
    } else {
      // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
      Response response = await NewsBoardsRepo.getAllNewsBoards(
          jwt: sharedPreferences.getString('jwt') ?? 'null',
          page: 1.toString(),
          pageSize: _allNewsBoards!.data!.length < pageSize
              ? pageSize.toString()
              : _allNewsBoards!.data!.length.toString());
      if (response.statusCode == 200) {
        _allNewsBoards = allNewsBoardsFromJson(response.body);
        allNewsBoardsStreamController.sink.add(_allNewsBoards!);
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

  bool isRefresh = false;
  Future refresh({required BuildContext context}) async {
    isRefresh = true;
    isLoading = false;
    hasMore = true;
    page = 1;
    if (_allNewsBoards != null) {
      _allNewsBoards!.data!.clear();
      allNewsBoardsStreamController.sink.add(_allNewsBoards!);
    }

    await getInitialNewsBoards(context: context);
    isRefresh = false;
    notifyListeners();
  }

  // NEWS BOARD FROM SHARED LINK

  AllNewsBoards? _sharedNewsBoard;
  AllNewsBoards? get sharedNewsBoard => _sharedNewsBoard;
  Future<void> getOneNewsBoardFromSharedLink(
      {required String newsBoardId, required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final response = await NewsBoardsRepo.getOneNewsBoardFromSharedLink(
        newsBoardId: newsBoardId,
        jwt: sharedPreferences.getString('jwt') ?? mainScreenProvider.jwt!);
    if (response.statusCode == 200) {
      _sharedNewsBoard = allNewsBoardsFromJson(response.body);
      fromShareNewsBoardStreamController.sink.add(_sharedNewsBoard);
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
      throw Exception('Unable to load one news board');
    }
  }

  void viewUserProfile(
      {required int userId,
      required BuildContext context,
      required int fromIndex,
      required int goToindex}) {
    if (userId != int.parse(mainScreenProvider.userId!)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                    otherUserId: userId,
                  )));
    } else {
      Navigator.pushNamed(context, MyProfileScreen.id);
    }
  }

  // Parent ask list view
  // All news are added to sink of this controller
  StreamController<AllNewsPost> parentDiscussStreamController =
      BehaviorSubject();

  AllNewsPost? _parentDiscussNewsPost;
  AllNewsPost? get parentDiscussNewsPost => _parentDiscussNewsPost;

  // page and pageSize is used for pagination
  int parentDiscussPage = 1;
  int parentDiscussPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool parentDiscussHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool parentDiscussIsLoading = false;

  // This method will be called to gets news posts
  Future loadInitialParentDiscuss({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response = await FurtherStudiesRepo.getParentPopularNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: parentDiscussPage.toString(),
        pageSize: parentDiscussPageSize.toString());

    if (response.statusCode == 200) {
      _parentDiscussNewsPost = allNewsPostFromJson(response.body);
      parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
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

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future loadMoreParentNewsPosts({required BuildContext context}) async {
    parentDiscussPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (parentDiscussIsLoading) {
      return;
    }
    parentDiscussIsLoading = true;
    Response response = await FurtherStudiesRepo.getParentPopularNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: parentDiscussPage.toString(),
        pageSize: parentDiscussPageSize.toString());
    if (response.statusCode == 200) {
      final newNewsPosts = allNewsPostFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      parentDiscussIsLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsPosts.data!.length < parentDiscussPageSize) {
        parentDiscussHasMore = false;
      }

      for (int i = 0; i < newNewsPosts.data!.length; i++) {
        _parentDiscussNewsPost!.data!.add(newNewsPosts.data![i]);
      }
      parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
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

  Future updateSelectedParentNewsPosts(
      {required String parentNewsPostId, required BuildContext context}) async {
    if (_parentDiscussNewsPost == null ||
        parentDiscussStreamController.isClosed) {
      return;
    } else {
      Response response =
          await FurtherStudiesRepo.getOneUpdatedParentPopularNewsPosts(
              myId: sharedPreferences.getString('id') ?? 'null',
              jwt: sharedPreferences.getString('jwt') ?? 'null',
              parentNewsPostId: parentNewsPostId);
      if (response.statusCode == 200) {
        final oneNewsPost = singleNewsPostFromJson(response.body).data;
        final newsPostIndex = _parentDiscussNewsPost!.data!.indexWhere(
            (element) => element.id.toString() == oneNewsPost!.id.toString());

        if (oneNewsPost != null && newsPostIndex != -1) {
          _parentDiscussNewsPost!.data![newsPostIndex] = oneNewsPost;
          parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
          notifyListeners();
        }
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

  // This method will be called from newsAdprovider when user likes, saves or comments a news post
  Future updateAllParentNewsPosts({required BuildContext context}) async {
    if (_parentDiscussNewsPost == null ||
        parentDiscussStreamController.isClosed) {
      return;
    } else {
      // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
      Response response = await FurtherStudiesRepo.getParentPopularNewsPosts(
          myId: sharedPreferences.getString('id') ?? 'null',
          jwt: sharedPreferences.getString('jwt') ?? 'null',
          page: 1.toString(),
          pageSize: _parentDiscussNewsPost!.data!.length < parentDiscussPageSize
              ? parentDiscussPageSize.toString()
              : _parentDiscussNewsPost!.data!.length.toString());
      if (response.statusCode == 200) {
        _parentDiscussNewsPost = allNewsPostFromJson(response.body);
        parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
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

  int totalInitialParentNewsPost = 15;

  void removeReportedParentNewsPost({required String newsPostId}) {
    if (_parentDiscussNewsPost != null &&
        _parentDiscussNewsPost!.data != null &&
        !parentDiscussStreamController.isClosed) {
      NewsPost? newsPost = _parentDiscussNewsPost!.data!
          .firstWhereOrNull((element) => element.id.toString() == newsPostId);
      if (newsPost != null) {
        _parentDiscussNewsPost!.data!
            .removeWhere((element) => element.id.toString() == newsPostId);
        if (_parentDiscussNewsPost!.data!.length <= 15 &&
            parentDiscussHasMore == true) {
          totalInitialParentNewsPost--;
          notifyListeners();
        }
        parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
        notifyListeners();
      }
    }
  }

  void removeBlockParentNewsPost({required String otherUserId}) {
    if (_parentDiscussNewsPost != null &&
        _parentDiscussNewsPost!.data != null &&
        !parentDiscussStreamController.isClosed) {
      NewsPost? newsPost = _parentDiscussNewsPost!.data!.firstWhereOrNull(
          (element) =>
              element.attributes != null &&
              element.attributes!.postedBy != null &&
              element.attributes!.postedBy!.data != null &&
              element.attributes!.postedBy!.data!.id.toString() == otherUserId);
      if (newsPost != null) {
        _parentDiscussNewsPost!.data!.removeWhere((element) =>
            element.attributes != null &&
            element.attributes!.postedBy != null &&
            element.attributes!.postedBy!.data != null &&
            element.attributes!.postedBy!.data!.id.toString() == otherUserId);
        if (_parentDiscussNewsPost!.data!.length <= 15 &&
            parentDiscussHasMore == true) {
          int itemsRemoved = 15 - _parentDiscussNewsPost!.data!.length;
          totalInitialParentNewsPost =
              totalInitialParentNewsPost - itemsRemoved;

          notifyListeners();
        }
        parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
        notifyListeners();
      }
    }
  }

  // Returns fire color based on whether current user has already viewed this post or not
  Color getFireColor(
      {DiscussCommentCounts? discussCommentCounts, int? currentCommentCount}) {
    if (discussCommentCounts == null) {
      return Colors.red;
    } else {
      int commentCountFromDiscussComment = 0;
      if (discussCommentCounts.data!.isNotEmpty) {
        // checking comment count of current post visited by current user
        for (var currentDiscussComment in discussCommentCounts.data!) {
          // Going to each user who has visited this current post
          for (var currentVisitedByUserId
              in currentDiscussComment!.attributes!.visitedBy!.data!) {
            // If we found current user id in the post visited by list
            if (currentVisitedByUserId!.id.toString() ==
                mainScreenProvider.userId) {
              commentCountFromDiscussComment = int.parse(currentDiscussComment
                  .attributes!.commentCountWhenVisited
                  .toString());

              // if the post has already been viewed by current user in further study discuss
              if (commentCountFromDiscussComment == currentCommentCount) {
                return const Color(0xFF8897A7);
              }
              // if the post has new comment
              else {
                return Colors.red;
              }
            }
          }
        }
        // if there's no comment in the post
      } else if (currentCommentCount == 0) {
        return const Color(0xFF8897A7);
      }
      // else
      return Colors.red;
    }
  }

  void goToFurtherStudyDetailScreen(
      {required BuildContext context,
      required int newsPostId,
      required String currentComment,
      required DiscussCommentCounts? discussCommentCounts,
      required bool isParent}) async {
    updateCommentCount(
        newsPostId: newsPostId.toString(),
        context: context,
        discussCommentCounts: discussCommentCounts,
        currentCommentCount: currentComment);
    if (isParentAsk) {
      updateAllParentNewsPosts(context: context);
    } else {
      updateAllStudentNewsPosts(context: context);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FurtherStudiesDiscussDescriptionScreen(
                  isParentAsk: isParentAsk,
                  newsPostId: newsPostId,
                  discussCommentTextEditingController: discussTextController,
                )));
  }

  // 0 index will store discussCommentId
  // 1 index will store commentCountWhenLastVisited
  List<String>? getDiscussCommentDetails(
      {required DiscussCommentCounts? discussCommentCounts}) {
    if (discussCommentCounts == null) {
      return null;
    } else {
      // checking for visited user from discuss comment counts
      for (var currentDiscussComment in discussCommentCounts.data!) {
        // Going to each user who has visited this current post
        for (var currentVisitedByUserId
            in currentDiscussComment!.attributes!.visitedBy!.data!) {
          // If we found current user id in the post visited by list
          if (currentVisitedByUserId!.id.toString() ==
              mainScreenProvider.userId) {
            return [
              currentDiscussComment.id.toString(),
              currentDiscussComment.attributes!.commentCountWhenVisited
                  .toString()
            ];
          } else {
            continue;
          }
        }
      }
    }

    return null;
  }

  Future<void> updateCommentCount(
      {required BuildContext context,
      required DiscussCommentCounts? discussCommentCounts,
      required String newsPostId,
      required String currentCommentCount}) async {
    late Response response;

    List<String>? discussCountDetailList =
        getDiscussCommentDetails(discussCommentCounts: discussCommentCounts);
    // if there's no record for current user for this news post in discuss comment count collection type,
    if (discussCountDetailList == null) {
      Map createBodyData = {
        "data": {
          "comment_count_when_visited": currentCommentCount,
          "visited_by": mainScreenProvider.userId!,
          "news_posts": newsPostId
        }
      };
      response = await FurtherStudiesRepo.createCommentCount(
          bodyData: createBodyData, jwt: sharedPreferences.getString('jwt')!);
    }
    // else if there is record, then
    else {
      String commentCountId = discussCountDetailList[0];
      String commentCountWhenLastVisited = discussCountDetailList[1];
      // if the current comment count and comment count when last visited is same, then we don't need to call API
      if (commentCountWhenLastVisited == currentCommentCount) {
        return;
      } else {
        // if current comment count and comment count when last visited is not same, then we will call API to update
        Map updateBodyData = {
          "data": {"comment_count_when_visited": currentCommentCount}
        };
        response = await FurtherStudiesRepo.updateCommentCount(
            discussCommentId: commentCountId,
            bodyData: updateBodyData,
            jwt: sharedPreferences.getString('jwt')!);
      }
    }
    if (response.statusCode == 200) {
      notifyListeners();
      return;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else if (((jsonDecode(response.body))["error"]["message"]).toString() ==
        'Not Found') {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    } else {
      showSnackBar(
          context: context,
          content: ((jsonDecode(response.body))["error"]["message"]).toString(),
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
    notifyListeners();
  }

  bool isParentRefresh = false;
  Future parentRefresh({required BuildContext context}) async {
    isParentRefresh = true;
    parentDiscussIsLoading = false;
    parentDiscussHasMore = true;
    parentDiscussPage = 1;
    if (_parentDiscussNewsPost != null) {
      _parentDiscussNewsPost!.data!.clear();
      parentDiscussStreamController.sink.add(_parentDiscussNewsPost!);
    }

    await loadInitialParentDiscuss(context: context);

    isParentRefresh = false;
    notifyListeners();
  }

  // Student ask list
  StreamController<AllNewsPost> studentDiscussStreamController =
      BehaviorSubject();
  AllNewsPost? _studentDiscussNewsPost;
  AllNewsPost? get studentDiscussNewsPost => _studentDiscussNewsPost;

  // page and pageSize is used for pagination
  int studentDiscussPage = 1;
  int studentDiscussPageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool studentDiscussHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool studentDiscussIsLoading = false;

  // This method will be called to gets news posts
  Future loadInitialStudentDiscuss({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response = await FurtherStudiesRepo.getStudentPopularNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: studentDiscussPage.toString(),
        pageSize: studentDiscussPageSize.toString());
    if (response.statusCode == 200) {
      _studentDiscussNewsPost = allNewsPostFromJson(response.body);
      studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
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

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future loadMoreStudentNewsPosts({required BuildContext context}) async {
    studentDiscussPage++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (studentDiscussIsLoading) {
      return;
    }
    studentDiscussIsLoading = true;
    Response response = await FurtherStudiesRepo.getStudentPopularNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: studentDiscussPage.toString(),
        pageSize: studentDiscussPageSize.toString());
    if (response.statusCode == 200) {
      final newNewsPosts = allNewsPostFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      studentDiscussIsLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsPosts.data!.length < studentDiscussPageSize) {
        studentDiscussHasMore = false;
      }

      for (int i = 0; i < newNewsPosts.data!.length; i++) {
        _studentDiscussNewsPost!.data!.add(newNewsPosts.data![i]);
      }
      studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
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

  Future updateSelectedStudentNewsPosts(
      {required String studentNewsPostId,
      required BuildContext context}) async {
    if (_studentDiscussNewsPost == null ||
        studentDiscussStreamController.isClosed) {
      return;
    } else {
      Response response =
          await FurtherStudiesRepo.getOneUpdatedStudentPopularNewsPosts(
              myId: sharedPreferences.getString('id') ?? 'null',
              jwt: sharedPreferences.getString('jwt') ?? 'null',
              studentNewsPostId: studentNewsPostId);
      if (response.statusCode == 200) {
        final oneNewsPost = singleNewsPostFromJson(response.body).data;
        final newsPostIndex = _studentDiscussNewsPost!.data!.indexWhere(
            (element) => element.id.toString() == oneNewsPost!.id.toString());
        if (oneNewsPost != null && newsPostIndex != -1) {
          _studentDiscussNewsPost!.data![newsPostIndex] = oneNewsPost;

          studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
          notifyListeners();
        }
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

  // This method will be called from newsAdprovider when user likes, saves or comments a news post
  Future updateAllStudentNewsPosts({required BuildContext context}) async {
    if (_studentDiscussNewsPost == null ||
        studentDiscussStreamController.isClosed) {
      return;
    } else {
      // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
      Response response = await FurtherStudiesRepo.getStudentPopularNewsPosts(
          myId: sharedPreferences.getString('id') ?? 'null',
          jwt: sharedPreferences.getString('jwt') ?? 'null',
          page: 1.toString(),
          pageSize:
              _studentDiscussNewsPost!.data!.length < studentDiscussPageSize
                  ? studentDiscussPageSize.toString()
                  : _studentDiscussNewsPost!.data!.length.toString());
      if (response.statusCode == 200) {
        _studentDiscussNewsPost = allNewsPostFromJson(response.body);
        studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
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

  int totalInitialStudentList = 15;

  void removeReportedStudentNewsPost({required String newsPostId}) {
    if (_studentDiscussNewsPost != null &&
        _studentDiscussNewsPost!.data != null &&
        !studentDiscussStreamController.isClosed) {
      NewsPost? newsPost = _studentDiscussNewsPost!.data!
          .firstWhereOrNull((element) => element.id.toString() == newsPostId);
      if (newsPost != null) {
        _studentDiscussNewsPost!.data!
            .removeWhere((element) => element.id.toString() == newsPostId);
        if (_studentDiscussNewsPost!.data!.length <= 15 &&
            studentDiscussHasMore == true) {
          totalInitialStudentList--;
          notifyListeners();
        }
        studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
        notifyListeners();
      }
    }
  }

  void removeBlockStudenttNewsPost({required String otherUserId}) {
    if (_studentDiscussNewsPost != null &&
        _studentDiscussNewsPost!.data != null &&
        !studentDiscussStreamController.isClosed) {
      NewsPost? newsPost = _studentDiscussNewsPost!.data!.firstWhereOrNull(
          (element) =>
              element.attributes != null &&
              element.attributes!.postedBy != null &&
              element.attributes!.postedBy!.data != null &&
              element.attributes!.postedBy!.data!.id.toString() == otherUserId);
      if (newsPost != null) {
        _studentDiscussNewsPost!.data!.removeWhere((element) =>
            element.attributes != null &&
            element.attributes!.postedBy != null &&
            element.attributes!.postedBy!.data != null &&
            element.attributes!.postedBy!.data!.id.toString() == otherUserId);
        if (_studentDiscussNewsPost!.data!.length <= 15 &&
            studentDiscussHasMore == true) {
          int itemsRemoved = 15 - _studentDiscussNewsPost!.data!.length;
          totalInitialStudentList = totalInitialStudentList - itemsRemoved;
          notifyListeners();
        }
        studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
        notifyListeners();
      }
    }
  }

  bool isStudentRefresh = false;
  Future studentRefresh({required BuildContext context}) async {
    isStudentRefresh = true;
    studentDiscussIsLoading = false;
    studentDiscussHasMore = true;
    studentDiscussPage = 1;
    if (_studentDiscussNewsPost != null) {
      _studentDiscussNewsPost!.data!.clear();
      studentDiscussStreamController.sink.add(_studentDiscussNewsPost!);
    }
    await loadInitialStudentDiscuss(context: context);
    isStudentRefresh = false;
    notifyListeners();
  }

  // parent discuss prev/next button

  int selectedParentDiscussIndex = 0;

  void changeParentDiscuss(
      {required bool isAdd, required BuildContext context}) {
    if (isAdd) {
      selectedParentDiscussIndex++;
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedParentDiscussIndex >= 1) {
        selectedParentDiscussIndex--;
      }
    }
    scrollToDiscuss(context: context);
    notifyListeners();
  }

  void resetParentDiscussIndex() {
    if (selectedParentDiscussIndex != 0) {
      selectedParentDiscussIndex = 0;
    }
    if (selectedParentDiscussIndex != 0) {
      selectedParentDiscussIndex = 0;
    }
    notifyListeners();
  }

  // student discuss prev/next button
  int selectedStudentDiscussIndex = 0;

  void changeStudentDiscuss(
      {required bool isAdd, required BuildContext context}) {
    if (isAdd) {
      selectedStudentDiscussIndex++;
    } else {
      // Value of 0 index is 1
      // Value of 1 index is 2
      if (selectedStudentDiscussIndex >= 1) {
        selectedStudentDiscussIndex--;
      }
    }
    scrollToDiscuss(context: context);
    notifyListeners();
  }

  void resetStudentDiscussIndex() {
    if (selectedStudentDiscussIndex != 0) {
      selectedStudentDiscussIndex = 0;
    }
    if (selectedStudentDiscussIndex != 0) {
      selectedStudentDiscussIndex = 0;
    }
    notifyListeners();
  }

  Future scrollToDiscuss({required BuildContext context}) async {
    await Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 500));
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

  // Share news board and creating dynamic links
  Future<void> shareNewsBoard(
      {required String? newsBoardId, required BuildContext context}) async {
    if (newsBoardId == null) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          backgroundColor: Colors.red,
          contentColor: Colors.white);
      return;
    }
    final dynamicLinkParameters = DynamicLinkParameters(

        /// when user opens on web browser
        link: Uri.parse(dynamicLink + "/newsboard?id=$newsBoardId"),

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

  String getFurtherStudiesLikeCount(
      {required int likeCount, required BuildContext context}) {
    if (likeCount == 0) {
      return "0 ${AppLocalizations.of(context).like}";
    }
    if (likeCount == 1) {
      return "1 ${AppLocalizations.of(context).like}";
    } else if (likeCount <= 999) {
      return "$likeCount ${AppLocalizations.of(context).likes}";
    } else if (likeCount >= 1000 && likeCount < 100000) {
      double number = (likeCount) / 1000.floorToDouble();
      return "${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)} K ${AppLocalizations.of(context).likes}";
    } else {
      double number = (likeCount) / 1000000.floorToDouble();
      return "${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)} M ${AppLocalizations.of(context).likes}";
    }
  }

  String getFurtherStudiesCommentCount(
      {required int commentCount, required BuildContext context}) {
    if (commentCount == 0) {
      return "0 ${AppLocalizations.of(context).reply}";
    }
    if (commentCount == 1) {
      return "1 ${AppLocalizations.of(context).reply}";
    } else if (commentCount <= 999) {
      return "$commentCount ${AppLocalizations.of(context).replies}";
    } else if (commentCount >= 1000 && commentCount < 100000) {
      double number = (commentCount) / 1000.floorToDouble();
      return "${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)} K ${AppLocalizations.of(context).replies}";
    } else {
      double number = (commentCount) / 1000000.floorToDouble();
      return "${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)} M ${AppLocalizations.of(context).replies}";
    }
  }

  @override
  void dispose() {
    allNewsBoardsStreamController.close();
    discussTextController.dispose();
    parentDiscussStreamController.close();
    studentDiscussStreamController.close();
    fromShareNewsBoardStreamController.close();
    super.dispose();
  }
}
