import 'dart:async';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/data/models/comment_load.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/logic/providers/single_news_provider.dart';
import 'package:c_talent/presentation/components/news/comment_container.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SingleNewsComments extends StatefulWidget {
  final NewsPost newsPost;
  final ScrollController scrollController;
  final CommentLoad commentLoad;
  const SingleNewsComments({
    Key? key,
    required this.commentLoad,
    required this.newsPost,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<SingleNewsComments> createState() => _SingleNewsCommentsState();
}

class _SingleNewsCommentsState extends State<SingleNewsComments> {
  StreamController<List<NewsComment>?> allNewsCommentStreamController =
      BehaviorSubject();

  @override
  void initState() {
    loadInitialNewsComments();
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        loadMoreNewsComments();
      }
    });
    super.initState();
  }

  Future<void> loadInitialNewsComments() async {
    if (mounted) {
      await Provider.of<SingleNewsProvider>(context, listen: false)
          .loadInitialNewsComments(
              commentLoad: widget.commentLoad,
              newsPost: widget.newsPost,
              context: context,
              allNewsCommentStreamController: allNewsCommentStreamController);
    }
  }

  Future<void> loadMoreNewsComments() async {
    await Provider.of<SingleNewsProvider>(context, listen: false)
        .loadMoreNewsComments(
            commentLoad: widget.commentLoad,
            context: context,
            allNewsCommentStreamController: allNewsCommentStreamController,
            newsPost: widget.newsPost);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
        child: StreamBuilder<List<NewsComment>?>(
          initialData: widget.newsPost.comments,
          stream: allNewsCommentStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
                    style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).errorOccured,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    // translate
                    child: Text(
                      "Comments could not load",
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data == null
                      ? Center(
                          // translate
                          child: Text(
                            "Comments could not load",
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          addAutomaticKeepAlives: true,
                          itemCount: snapshot.data!.length >=
                                  widget.commentLoad.singleNewsCommentsPageSize
                              ? snapshot.data!.length + 1
                              : snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (index < snapshot.data!.length) {
                              return CommentContainer(
                                  comment: snapshot.data![index]);
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.defaultSize * 3),
                                child: Center(
                                    child: widget.commentLoad
                                            .hasMoreSingleNewsComments
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
                } else {
                  return Center(
                    child: Text(
                      // translate
                      "Comments could not load",
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                }
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    allNewsCommentStreamController.close();
    super.dispose();
  }
}
