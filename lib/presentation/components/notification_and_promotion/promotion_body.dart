import 'package:c_talent/data/models/all_promotions.dart';
import 'package:c_talent/logic/providers/promotion_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/link.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class PromotionBody extends StatefulWidget {
  const PromotionBody({super.key});

  @override
  State<PromotionBody> createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<PromotionProvider>(context, listen: false)
        .loadInitialPromotions(context: context);

    // this will load more data when we reach the end of services
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMorePromotions();
      }
    });
    super.initState();
  }

  void loadMorePromotions() async {
    await Provider.of<PromotionProvider>(context, listen: false)
        .loadMorePromotions(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PromotionProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllPromotions?>(
            stream: data.allPromotionsStreamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(AppLocalizations.of(context).loading,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
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
                    return snapshot.data?.promotions == null ||
                            snapshot.data!.promotions!.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.promotionsIsLoading == true ||
                                        data.isRefreshingPromotions
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context).noPromotions,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          )
                        : snapshot.data!.promotions!.isEmpty &&
                                data.isRefreshingPromotions == true
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context).reloading,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kHelveticaRegular,
                                        fontSize:
                                            SizeConfig.defaultSize * 1.5)))
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 2),
                                child: RefreshIndicator(
                                  onRefresh: () =>
                                      data.refreshPromotions(context: context),
                                  child: ListView.builder(
                                      controller: scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      itemCount: snapshot
                                                  .data!.promotions!.length >=
                                              10
                                          ? snapshot.data!.promotions!.length +
                                              1
                                          : snapshot.data!.promotions!.length,
                                      itemBuilder: (context, index) {
                                        if (index <
                                            snapshot.data!.promotions!.length) {
                                          final onePromotion =
                                              snapshot.data!.promotions![index];

                                          return Link(
                                            target: LinkTarget.self,
                                            uri: Uri.parse(onePromotion
                                                .promotionalLink
                                                .toString()),
                                            builder:
                                                ((context, followLink) =>
                                                    GestureDetector(
                                                      onTap: followLink,
                                                      child: Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            11,
                                                        margin: index == 0
                                                            ? EdgeInsets.only(
                                                                top: SizeConfig
                                                                    .defaultSize,
                                                                bottom: SizeConfig
                                                                    .defaultSize)
                                                            : EdgeInsets.only(
                                                                bottom: SizeConfig
                                                                    .defaultSize),
                                                        padding: EdgeInsets.all(
                                                            SizeConfig
                                                                .defaultSize),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: const Color(
                                                                        0xFF000000)
                                                                    .withOpacity(
                                                                        0.16),
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                                blurRadius: 3)
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            onePromotion.image ==
                                                                    null
                                                                ? Container(
                                                                    height:
                                                                        SizeConfig.defaultSize *
                                                                            9,
                                                                    width: SizeConfig
                                                                            .defaultSize *
                                                                        9,
                                                                    decoration: const BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/no_image.png"),
                                                                            fit: BoxFit.cover)),
                                                                  )
                                                                : PinchZoomImage(
                                                                    image:
                                                                        CachedNetworkImage(
                                                                      height:
                                                                          SizeConfig.defaultSize *
                                                                              9,
                                                                      width:
                                                                          SizeConfig.defaultSize *
                                                                              9,
                                                                      imageUrl:
                                                                          kIMAGEURL +
                                                                              onePromotion.image,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Container(
                                                                        height:
                                                                            SizeConfig.defaultSize *
                                                                                9,
                                                                        width:
                                                                            SizeConfig.defaultSize *
                                                                                9,
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Color(0xFFD0E0F0),
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    ),
                                                                    zoomedBackgroundColor:
                                                                        const Color.fromRGBO(
                                                                            240,
                                                                            240,
                                                                            240,
                                                                            1.0),
                                                                    hideStatusBarWhileZooming:
                                                                        false,
                                                                    onZoomStart:
                                                                        () {},
                                                                    onZoomEnd:
                                                                        () {},
                                                                  ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: SizeConfig
                                                                          .defaultSize),
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        SizeConfig.defaultSize *
                                                                            10,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          onePromotion
                                                                              .title
                                                                              .toString(),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                kHelveticaMedium,
                                                                            fontSize:
                                                                                SizeConfig.defaultSize * 1.4,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: SizeConfig.defaultSize * 0.2),
                                                                          child:
                                                                              Text(
                                                                            onePromotion.subTitle.toString(),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(
                                                                              height: 1.3,
                                                                              fontFamily: kHelveticaRegular,
                                                                              fontSize: SizeConfig.defaultSize * 1.25,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: SizeConfig.defaultSize * 0.4),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Text(
                                                                                data.mainScreenProvider.convertDateTimeToAgo(onePromotion.createdAt!, context),
                                                                                style: TextStyle(
                                                                                  height: 1.3,
                                                                                  color: const Color(0xFF8897A7),
                                                                                  fontFamily: kHelveticaRegular,
                                                                                  fontSize: SizeConfig.defaultSize * 1.05,
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    SizeConfig.defaultSize * 3),
                                            child: Center(
                                                child: data.promotionsHasMore
                                                    ? const CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFA08875))
                                                    : Text(
                                                        AppLocalizations.of(
                                                                context)
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
                                      }),
                                ),
                              );
                  }
              }
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
