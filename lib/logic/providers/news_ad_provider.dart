import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/data/constant/color_constant.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/news_post_enum.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/data/models/news_post_likes_model.dart';
import 'package:spa_app/data/models/push_notification_model.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/data/repositories/new_post_repo.dart';
import 'package:spa_app/data/repositories/news_comment_repo.dart';
import 'package:spa_app/data/repositories/news_post_repo.dart';
import 'package:spa_app/data/repositories/profile_topic_repo.dart';
import 'package:spa_app/data/repositories/push_notification_repo.dart';
import 'package:spa_app/data/repositories/report_news_post_repo.dart';
import 'package:spa_app/logic/providers/bottom_nav_provider.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';

class NewsAdProvider extends ChangeNotifier {
  GlobalKey<FormState> postContentKey = GlobalKey<FormState>();
  // New news post controllers
  late TextEditingController postTitleController;
  late TextEditingController postContentController;

  late SharedPreferences sharedPreferences =
      mainScreenProvider.sharedPreferences;

  List<TextEditingController> newsCommentControllerList =
      <TextEditingController>[];
  List<TextEditingController> profileNewsCommentControllerList =
      <TextEditingController>[];

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  late final MainScreenProvider mainScreenProvider;
  late final BottomNavProvider bottomNavProvider;

  NewsAdProvider(
      {required this.mainScreenProvider, required this.bottomNavProvider}) {
    initial();
    postContentController = TextEditingController();
    postTitleController = TextEditingController();
  }

  String getLike({required int likeCount, required BuildContext context}) {
    if (likeCount == 0) {
      return "0 ${AppLocalizations.of(context).like}";
    }
    if (likeCount == 1) {
      return "1 ${AppLocalizations.of(context).like}";
    } else if (likeCount <= 3) {
      return "$likeCount ${AppLocalizations.of(context).likes}";
    } else if (likeCount == 4) {
      return "+${likeCount - 3} ${AppLocalizations.of(context).like}";
    } else if (likeCount - 3 <= 999) {
      return "+${likeCount - 3} ${AppLocalizations.of(context).likes}";
    } else if (likeCount - 3 >= 1000 && likeCount - 3 < 1000000) {
      double number = (likeCount - 3) / 1000.floorToDouble();
      return "+${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)}${AppLocalizations.of(context).kLikes}";
    } else {
      double number = (likeCount - 3) / 1000000.floorToDouble();
      return "+${number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 1)}${AppLocalizations.of(context).mLikes}";
    }
  }

  String getUserType(
      {required String usertType, required BuildContext context}) {
    if (usertType == 'Member') {
      return AppLocalizations.of(context).member;
    } else if (usertType == 'Therapist') {
      return AppLocalizations.of(context).therapist;
    } else {
      return 'User';
    }
  }

  // Load news post

  // All news are added to sink of this controller
  StreamController<AllNewsPost> allNewsPostController = BehaviorSubject();

  AllNewsPost? _allNewsPost;
  AllNewsPost? get allNewsPost => _allNewsPost;

  // page and pageSize is used for pagination
  int page = 1;
  int pageSize = 15;
  // hasMore will be true until we have more data to fetch in the API
  bool hasMore = true;
  // It will be true once we try to fetch more news post data.
  bool isLoading = false;

  // This method will be called to gets news posts, when user is logged in
  Future loadInitialNewsPosts({required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response = await NewsPostRepo.getAllNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: page.toString(),
        pageSize: pageSize.toString());
    if (response.statusCode == 200) {
      _allNewsPost = allNewsPostFromJson(response.body);
      allNewsPostController.sink.add(_allNewsPost!);
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

  Future<void> setUnreadNotificationBadge(
      {required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response = await PushNotificationRepo.getUnreadFollowNotification(
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        currentUserId: mainScreenProvider.userId.toString());
    if (response.statusCode == 200) {
      final unreadNotification = notificationFromJson(response.body).data;
      followNotificationBadge =
          (unreadNotification != null && unreadNotification.isNotEmpty);
      sharedPreferences.setBool("follow_push_notification",
          (unreadNotification != null && unreadNotification.isNotEmpty));
      sharedPreferences.setBool("notification_tab_active_status",
          (unreadNotification != null && unreadNotification.isNotEmpty));
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    }
    notifyListeners();
  }

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future loadMoreNewsPosts({required BuildContext context}) async {
    page++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, we will get exit from this method.
    if (isLoading) {
      return;
    }
    isLoading = true;
    Response response = await NewsPostRepo.getAllNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: page.toString(),
        pageSize: pageSize.toString());
    if (response.statusCode == 200) {
      final newNewsPosts = allNewsPostFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      isLoading = false;

      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsPosts.data!.length < pageSize) {
        hasMore = false;
      }

      for (int i = 0; i < newNewsPosts.data!.length; i++) {
        _allNewsPost!.data!.add(newNewsPosts.data![i]);
      }
      allNewsPostController.sink.add(_allNewsPost!);
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

  // // This method will be called to update news posts when like, save or comment is done.
  Future updateSelectedNewsPosts(
      {required BuildContext context,
      required String newsPostId,
      required NewsPostSource newsPostSource}) async {
    if (_allNewsPost == null || allNewsPostController.isClosed) {
      return;
    }
    Response response = await NewsPostRepo.getOneUpdateNewsPost(
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        newsPostId: newsPostId);
    if (response.statusCode == 200) {
      final oneNewsPost = singleNewsPostFromJson(response.body).data;

      final newsPostIndex = _allNewsPost!.data!.indexWhere(
          (element) => element.id.toString() == oneNewsPost!.id.toString());

      if (oneNewsPost != null && newsPostIndex != -1) {
        _allNewsPost!.data![newsPostIndex] = oneNewsPost;
        allNewsPostController.sink.add(_allNewsPost!);
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
    } else {
      return false;
    }
  }

  Future updateAllNewsPosts({required BuildContext? context}) async {
    if (_allNewsPost == null || allNewsPostController.isClosed) {
      return;
    }
    // We pass 1 as page, and all the loaded news posts' length as pageSize because we want update all the news posts when this method is called.
    Response response = await NewsPostRepo.getAllNewsPosts(
        myId: sharedPreferences.getString('id') ?? 'null',
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        page: 1.toString(),
        pageSize: _allNewsPost!.data!.length < pageSize
            ? pageSize.toString()
            : _allNewsPost!.data!.length.toString());
    if (response.statusCode == 200) {
      _allNewsPost = allNewsPostFromJson(response.body);
      allNewsPostController.sink.add(_allNewsPost!);
      notifyListeners();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context != null && context.mounted) {
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

  StreamController<NewsPostLikes> newsPostLikesStreamController =
      BehaviorSubject();
  Future getNewsPostLikes(
      {required String newsPostId, required BuildContext context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Response response = await NewsPostRepo.getAllNewsPostsLikes(
        jwt: sharedPreferences.getString('jwt') ?? 'null',
        newsPostId: newsPostId);
    if (response.statusCode == 200) {
      final newsPostLikes = newsPostLikesFromJson(response.body);
      newsPostLikesStreamController.sink.add(newsPostLikes);
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

  Future refresh({required BuildContext context}) async {
    isLoading = false;
    hasMore = true;
    page = 1;
    if (_allNewsPost != null) {
      _allNewsPost!.data!.clear();
      allNewsPostController.sink.add(_allNewsPost!);
    }
    await loadInitialNewsPosts(context: context);
    // await setUnreadNotificationBadge();
    notifyListeners();
  }

  // Profile topics

  NewsPost? _singleNewsPostFromMyTopicAndBookmark;
  NewsPost? get singleNewsPostFromMyTopicAndBookmark =>
      _singleNewsPostFromMyTopicAndBookmark;
  Future<void> getOneProfileTopic(
      {required String topicId, required BuildContext context}) async {
    final response = await ProfileTopicRepo.getOneProfileTopic(
        jwt: sharedPreferences.getString('jwt')!, topicId: topicId);
    if (response.statusCode == 200) {
      _singleNewsPostFromMyTopicAndBookmark =
          NewsPost.fromJson((jsonDecode(response.body))['data']);
      mainScreenProvider.profileNewsTopicStreamController.sink
          .add(_singleNewsPostFromMyTopicAndBookmark);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      if (context.mounted) {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).newsCouldNotLoad,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
  }

  User? _myProfileTopics;
  User? get myProfileTopics => _myProfileTopics;

  Future<void> getSelectedUserProfileTopics(
      {required String userId, required BuildContext context}) async {
    final response = await ProfileTopicRepo.getSelectedUserAllProfileTopic(
        jwt: sharedPreferences.getString('jwt')!, userId: userId);
    if (response.statusCode == 200) {
      _myProfileTopics = userFromJson(response.body);
      for (int i = 0;
          i < mainScreenProvider.reportedNewsPostidList.length;
          i++) {
        if (_myProfileTopics != null && _myProfileTopics!.createdPost != null) {
          _myProfileTopics!.createdPost!.removeWhere((element) =>
              element != null &&
              element.id == mainScreenProvider.reportedNewsPostidList[i]);
        }
      }
      mainScreenProvider.allProfileTopicController.sink.add(_myProfileTopics);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else if (response.statusCode == 400 && context.mounted) {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).tryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).newsCouldNotLoad,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  bool checkNewsPostSaveStatus({required int postId}) {
    if (mainScreenProvider.savedNewsPostIdList.contains(postId)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkNewsPostLikeStatus({required int postId}) {
    if (mainScreenProvider.likedPostIdList.contains(postId)) {
      return true;
    } else {
      return false;
    }
  }

  bool toggleSaveOnProcess = false;

  Future<void> toggleNewsPostSave(
      {required NewsPostSource newsPostSource,
      required String? newsPostSaveId,
      required BuildContext context,
      required String postId,
      required bool setLikeSaveCommentFollow}) async {
    if (toggleSaveOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleSaveOnProcess == false) {
      toggleSaveOnProcess = true;
      Response response;
      if (mainScreenProvider.savedNewsPostIdList.contains(int.parse(postId)) &&
          newsPostSaveId != null) {
        mainScreenProvider.savedNewsPostIdList.remove(int.parse(postId));
        response = await NewsPostRepo.removeNewsPostSave(
            newsPostSavedId: newsPostSaveId,
            jwt: sharedPreferences.getString('jwt')!);
      } else {
        mainScreenProvider.savedNewsPostIdList.add(int.parse(postId));
        Map bodyData = {
          "data": {"saved_by": mainScreenProvider.userId, "news_post": postId}
        };
        response = await NewsPostRepo.addNewsPostSave(
            bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      }
      notifyListeners();
      if (response.statusCode == 200 && context.mounted) {
        await Future.wait([
          updateSelectedNewsPosts(
              context: context,
              newsPostId: postId,
              newsPostSource: newsPostSource),
          mainScreenProvider.updateAndSetUserDetails(
              context: context,
              setLikeSaveCommentFollow: setLikeSaveCommentFollow)
        ]);
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
      } else if (((jsonDecode(response.body))["error"]["message"]).toString() ==
          'Not Found') {
        toggleSaveOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
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

  bool toggleLikeOnProcess = false;

  Future<void> toggleNewsPostLike(
      {required NewsPostSource newsPostSource,
      required String? newsPostLikeId,
      required BuildContext context,
      required String postId,
      required bool setLikeSaveCommentFollow,
      required int postLikeCount}) async {
    if (toggleLikeOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleLikeOnProcess == false) {
      toggleLikeOnProcess = true;
      Response response;

      if (mainScreenProvider.likedPostIdList.contains(int.parse(postId)) &&
          newsPostLikeId != null) {
        mainScreenProvider.likedPostIdList.remove(int.parse(postId));
        postLikeCount--;
        Map bodyDataTwo = {
          "data": {"like_count": postLikeCount.toString()}
        };
        response = await NewsPostRepo.removeNewsPostLike(
            newsPostLikeId: newsPostLikeId,
            jwt: sharedPreferences.getString('jwt')!,
            bodyDataTwo: bodyDataTwo,
            postId: postId);
      } else {
        mainScreenProvider.likedPostIdList.add(int.parse(postId));
        postLikeCount++;
        Map bodyDataOne = {
          "data": {"liked_by": mainScreenProvider.userId, "news_post": postId}
        };
        Map bodyDataTwo = {
          "data": {"like_count": postLikeCount.toString()}
        };
        response = await NewsPostRepo.addNewsPostLike(
            bodyDataOne: bodyDataOne,
            jwt: sharedPreferences.getString('jwt')!,
            bodyDataTwo: bodyDataTwo,
            postId: postId);
      }
      notifyListeners();
      if (response.statusCode == 200 && context.mounted) {
        await Future.wait([
          updateSelectedNewsPosts(
              context: context,
              newsPostId: postId,
              newsPostSource: newsPostSource),
          mainScreenProvider.updateAndSetUserDetails(
              context: context,
              setLikeSaveCommentFollow: setLikeSaveCommentFollow)
        ]);
        toggleLikeOnProcess = false;
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        toggleLikeOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else if (((jsonDecode(response.body))["error"]["message"]).toString() ==
          'Not Found') {
        toggleLikeOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      } else {
        toggleLikeOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
    toggleLikeOnProcess = false;
    notifyListeners();
  }

  // if the comment is posted in further studies news post, then we will require currentCommentCount and comment count from discussCommentCounts in order to provide color to fire icon accordingly.
  Future<void> postNewsComment(
      {required NewsPostSource newsPostSource,
      String? currentCommentCount,
      DiscussCommentCounts? discussCommentCounts,
      required BuildContext context,
      required String newsPostId,
      required TextEditingController newsCommentController,
      required bool setLikeSaveCommentFollow}) async {
    try {
      String body = jsonEncode({
        "data": {
          "comment_by": sharedPreferences.getString('id')!,
          "content": newsCommentController.text,
          "news_post": newsPostId,
        }
      });

      Response commentResponse = await NewsCommentRepo.saveNewsComment(
          bodyData: body, jwt: sharedPreferences.getString('jwt')!);
      if (commentResponse.statusCode == 200 && context.mounted) {
        newsCommentController.clear();
        FocusScope.of(context).unfocus();
        await Future.wait([
          updateSelectedNewsPosts(
              context: context,
              newsPostId: newsPostId,
              newsPostSource: newsPostSource),
          mainScreenProvider.updateAndSetUserDetails(
              context: context,
              setLikeSaveCommentFollow: setLikeSaveCommentFollow)
        ]);

        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).commentPosted,
              backgroundColor: const Color(0xFFA08875),
              contentColor: Colors.white);
        }
        // if the comment is posted in further study discuss, then
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

  // toggle save from profile
  Future<void> toggleNewsPostSaveFromProfile(
      {required bool updateOnlyOneTopic,
      required StreamController<User>? otherUserStreamController,
      required bool isMe,
      required String postedById,
      required NewsPostSource newsPostSource,
      required String? newsPostSaveId,
      required BuildContext context,
      required String postId,
      required bool setLikeSaveCommentFollow}) async {
    if (toggleSaveOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleSaveOnProcess == false) {
      toggleSaveOnProcess = true;
      Response response;
      if (mainScreenProvider.savedNewsPostIdList.contains(int.parse(postId)) &&
          newsPostSaveId != null) {
        mainScreenProvider.savedNewsPostIdList.remove(int.parse(postId));
        response = await NewsPostRepo.removeNewsPostSave(
            newsPostSavedId: newsPostSaveId,
            jwt: sharedPreferences.getString('jwt')!);
      } else {
        mainScreenProvider.savedNewsPostIdList.add(int.parse(postId));
        Map bodyData = {
          "data": {"saved_by": mainScreenProvider.userId, "news_post": postId}
        };
        response = await NewsPostRepo.addNewsPostSave(
            bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      }
      notifyListeners();
      if (response.statusCode == 200) {
        if (!isMe && otherUserStreamController != null && context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getOtherUserProfile(
                  otherUserStreamController: otherUserStreamController,
                  otherUserId: postedById,
                  context: context);
        }
        if (context.mounted) {
          await Future.wait([
            updateOnlyOneTopic == true
                ? getOneProfileTopic(topicId: postId, context: context)
                : getSelectedUserProfileTopics(
                    userId: postedById, context: context),
            updateSelectedNewsPosts(
                context: context,
                newsPostId: postId,
                newsPostSource: newsPostSource),
            mainScreenProvider.updateAndSetUserDetails(
                context: context,
                setLikeSaveCommentFollow: setLikeSaveCommentFollow)
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
      } else if (((jsonDecode(response.body))["error"]["message"]).toString() ==
              'Not Found' &&
          context.mounted) {
        toggleSaveOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
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

  // toggle like from profile
  Future<void> toggleNewsPostLikeFromProfile(
      {required bool updateOnlyOneTopic,
      required StreamController<User>? otherUserStreamController,
      required bool isMe,
      required String postedById,
      required NewsPostSource newsPostSource,
      required String? newsPostLikeId,
      required BuildContext context,
      required String postId,
      required bool setLikeSaveCommentFollow,
      required int postLikeCount}) async {
    if (toggleLikeOnProcess == true) {
      // Please wait
      EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
          dismissOnTap: false, duration: const Duration(seconds: 1));
      return;
    } else if (toggleLikeOnProcess == false) {
      toggleLikeOnProcess = true;
      Response response;

      if (mainScreenProvider.likedPostIdList.contains(int.parse(postId)) &&
          newsPostLikeId != null) {
        mainScreenProvider.likedPostIdList.remove(int.parse(postId));
        postLikeCount--;
        Map bodyDataTwo = {
          "data": {"like_count": postLikeCount.toString()}
        };
        response = await NewsPostRepo.removeNewsPostLike(
            newsPostLikeId: newsPostLikeId,
            jwt: sharedPreferences.getString('jwt')!,
            bodyDataTwo: bodyDataTwo,
            postId: postId);
      } else {
        mainScreenProvider.likedPostIdList.add(int.parse(postId));
        postLikeCount++;
        Map bodyDataOne = {
          "data": {"liked_by": mainScreenProvider.userId, "news_post": postId}
        };
        Map bodyDataTwo = {
          "data": {"like_count": postLikeCount.toString()}
        };
        response = await NewsPostRepo.addNewsPostLike(
            bodyDataOne: bodyDataOne,
            jwt: sharedPreferences.getString('jwt')!,
            bodyDataTwo: bodyDataTwo,
            postId: postId);
      }
      notifyListeners();
      if (response.statusCode == 200) {
        if (!isMe && otherUserStreamController != null && context.mounted) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getOtherUserProfile(
                  otherUserStreamController: otherUserStreamController,
                  otherUserId: postedById,
                  context: context);
        }
        if (context.mounted) {
          await Future.wait([
            updateOnlyOneTopic == true
                ? getOneProfileTopic(topicId: postId, context: context)
                : getSelectedUserProfileTopics(
                    userId: postedById, context: context),
            updateSelectedNewsPosts(
                context: context,
                newsPostId: postId,
                newsPostSource: newsPostSource),
            mainScreenProvider.updateAndSetUserDetails(
                context: context,
                setLikeSaveCommentFollow: setLikeSaveCommentFollow)
          ]);
        }
        toggleLikeOnProcess = false;
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        toggleLikeOnProcess = false;
        notifyListeners();
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
              dismissOnTap: false, duration: const Duration(seconds: 4));
          Provider.of<DrawerProvider>(context, listen: false)
              .removeCredentials(context: context);
          return;
        }
      } else if (((jsonDecode(response.body))["error"]["message"]).toString() ==
              'Not Found' &&
          context.mounted) {
        toggleLikeOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      } else {
        toggleLikeOnProcess = false;
        notifyListeners();
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).tryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
    toggleLikeOnProcess = false;
    notifyListeners();
  }

  // post comment from profile
  Future<void> postNewsCommentFromProfile(
      {required bool updateOnlyOneTopic,
      required StreamController<User>? otherUserStreamController,
      required bool isMe,
      required String postedById,
      required NewsPostSource newsPostSource,
      required BuildContext context,
      required String newsPostId,
      required TextEditingController newsCommentController,
      required bool setLikeSaveCommentFollow}) async {
    try {
      String body = jsonEncode({
        "data": {
          "comment_by": sharedPreferences.getString('id')!,
          "content": newsCommentController.text,
          "news_post": newsPostId,
        }
      });

      Response commentResponse = await NewsCommentRepo.saveNewsComment(
          bodyData: body, jwt: sharedPreferences.getString('jwt')!);
      if (commentResponse.statusCode == 200 && context.mounted) {
        newsCommentController.clear();
        FocusScope.of(context).unfocus();
        if (!isMe && otherUserStreamController != null) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getOtherUserProfile(
                  otherUserStreamController: otherUserStreamController,
                  otherUserId: postedById,
                  context: context);
        }
        await Future.wait([
          updateOnlyOneTopic == true
              ? getOneProfileTopic(topicId: newsPostId, context: context)
              : getSelectedUserProfileTopics(
                  userId: postedById, context: context),
          updateSelectedNewsPosts(
              context: context,
              newsPostId: newsPostId,
              newsPostSource: newsPostSource),
          mainScreenProvider.updateAndSetUserDetails(
              context: context,
              setLikeSaveCommentFollow: setLikeSaveCommentFollow)
        ]);

        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).commentPosted,
              backgroundColor: const Color(0xFFA08875),
              contentColor: Colors.white);
        }
        // if the comment is posted in further study discuss, then
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

  Widget profileTopiclikedAvatars(
      {required List<TopicLike?>? likeCount, required bool isLike}) {
    if (likeCount == null || likeCount.isEmpty) {
      return const SizedBox();
      // If it's liked only by the current user
    } else if (likeCount.length == 1 && isLike == true) {
      return mainScreenProvider.currentUser!.profileImage == null
          ? CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/default_profile.jpg"),
              radius: SizeConfig.defaultSize * 1.5)
          : CircleAvatar(
              backgroundImage: NetworkImage(kIMAGEURL +
                  mainScreenProvider.currentUser!.profileImage!.url!),
              radius: SizeConfig.defaultSize * 1.5);
    } else if (likeCount.length == 1 && isLike == false) {
      return likeCount[likeCount.length - 1]!.likedBy == null ||
              (likeCount[likeCount.length - 1]!.likedBy != null &&
                  likeCount[likeCount.length - 1]!.likedBy!.profileImage ==
                      null)
          ? CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/default_profile.jpg"),
              radius: SizeConfig.defaultSize * 1.5)
          : CircleAvatar(
              backgroundImage: NetworkImage(kIMAGEURL +
                  likeCount[likeCount.length - 1]!.likedBy!.profileImage!.url!),
              radius: SizeConfig.defaultSize * 1.5);
    } else if (likeCount.length == 2) {
      return likeCount[likeCount.length - 1]!.likedBy!.id !=
              int.parse(mainScreenProvider.userId!)
          ? Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 1]!.likedBy == null ||
                        (likeCount[likeCount.length - 1]!.likedBy != null &&
                            likeCount[likeCount.length - 1]!
                                    .likedBy!
                                    .profileImage ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 1]!
                                .likedBy!
                                .profileImage!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                    child: likeCount[likeCount.length - 2]!.likedBy == null ||
                            (likeCount[likeCount.length - 2]!.likedBy != null &&
                                likeCount[likeCount.length - 2]!
                                        .likedBy!
                                        .profileImage ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(isLike == true &&
                                    mainScreenProvider
                                            .currentUser!.profileImage !=
                                        null
                                ? kIMAGEURL +
                                    mainScreenProvider
                                        .currentUser!.profileImage!.url!
                                : kIMAGEURL +
                                    likeCount[likeCount.length - 2]!
                                        .likedBy!
                                        .profileImage!
                                        .url!),
                            radius: SizeConfig.defaultSize * 1.5)),
              ],
            )
          : Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 2]!.likedBy == null ||
                        (likeCount[likeCount.length - 2]!.likedBy != null &&
                            likeCount[likeCount.length - 2]!
                                    .likedBy!
                                    .profileImage ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 2]!
                                .likedBy!
                                .profileImage!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                    child: likeCount[likeCount.length - 1]!.likedBy == null ||
                            (likeCount[likeCount.length - 1]!.likedBy != null &&
                                likeCount[likeCount.length - 1]!
                                        .likedBy!
                                        .profileImage ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(isLike == true &&
                                    mainScreenProvider
                                            .currentUser!.profileImage !=
                                        null
                                ? kIMAGEURL +
                                    mainScreenProvider
                                        .currentUser!.profileImage!.url!
                                : kIMAGEURL +
                                    likeCount[likeCount.length - 1]!
                                        .likedBy!
                                        .profileImage!
                                        .url!),
                            radius: SizeConfig.defaultSize * 1.5)),
              ],
            );
    }
    // If like count is >= 3
    else {
      return likeCount[likeCount.length - 3]!.likedBy!.id ==
              int.parse(mainScreenProvider.userId!)
          ? Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 1]!.likedBy == null ||
                        (likeCount[likeCount.length - 1]!.likedBy != null &&
                            likeCount[likeCount.length - 1]!
                                    .likedBy!
                                    .profileImage ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 1]!
                                .likedBy!
                                .profileImage!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                  child: likeCount[likeCount.length - 2]!.likedBy == null ||
                          (likeCount[likeCount.length - 2]!.likedBy != null &&
                              likeCount[likeCount.length - 2]!
                                      .likedBy!
                                      .profileImage ==
                                  null)
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/default_profile.jpg"),
                          radius: SizeConfig.defaultSize * 1.5)
                      : CircleAvatar(
                          backgroundImage: NetworkImage(kIMAGEURL +
                              likeCount[likeCount.length - 2]!
                                  .likedBy!
                                  .profileImage!
                                  .url!),
                          radius: SizeConfig.defaultSize * 1.5),
                ),
                // Third avatar
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                  child: likeCount[likeCount.length - 3]!.likedBy == null ||
                          (likeCount[likeCount.length - 3]!.likedBy != null &&
                              likeCount[likeCount.length - 3]!
                                      .likedBy!
                                      .profileImage ==
                                  null)
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/default_profile.jpg"),
                          radius: SizeConfig.defaultSize * 1.5)
                      : CircleAvatar(
                          backgroundImage: NetworkImage(isLike == true &&
                                  mainScreenProvider
                                          .currentUser!.profileImage !=
                                      null
                              ? kIMAGEURL +
                                  mainScreenProvider
                                      .currentUser!.profileImage!.url!
                              : kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .likedBy!
                                      .profileImage!
                                      .url!),
                          radius: SizeConfig.defaultSize * 1.5),
                ),
              ],
            )
          : likeCount[likeCount.length - 2]!.likedBy!.id ==
                  int.parse(mainScreenProvider.userId!)
              ? Stack(
                  children: [
                    // First avatar
                    likeCount[likeCount.length - 1]!.likedBy == null ||
                            (likeCount[likeCount.length - 1]!.likedBy != null &&
                                likeCount[likeCount.length - 1]!
                                        .likedBy!
                                        .profileImage ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(kIMAGEURL +
                                likeCount[likeCount.length - 1]!
                                    .likedBy!
                                    .profileImage!
                                    .url!),
                            radius: SizeConfig.defaultSize * 1.5),

                    // Second avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                      child: likeCount[likeCount.length - 3]!.likedBy == null ||
                              (likeCount[likeCount.length - 3]!.likedBy !=
                                      null &&
                                  likeCount[likeCount.length - 3]!
                                          .likedBy!
                                          .profileImage ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .likedBy!
                                      .profileImage!
                                      .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                    // Third avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                      child: likeCount[likeCount.length - 2]!.likedBy == null ||
                              (likeCount[likeCount.length - 2]!.likedBy != null &&
                                  likeCount[likeCount.length - 2]!
                                          .likedBy!
                                          .profileImage ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(isLike == true &&
                                      mainScreenProvider
                                              .currentUser!.profileImage !=
                                          null
                                  ? kIMAGEURL +
                                      mainScreenProvider
                                          .currentUser!.profileImage!.url!
                                  : kIMAGEURL +
                                      likeCount[likeCount.length - 2]!
                                          .likedBy!
                                          .profileImage!
                                          .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    // First avatar
                    likeCount[likeCount.length - 2]!.likedBy == null ||
                            (likeCount[likeCount.length - 2]!.likedBy != null &&
                                likeCount[likeCount.length - 2]!
                                        .likedBy!
                                        .profileImage ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(kIMAGEURL +
                                likeCount[likeCount.length - 2]!
                                    .likedBy!
                                    .profileImage!
                                    .url!),
                            radius: SizeConfig.defaultSize * 1.5),

                    // Second avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                      child: likeCount[likeCount.length - 3]!.likedBy == null ||
                              (likeCount[likeCount.length - 3]!.likedBy !=
                                      null &&
                                  likeCount[likeCount.length - 3]!
                                          .likedBy!
                                          .profileImage ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .likedBy!
                                      .profileImage!
                                      .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                    // Third avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                      child: likeCount[likeCount.length - 1]!.likedBy == null ||
                              (likeCount[likeCount.length - 1]!.likedBy != null &&
                                  likeCount[likeCount.length - 1]!
                                          .likedBy!
                                          .profileImage ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(isLike == true &&
                                      mainScreenProvider
                                              .currentUser!.profileImage !=
                                          null
                                  ? kIMAGEURL +
                                      mainScreenProvider
                                          .currentUser!.profileImage!.url!
                                  : kIMAGEURL +
                                      likeCount[likeCount.length - 1]!
                                          .likedBy!
                                          .profileImage!
                                          .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                  ],
                );
    }
  }

  Widget likedAvatars(
      {required bool isLike, required List<AllNewsPostLikesData?>? likeCount}) {
    if (likeCount == null || likeCount.isEmpty) {
      return const SizedBox();
      // If it's liked only by the current user
    } else if (likeCount.length == 1 && isLike == true) {
      return mainScreenProvider.currentUser!.profileImage == null
          ? CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/default_profile.jpg"),
              radius: SizeConfig.defaultSize * 1.5)
          : CircleAvatar(
              backgroundImage: NetworkImage(kIMAGEURL +
                  mainScreenProvider.currentUser!.profileImage!.url!),
              radius: SizeConfig.defaultSize * 1.5);
    } else if (likeCount.length == 1 && isLike == false) {
      return likeCount[likeCount.length - 1]!.attributes!.likedBy!.data ==
                  null ||
              (likeCount[likeCount.length - 1]!.attributes!.likedBy!.data !=
                      null &&
                  likeCount[likeCount.length - 1]!
                          .attributes!
                          .likedBy!
                          .data!
                          .attributes!
                          .profileImage!
                          .data ==
                      null)
          ? CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/default_profile.jpg"),
              radius: SizeConfig.defaultSize * 1.5)
          : CircleAvatar(
              backgroundImage: NetworkImage(kIMAGEURL +
                  likeCount[likeCount.length - 1]!
                      .attributes!
                      .likedBy!
                      .data!
                      .attributes!
                      .profileImage!
                      .data!
                      .attributes!
                      .url!),
              radius: SizeConfig.defaultSize * 1.5);
    } else if (likeCount.length == 2) {
      return likeCount[likeCount.length - 1]!.attributes!.likedBy!.data!.id !=
              int.parse(mainScreenProvider.userId!)
          ? Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 1]!.attributes!.likedBy!.data ==
                            null ||
                        (likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data !=
                                null &&
                            likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data!
                                    .attributes!
                                    .profileImage!
                                    .data ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 1]!
                                .attributes!
                                .likedBy!
                                .data!
                                .attributes!
                                .profileImage!
                                .data!
                                .attributes!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                    child: likeCount[likeCount.length - 2]!.attributes!.likedBy!.data == null ||
                            (likeCount[likeCount.length - 2]!.attributes!.likedBy!.data != null &&
                                likeCount[likeCount.length - 2]!
                                        .attributes!
                                        .likedBy!
                                        .data!
                                        .attributes!
                                        .profileImage!
                                        .data ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                isLike == true && mainScreenProvider.currentUser!.profileImage != null
                                    ? kIMAGEURL +
                                        mainScreenProvider
                                            .currentUser!.profileImage!.url!
                                    : kIMAGEURL +
                                        likeCount[likeCount.length - 2]!
                                            .attributes!
                                            .likedBy!
                                            .data!
                                            .attributes!
                                            .profileImage!
                                            .data!
                                            .attributes!
                                            .url!),
                            radius: SizeConfig.defaultSize * 1.5)),
              ],
            )
          : Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 2]!.attributes!.likedBy!.data ==
                            null ||
                        (likeCount[likeCount.length - 2]!
                                    .attributes!
                                    .likedBy!
                                    .data !=
                                null &&
                            likeCount[likeCount.length - 2]!
                                    .attributes!
                                    .likedBy!
                                    .data!
                                    .attributes!
                                    .profileImage!
                                    .data ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 2]!
                                .attributes!
                                .likedBy!
                                .data!
                                .attributes!
                                .profileImage!
                                .data!
                                .attributes!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                    padding:
                        EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                    child: likeCount[likeCount.length - 1]!.attributes!.likedBy!.data == null ||
                            (likeCount[likeCount.length - 1]!.attributes!.likedBy!.data != null &&
                                likeCount[likeCount.length - 1]!
                                        .attributes!
                                        .likedBy!
                                        .data!
                                        .attributes!
                                        .profileImage!
                                        .data ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                isLike == true && mainScreenProvider.currentUser!.profileImage != null
                                    ? kIMAGEURL +
                                        mainScreenProvider
                                            .currentUser!.profileImage!.url!
                                    : kIMAGEURL +
                                        likeCount[likeCount.length - 1]!
                                            .attributes!
                                            .likedBy!
                                            .data!
                                            .attributes!
                                            .profileImage!
                                            .data!
                                            .attributes!
                                            .url!),
                            radius: SizeConfig.defaultSize * 1.5)),
              ],
            );
    }
    // If like count is >= 3
    else {
      return likeCount[likeCount.length - 3]!.attributes!.likedBy!.data!.id ==
              int.parse(mainScreenProvider.userId!)
          ? Stack(
              children: [
                // First avatar
                likeCount[likeCount.length - 1]!.attributes!.likedBy!.data ==
                            null ||
                        (likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data !=
                                null &&
                            likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data!
                                    .attributes!
                                    .profileImage!
                                    .data ==
                                null)
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(kIMAGEURL +
                            likeCount[likeCount.length - 1]!
                                .attributes!
                                .likedBy!
                                .data!
                                .attributes!
                                .profileImage!
                                .data!
                                .attributes!
                                .url!),
                        radius: SizeConfig.defaultSize * 1.5),

                // Second avatar
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                  child: likeCount[likeCount.length - 2]!
                                  .attributes!
                                  .likedBy!
                                  .data ==
                              null ||
                          (likeCount[likeCount.length - 2]!
                                      .attributes!
                                      .likedBy!
                                      .data !=
                                  null &&
                              likeCount[likeCount.length - 2]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes!
                                      .profileImage!
                                      .data ==
                                  null)
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/default_profile.jpg"),
                          radius: SizeConfig.defaultSize * 1.5)
                      : CircleAvatar(
                          backgroundImage: NetworkImage(kIMAGEURL +
                              likeCount[likeCount.length - 2]!
                                  .attributes!
                                  .likedBy!
                                  .data!
                                  .attributes!
                                  .profileImage!
                                  .data!
                                  .attributes!
                                  .url!),
                          radius: SizeConfig.defaultSize * 1.5),
                ),
                // Third avatar
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                  child: likeCount[likeCount.length - 3]!.attributes!.likedBy!.data == null ||
                          (likeCount[likeCount.length - 3]!.attributes!.likedBy!.data !=
                                  null &&
                              likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes!
                                      .profileImage!
                                      .data ==
                                  null)
                      ? CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/default_profile.jpg"),
                          radius: SizeConfig.defaultSize * 1.5)
                      : CircleAvatar(
                          backgroundImage: NetworkImage(isLike == true &&
                                  mainScreenProvider.currentUser!.profileImage !=
                                      null
                              ? kIMAGEURL +
                                  mainScreenProvider
                                      .currentUser!.profileImage!.url!
                              : kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes!
                                      .profileImage!
                                      .data!
                                      .attributes!
                                      .url!),
                          radius: SizeConfig.defaultSize * 1.5),
                ),
              ],
            )
          : likeCount[likeCount.length - 2]!.attributes!.likedBy!.data!.id ==
                  int.parse(mainScreenProvider.userId!)
              ? Stack(
                  children: [
                    // First avatar
                    likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data ==
                                null ||
                            (likeCount[
                                            likeCount.length - 1]!
                                        .attributes!
                                        .likedBy!
                                        .data !=
                                    null &&
                                likeCount[
                                            likeCount.length - 1]!
                                        .attributes!
                                        .likedBy!
                                        .data!
                                        .attributes!
                                        .profileImage!
                                        .data ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(kIMAGEURL +
                                likeCount[likeCount.length - 1]!
                                    .attributes!
                                    .likedBy!
                                    .data!
                                    .attributes!
                                    .profileImage!
                                    .data!
                                    .attributes!
                                    .url!),
                            radius: SizeConfig.defaultSize * 1.5),

                    // Second avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                      child: likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data ==
                                  null ||
                              (likeCount[likeCount.length - 3]!
                                          .attributes!
                                          .likedBy!
                                          .data !=
                                      null &&
                                  likeCount[likeCount.length - 3]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes!
                                      .profileImage!
                                      .data!
                                      .attributes!
                                      .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                    // Third avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                      child: likeCount[likeCount.length - 2]!.attributes!.likedBy!.data == null ||
                              (likeCount[likeCount.length - 2]!.attributes!.likedBy!.data != null &&
                                  likeCount[likeCount.length - 2]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(isLike == true &&
                                      mainScreenProvider.currentUser!.profileImage !=
                                          null
                                  ? kIMAGEURL +
                                      mainScreenProvider
                                          .currentUser!.profileImage!.url!
                                  : kIMAGEURL +
                                      likeCount[likeCount.length - 2]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data!
                                          .attributes!
                                          .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    // First avatar
                    likeCount[likeCount.length - 2]!
                                    .attributes!
                                    .likedBy!
                                    .data ==
                                null ||
                            (likeCount[
                                            likeCount.length - 2]!
                                        .attributes!
                                        .likedBy!
                                        .data !=
                                    null &&
                                likeCount[
                                            likeCount.length - 2]!
                                        .attributes!
                                        .likedBy!
                                        .data!
                                        .attributes!
                                        .profileImage!
                                        .data ==
                                    null)
                        ? CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/images/default_profile.jpg"),
                            radius: SizeConfig.defaultSize * 1.5)
                        : CircleAvatar(
                            backgroundImage: NetworkImage(kIMAGEURL +
                                likeCount[likeCount.length - 2]!
                                    .attributes!
                                    .likedBy!
                                    .data!
                                    .attributes!
                                    .profileImage!
                                    .data!
                                    .attributes!
                                    .url!),
                            radius: SizeConfig.defaultSize * 1.5),

                    // Second avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                      child: likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data ==
                                  null ||
                              (likeCount[likeCount.length - 3]!
                                          .attributes!
                                          .likedBy!
                                          .data !=
                                      null &&
                                  likeCount[likeCount.length - 3]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(kIMAGEURL +
                                  likeCount[likeCount.length - 3]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes!
                                      .profileImage!
                                      .data!
                                      .attributes!
                                      .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                    // Third avatar
                    Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
                      child: likeCount[likeCount.length - 1]!.attributes!.likedBy!.data == null ||
                              (likeCount[likeCount.length - 1]!.attributes!.likedBy!.data != null &&
                                  likeCount[likeCount.length - 1]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data ==
                                      null)
                          ? CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "assets/images/default_profile.jpg"),
                              radius: SizeConfig.defaultSize * 1.5)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(isLike == true &&
                                      mainScreenProvider.currentUser!.profileImage !=
                                          null
                                  ? kIMAGEURL +
                                      mainScreenProvider
                                          .currentUser!.profileImage!.url!
                                  : kIMAGEURL +
                                      likeCount[likeCount.length - 1]!
                                          .attributes!
                                          .likedBy!
                                          .data!
                                          .attributes!
                                          .profileImage!
                                          .data!
                                          .attributes!
                                          .url!),
                              radius: SizeConfig.defaultSize * 1.5),
                    ),
                  ],
                );
    }
  }

  // New post
  goBack({required BuildContext context}) {
    if (imageFileList != null || imageFileList!.isNotEmpty) {
      imageFileList!.clear();
    }

    if (postContentController.text != '') {
      postContentController.text = '';
    }
    if (postTitleController.text != '') {
      postTitleController.text = '';
    }
    notifyListeners();
    Navigator.pop(context);
  }

  // New news post validation
  String? validatePostTitle(
      {required String value, required BuildContext context}) {
    if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterTitle;
    } else {
      return null;
    }
  }

  String? validatePostContent(
      {required String value, required BuildContext context}) {
    if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterContent;
    } else {
      return null;
    }
  }

  bool isPostClick = false;

  void toggleIspostClick() {
    if (isPostClick == true) {
      isPostClick = false;
    } else {
      isPostClick = true;
    }
    notifyListeners();
  }

  // Multiple picture selection
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectMultiImages() async {
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    notifyListeners();
  }

  void removeSelectedImage({required int index}) {
    imageFileList!.removeAt(index);
    notifyListeners();
  }

  Future<void> createNewPost({required BuildContext context}) async {
    toggleIspostClick();
    Map bodyData = {
      'title': postTitleController.text,
      'posted_by': sharedPreferences.getString('id'),
      'content': postContentController.text
    };
    if (imageFileList == null || imageFileList!.isEmpty) {
      Response createResponse = await NewPostRepo.createNewPost(
          bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);
      if (createResponse.statusCode == 200) {
        String createdPostId =
            jsonDecode(createResponse.body)["data"]["id"].toString();
        Response getResponse = await NewsPostRepo.getOneUpdateNewsPost(
            jwt: sharedPreferences.getString('jwt') ?? 'null',
            newsPostId: createdPostId);
        if (getResponse.statusCode == 200) {
          final oneNewsPost = singleNewsPostFromJson(getResponse.body).data;
          if (oneNewsPost != null &&
              _allNewsPost != null &&
              !allNewsPostController.isClosed) {
            _allNewsPost!.data!.insert(0, oneNewsPost);
            // to prevent same data from displaying twice
            if (hasMore == true && _allNewsPost!.data!.length >= 16) {
              _allNewsPost!.data!.removeLast();
            }
            allNewsPostController.sink.add(_allNewsPost!);
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
        // Since we have successfully added a new news post, we also want to add the length of total news posts list
        if (context.mounted) {
          mainScreenProvider.updateAndSetUserDetails(
              context: context, setLikeSaveCommentFollow: false);
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).createdSuccessfully,
              backgroundColor: const Color(0xFFA08875),
              contentColor: Colors.white);
          goBack(context: context);
        }
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
        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).tryAgainLater,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        }
      }
    }
    // If there are images
    else {
      for (int i = 0; i < imageFileList!.length; i++) {}
      final streamedResponse = await NewPostRepo.createNewPostWithImage(
          bodyData: bodyData,
          imageList: imageFileList!,
          jwt: sharedPreferences.getString('jwt')!);
      Response createResponse = await Response.fromStream(streamedResponse);
      if (createResponse.statusCode == 200) {
        String createdPostId =
            jsonDecode(createResponse.body)["data"]["id"].toString();
        Response getResponse = await NewsPostRepo.getOneUpdateNewsPost(
            jwt: sharedPreferences.getString('jwt') ?? 'null',
            newsPostId: createdPostId);
        if (getResponse.statusCode == 200) {
          final oneNewsPost = singleNewsPostFromJson(getResponse.body).data;
          if (oneNewsPost != null &&
              _allNewsPost != null &&
              !allNewsPostController.isClosed) {
            _allNewsPost!.data!.insert(0, oneNewsPost);
            // to prevent same data from displaying twice
            if (hasMore == true && _allNewsPost!.data!.length >= 16) {
              _allNewsPost!.data!.removeLast();
            }
            allNewsPostController.sink.add(_allNewsPost!);
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
        if (context.mounted) {
          mainScreenProvider.updateAndSetUserDetails(
              context: context, setLikeSaveCommentFollow: false);
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).createdSuccessfully,
              backgroundColor: const Color(0xFFA08875),
              contentColor: Colors.white);
          goBack(context: context);
        }
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
        if (context.mounted) {
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).tryAgainLater,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        }
      }
    }
    toggleIspostClick();
  }

  bool isNewsDescriptionReverse = false;

  // this method will be called to reverse the singlechildscrollview to see all comments
  void changeNewsReverse({bool fromInitial = false, required bool isReverse}) {
    if (isNewsDescriptionReverse == isReverse) {
      return;
    } else {
      isNewsDescriptionReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  // to reverse single child scrollview in further studies description
  bool isFurtherStudyReverse = false;

  // this method will be called to reverse the singlechildscrollview to see all comments
  void changeFurtherStudyReverse(
      {bool fromInitial = false, required bool isReverse}) {
    if (isFurtherStudyReverse == isReverse) {
      return;
    } else {
      isFurtherStudyReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  // to reverse single child scrollview in profile topic description
  bool isProfileTopicReverse = false;

  // this method will be called to reverse the singlechildscrollview to see all comments
  void changeProfileTopicReverse(
      {bool fromInitial = false, required bool isReverse}) {
    if (isProfileTopicReverse == isReverse) {
      return;
    } else {
      isProfileTopicReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  // to reverse single child scrollview in last and bookmark topic description
  bool isLastBookmarkTopicReverse = false;

  // this method will be called to reverse the singlechildscrollview to see all comments
  void changeLastBookmarkTopicReverse(
      {bool fromInitial = false, required bool isReverse}) {
    if (isLastBookmarkTopicReverse == isReverse) {
      return;
    } else {
      isLastBookmarkTopicReverse = isReverse;
      // if called from initstate, we cannot call notifyListeners()
      if (fromInitial == true) {
        return;
      } else {
        notifyListeners();
      }
    }
  }

  void postUserOnPress({
    required int userId,
    required BuildContext context,
  }) {
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

  // Profile topic comment by
  void profileUserOnPress(
      {required int commentById, required BuildContext context}) {
    if (commentById != int.parse(mainScreenProvider.userId!)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUserProfileScreen(
                    otherUserId: commentById,
                  )));
    } else {
      Navigator.pushNamed(context, MyProfileScreen.id);
    }
  }

  // news post report list
  List<String> getNewsPostReportList({required BuildContext context}) {
    return [AppLocalizations.of(context).report];
  }

  String? reportNewsPostReasonType;
  String? reportNewsPostOtherReason;

  void setNewsPostReportReasonType(
      {required BuildContext context, required String newsPostReportReason}) {
    if (mainScreenProvider
        .getReportOptionList(context: context)
        .values
        .toList()
        .contains(newsPostReportReason)) {
      reportNewsPostReasonType = newsPostReportReason;
      if (reportNewsPostReasonType.toString() !=
          AppLocalizations.of(context).other) {
        reportNewsPostOtherReason = null;
      }
      notifyListeners();
    }
  }

  void setNewsPostReportOtherReason(
      {required String newsPostReportOtherReason}) {
    reportNewsPostOtherReason = newsPostReportOtherReason;
  }

  void resetNewsPostReportOption() {
    reportNewsPostReasonType = null;
    reportNewsPostOtherReason = null;
    notifyListeners();
  }

  int totalInitialNewsList = 15;
  Future<void> reportNewsPost(
      {required TextEditingController newsCommentTextEditingController,
      required bool isFromDescriptionScreen,
      isOtherUserProfile,
      StreamController<User>? otherUserStreamController,
      required BuildContext context,
      required String newsPostId,
      required String reason}) async {
    if (!mainScreenProvider.reportedNewsPostidList
        .contains(int.parse(newsPostId))) {
      mainScreenProvider.reportedNewsPostidList.add(int.parse(newsPostId));
      notifyListeners();
      Map bodyData = {
        "data": {
          'reported_by': sharedPreferences.getString('id').toString(),
          'news_post': newsPostId,
          'reason': reason
        }
      };
      Response reportResponse = await ReportAndBlockRepo.reportNewsPost(
          bodyData: bodyData, jwt: sharedPreferences.getString('jwt')!);

      if (reportResponse.statusCode == 200 && context.mounted) {
        newsCommentControllerList.remove(newsCommentTextEditingController);
        removePostAfterReport(
            context: context,
            isOtherUserProfile: isOtherUserProfile,
            otherUserStreamController: otherUserStreamController,
            newsPostId: newsPostId);
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
      removePostAfterReport(
          context: context,
          isOtherUserProfile: isOtherUserProfile,
          otherUserStreamController: otherUserStreamController,
          newsPostId: newsPostId);
    }
  }

  void removePostAfterReport(
      {required bool isOtherUserProfile,
      required StreamController? otherUserStreamController,
      required BuildContext context,
      required String newsPostId}) {
    if (isOtherUserProfile == true &&
        otherUserStreamController != null &&
        !otherUserStreamController.isClosed) {
      Provider.of<ProfileProvider>(context, listen: false)
          .removeReportOtherUserProfile(
              context: context,
              newsPostId: newsPostId,
              otherUserStreamController: otherUserStreamController);
    }
    // DO NOT DISPLAY REPORT NEWS POST IN NEWS POSTS LIST
    if (_allNewsPost != null &&
        _allNewsPost!.data != null &&
        !allNewsPostController.isClosed) {
      NewsPost? newsPost = _allNewsPost!.data!
          .firstWhereOrNull((element) => element.id.toString() == newsPostId);
      if (newsPost != null) {
        _allNewsPost!.data!
            .removeWhere((element) => element.id.toString() == newsPostId);
        if (_allNewsPost!.data!.length <= 15 && hasMore == true) {
          totalInitialNewsList--;
          notifyListeners();
        }
      }

      allNewsPostController.sink.add(_allNewsPost!);
    }

    // DO NOT DISPLAY REPORT NEWS POST IN PROFILE TAB
    mainScreenProvider.removeNewReportNews(
        newsPostId: newsPostId, context: context);
    // DO NOT DISPLAY REPORT NEWS POST IN PROFILE TOPIC
    if (_myProfileTopics != null &&
        !mainScreenProvider.allProfileTopicController.isClosed) {
      _myProfileTopics!.createdPost!.removeWhere(
          (element) => element != null && element.id.toString() == newsPostId);
      mainScreenProvider.allProfileTopicController.sink.add(_myProfileTopics!);
    }
    // DO NOT DISPLAY REPORT NEWS POST IN MY TOPIC AND BOOKMARK TOPIC
    if (_singleNewsPostFromMyTopicAndBookmark != null &&
        !mainScreenProvider.profileNewsTopicStreamController.isClosed) {
      if (_singleNewsPostFromMyTopicAndBookmark!.id.toString() == newsPostId) {
        _singleNewsPostFromMyTopicAndBookmark = null;
        mainScreenProvider.profileNewsTopicStreamController.sink
            .add(_singleNewsPostFromMyTopicAndBookmark);
      }
    }
    Navigator.of(context).pop();
    resetNewsPostReportOption();
    showSnackBar(
        context: context,
        content: AppLocalizations.of(context).reportedSuccessfully,
        contentColor: Colors.white,
        backgroundColor: kPrimaryColor);
  }

  void removePostAfterUserBlock(
      {required bool isOtherUserProfile,
      required StreamController? otherUserStreamController,
      required BuildContext context,
      required String otherUserId}) {
    if (isOtherUserProfile == true &&
        otherUserStreamController != null &&
        !otherUserStreamController.isClosed) {
      Provider.of<ProfileProvider>(context, listen: false)
          .removeBlockOtherUserProfile(
              context: context,
              otherUserId: otherUserId,
              otherUserStreamController: otherUserStreamController);
    }
    // DO NOT DISPLAY REPORT NEWS POST IN NEWS POSTS LIST
    if (_allNewsPost != null &&
        _allNewsPost!.data != null &&
        !allNewsPostController.isClosed) {
      NewsPost? newsPost = _allNewsPost!.data!.firstWhereOrNull((element) =>
          element.attributes != null &&
          element.attributes!.postedBy != null &&
          element.attributes!.postedBy!.data != null &&
          element.attributes!.postedBy!.data!.id.toString() == otherUserId);
      if (newsPost != null) {
        _allNewsPost!.data!.removeWhere((element) =>
            element.attributes != null &&
            element.attributes!.postedBy != null &&
            element.attributes!.postedBy!.data != null &&
            element.attributes!.postedBy!.data!.id.toString() == otherUserId);
        if (_allNewsPost!.data!.length <= 15 && hasMore == true) {
          int itemsRemoved = 15 - _allNewsPost!.data!.length;
          totalInitialNewsList = totalInitialNewsList - itemsRemoved;
          notifyListeners();
        }
      }

      allNewsPostController.sink.add(_allNewsPost!);
    }

    // DO NOT DISPLAY REPORT NEWS POST IN PROFILE TAB
    mainScreenProvider.removeBlockedUsersNews(
        otherUserId: otherUserId, context: context);
    // DO NOT DISPLAY REPORT NEWS POST IN PROFILE TOPIC
    if (_myProfileTopics != null &&
        !mainScreenProvider.allProfileTopicController.isClosed) {
      _myProfileTopics!.createdPost!.removeWhere((element) =>
          element != null &&
          element.postedBy != null &&
          element.postedBy!.id.toString() == otherUserId);
      mainScreenProvider.allProfileTopicController.sink.add(_myProfileTopics!);
    }

    Navigator.of(context).pop();
    showSnackBar(
        context: context,
        content: AppLocalizations.of(context).accountBlockedSuccessfully,
        contentColor: Colors.white,
        backgroundColor: kPrimaryColor);
  }

  Future<void> goBackAfterReporting(
      {required bool isFromDescriptionScreen,
      required BuildContext context}) async {
    if (isFromDescriptionScreen == true) {
      Navigator.of(context).pop();
    }
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

  bool followNotificationBadge = false;

  Future<void> setFollowNotification() async {
    sharedPreferences = await SharedPreferences.getInstance();
    followNotificationBadge = true;
    sharedPreferences.setBool("follow_push_notification", true);
    notifyListeners();
  }

  @override
  void dispose() {
    postContentController.dispose();
    postTitleController.dispose();
    allNewsPostController.close();
    newsPostLikesStreamController.close();
    super.dispose();
  }
}
