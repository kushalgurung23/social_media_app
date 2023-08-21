import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/interest_class_enum.dart';
import 'package:c_talent/data/models/bookmark_interest_class_model.dart';
import 'package:c_talent/data/models/interest_class_model.dart';
import 'package:c_talent/logic/providers/interest_class_provider.dart';
import 'package:c_talent/presentation/components/all/all_social_icons.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/interest_class/carousel_image_slider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkInterestClassDetailScreen extends StatefulWidget {
  final String interestClassId;
  final InterestClassSourceType source;
  final String? savedInterestClassId;

  const BookmarkInterestClassDetailScreen(
      {Key? key,
      required this.interestClassId,
      required this.source,
      required this.savedInterestClassId})
      : super(key: key);

  @override
  State<BookmarkInterestClassDetailScreen> createState() =>
      _BookmarkInterestClassDetailScreenState();
}

class _BookmarkInterestClassDetailScreenState
    extends State<BookmarkInterestClassDetailScreen> {
  @override
  void initState() {
    if (widget.source == InterestClassSourceType.fromShare) {
      Provider.of<InterestClassProvider>(context, listen: false)
          .getOneInterestClassForSharedInterestClass(
              context: context, interestClassId: widget.interestClassId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
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
                          data.shareService(
                              serviceId: widget.interestClassId,
                              context: context);
                        },
                      ));
                }),
              ]),
          body: !data.mainScreenProvider.savedInterestClassIdList
                  .contains(int.parse(widget.interestClassId))
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .interestClassRemovedFromBookmark,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  ),
                )
              : StreamBuilder<BookmarkInterestClass?>(
                  stream: data.bookmarkInterestClassStreamController.stream,
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
                        } else if ((snapshot.data!.data!.firstWhere((element) =>
                                element!.attributes!.interestClass!.data!.id
                                    .toString() ==
                                widget.interestClassId)) ==
                            null) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .interestClassIsRemoved,
                              style: TextStyle(
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5),
                            ),
                          );
                        } else {
                          // Finding the first interest class that matches our final interestClassId attribute
                          InterestClassData? courseData = snapshot.data!.data!
                              .firstWhere((element) =>
                                  element!.attributes!.interestClass!.data!.id
                                      .toString() ==
                                  widget.interestClassId)!
                              .attributes!
                              .interestClass!
                              .data!;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize * 2),
                            child: Column(
                              children: [
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        courseData.attributes!.mainImage!
                                                    .data ==
                                                null
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    right:
                                                        SizeConfig.defaultSize),
                                                height:
                                                    SizeConfig.defaultSize * 28,
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
                                                      courseData
                                                          .attributes!
                                                          .mainImage!
                                                          .data!
                                                          .attributes!
                                                          .url
                                                          .toString(),
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                                zoomedBackgroundColor:
                                                    const Color.fromRGBO(
                                                        240, 240, 240, 1.0),
                                                hideStatusBarWhileZooming:
                                                    false,
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
                                                width:
                                                    SizeConfig.defaultSize * 28,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        data.toggleInterestClassSave(
                                                            savedInterestClassId:
                                                                widget
                                                                    .savedInterestClassId,
                                                            source:
                                                                widget.source,
                                                            context: context,
                                                            interestClassCourseId:
                                                                courseData.id
                                                                    .toString());
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  const Color(
                                                                      0xFFF9F9F9),
                                                              border: Border.all(
                                                                  color:
                                                                      const Color(
                                                                          0xFFE6E6E6),
                                                                  width: 0.3)),
                                                          height:
                                                              SizeConfig
                                                                      .defaultSize *
                                                                  4.5,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              4.5,
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            color: data
                                                                    .mainScreenProvider
                                                                    .savedInterestClassIdList
                                                                    .contains(
                                                                        courseData
                                                                            .id)
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
                                                        width: SizeConfig
                                                            .defaultSize),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            courseData
                                                                .attributes!
                                                                .title
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
                                                            '${AppLocalizations.of(context).price}: ${courseData.attributes!.price}',
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
                                                  data
                                                          .getCategoryTypeList(
                                                              context: context)
                                                          .map((key, value) =>
                                                              MapEntry(value,
                                                                  key))[courseData
                                                          .attributes!.type
                                                          .toString()] ??
                                                      courseData
                                                          .attributes!.type
                                                          .toString(),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xFFA08875),
                                                      fontFamily:
                                                          kHelveticaMedium,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
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
                                        courseData.attributes!.description ==
                                                    null ||
                                                courseData.attributes!
                                                        .description ==
                                                    ''
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.defaultSize *
                                                            2),
                                                child: Text(
                                                  courseData
                                                      .attributes!.description
                                                      .toString(),
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.45,
                                                  ),
                                                ),
                                              ),
                                        // interest class images
                                        courseData.attributes!.classImages!
                                                    .data ==
                                                null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.defaultSize *
                                                            2),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CarouselSlider.builder(
                                                      itemCount: courseData
                                                          .attributes!
                                                          .classImages!
                                                          .data!
                                                          .length,
                                                      itemBuilder: (context,
                                                          index, realIndex) {
                                                        final imageUrl =
                                                            courseData
                                                                .attributes!
                                                                .classImages!
                                                                .data![index];
                                                        return buildImage(
                                                            imageUrl: imageUrl!
                                                                .attributes!.url
                                                                .toString(),
                                                            index: index);
                                                      },
                                                      options: CarouselOptions(
                                                          viewportFraction: 1,
                                                          enableInfiniteScroll:
                                                              false,
                                                          enlargeCenterPage:
                                                              true,
                                                          onPageChanged:
                                                              (index, reason) {
                                                            data.changeDotIndex(
                                                                newIndex:
                                                                    index);
                                                          }),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .defaultSize *
                                                          2,
                                                    ),
                                                    buildDotIndicator(
                                                        activeIndex: data
                                                            .activeImageIndex,
                                                        count: courseData
                                                            .attributes!
                                                            .classImages!
                                                            .data!
                                                            .length)
                                                  ],
                                                ),
                                              ),

                                        // Contact number
                                        courseData.attributes!.phoneNumber ==
                                                null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.defaultSize *
                                                            2),
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
                                                          '${AppLocalizations.of(context).tel}: +852 ${courseData.attributes!.phoneNumber}'),
                                                      builder: ((context,
                                                              followLink) =>
                                                          GestureDetector(
                                                            onTap: followLink,
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                courseData
                                                                    .attributes!
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
                                        courseData.attributes!.facebookLink ==
                                                    null &&
                                                courseData.attributes!
                                                        .instagramLink ==
                                                    null &&
                                                courseData.attributes!
                                                        .twitterLink ==
                                                    null
                                            ? const SizedBox()
                                            : Text(
                                                '${AppLocalizations.of(context).socialMedia}: ',
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaMedium,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.45),
                                              ),
                                        courseData.attributes!.facebookLink ==
                                                    null &&
                                                courseData.attributes!
                                                        .instagramLink ==
                                                    null &&
                                                courseData.attributes!
                                                        .twitterLink ==
                                                    null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.defaultSize *
                                                            2),
                                                child: AllSocialIcons(
                                                  facebookLink: courseData
                                                      .attributes!.facebookLink,
                                                  instagramLink: courseData
                                                      .attributes!
                                                      .instagramLink,
                                                  twitterLink: courseData
                                                      .attributes!.twitterLink,
                                                  showFacebook: courseData
                                                              .attributes!
                                                              .facebookLink ==
                                                          null
                                                      ? false
                                                      : true,
                                                  showTwitter: courseData
                                                              .attributes!
                                                              .twitterLink ==
                                                          null
                                                      ? false
                                                      : true,
                                                  showInstagram: courseData
                                                              .attributes!
                                                              .instagramLink ==
                                                          null
                                                      ? false
                                                      : true,
                                                ),
                                              ),
                                        courseData.attributes!.website == null ||
                                                courseData.attributes!.website ==
                                                    ''
                                            ? const SizedBox()
                                            : Link(
                                                target: LinkTarget.self,
                                                uri: Uri.parse(courseData
                                                    .attributes!.website
                                                    .toString()),
                                                builder: ((context, followLink) => RectangularButton(
                                                    width: double.infinity,
                                                    height: SizeConfig.defaultSize *
                                                        5.5,
                                                    buttonColor:
                                                        const Color(0xFFFEB703),
                                                    text: AppLocalizations.of(context)
                                                        .bookNow,
                                                    textColor:
                                                        const Color(0xFFF1F0F1),
                                                    borderColor: Colors.white,
                                                    borderRadius: 10,
                                                    fontFamily:
                                                        kHelveticaMedium,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.6,
                                                    keepBoxShadow: true,
                                                    onPress: followLink,
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 3,
                                                    textPadding:
                                                        EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2)))),
                                        SizedBox(
                                          height: SizeConfig.defaultSize * 2,
                                        )
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
