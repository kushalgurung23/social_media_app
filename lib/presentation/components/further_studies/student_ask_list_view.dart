import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentAskListView extends StatefulWidget {
  const StudentAskListView({Key? key}) : super(key: key);

  @override
  State<StudentAskListView> createState() => _StudentAskListViewState();
}

class _StudentAskListViewState extends State<StudentAskListView> {
  Timer? _periodic;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final furtherStudiesProvider =
        Provider.of<FurtherStudiesProvider>(context, listen: false);

    // this will load initial 15 news posts in the discuss tab
    furtherStudiesProvider.studentRefresh(context: context);

    // this will load more data when we reach the end of news posts
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
  }

  void loadNextData() async {
    await Provider.of<FurtherStudiesProvider>(context, listen: false)
        .loadMoreStudentNewsPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FurtherStudiesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllNewsPost>(
          initialData: data.studentDiscussNewsPost,
          stream: data.studentDiscussStreamController.stream,
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
                      AppLocalizations.of(context).refreshPage,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).dataCouldNotLoad,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  return snapshot.data!.data!.isEmpty &&
                          data.isStudentRefresh == false
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context).studentDiscussEmpty,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                        )
                      : snapshot.data!.data!.isEmpty &&
                              data.isStudentRefresh == true
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context).loading,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  data.studentRefresh(context: context),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                controller: scrollController,
                                itemCount: snapshot.data!.data!.length >=
                                        data.totalInitialStudentList
                                    ? snapshot.data!.data!.length + 1
                                    : snapshot.data!.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index < snapshot.data!.data!.length) {
                                    final studentData =
                                        snapshot.data!.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        data.goToFurtherStudyDetailScreen(
                                            context: context,
                                            newsPostId: studentData.id!,
                                            discussCommentCounts: studentData
                                                .attributes!
                                                .discussCommentCounts!,
                                            currentComment: studentData
                                                        .attributes!
                                                        .comments!
                                                        .data ==
                                                    null
                                                ? '0'
                                                : studentData.attributes!
                                                    .comments!.data!.length
                                                    .toString(),
                                            isParent: false);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xFFD0E0F0),
                                                    width: 1))),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: SizeConfig
                                                            .defaultSize),
                                                    child: Text(
                                                      studentData
                                                          .attributes!.title
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              kHelveticaMedium,
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.4,
                                                          color: const Color(
                                                              0xFF000000)),
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/svg/push.svg",
                                                    color: data.getFireColor(
                                                        discussCommentCounts:
                                                            studentData
                                                                .attributes!
                                                                .discussCommentCounts,
                                                        currentCommentCount:
                                                            studentData
                                                                        .attributes!
                                                                        .comments!
                                                                        .data ==
                                                                    null
                                                                ? 0
                                                                : studentData
                                                                    .attributes!
                                                                    .comments!
                                                                    .data!
                                                                    .length),
                                                    height:
                                                        SizeConfig.defaultSize *
                                                            1.3,
                                                    width:
                                                        SizeConfig.defaultSize *
                                                            1.3,
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.defaultSize *
                                                            0.8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          studentData
                                                              .attributes!
                                                              .postedBy!
                                                              .data!
                                                              .attributes!
                                                              .username
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.2,
                                                              color: const Color(
                                                                  0xFF8897A7)),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              SizedBox(
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            right: SizeConfig.defaultSize *
                                                                                0.8),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              const Color(0xFFD1D3D5),
                                                                          size: SizeConfig.defaultSize *
                                                                              1.5,
                                                                        )),
                                                                    Text(
                                                                        data.getFurtherStudiesLikeCount(
                                                                            likeCount: studentData.attributes!.newsPostLikes == null || (studentData.attributes!.newsPostLikes != null && studentData.attributes!.newsPostLikes!.data == null)
                                                                                ? 0
                                                                                : studentData
                                                                                    .attributes!.newsPostLikes!.data!.length,
                                                                            context:
                                                                                context),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                kHelveticaRegular,
                                                                            fontSize: SizeConfig.defaultSize *
                                                                                1.3,
                                                                            color:
                                                                                const Color(0xFF8897A7))),
                                                                    SizedBox(
                                                                      width:
                                                                          SizeConfig.defaultSize *
                                                                              3,
                                                                    ),
                                                                    SizedBox(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: SizeConfig.defaultSize),
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          "assets/svg/comment.svg",
                                                                          color:
                                                                              const Color(0xFFD1D3D5),
                                                                          height:
                                                                              SizeConfig.defaultSize * 1.3,
                                                                          width:
                                                                              SizeConfig.defaultSize * 1.3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      data.getFurtherStudiesCommentCount(
                                                                          commentCount: studentData.attributes!.comments!.data == null
                                                                              ? 0
                                                                              : studentData
                                                                                  .attributes!.comments!.data!.length,
                                                                          context:
                                                                              context),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              kHelveticaRegular,
                                                                          fontSize: SizeConfig.defaultSize *
                                                                              1.3,
                                                                          color:
                                                                              const Color(0xFF8897A7)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.defaultSize * 3),
                                      child: Center(
                                          child: data.studentDiscussHasMore
                                              ? const CircularProgressIndicator(
                                                  color: Color(0xFF5545CF))
                                              : Text(
                                                  AppLocalizations.of(context)
                                                      .caughtUp,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaMedium,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                )),
                                    );
                                  }
                                },
                              ),
                            );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    if (_periodic != null) {
      _periodic!.cancel();
    }
    super.dispose();
  }
}
