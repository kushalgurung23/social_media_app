import 'dart:async';
import 'dart:convert';

import 'package:c_talent/data/repositories/profile/profile_posts_repo.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  // SAVE CREATED POSTS
  bool saveOnProcessCreatedPost = false;

  Future<void> toggleCreatedPostSave(
      {required NewsPost createdPost, required BuildContext context}) async {
    int? currentSaveStatus = createdPost.isSaved;

    // THIS METHOD IS CALLED WHEN TOGGLE SAVE FAILS TO KEEP ORIGINAL DATA
    void onToggleSaveFailed() {
      // if error occurs, keep current save status
      createdPost.isSaved = currentSaveStatus;
      saveOnProcessCreatedPost = false;
      notifyListeners();
    }

    try {
      if (saveOnProcessCreatedPost == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        saveOnProcessCreatedPost = true;
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
          saveOnProcessCreatedPost = false;
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

  //
  bool likeOnProcessCreatedPosts = false;

  Future<void> toggleCreatedPostLike(
      {required NewsPost createdPost, required BuildContext context}) async {
    int? currentLikeStatus = createdPost.isLiked;

    // THIS METHOD IS CALLED WHEN TOGGLE LIKE FAILS TO KEEP ORIGINAL DATA
    void onToggleLikeFailed() {
      // if error occurs, keep current like status
      createdPost.isLiked = currentLikeStatus;
      likeOnProcessCreatedPosts = false;
      notifyListeners();
    }

    try {
      if (likeOnProcessCreatedPosts == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        likeOnProcessCreatedPosts = true;

        if (currentLikeStatus == 1) {
          createdPost.isLiked = 0;
        } else {
          createdPost.isLiked = 1;
        }
        notifyListeners();
        Response response = await NewsLikesRepo.toggleNewsPostLike(
            jwt: mainScreenProvider.loginSuccess.accessToken.toString(),
            bodyData:
                jsonEncode({"post_id": int.parse(createdPost.id.toString())}));
        // SUCCESSFUL
        if (response.statusCode == 200 && context.mounted) {
          final loggedInUser = mainScreenProvider.loginSuccess.user;
          // SHOW PROFILE IMAGE AVATAR
          if (createdPost.isLiked == 1 && loggedInUser != null) {
            createdPost.likes?.insert(
                0,
                Like(
                    likedBy: By(
                        id: int.tryParse(loggedInUser.id.toString()),
                        profilePicture: loggedInUser.profilePicture)));
            if (createdPost.likesCount != null) {
              createdPost.likesCount = createdPost.likesCount! + 1;
            }
          }
          // REMOVE PROFILE IMAGE AVATAR
          else {
            createdPost.likes?.removeWhere((element) =>
                element.likedBy?.id ==
                int.tryParse(loggedInUser?.id.toString() ?? '0'));
            if (createdPost.likesCount != null) {
              createdPost.likesCount = createdPost.likesCount! - 1;
            }
          }
          likeOnProcessCreatedPosts = false;
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

  bool commentOnProcessCreatedPost = false;

  Future<void> writeCreatedPostComment(
      {required NewsPost createdPost,
      required TextEditingController commentTextController,
      required BuildContext context}) async {
    // WHEN ACTION FAILS, THIS METHOD WILL BE CALLED TO SET DEFAULT VALUE
    void onCommentFailed() {
      if (createdPost.commentCount != null) {
        createdPost.commentCount = createdPost.commentCount! - 1;
      }
      // if error occurs, remove new comment
      createdPost.comments?.removeAt(0);
      commentOnProcessCreatedPost = false;
      notifyListeners();
    }

    try {
      if (commentOnProcessCreatedPost == true) {
        // Please wait
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseWait,
            dismissOnTap: false, duration: const Duration(seconds: 1));
        return;
      } else {
        commentOnProcessCreatedPost = true;
        final currentLocalDateTime = DateTime.now();

        addNewCommentToObject(
            newsComments: createdPost.comments,
            currentLocalDateTime: currentLocalDateTime,
            commentTextController: commentTextController);
        if (createdPost.commentCount != null) {
          createdPost.commentCount = createdPost.commentCount! + 1;
        }
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
          commentTextController.clear();
          commentOnProcessCreatedPost = false;
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

  void addNewCommentToObject(
      {required List<NewsComment>? newsComments,
      required DateTime currentLocalDateTime,
      required TextEditingController commentTextController}) {
    final loggedInUser = mainScreenProvider.loginSuccess.user;
    if (loggedInUser == null) {
      return;
    }
    newsComments?.insert(
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
}
