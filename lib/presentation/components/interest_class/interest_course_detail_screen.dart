import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/all/all_social_icons.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/interest_class/carousel_image_slider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class InterestCourseDetailScreen extends StatefulWidget {
  final String interestClassId;
  final InterestClassSourceType source;

  const InterestCourseDetailScreen(
      {Key? key, required this.interestClassId, required this.source})
      : super(key: key);

  @override
  State<InterestCourseDetailScreen> createState() =>
      _InterestCourseDetailScreenState();
}

class _InterestCourseDetailScreenState
    extends State<InterestCourseDetailScreen> {
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
              title: AppLocalizations.of(context).interestClass,
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
                          data.shareInterestClass(
                              interestClassId: widget.interestClassId,
                              context: context);
                        },
                      ));
                }),
              ]),
          body: StreamBuilder<InterestClass?>(
              stream: widget.source == InterestClassSourceType.filter
                  ? data.filterInterestClassStreamController.stream
                  : widget.source == InterestClassSourceType.search
                      ? data.searchInterestClassStreamController.stream
                      : widget.source == InterestClassSourceType.recommend
                          ? data.allRecommendClassStreamController.stream
                          : widget.source == InterestClassSourceType.fromShare
                              ? data
                                  .fromShareInterestClassStreamController.stream
                              : data.allInterestClassStreamController.stream,
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
                      InterestClassData? courseData;
                      if (widget.source == InterestClassSourceType.fromShare) {
                        // While the source is equal to fromShare, we will always get only one data
                        courseData = snapshot.data!.data![0]!;
                      } else {
                        // Finding the first interest class that matches our final interestClassId attribute
                        courseData = snapshot.data!.data!.firstWhere(
                            (element) =>
                                element!.id.toString() ==
                                widget.interestClassId);
                      }
                      final interestClassCoursSaveData = courseData != null
                          ? courseData.attributes!.interestClassSaves!.data!
                              .firstWhereOrNull((element) =>
                                  element!.attributes!.savedBy!.data != null &&
                                  element.attributes!.savedBy!.data!.id
                                          .toString() ==
                                      data.mainScreenProvider.userId)
                          : null;
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
                                    courseData!.attributes!.mainImage!.data ==
                                            null
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
                                                  courseData
                                                      .attributes!
                                                      .mainImage!
                                                      .data!
                                                      .attributes!
                                                      .url
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
                                                  onTap: () {
                                                    data.toggleInterestClassSave(
                                                        savedInterestClassId: data
                                                                    .mainScreenProvider
                                                                    .savedInterestClassIdList
                                                                    .contains(
                                                                        courseData!
                                                                            .id) &&
                                                                courseData
                                                                        .attributes!
                                                                        .interestClassSaves!
                                                                        .data !=
                                                                    null
                                                            ? interestClassCoursSaveData
                                                                ?.id
                                                                .toString()
                                                            : null,
                                                        source: widget.source,
                                                        context: context,
                                                        interestClassCourseId:
                                                            courseData.id
                                                                .toString());
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
                                                        color: data
                                                                .mainScreenProvider
                                                                .savedInterestClassIdList
                                                                .contains(
                                                                    courseData
                                                                        .id)
                                                            ? const Color(
                                                                0xFF5545CF)
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
                                                        courseData
                                                            .attributes!.brand
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                kHelveticaMedium,
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.6),
                                                      ),
                                                      SizedBox(
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              0.8),
                                                      Text(
                                                        courseData
                                                            .attributes!.title
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
                                                        '${AppLocalizations.of(context).target}: ${data.getTargetAgeList(context: context).map((key, value) => MapEntry(value, key))[courseData.attributes!.targetAge] ?? courseData.attributes!.targetAge}',
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
                                                              MapEntry(
                                                                  value, key))[
                                                      courseData
                                                          .attributes!.type
                                                          .toString()] ??
                                                  courseData.attributes!.type
                                                      .toString(),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFF5545CF),
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
                                    courseData.attributes!.description ==
                                                null ||
                                            courseData
                                                    .attributes!.description ==
                                                ''
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    SizeConfig.defaultSize * 2),
                                            child: Text(
                                              courseData.attributes!.description
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
                                    courseData.attributes!.classImages!.data ==
                                            null
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
                                                  itemCount: courseData
                                                      .attributes!
                                                      .classImages!
                                                      .data!
                                                      .length,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    final imageUrl = courseData!
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
                                                    count: courseData
                                                        .attributes!
                                                        .classImages!
                                                        .data!
                                                        .length)
                                              ],
                                            ),
                                          ),
                                    // Contact number
                                    courseData.attributes!.phoneNumber == null
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
                                                      'tel: +852 ${courseData.attributes!.phoneNumber}'),
                                                  builder:
                                                      ((context, followLink) =>
                                                          GestureDetector(
                                                            onTap: followLink,
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              child: Text(
                                                                courseData!
                                                                    .attributes!
                                                                    .phoneNumber
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        SizeConfig.defaultSize *
                                                                            1.45,
                                                                    color: const Color(
                                                                        0xFF5545CF),
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
                                            courseData
                                                    .attributes!.twitterLink ==
                                                null
                                        ? const SizedBox()
                                        : Text(
                                            '${AppLocalizations.of(context).socialMedia}: ',
                                            style: TextStyle(
                                                fontFamily: kHelveticaMedium,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.45),
                                          ),
                                    courseData.attributes!.facebookLink ==
                                                null &&
                                            courseData.attributes!
                                                    .instagramLink ==
                                                null &&
                                            courseData
                                                    .attributes!.twitterLink ==
                                                null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    SizeConfig.defaultSize * 2),
                                            child: AllSocialIcons(
                                              facebookLink: courseData
                                                  .attributes!.facebookLink,
                                              instagramLink: courseData
                                                  .attributes!.instagramLink,
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
                                            courseData.attributes!.website == ''
                                        ? const SizedBox()
                                        : Link(
                                            target: LinkTarget.self,
                                            uri: Uri.parse(courseData
                                                .attributes!.website
                                                .toString()),
                                            builder: (context, followLink) =>
                                                RectangularButton(
                                                    onPress: followLink,
                                                    width: double.infinity,
                                                    height:
                                                        SizeConfig.defaultSize *
                                                            5.5,
                                                    buttonColor:
                                                        const Color(0xFFFEB703),
                                                    text: AppLocalizations
                                                            .of(context)
                                                        .joinNow,
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
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 3,
                                                    textPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: SizeConfig
                                                                    .defaultSize *
                                                                2)),
                                          ),

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
