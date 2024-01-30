import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/created_post_provider.dart';
import 'package:c_talent/presentation/components/news/news_post_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/constant/font_constant.dart';
import '../../components/all/top_app_bar.dart';
import '../../helper/size_configuration.dart';

// ignore: must_be_immutable
class CreatedPostsScreen extends StatefulWidget {
  static const String id = 'created_post_screen';
  const CreatedPostsScreen({Key? key}) : super(key: key);

  @override
  State<CreatedPostsScreen> createState() => _CreatedPostsScreenState();
}

class _CreatedPostsScreenState extends State<CreatedPostsScreen> {
  StreamController<AllNewsPosts> createdPostsStreamController =
      BehaviorSubject<AllNewsPosts>();
  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final createdPostProvider =
        Provider.of<CreatedPostProvider>(context, listen: false);
    createdPostProvider.loadInitialCreatedPosts(
        context: context, createdPostController: createdPostsStreamController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            Provider.of<CreatedPostProvider>(context, listen: false)
                .goBackFromCreatedPostsScreen(context: context);
          },
        ),
        title: AppLocalizations.of(context).createdPost,
      ),
      body: Consumer<CreatedPostProvider>(
        builder: (context, data, child) {
          return StreamBuilder<AllNewsPosts>(
            stream: createdPostsStreamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).loading,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .promotionCouldNotBeLoaded,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    return snapshot.data?.posts == null ||
                            snapshot.data!.posts!.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.createdPostIsLoading == true ||
                                        data.isRefreshingCreatedPosts == true
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context)
                                        .noPostCreatedYet,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.posts!.length >=
                                    data.createdPostPageSize
                                ? snapshot.data!.posts!.length + 1
                                : snapshot.data!.posts!.length,
                            itemBuilder: (context, index) {
                              if (index < snapshot.data!.posts!.length) {
                                // CREATED POST
                                final createdPost =
                                    snapshot.data!.posts![index].newsPost;
                                return createdPost == null
                                    ? const SizedBox()
                                    : NewsPostContainer(
                                        newsPostActionFrom:
                                            NewsPostActionFrom.createdPost,
                                        index: index,
                                        newsPost: createdPost,
                                        onComment:
                                            (newsTextEditingController) async {
                                          if (newsTextEditingController.text
                                              .trim()
                                              .isNotEmpty) {
                                            await data.writeCreatedPostComment(
                                                createdPost: createdPost,
                                                commentTextController:
                                                    newsTextEditingController,
                                                context: context);
                                          }
                                        },
                                        onLike: () async {
                                          await data.toggleCreatedPostLike(
                                              createdPost: createdPost,
                                              context: context);
                                        },
                                        onSave: () async {
                                          await data.toggleCreatedPostSave(
                                              createdPost: createdPost,
                                              context: context);
                                        },
                                      );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.defaultSize * 3),
                                  child: Center(
                                      child: data.createdPostHasMore
                                          ? const CircularProgressIndicator(
                                              color: Color(0xFFA08875))
                                          : Text(
                                              AppLocalizations.of(context)
                                                  .caughtUp,
                                              style: TextStyle(
                                                  fontFamily: kHelveticaMedium,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.5),
                                            )),
                                );
                              }
                            });
                  }
              }
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    createdPostsStreamController.close();
    super.dispose();
  }
}
