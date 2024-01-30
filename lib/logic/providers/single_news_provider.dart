import 'dart:async';
import 'dart:convert';

import 'package:c_talent/data/models/comment_load.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/all_news_posts.dart';
import '../../data/models/single_news_comments.dart';
import '../../data/repositories/news_post/news_comment_repo.dart';
import '../../data/repositories/news_post/news_post_repo.dart';
import 'auth_provider.dart';
import 'drawer_provider.dart';

class SingleNewsProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;
  SingleNewsProvider({required this.mainScreenProvider});

  Future<void> loadSingleNewsPost(
      {required BuildContext context,
      required String newsPostId,
      required StreamController<NewsPost>
          singleNewsPostStreamController}) async {
    try {
      Response response = await NewsPostRepo.getPostById(
          accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
          newsPostId: newsPostId);
      if (response.statusCode == 200) {
        NewsPost newsPost =
            NewsPost.fromJson(json.decode(response.body)["news_post"]);
        singleNewsPostStreamController.sink.add(newsPost);
        notifyListeners();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        if (context.mounted) {
          bool isTokenRefreshed =
              await Provider.of<AuthProvider>(context, listen: false)
                  .refreshAccessToken(context: context);

          // If token is refreshed, re-call the method
          if (isTokenRefreshed == true && context.mounted) {
            return loadSingleNewsPost(
                context: context,
                newsPostId: newsPostId,
                singleNewsPostStreamController: singleNewsPostStreamController);
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
        // translate
        EasyLoading.showInfo("Please check your internet connection.",
            duration: const Duration(seconds: 5), dismissOnTap: true);
      }
    }
  }

  Future<void> loadInitialNewsComments(
      {required StreamController<List<NewsComment>?>
          allNewsCommentStreamController,
      required NewsPost newsPost,
      required BuildContext context,
      required CommentLoad commentLoad}) async {
    Response response = await NewsCommentRepo.getAllNewsComments(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: commentLoad.singleNewsCommentsPageNum.toString(),
        pageSize: commentLoad.singleNewsCommentsPageSize.toString(),
        newsPostId: newsPost.id.toString());

    if (response.statusCode == 200) {
      final singleNewsComments = singleNewsCommentsFromJson(response.body);
      if (singleNewsComments != null) {
        // FOR NEWS POST LIST
        newsPost.comments = singleNewsComments.comments;

        // FOR NEWS POST DESCRIPTION SCREEN
        allNewsCommentStreamController.sink.add(newsPost.comments);
        notifyListeners();
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadInitialNewsComments(
              commentLoad: commentLoad,
              allNewsCommentStreamController: allNewsCommentStreamController,
              newsPost: newsPost,
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
          "Sorry, comments could not load. Please try again later.",
          dismissOnTap: true,
          duration: const Duration(seconds: 4));
    }
  }

  // Loading more news posts when user reach maximum pageSize item of a page in listview
  Future<void> loadMoreNewsComments(
      {required BuildContext context,
      required StreamController<List<NewsComment>?>
          allNewsCommentStreamController,
      required CommentLoad commentLoad,
      required NewsPost newsPost}) async {
    commentLoad.singleNewsCommentsPageNum++;
    // If we have already made request to fetch more data, and new data hasn't been fetched yet,
    // or we don't have more data, we will get exit from this method.
    if (commentLoad.isLoadingSingleNewsComments ||
        commentLoad.hasMoreSingleNewsComments == false) {
      return;
    }
    commentLoad.isLoadingSingleNewsComments = true;

    Response response = await NewsCommentRepo.getAllNewsComments(
        accessToken: mainScreenProvider.loginSuccess.accessToken.toString(),
        page: commentLoad.singleNewsCommentsPageNum.toString(),
        pageSize: commentLoad.singleNewsCommentsPageSize.toString(),
        newsPostId: newsPost.id.toString());
    if (response.statusCode == 200) {
      final newComments = singleNewsCommentsFromJson(response.body);

      // isLoading = false indicates that the loading is complete
      commentLoad.isLoadingSingleNewsComments = false;

      if (newComments?.comments == null) return;
      // If the newly added data is less than our default pageSize, it means we won't have further more data. Hence hasMore = false
      if (newComments!.comments!.length <
          commentLoad.singleNewsCommentsPageSize) {
        commentLoad.hasMoreSingleNewsComments = false;
      }
      // ADDING NEWS COMMENTS IN TOTAL NEWS COMMENTS
      if (newsPost.comments != null) {
        // ADDING NEW COMMENTS FOR NEWS POST LIST
        for (int i = 0; i < newComments.comments!.length; i++) {
          newsPost.comments!.add(newComments.comments![i]);
        }
        // ADD NEW COMMENTS FOR NEWS POST DESCRIPTION SCREEN
        allNewsCommentStreamController.sink.add(newsPost.comments);
      }
      notifyListeners();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        bool isTokenRefreshed =
            await Provider.of<AuthProvider>(context, listen: false)
                .refreshAccessToken(context: context);

        // If token is refreshed, re-call the method
        if (isTokenRefreshed == true && context.mounted) {
          return loadMoreNewsComments(
              context: context,
              allNewsCommentStreamController: allNewsCommentStreamController,
              newsPost: newsPost,
              commentLoad: commentLoad);
        } else {
          await Provider.of<DrawerProvider>(context, listen: false)
              .logOut(context: context);
          return;
        }
      }
    } else {
      // translate
      EasyLoading.showInfo(
          "Sorry, comments could not load. Please try again later.",
          dismissOnTap: true,
          duration: const Duration(seconds: 4));
    }
  }

  void goBackFromNewsDescriptionScreen(
      {required TextEditingController newsCommentTextController,
      required CommentLoad commentLoad,
      required BuildContext context}) {
    commentLoad.singleNewsCommentsPageNum = 1;
    commentLoad.singleNewsCommentsPageSize = 10;
    commentLoad.hasMoreSingleNewsComments = true;
    commentLoad.isLoadingSingleNewsComments = false;
    newsCommentTextController.clear();
    notifyListeners();
    Navigator.of(context).pop();
  }
}
