import 'dart:async';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/news/comment_container.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CommentListview extends StatefulWidget {
  final NewsPost newsPost;
  final StreamController<List<NewsComment>?> allNewsCommentStreamController;
  const CommentListview(
      {Key? key,
      required this.newsPost,
      required this.allNewsCommentStreamController})
      : super(key: key);

  @override
  State<CommentListview> createState() => _CommentListviewState();
}

class _CommentListviewState extends State<CommentListview> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
        child: StreamBuilder<List<NewsComment>?>(
          initialData: widget.newsPost.comments,
          stream: widget.allNewsCommentStreamController.stream,
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
                          itemCount:
                              snapshot.data!.length >= data.commentsPageSize
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
                                    child: data.hasMoreComments
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
}
