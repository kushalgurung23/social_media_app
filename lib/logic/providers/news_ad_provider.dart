import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/data/models/comment_load.dart';
import 'package:c_talent/data/models/created_news_post.dart';
import 'package:c_talent/data/models/news_post_likes.dart';
import 'package:c_talent/data/models/single_news_comments.dart';
import 'package:c_talent/data/models/user.dart';
import 'package:c_talent/data/repositories/news_post/news_comment_repo.dart';
import 'package:c_talent/data/repositories/news_post/news_likes_repo.dart';
import 'package:c_talent/data/repositories/news_post/news_post_repo.dart';
import 'package:c_talent/data/repositories/news_post/news_save_repo.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/logic/providers/permission_provider.dart';
import 'package:c_talent/logic/providers/profile_news_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'created_post_provider.dart';

class NewsAdProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;
  late PermissionProvider permissionProvider;
  late AuthProvider authProvider;

  NewsAdProvider(
      {required this.mainScreenProvider,
      required this.permissionProvider,
      required this.authProvider});

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
      {required String userType, required BuildContext context}) {
    if (userType == 'Student') {
      return AppLocalizations.of(context).member;
    } else if (userType == 'Therapist') {
      return AppLocalizations.of(context).therapist;
    } else {
      return 'User';
    }
  }

  // Load news post
  AllNewsPosts? _allNewsPosts;
  AllNewsPosts? get allNewsPosts => _allNewsPosts;

  // page and pageSize is used for pagination
  int newsPostPageNumber = 1;
  int newsPostPageSize = 10;
  // hasMore will be true until we have more data to fetch in the API
  bool newsPostHasMore = true;
  // It will be true once we try to fetch more news post data.
  bool newsPostIsLoading = false;

  // This method will be called to gets news posts, when user is logged in
  Future<void> loadInitialNewsPosts(
      {required BuildContext context,
      required StreamController<AllNewsPosts> allNewsPostController}) async {
    try {
      Response response = await NewsPostRepo.getAllNewsPosts(
          accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
          page: newsPostPageNumber.toString(),
          pageSize: newsPostPageSize.toString());
      if (response.statusCode == 200) {
        _allNewsPosts = allNewsPostsFromJson(response.body);
        if (_allNewsPosts != null) {
          allNewsPostController.sink.add(_allNewsPosts!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialNewsPosts(
                context: context, allNewsPostController: allNewsPostController);
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

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future loadMoreNewsPosts(
      {required BuildContext context,
      required StreamController<AllNewsPosts> allNewsPostController}) async {
    newsPostPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data we will get exit from this method.
    if (newsPostIsLoading || newsPostHasMore == false) {
      return;
    }
    newsPostIsLoading = true;
    Response response = await NewsPostRepo.getAllNewsPosts(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: newsPostPageNumber.toString(),
        pageSize: newsPostPageSize.toString());
    if (response.statusCode == 200) {
      final newNewsPosts = allNewsPostsFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      newsPostIsLoading = false;

      if (newNewsPosts.posts == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsPosts.posts!.length < newsPostPageSize) {
        newsPostHasMore = false;
      }
      _allNewsPosts!.posts = [..._allNewsPosts!.posts!, ...newNewsPosts.posts!];
      allNewsPostController.sink.add(_allNewsPosts!);
      notifyListeners();
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreNewsPosts(
              context: context, allNewsPostController: allNewsPostController);
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

  // NEWS COMMENTS
  // bool isLoadingComments = false;
  // int commentsPageNumber = 1;
  // int commentsPageSize = 10;
  // bool hasMoreComments = true;

  // Future<void> loadInitialNewsComments(
  //     {required StreamController<List<NewsComment>?>
  //         allNewsCommentStreamController,
  //     required NewsPost newsPost,
  //     required BuildContext context}) async {
  //   Response response = await NewsCommentRepo.getAllNewsComments(
  //       accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
  //       page: commentsPageNumber.toString(),
  //       pageSize: commentsPageSize.toString(),
  //       newsPostId: newsPost.id.toString());

  //   if (response.statusCode == 200) {
  //     final singleNewsComments = singleNewsCommentsFromJson(response.body);
  //     if (singleNewsComments != null) {
  //       // FOR NEWS POST LIST
  //       newsPost.comments = singleNewsComments.comments;

  //       // FOR NEWS POST DESCRIPTION SCREEN
  //       allNewsCommentStreamController.sink.add(newsPost.comments);
  //       notifyListeners();
  //     }
  //   } else if (response.statusCode == 401 || response.statusCode == 403) {
  //     if (context.mounted) {
  //       bool isTokenRefreshed =
  //           await Provider.of<AuthProvider>(context, listen: false)
  //               .refreshAccessToken(context: context);

  //       // If token is refreshed, re-call the method
  //       if (isTokenRefreshed == true && context.mounted) {
  //         return loadInitialNewsComments(
  //             allNewsCommentStreamController: allNewsCommentStreamController,
  //             newsPost: newsPost,
  //             context: context);
  //       } else {
  //         await Provider.of<DrawerProvider>(context, listen: false)
  //             .logOut(context: context);
  //         return;
  //       }
  //     }
  //   } else {
  //     // translate
  //     EasyLoading.showInfo(
  //         "Sorry, comments could not load. Please try again later.",
  //         dismissOnTap: true,
  //         duration: const Duration(seconds: 4));
  //   }
  // }

  // // Loading more news posts when user reach maximum pageSize item of a page in listview
  // Future<void> loadMoreNewsComments(
  //     {required BuildContext context,
  //     required StreamController<List<NewsComment>?>
  //         allNewsCommentStreamController,
  //     required NewsPost newsPost}) async {
  //   commentsPageNumber++;
  //   // If we have already made request to fetch more data, and new data hasn't been fetched yet,
  //   // or we don't have more data, we will get exit from this method.
  //   if (isLoadingComments || hasMoreComments == false) {
  //     return;
  //   }
  //   isLoadingComments = true;

  //   Response response = await NewsCommentRepo.getAllNewsComments(
  //       accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
  //       page: commentsPageNumber.toString(),
  //       pageSize: commentsPageSize.toString(),
  //       newsPostId: newsPost.id.toString());
  //   if (response.statusCode == 200) {
  //     final newComments = singleNewsCommentsFromJson(response.body);

  //     // isLoading = false indicates that the loading is complete
  //     isLoadingComments = false;

  //     if (newComments?.comments == null) return;
  //     // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
  //     if (newComments!.comments!.length < commentsPageSize) {
  //       hasMoreComments = false;
  //     }
  //     // ADDING NEWS COMMENTS IN TOTAL NEWS COMMENTS
  //     if (newsPost.comments != null) {
  //       // ADDING NEW COMMENTS FOR NEWS POST LIST
  //       for (int i = 0; i < newComments.comments!.length; i++) {
  //         newsPost.comments!.add(newComments.comments![i]);
  //       }
  //       // ADD NEW COMMENTS FOR NEWS POST DESCRIPTION SCREEN
  //       allNewsCommentStreamController.sink.add(newsPost.comments);
  //     }
  //     notifyListeners();
  //   } else if (response.statusCode == 401 || response.statusCode == 403) {
  //     if (context.mounted) {
  //       bool isTokenRefreshed =
  //           await Provider.of<AuthProvider>(context, listen: false)
  //               .refreshAccessToken(context: context);

  //       // If token is refreshed, re-call the method
  //       if (isTokenRefreshed == true && context.mounted) {
  //         return loadMoreNewsComments(
  //             context: context,
  //             allNewsCommentStreamController: allNewsCommentStreamController,
  //             newsPost: newsPost);
  //       } else {
  //         await Provider.of<DrawerProvider>(context, listen: false)
  //             .logOut(context: context);
  //         return;
  //       }
  //     }
  //   } else {
  //     // translate
  //     EasyLoading.showInfo(
  //         "Sorry, comments could not load. Please try again later.",
  //         dismissOnTap: true,
  //         duration: const Duration(seconds: 4));
  //   }
  // }

  // CLEAR LOADED COMMENTS IN BOTH NEWS POSTS AND CREATED POSTS DESCRIPTION SCREEN

  Future refreshNewsPosts(
      {required BuildContext context,
      required StreamController<AllNewsPosts> allNewsPostController}) async {
    newsPostIsLoading = false;
    newsPostHasMore = true;
    newsPostPageNumber = 1;
    if (_allNewsPosts != null) {
      _allNewsPosts!.posts!.clear();
    }
    notifyListeners();
    await loadInitialNewsPosts(
        context: context, allNewsPostController: allNewsPostController);
  }

  // NEWS POST LIKES
  bool isLoadingLikes = false;
  int likesPageNumber = 1;
  int likesPageSize = 10;
  bool hasMoreLikes = true;

  NewsPostLikes? _singleNewsLikes;
  NewsPostLikes? get singleNewsLikes => _singleNewsLikes;

  Future<void> loadInitialNewsLikes(
      {required StreamController<NewsPostLikes?> allNewsLikeStreamController,
      required int newsPostId,
      required BuildContext context}) async {
    Response response = await NewsLikesRepo.getAllNewsLikes(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: likesPageNumber.toString(),
        pageSize: likesPageSize.toString(),
        newsPostId: newsPostId.toString());

    if (response.statusCode == 200) {
      _singleNewsLikes = newsPostLikesFromJson(response.body);
      if (_singleNewsLikes != null) {
        allNewsLikeStreamController.sink.add(_singleNewsLikes);
        notifyListeners();
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadInitialNewsLikes(
              allNewsLikeStreamController: allNewsLikeStreamController,
              newsPostId: newsPostId,
              context: context);
        } else {
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
      }
    } else {
      // translate
      EasyLoading.showInfo(
          "Sorry, news likes could not load. Please try again later.",
          dismissOnTap: true,
          duration: const Duration(seconds: 4));
    }
  }

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future<void> loadMoreNewsLikes(
      {required BuildContext context,
      required StreamController<NewsPostLikes?> allNewsLikesStreamController,
      required int newsPostId}) async {
    likesPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet, or we don't have more data,
    // we will get exit from this method.
    if (isLoadingLikes || hasMoreLikes == false) {
      return;
    }
    isLoadingLikes = true;

    Response response = await NewsLikesRepo.getAllNewsLikes(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: likesPageNumber.toString(),
        pageSize: likesPageSize.toString(),
        newsPostId: newsPostId.toString());
    if (response.statusCode == 200) {
      final newLikes = newsPostLikesFromJson(response.body);

      // isLoadingLikes = false indicates that the loading is complete
      isLoadingLikes = false;

      if (newLikes.likes == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newLikes.likes!.length < likesPageSize) {
        hasMoreLikes = false;
      }
      // ADDING NEWS LIKES IN TOTAL NEWS LIKES
      if (_singleNewsLikes != null && _singleNewsLikes?.likes != null) {
        for (int i = 0; i < newLikes.likes!.length; i++) {
          _singleNewsLikes!.likes!.add(newLikes.likes![i]);
        }
        allNewsLikesStreamController.sink.add(_singleNewsLikes);
      }
      notifyListeners();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreNewsLikes(
              context: context,
              allNewsLikesStreamController: allNewsLikesStreamController,
              newsPostId: newsPostId);
        } else {
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
      }
    } else {
      // translate
      EasyLoading.showInfo(
          "Sorry, more news likes could not load. Please try again later.",
          dismissOnTap: true,
          duration: const Duration(seconds: 4));
    }
  }

  void clearNewsLikesDetails() {
    likesPageNumber = 1;
    likesPageSize = 10;
    hasMoreLikes = true;
    isLoadingLikes = false;
    notifyListeners();
  }

  void goBackFromNewsLikesScreen({required BuildContext context}) {
    clearNewsLikesDetails();
    Navigator.of(context).pop();
  }

  bool toggleSaveOnProcess = false;

  Future<void> toggleNewsPostSave(
      {required NewsPost newsPost, required BuildContext context}) async {
    int? currentSaveStatus = newsPost.isSaved;

    // THIS METHOD IS CALLED WHEN TOGGLE SAVE FAILS TO KEEP ORIGINAL DATA
    void onToggleSaveFailed() {
      // if error occurs, keep current save status
      newsPost.isSaved = currentSaveStatus;
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
          newsPost.isSaved = 0;
        } else {
          newsPost.isSaved = 1;
        }
        notifyListeners();
        Response response = await NewsSaveRepo.toggleNewsPostSave(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData:
                jsonEncode({"post_id": int.parse(newsPost.id.toString())}));

        if (response.statusCode == 200 && context.mounted) {
          onSuccessToggleSave(context: context, newsPost: newsPost);
          toggleSaveOnProcess = false;
          notifyListeners();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          onToggleSaveFailed();

          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return toggleNewsPostSave(newsPost: newsPost, context: context);
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
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: false, duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      onToggleSaveFailed();
      EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
          dismissOnTap: false, duration: const Duration(seconds: 4));
    }
  }

  // UPDATE STATE IN OTHER SCREENS AS WELL
  void onSuccessToggleSave(
      {required BuildContext context, required NewsPost newsPost}) {
    // NOT REQUIRED TO UPDATE IN MY TOPIC
    // BOOKMARKED TOPIC
    Provider.of<ProfileNewsProvider>(context, listen: false)
        .onToggleSaveFromDifferentScreen(context: context);

    // CREATED POST (NOT MY TOPIC)
    Provider.of<CreatedPostProvider>(context, listen: false)
        .onSaveFromDifferentScreen(
            isSaved: newsPost.isSaved, newsPostId: newsPost.id);
  }

  bool toggleLikeOnProcess = false;

  Future<void> toggleNewsPostLike(
      {required NewsPost newsPost, required BuildContext context}) async {
    int? previousLikeStatus = newsPost.isLiked;
    List<Like> previousLikes =
        newsPost.likes == null ? [] : [...newsPost.likes!];
    int? previousLikesCount = newsPost.likesCount;
    // THIS METHOD IS CALLED WHEN TOGGLE LIKE FAILS TO KEEP ORIGINAL DATA
    void onToggleLikeFailed() {
      // if error occurs, keep current like status
      newsPost.isLiked = previousLikeStatus;
      newsPost.likes = previousLikes;
      newsPost.likesCount = previousLikesCount;
      toggleLikeOnProcess = false;
      notifyListeners();
    }

    try {
      if (toggleLikeOnProcess == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        toggleLikeOnProcess = true;
        updateLikeState(
            previousLikeStatus: previousLikeStatus,
            loggedInUser: mainScreenProvider.loginSuccess.user,
            newsPost: newsPost);
        notifyListeners();
        Response response = await NewsLikesRepo.toggleNewsPostLike(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData:
                jsonEncode({"post_id": int.parse(newsPost.id.toString())}));
        // SUCCESSFUL
        if (response.statusCode == 200 && context.mounted) {
          onSuccessToggleLike(newsPost: newsPost, context: context);
          toggleLikeOnProcess = false;
          notifyListeners();
        }

        // ACCESS TOKEN EXPIRED
        else if (response.statusCode == 401 || response.statusCode == 403) {
          onToggleLikeFailed();

          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // if token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return toggleNewsPostLike(newsPost: newsPost, context: context);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
            return;
          }
        } else if ((jsonDecode(response.body))["status"] == 'Error') {
          onToggleLikeFailed();
          if (context.mounted) {
            EasyLoading.showInfo((jsonDecode(response.body))["msg"],
                dismissOnTap: false, duration: const Duration(seconds: 4));
          }
        } else {
          onToggleLikeFailed();
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: false, duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      onToggleLikeFailed();
      EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
          dismissOnTap: false, duration: const Duration(seconds: 4));
    }
  }

  void updateLikeState(
      {required UserObject? loggedInUser,
      required NewsPost newsPost,
      required int? previousLikeStatus}) {
    if (loggedInUser == null) {
      return;
    } else {
      // IF POST WAS ALREADY LIKED, NOW IT WILL BE DISLIKED
      if (previousLikeStatus == 1) {
        newsPost.isLiked = 0;
        if (newsPost.likesCount != null && newsPost.likesCount! > 0) {
          newsPost.likesCount = newsPost.likesCount! - 1;
        }
        // REMOVE PROFILE IMAGE AVATAR
        newsPost.likes?.removeWhere((element) =>
            element.likedBy?.id == int.tryParse(loggedInUser.id.toString()));
      }
      // IF POST WAS NOT LIKED BEFORE, IT WILL NOW BE LIKED
      else {
        newsPost.isLiked = 1;
        if (newsPost.likesCount != null) {
          newsPost.likesCount = newsPost.likesCount! + 1;
        }
        Like newLike = Like(
            likedBy: By(
                id: int.tryParse(loggedInUser.id.toString()),
                profilePicture: loggedInUser.profilePicture));
        // SHOW PROFILE IMAGE AVATAR
        newsPost.likes?.insert(0, newLike);
      }

      notifyListeners();
    }
  }

  void onSuccessToggleLike(
      {required NewsPost newsPost, required BuildContext context}) {
    if (newsPost.id != null && newsPost.likesCount != null) {
      // MY TOPIC AND MY BOOKMARK TOPIC
      Provider.of<ProfileNewsProvider>(context, listen: false)
          .onToggleLikeFromDifferentScreen(
              newsPostId: newsPost.id!, likeCount: newsPost.likesCount!);
    }

    // CREATED NEWS POST (NOT MY TOPIC)
    Provider.of<CreatedPostProvider>(context, listen: false)
        .onLikeFromDifferentScreen(newsPost: newsPost);
  }

  bool toggleCommentOnProcess = false;

  Future<void> writeNewsPostComment(
      {required NewsPost newsPost,
      required TextEditingController commentTextController,
      required BuildContext context}) async {
    int? previousCommentCount = newsPost.commentCount;
    List<NewsComment>? previousComments =
        newsPost.comments == null ? [] : [...newsPost.comments!];
    // WHEN ACTION FAILS, THIS METHOD WILL BE CALLED TO SET DEFAULT VALUE
    void onCommentFailed() {
      newsPost.commentCount = previousCommentCount;
      newsPost.comments = previousComments;
      toggleCommentOnProcess = false;
      notifyListeners();
    }

    try {
      if (toggleCommentOnProcess == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        toggleCommentOnProcess = true;
        final currentLocalDateTime = DateTime.now();

        updateCommentState(
            newsPost: newsPost,
            currentLocalDateTime: currentLocalDateTime,
            commentTextController: commentTextController);

        notifyListeners();
        Response response = await NewsCommentRepo.writeNewsComment(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData: jsonEncode({
              "post_id": int.parse(newsPost.id.toString()),
              "comment": commentTextController.text,
              "created_at_utc": currentLocalDateTime.toUtc().toString(),
              "updated_at_utc": currentLocalDateTime.toUtc().toString()
            }));
        if (response.statusCode == 200 && context.mounted) {
          onCommentSuccess(context: context, newsPost: newsPost);
          commentTextController.clear();
          toggleCommentOnProcess = false;
          notifyListeners();
        }
        // ACCESS TOKEN EXPIRED
        else if (response.statusCode == 401 || response.statusCode == 403) {
          onCommentFailed();
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // if token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return writeNewsPostComment(
                newsPost: newsPost,
                commentTextController: commentTextController,
                context: context);
          } else {
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
            return;
          }
        } else if ((jsonDecode(response.body))["status"] == 'Error') {
          onCommentFailed();
          EasyLoading.showInfo((jsonDecode(response.body))["msg"],
              dismissOnTap: false, duration: const Duration(seconds: 4));
        } else {
          onCommentFailed();
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: false, duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      onCommentFailed();
      EasyLoading.showInfo("${AppLocalizations.of(context).tryAgainLater}: $e",
          dismissOnTap: false, duration: const Duration(seconds: 4));
    }
  }

  void updateCommentState(
      {required NewsPost newsPost,
      required DateTime currentLocalDateTime,
      required TextEditingController commentTextController}) {
    final loggedInUser = mainScreenProvider.loginSuccess.user;
    if (loggedInUser == null) {
      return;
    }
    if (newsPost.commentCount != null) {
      newsPost.commentCount = newsPost.commentCount! + 1;
    }
    newsPost.comments?.insert(
        0,
        NewsComment(
            createdAt: currentLocalDateTime,
            updatedAt: currentLocalDateTime,
            comment: commentTextController.text,
            commentBy: By(
                id: int.tryParse(loggedInUser.id.toString()),
                profilePicture: loggedInUser.profilePicture,
                username: loggedInUser.username)));
  }

  void onCommentSuccess(
      {required NewsPost newsPost, required BuildContext context}) {
    // MY TOPIC AND BOOKMARK TOPIC
    if (newsPost.id != null && newsPost.commentCount != null) {
      Provider.of<ProfileNewsProvider>(context, listen: false)
          .onCommentFromDifferentScreen(
              newsPostId: newsPost.id!, commentCount: newsPost.commentCount!);
    }
    // CREATED POST (NOT MY TOPIC)
    Provider.of<CreatedPostProvider>(context, listen: false)
        .onCommentFromDifferentScreen(newsPost: newsPost);
  }

  // WHEN POST IS SAVED FROM DIFFERENT SCREEN, WE WILL UPDATE THE LIKE STATE IN NEWS POSTS TOO
  void onSaveFromDifferentScreen(
      {required int? isSaved, required int? newsPostId}) {
    if (_allNewsPosts?.posts == null) {
      return;
    }
    Post? foundPost = _allNewsPosts!.posts!.firstWhereOrNull((element) =>
        element.newsPost?.id != null && element.newsPost?.id == newsPostId);
    if (foundPost == null) {
      return;
    } else {
      foundPost.newsPost?.isSaved = isSaved;
      notifyListeners();
    }
  }

  // WHEN POST IS LIKED FROM DIFFERENT SCREEN, WE WILL UPDATE THE LIKE STATE IN NEWS POSTS TOO
  void onLikeFromDifferentScreen({required NewsPost newsPost}) {
    if (_allNewsPosts?.posts == null) {
      return;
    }
    Post? foundPost = _allNewsPosts!.posts!.firstWhereOrNull((element) =>
        element.newsPost?.id != null && element.newsPost?.id == newsPost.id);
    if (foundPost == null) {
      return;
    } else {
      foundPost.newsPost?.isLiked = newsPost.isLiked;
      foundPost.newsPost?.likesCount = newsPost.likesCount;
      foundPost.newsPost?.likes = newsPost.likes;
      notifyListeners();
    }
  }

  // WHEN POST IS COMMENTED FROM DIFFERENT SCREEN, WE WILL UPDATE THE COMMENT STATE IN NEWS POSTS TOO
  void onCommentFromDifferentScreen({required NewsPost newsPost}) {
    if (_allNewsPosts?.posts == null) {
      return;
    }
    Post? foundPost = _allNewsPosts!.posts!.firstWhereOrNull((element) =>
        element.newsPost?.id != null && element.newsPost?.id == newsPost.id);
    if (foundPost == null) {
      return;
    } else {
      foundPost.newsPost?.commentCount = newsPost.commentCount;
      foundPost.newsPost?.comments = newsPost.comments;
      notifyListeners();
    }
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

  void clearReportOptionData() {
    reportNewsPostReasonType = null;
    reportNewsPostOtherReason = null;
    notifyListeners();
  }

  void resetNewsPostReportOption({required BuildContext context}) {
    clearReportOptionData();
    Navigator.of(context).pop();
  }

  Future<void> reportNewsPost(
      {required String postId,
      required BuildContext context,
      required NewsPostFrom newsPostFrom}) async {
    try {
      if (reportNewsPostReasonType == null) {
        mainScreenProvider.showSnackBar(
            context: context,
            // translate
            content: "Please select a reason",
            contentColor: Colors.white,
            backgroundColor: Colors.red);
        return;
      } else {
        if ((reportNewsPostReasonType.toString() == 'Other' ||
                    reportNewsPostReasonType.toString() == '其他' ||
                    reportNewsPostReasonType.toString() == '其他') &&
                reportNewsPostOtherReason == null ||
            reportNewsPostOtherReason.toString().isEmpty) {
          mainScreenProvider.showSnackBar(
              context: context,
              // translate
              content: "Please provide reason",
              contentColor: Colors.white,
              backgroundColor: Colors.red);
          return;
        }
        // translate
        EasyLoading.show(status: "Reporting..", dismissOnTap: false);
        String? currentUserId =
            mainScreenProvider.loginSuccess.user?.id.toString();
        if (currentUserId == null) {
          clearReportOptionData();
          // translate
          EasyLoading.showInfo("Please login again.",
              dismissOnTap: false, duration: const Duration(seconds: 4));
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
        String currentLocalDateTime = DateTime.now().toUtc().toString();

        Map body = {
          'post_id': postId,
          'reason':
              "$reportNewsPostReasonType${(reportNewsPostReasonType.toString() == 'Other' || reportNewsPostReasonType.toString() == '其他' || reportNewsPostReasonType.toString() == '其他') ? ': ${reportNewsPostOtherReason.toString()}' : ''}",
          'created_at_utc': currentLocalDateTime,
          'updated_at_utc': currentLocalDateTime
        };
        String bodyData = jsonEncode(body);
        Response response = await NewsPostRepo.reportNewsPost(
            bodyData: bodyData,
            jwt: mainScreenProvider.loginSuccess.accessToken.toString());
        if (response.statusCode == 200) {
          clearReportOptionData();
          if (_allNewsPosts != null && _allNewsPosts?.posts != null) {
            _allNewsPosts!.posts!
                .removeWhere((post) => post.newsPost?.id.toString() == postId);
          }
          if (newsPostFrom == NewsPostFrom.newsPostDescription &&
              context.mounted) {
            Navigator.of(context).pop();
          }
          // translate
          EasyLoading.showSuccess("Reported successfully!",
              duration: const Duration(seconds: 4), dismissOnTap: true);
          if (context.mounted) Navigator.of(context).pop();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          if (context.mounted) {
            bool isTokenRefreshed =
                await Provider.of<AuthProvider>(context, listen: false)
                    .refreshAccessToken(context: context);
            // if token is refreshed, re-call the method
            if (isTokenRefreshed == true && context.mounted) {
              return reportNewsPost(
                  postId: postId, context: context, newsPostFrom: newsPostFrom);
            } else {
              clearReportOptionData();
              await Provider.of<DrawerProvider>(context, listen: false)
                  .logOut(context: context);
              return;
            }
          }
        } else {
          // translate
          EasyLoading.showInfo("Error, please try again later.",
              dismissOnTap: false, duration: const Duration(seconds: 4));
          return;
        }
      }
    } catch (err) {
      // translate
      EasyLoading.showInfo("Please try again later. Error: $err",
          dismissOnTap: false, duration: const Duration(seconds: 4));
      return;
    }
  }

  // CREATE NEW POST //
  final ImagePicker imagePicker = ImagePicker();
  List<XFile?>? imageFileList = [];

  Future<void> selectMultiImages({required BuildContext context}) async {
    try {
      bool hasPermission = await permissionProvider.checkPermission(
          context: context,
          denyTitle: permissionProvider.androidStoragePermissionDenyTitle,
          denyDescription:
              permissionProvider.androidStoragePermissionDenyDescription,
          permission: Permission.storage);
      if (!hasPermission) {
        return;
      }
      final List<XFile?> selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
      notifyListeners();
    } on PlatformException {
      permissionProvider.onImagePickerPermissionPlatformException(
          context: context);
    }
  }

  void removeSelectedImage({required int index}) {
    imageFileList!.removeAt(index);
    notifyListeners();
  }

  Future<void> createANewPost(
      {required TextEditingController titleTextController,
      required TextEditingController contentTextController,
      required BuildContext context}) async {
    try {
      // translate
      EasyLoading.show(status: "Uploading..", dismissOnTap: false);
      Response createResponse;
      if (imageFileList == null || imageFileList!.isEmpty) {
        createResponse = await createNewsPostWithoutImage(
            context: context,
            titleTextController: titleTextController,
            contentTextController: contentTextController);
      } else {
        createResponse = await createNewsPostWithImages(
            context: context,
            titleTextController: titleTextController,
            contentTextController: contentTextController);
      }
      if (createResponse.statusCode == 201) {
        final createdNewsPost = createdNewsPostFromJson(createResponse.body);
        if (createdNewsPost.post != null) {
          _allNewsPosts?.posts?.insert(0, createdNewsPost.post!);
          // to prevent same post from displaying twice
          if (newsPostHasMore == true &&
              _allNewsPosts?.posts != null &&
              _allNewsPosts!.posts!.length > newsPostPageSize) {
            _allNewsPosts!.posts!.removeLast();
          }
        }
        clearNewPostData(
            titleTextController: titleTextController,
            contentTextController: contentTextController);
        // TO ADD NEW POST IN MY TOPIC IN PROFILE TAB
        if (context.mounted) {
          await Provider.of<ProfileNewsProvider>(context, listen: false)
              .onSuccessCreateNewPost(context: context);
        }
        // translate
        EasyLoading.showSuccess("Created successfully!",
            duration: const Duration(seconds: 2), dismissOnTap: true);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
      // ACCESS TOKEN EXPIRED
      else if (createResponse.statusCode == 401 ||
          createResponse.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);
          // if token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return createANewPost(
                titleTextController: titleTextController,
                contentTextController: contentTextController,
                context: context);
          } else {
            clearNewPostData(
                titleTextController: titleTextController,
                contentTextController: contentTextController);
            await Provider.of<DrawerProvider>(context, listen: false)
                .logOut(context: context);
            return;
          }
        }
      } else if ((jsonDecode(createResponse.body))["status"] == 'Error') {
        EasyLoading.showInfo((jsonDecode(createResponse.body))["msg"],
            dismissOnTap: true, duration: const Duration(seconds: 4));
      } else {
        if (context.mounted) {
          EasyLoading.showInfo(AppLocalizations.of(context).tryAgainLater,
              dismissOnTap: true, duration: const Duration(seconds: 3));
        }
      }
    } catch (err) {
      EasyLoading.showInfo(
          "An error occured while trying to create a new post. Error: $err",
          dismissOnTap: true,
          duration: const Duration(seconds: 5));
    }
  }

  Future<Response> createNewsPostWithoutImage(
      {required BuildContext context,
      required TextEditingController titleTextController,
      required TextEditingController contentTextController}) async {
    final streamedResponse = await NewsPostRepo.createNewPostWithoutImage(
        title: titleTextController.text,
        content: contentTextController.text,
        accessJWT: mainScreenProvider.loginSuccess.accessToken.toString());
    Response createResponse = await Response.fromStream(streamedResponse);
    return createResponse;
  }

  Future<Response> createNewsPostWithImages(
      {required BuildContext context,
      required TextEditingController titleTextController,
      required TextEditingController contentTextController}) async {
    final List<File> compressedPostImages = await mainScreenProvider
        .compressAllImage(imageFileList: imageFileList!);
    final streamedResponse = await NewsPostRepo.createNewPostWithImage(
        imageList: compressedPostImages,
        title: titleTextController.text,
        content: contentTextController.text,
        accessJWT: mainScreenProvider.loginSuccess.accessToken.toString());
    Response createResponse = await Response.fromStream(streamedResponse);
    return createResponse;
  }

  void clearNewPostData(
      {required TextEditingController titleTextController,
      required TextEditingController contentTextController}) {
    titleTextController.clear();
    contentTextController.clear();
    imageFileList?.clear();
    notifyListeners();
  }

  void goBackFromNewPostScreen(
      {required BuildContext context,
      required TextEditingController titleTextController,
      required TextEditingController contentTextController}) {
    clearNewPostData(
        titleTextController: titleTextController,
        contentTextController: contentTextController);
    Navigator.of(context).pop();
  }
}
