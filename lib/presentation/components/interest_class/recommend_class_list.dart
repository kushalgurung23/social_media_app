import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/interest_class_enum.dart';
import 'package:c_talent/data/models/interest_class_model.dart';
import 'package:c_talent/logic/providers/interest_class_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/components/interest_class/interest_course_detail_screen.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendClassList extends StatefulWidget {
  const RecommendClassList({Key? key}) : super(key: key);

  @override
  State<RecommendClassList> createState() => _RecommendClassListState();
}

class _RecommendClassListState extends State<RecommendClassList> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // Loading recommend class
    Provider.of<InterestClassProvider>(context, listen: false)
        .getInitialRecommendClass(context: context);

    // this will load more data when we reach the end of paper share
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    await Provider.of<InterestClassProvider>(context, listen: false)
        .loadMoreRecommendClass(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
      return StreamBuilder<InterestClass?>(
          stream: data.allRecommendClassStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: SizedBox(
                    height: SizeConfig.defaultSize * 22.5,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).loading,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    ),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 2),
                    child: SizedBox(
                      height: SizeConfig.defaultSize * 22.5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 2),
                    child: SizedBox(
                      height: SizeConfig.defaultSize * 22.5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).dataCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    ),
                  );
                } else {
                  return snapshot.data!.data!.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: SizedBox(
                            height: SizeConfig.defaultSize * 22.5,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).noRecommendClass,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: SizeConfig.defaultSize * 22.5,
                          child: RefreshIndicator(
                            onRefresh: () =>
                                data.recommendClassRefresh(context: context),
                            child: ListView.builder(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.data!.length >= 15
                                    ? snapshot.data!.data!.length + 1
                                    : snapshot.data!.data!.length,
                                itemBuilder: (context, index) {
                                  if (index < snapshot.data!.data!.length) {
                                    final interestClassId = snapshot
                                        .data!.data![index]!.id
                                        .toString();
                                    final interestClass =
                                        snapshot.data!.data![index]!.attributes;
                                    return Padding(
                                      padding: index == 0
                                          ? EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize * 2)
                                          : EdgeInsets.only(
                                              right:
                                                  SizeConfig.defaultSize * 2),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InterestCourseDetailScreen(
                                                              source:
                                                                  InterestClassSourceType
                                                                      .recommend,
                                                              interestClassId:
                                                                  interestClassId)));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 1),
                                                        blurRadius: 3,
                                                        color: const Color(
                                                                0xFFA08875)
                                                            .withOpacity(0.22))
                                                  ]),
                                              height:
                                                  SizeConfig.defaultSize * 22,
                                              width:
                                                  SizeConfig.defaultSize * 16,
                                              child: Column(children: [
                                                interestClass!
                                                            .mainImage!.data ==
                                                        null
                                                    ? Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            13,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            16,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/no_image.png"),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ))
                                                    : ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15),
                                                        ),
                                                        child: PinchZoomImage(
                                                          image:
                                                              CachedNetworkImage(
                                                            imageUrl: kIMAGEURL +
                                                                interestClass
                                                                    .mainImage!
                                                                    .data!
                                                                    .attributes!
                                                                    .url
                                                                    .toString(),
                                                            height: SizeConfig
                                                                    .defaultSize *
                                                                13,
                                                            width: SizeConfig
                                                                    .defaultSize *
                                                                16,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              height: SizeConfig
                                                                      .defaultSize *
                                                                  13,
                                                              width: SizeConfig
                                                                      .defaultSize *
                                                                  16,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                                color: Color(
                                                                    0xFFD0E0F0),
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                          zoomedBackgroundColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  240,
                                                                  240,
                                                                  240,
                                                                  1.0),
                                                          hideStatusBarWhileZooming:
                                                              false,
                                                          onZoomStart: () {},
                                                          onZoomEnd: () {},
                                                        ),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: SizeConfig
                                                          .defaultSize),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: SizeConfig
                                                              .defaultSize,
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                interestClass
                                                                    .title
                                                                    .toString(),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        kHelveticaMedium,
                                                                    fontSize:
                                                                        SizeConfig.defaultSize *
                                                                            1.1),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig
                                                                  .defaultSize,
                                                            ),
                                                            SizedBox(
                                                              width: SizeConfig
                                                                      .defaultSize *
                                                                  6.5,
                                                              child: Text(
                                                                data.getCategoryTypeList(context: context).map((key,
                                                                            value) =>
                                                                        MapEntry(
                                                                            value,
                                                                            key))[interestClass
                                                                        .type
                                                                        .toString()] ??
                                                                    interestClass
                                                                        .type
                                                                        .toString(),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    color: const Color(
                                                                        0xFFA08875),
                                                                    fontFamily:
                                                                        kHelveticaMedium,
                                                                    fontSize:
                                                                        SizeConfig.defaultSize *
                                                                            1.1),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: SizeConfig
                                                                .defaultSize),
                                                        child: Text(
                                                          "${AppLocalizations.of(context).price}: ${interestClass.price.toString()}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xFF8897A7),
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.defaultSize,
                                          right: SizeConfig.defaultSize * 3),
                                      child: Center(
                                          child: data.recommendClassHasMore
                                              ? const CircularProgressIndicator(
                                                  color: Color(0xFFA08875))
                                              : Text(
                                                  AppLocalizations.of(context)
                                                      .caughtUp,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                )),
                                    );
                                  }
                                }),
                          ),
                        );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
