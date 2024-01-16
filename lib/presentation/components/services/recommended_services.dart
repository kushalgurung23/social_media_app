import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class RecommendedServices extends StatefulWidget {
  const RecommendedServices({Key? key}) : super(key: key);

  @override
  State<RecommendedServices> createState() => _RecommendedServicesState();
}

class _RecommendedServicesState extends State<RecommendedServices> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // Loading recommend class
    Provider.of<ServicesProvider>(context, listen: false)
        .loadRecommendedServices(context: context);

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
    await Provider.of<ServicesProvider>(context, listen: false)
        .loadMoreRecommendedServices(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllServices?>(
          stream: data.recommendedServStrmContrller.stream,
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
                  return snapshot.data?.services == null ||
                          snapshot.data!.services!.isEmpty
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
                          height: SizeConfig.defaultSize * 23.5,
                          child: ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.services!.length >= 10
                                  ? snapshot.data!.services!.length + 1
                                  : snapshot.data!.services!.length,
                              itemBuilder: (context, index) {
                                if (index < snapshot.data!.services!.length) {
                                  final oneService =
                                      snapshot.data!.services![index];
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.defaultSize * 2)
                                        : EdgeInsets.only(
                                            right: SizeConfig.defaultSize * 2),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            data.goToServicesDescriptionScreen(
                                                serviceToggleType:
                                                    ServiceToggleType
                                                        .recommendService,
                                                context: context,
                                                service: oneService.service);
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
                                            height: SizeConfig.defaultSize * 23,
                                            width: SizeConfig.defaultSize * 16,
                                            child: Column(children: [
                                              oneService.service == null ||
                                                      oneService.service
                                                              ?.mainImage ==
                                                          null ||
                                                      oneService.service
                                                              ?.mainImage ==
                                                          ''
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
                                                            fit: BoxFit.cover),
                                                      ))
                                                  : ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15),
                                                      ),
                                                      child: PinchZoomImage(
                                                        image:
                                                            CachedNetworkImage(
                                                          imageUrl: kIMAGEURL +
                                                              oneService
                                                                  .service!
                                                                  .mainImage
                                                                  .toString(),
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              13,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              16,
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) =>
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
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
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
                                                    horizontal:
                                                        SizeConfig.defaultSize),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                              oneService
                                                                  .service!
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
                                                                      SizeConfig
                                                                              .defaultSize *
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
                                                              // data.getCategoryTypeList(context: context).map((key,
                                                              //             value) =>
                                                              //         MapEntry(
                                                              //             value,
                                                              //             key))[services
                                                              //         .type
                                                              //         .toString()] ??
                                                              //     services.type
                                                              //         .toString(),
                                                              oneService
                                                                  .service!
                                                                  .category
                                                                  .toString(),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  color: const Color(
                                                                      0xFFA08875),
                                                                  fontFamily:
                                                                      kHelveticaMedium,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .defaultSize *
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
                                                        "${AppLocalizations.of(context).price}: ${oneService.service!.price.toString()}",
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
                                        child: data.recmdServicesHasMore
                                            ? const CircularProgressIndicator(
                                                color: Color(0xFFA08875))
                                            : Text(
                                                AppLocalizations.of(context)
                                                    .caughtUp,
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                              )),
                                  );
                                }
                              }),
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
