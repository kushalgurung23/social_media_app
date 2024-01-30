import 'dart:async';
import 'dart:convert';

import 'package:c_talent/data/repositories/profile/profile_posts_repo.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/logic/providers/profile_news_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../data/models/all_news_posts.dart';
import '../../data/repositories/news_post/news_comment_repo.dart';
import '../../data/repositories/news_post/news_likes_repo.dart';
import '../../data/repositories/news_post/news_post_repo.dart';
import '../../data/repositories/news_post/news_save_repo.dart';
import 'auth_provider.dart';

class CreatedPostProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;
  CreatedPostProvider({required this.mainScreenProvider});

  // Load news post
  AllNewsPosts? _createdProfilePosts;
  AllNewsPosts? get createdProfilePosts => _createdProfilePosts;

  // createdPostPageNumber and createdPostPageSize is used for pagination
  int createdPostPageNumber = 1;
  int createdPostPageSize = 10;
  // createdPostHasMore will be true until we have more data to fetch in the API
  bool createdPostHasMore = true;
  // createdPostIsLoading will be true once we try to fetch more news post data.
  bool createdPostIsLoading = false;

  // This method will be called to get created posts
  Future<void> loadInitialCreatedPosts(
      {required BuildContext context,
      required StreamController<AllNewsPosts> createdPostController}) async {
    try {
      Response response = await ProfilePostsRepo.getAllCreatedPosts(
          accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
          page: createdPostPageNumber.toString(),
          pageSize: createdPostPageSize.toString());
      if (isRefreshingCreatedPosts == true) {
        isRefreshingCreatedPosts = false;
      }
      if (response.statusCode == 200) {
        _createdProfilePosts = allNewsPostsFromJson(response.body);
        if (_createdProfilePosts != null) {
          createdPostController.sink.add(_createdProfilePosts!);
          notifyListeners();
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadInitialCreatedPosts(
                context: context, createdPostController: createdPostController);
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
    createdPostPageNumber++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data we will get exit from this method.
    if (createdPostIsLoading || createdPostHasMore == false) {
      return;
    }
    createdPostIsLoading = true;
    Response response = await NewsPostRepo.getAllNewsPosts(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: createdPostPageNumber.toString(),
        pageSize: createdPostPageSize.toString());
    if (response.statusCode == 200) {
      final newNewsPosts = allNewsPostsFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      createdPostIsLoading = false;

      if (newNewsPosts.posts == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newNewsPosts.posts!.length < createdPostPageSize) {
        createdPostHasMore = false;
      }
      _createdProfilePosts!.posts = [
        ..._createdProfilePosts!.posts!,
        ...newNewsPosts.posts!
      ];
      allNewsPostController.sink.add(_createdProfilePosts!);
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

  bool isRefreshingCreatedPosts = false;
  Future refreshCreatedPosts(
      {required BuildContext context,
      required StreamController<AllNewsPosts> allCreatedPostController}) async {
    isRefreshingCreatedPosts = true;
    createdPostIsLoading = false;
    createdPostHasMore = true;
    createdPostPageNumber = 1;
    if (_createdProfilePosts?.posts != null) {
      _createdProfilePosts!.posts!.clear();
    }

    await loadInitialCreatedPosts(
        context: context, createdPostController: allCreatedPostController);
    isRefreshingCreatedPosts = false;
    notifyListeners();
  }

  // SAVING NEWS POST FROM CREATED POST
  bool onProcessCreatedPostSave = false;

  Future<void> toggleCreatedPostSave(
      {required NewsPost createdPost, required BuildContext context}) async {
    int? currentSaveStatus = createdPost.isSaved;

    // THIS METHOD IS CALLED WHEN TOGGLE SAVE FAILS TO KEEP ORIGINAL DATA
    void onToggleSaveFailed() {
      // if error occurs, keep current save status
      createdPost.isSaved = currentSaveStatus;
      onProcessCreatedPostSave = false;
      notifyListeners();
    }

    try {
      if (onProcessCreatedPostSave == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        onProcessCreatedPostSave = true;
        if (currentSaveStatus == 1) {
          createdPost.isSaved = 0;
        } else {
          createdPost.isSaved = 1;
        }
        notifyListeners();
        Response response = await NewsSaveRepo.toggleNewsPostSave(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData:
                jsonEncode({"post_id": int.parse(createdPost.id.toString())}));

        if (response.statusCode == 200 && context.mounted) {
          onSuccessCreatedPostSave(context: context, createdPost: createdPost);
          onProcessCreatedPostSave = false;
          notifyListeners();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          onToggleSaveFailed();

          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return toggleCreatedPostSave(
                createdPost: createdPost, context: context);
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
  void onSuccessCreatedPostSave(
      {required BuildContext context, required NewsPost createdPost}) {
    // NEWS POSTS
    Provider.of<NewsAdProvider>(context, listen: false)
        .onSaveFromDifferentScreen(
            isSaved: createdPost.isSaved, newsPostId: createdPost.id);

    // NOT REQUIRED TO UPDATE IN MY TOPIC
    // BOOKMARKED TOPIC
    Provider.of<ProfileNewsProvider>(context, listen: false)
        .onToggleSaveFromDifferentScreen(context: context);
  }

  bool onProcessCreatedPostLike = false;

  Future<void> toggleCreatedPostLike(
      {required NewsPost createdPost, required BuildContext context}) async {
    int? previousLikeStatus = createdPost.isLiked;
    List<Like> previousLikes =
        createdPost.likes == null ? [] : [...createdPost.likes!];
    int? previousLikesCount = createdPost.likesCount;
    // THIS METHOD IS CALLED WHEN TOGGLE LIKE FAILS TO KEEP ORIGINAL DATA
    void onToggleLikeFailed() {
      // if error occurs, keep current like status
      createdPost.isLiked = previousLikeStatus;
      createdPost.likes = previousLikes;
      createdPost.likesCount = previousLikesCount;
      onProcessCreatedPostLike = false;
      notifyListeners();
    }

    try {
      if (onProcessCreatedPostLike == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        onProcessCreatedPostLike = true;
        Provider.of<NewsAdProvider>(context, listen: false).updateLikeState(
            previousLikeStatus: previousLikeStatus,
            loggedInUser: mainScreenProvider.loginSuccess.user,
            newsPost: createdPost);
        notifyListeners();
        Response response = await NewsLikesRepo.toggleNewsPostLike(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData:
                jsonEncode({"post_id": int.parse(createdPost.id.toString())}));
        // SUCCESSFUL
        if (response.statusCode == 200 && context.mounted) {
          onSuccessToggleLike(createdPost: createdPost, context: context);
          onProcessCreatedPostLike = false;
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
            return toggleCreatedPostLike(
                createdPost: createdPost, context: context);
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

  void onSuccessToggleLike(
      {required NewsPost createdPost, required BuildContext context}) {
    if (createdPost.id != null && createdPost.likesCount != null) {
      // MY TOPIC AND MY BOOKMARK TOPIC
      Provider.of<ProfileNewsProvider>(context, listen: false)
          .onToggleLikeFromDifferentScreen(
              newsPostId: createdPost.id!, likeCount: createdPost.likesCount!);
    }

    // NEWS POST
    Provider.of<NewsAdProvider>(context, listen: false)
        .onLikeFromDifferentScreen(newsPost: createdPost);
  }

  bool onProcessCreatedPostComment = false;

  Future<void> writeCreatedPostComment(
      {required NewsPost createdPost,
      required TextEditingController commentTextController,
      required BuildContext context}) async {
    int? previousCommentCount = createdPost.commentCount;
    List<NewsComment>? previousComments =
        createdPost.comments == null ? [] : [...createdPost.comments!];
    // WHEN ACTION FAILS, THIS METHOD WILL BE CALLED TO SET DEFAULT VALUE
    void onCommentFailed() {
      createdPost.commentCount = previousCommentCount;
      createdPost.comments = previousComments;
      onProcessCreatedPostComment = false;
      notifyListeners();
    }

    try {
      if (onProcessCreatedPostComment == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        onProcessCreatedPostComment = true;
        final currentLocalDateTime = DateTime.now();

        Provider.of<NewsAdProvider>(context, listen: false).updateCommentState(
            newsPost: createdPost,
            currentLocalDateTime: currentLocalDateTime,
            commentTextController: commentTextController);

        notifyListeners();
        Response response = await NewsCommentRepo.writeNewsComment(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData: jsonEncode({
              "post_id": int.parse(createdPost.id.toString()),
              "comment": commentTextController.text,
              "created_at_utc": currentLocalDateTime.toUtc().toString(),
              "updated_at_utc": currentLocalDateTime.toUtc().toString()
            }));
        if (response.statusCode == 200 && context.mounted) {
          onCommentSuccess(context: context, createdPost: createdPost);
          commentTextController.clear();
          onProcessCreatedPostComment = false;
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
            return writeCreatedPostComment(
                createdPost: createdPost,
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

  void onCommentSuccess(
      {required NewsPost createdPost, required BuildContext context}) {
    // MY TOPIC AND BOOKMARK TOPIC
    if (createdPost.id != null && createdPost.commentCount != null) {
      Provider.of<ProfileNewsProvider>(context, listen: false)
          .onCommentFromDifferentScreen(
              newsPostId: createdPost.id!,
              commentCount: createdPost.commentCount!);
    }
    // CREATED POST (NOT MY TOPIC)
    Provider.of<NewsAdProvider>(context, listen: false)
        .onCommentFromDifferentScreen(newsPost: createdPost);
  }

  void goBackFromCreatedPostsScreen({required BuildContext context}) {
    _createdProfilePosts = null;
    Navigator.pop(context);
  }

  // WHEN POST IS SAVED FROM DIFFERENT SCREEN, WE WILL UPDATE THE LIKE STATE IN CREATED POSTS TOO
  void onSaveFromDifferentScreen(
      {required int? isSaved, required int? newsPostId}) {
    if (_createdProfilePosts?.posts == null) {
      return;
    }
    Post? foundPost = _createdProfilePosts!.posts!.firstWhereOrNull((element) =>
        element.newsPost?.id != null && element.newsPost?.id == newsPostId);
    if (foundPost == null) {
      return;
    } else {
      foundPost.newsPost?.isSaved = isSaved;
      notifyListeners();
    }
  }

  // WHEN POST IS LIKED FROM DIFFERENT SCREEN, WE WILL UPDATE THE LIKE STATE IN CREATED POSTS TOO
  void onLikeFromDifferentScreen({required NewsPost newsPost}) {
    if (_createdProfilePosts?.posts == null) {
      return;
    }
    Post? foundPost = _createdProfilePosts!.posts!.firstWhereOrNull((element) =>
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

  // WHEN POST IS COMMENTED FROM DIFFERENT SCREEN, WE WILL UPDATE THE COMMENT STATE IN CREATED POSTS TOO
  void onCommentFromDifferentScreen({required NewsPost newsPost}) {
    if (_createdProfilePosts?.posts == null) {
      return;
    }
    Post? foundPost = _createdProfilePosts!.posts!.firstWhereOrNull((element) =>
        element.newsPost?.id != null && element.newsPost?.id == newsPost.id);
    if (foundPost == null) {
      return;
    } else {
      foundPost.newsPost?.commentCount = newsPost.commentCount;
      foundPost.newsPost?.comments = newsPost.comments;
      notifyListeners();
    }
  }
}
