import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../../data/models/all_services.dart';
import '../../components/all/all_social_icons.dart';
import '../../components/all/carousel_image_slider.dart';
import '../../components/all/top_app_bar.dart';
import '../../helper/size_configuration.dart';

class ServiceDescriptionScreen extends StatefulWidget {
  final OneService service;
  final ServiceToggleType serviceToggleType;

  const ServiceDescriptionScreen(
      {Key? key, required this.service, required this.serviceToggleType})
      : super(key: key);

  @override
  State<ServiceDescriptionScreen> createState() =>
      _ServiceDescriptionScreenState();
}

class _ServiceDescriptionScreenState extends State<ServiceDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return Scaffold(
          appBar: topAppBar(
              leadingWidget: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: Icon(CupertinoIcons.back,
                    color: const Color(0xFF8897A7),
                    size: SizeConfig.defaultSize * 2.7),
                onPressed: () {
                  data.resetActiveDotIndex();
                  Navigator.pop(context);
                },
              ),
              title: AppLocalizations.of(context).serviceBottomTab,
              widgetList: [
                Builder(builder: (context) {
                  return Container(
                      margin: EdgeInsets.only(right: SizeConfig.defaultSize),
                      color: Colors.transparent,
                      height: SizeConfig.defaultSize * 5.3,
                      width: SizeConfig.defaultSize * 4.8,
                      child: IconButton(
                        splashRadius: SizeConfig.defaultSize * 2.5,
                        icon: SvgPicture.asset("assets/svg/share.svg",
                            color: const Color(0xFF8897A7),
                            height: SizeConfig.defaultSize * 2.3,
                            width: SizeConfig.defaultSize * 2.6),
                        onPressed: () {
                          data.resetActiveDotIndex();
                          // data.shareService(
                          //     serviceId: widget.interestClassId,
                          //     context: context);
                        },
                      ));
                }),
              ]),
          body: StreamBuilder<AllServices?>(
              stream: data.allServicesStreamController.stream,
              builder: ((context, snapshot) {
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 2),
                        child: Column(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.service.mainImage == null ||
                                            widget.service.mainImage == ''
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                right: SizeConfig.defaultSize),
                                            height: SizeConfig.defaultSize * 28,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/no_image.png"),
                                                    fit: BoxFit.fitHeight)),
                                          )
                                        : PinchZoomImage(
                                            image: CachedNetworkImage(
                                              imageUrl: kIMAGEURL +
                                                  widget.service.mainImage
                                                      .toString(),
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            zoomedBackgroundColor:
                                                const Color.fromRGBO(
                                                    240, 240, 240, 1.0),
                                            hideStatusBarWhileZooming: false,
                                            onZoomStart: () {},
                                            onZoomEnd: () {},
                                          ),
                                    SizedBox(
                                      height: SizeConfig.defaultSize * 2,
                                    ),
                                    SizedBox(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: SizeConfig.defaultSize * 28,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await data.toggleServiceSave(
                                                        serviceToggleType: widget
                                                            .serviceToggleType,
                                                        context: context,
                                                        oneService:
                                                            widget.service);
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color(
                                                              0xFFF9F9F9),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFFE6E6E6),
                                                              width: 0.3)),
                                                      height: SizeConfig
                                                              .defaultSize *
                                                          4.5,
                                                      width: SizeConfig
                                                              .defaultSize *
                                                          4.5,
                                                      child: Icon(
                                                        Icons.bookmark,
                                                        color: widget.service
                                                                    .isSaved ==
                                                                1
                                                            ? const Color(
                                                                0xFFA08875)
                                                            : const Color(
                                                                0xFFD1D3D5),
                                                        size: SizeConfig
                                                                .defaultSize *
                                                            3,
                                                      )),
                                                ),
                                                SizedBox(
                                                    width:
                                                        SizeConfig.defaultSize),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.service.title
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                kHelveticaRegular,
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.6),
                                                      ),
                                                      SizedBox(
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              0.8),
                                                      Text(
                                                        '${AppLocalizations.of(context).price}: ${widget.service.price}',
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xFF8897A7),
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.3,
                                                            fontFamily:
                                                                kHelveticaRegular),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.defaultSize,
                                          ),
                                          Expanded(
                                            child: Text(
                                              // data
                                              //             .getCategoryTypeList(
                                              //                 context: context)
                                              //             .map((key, value) =>
                                              //                 MapEntry(
                                              //                     value, key))[
                                              //         courseData
                                              //             .attributes!.type
                                              //             .toString()] ??
                                              //     courseData.attributes!.type
                                              //         .toString(),
                                              widget.service.category
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFFA08875),
                                                  fontFamily: kHelveticaMedium,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.defaultSize * 2,
                                    ),
                                    // interest class description
                                    widget.service.description == null ||
                                            widget.service.description == ''
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.defaultSize * 2),
                                            child: Text(
                                              widget.service.description
                                                  .toString(),
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.45,
                                              ),
                                            ),
                                          ),
                                    // interest class images
                                    widget.service.serviceImages == null ||
                                            widget
                                                .service.serviceImages!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.defaultSize * 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CarouselSlider.builder(
                                                  itemCount: widget.service
                                                      .serviceImages!.length,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    final imageUrl = widget
                                                        .service
                                                        .serviceImages![index]
                                                        .url;
                                                    return buildCarouselImage(
                                                        imageUrl:
                                                            imageUrl.toString(),
                                                        index: index);
                                                  },
                                                  options: CarouselOptions(
                                                      viewportFraction: 1,
                                                      enableInfiniteScroll:
                                                          false,
                                                      enlargeCenterPage: true,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        data.changeDotIndex(
                                                            newIndex: index);
                                                      }),
                                                ),
                                                SizedBox(
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          2,
                                                ),
                                                buildDotIndicator(
                                                    activeIndex:
                                                        data.activeImageIndex,
                                                    count: widget.service
                                                        .serviceImages!.length)
                                              ],
                                            ),
                                          ),
                                    // Contact number
                                    widget.service.phoneNumber == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.defaultSize * 2),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context).contact}: ',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaMedium,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.45),
                                                ),
                                                Link(
                                                  uri: Uri.parse(
                                                      'tel: +852 ${widget.service.phoneNumber}'),
                                                  builder:
                                                      ((context, followLink) =>
                                                          GestureDetector(
                                                            onTap: followLink,
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                widget.service
                                                                    .phoneNumber
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        SizeConfig.defaultSize *
                                                                            1.45,
                                                                    color: const Color(
                                                                        0xFFA08875),
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    fontFamily:
                                                                        kHelveticaRegular),
                                                              ),
                                                            ),
                                                          )),
                                                )
                                              ],
                                            ),
                                          ),
                                    // social media
                                    widget.service.facebookLink == null &&
                                            widget.service.instagramLink ==
                                                null &&
                                            widget.service.twitterLink == null
                                        ? const SizedBox()
                                        : Text(
                                            '${AppLocalizations.of(context).socialMedia}: ',
                                            style: TextStyle(
                                                fontFamily: kHelveticaMedium,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.45),
                                          ),
                                    widget.service.facebookLink == null &&
                                            widget.service.instagramLink ==
                                                null &&
                                            widget.service.twitterLink == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    SizeConfig.defaultSize * 2),
                                            child: AllSocialIcons(
                                              facebookLink:
                                                  widget.service.facebookLink,
                                              instagramLink:
                                                  widget.service.instagramLink,
                                              twitterLink:
                                                  widget.service.twitterLink,
                                              showFacebook:
                                                  widget.service.facebookLink ==
                                                          null
                                                      ? false
                                                      : true,
                                              showTwitter:
                                                  widget.service.twitterLink ==
                                                          null
                                                      ? false
                                                      : true,
                                              showInstagram: widget.service
                                                          .instagramLink ==
                                                      null
                                                  ? false
                                                  : true,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              })));
    });
  }
}
