import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/interest_class_enum.dart';
import 'package:c_talent/data/models/interest_class_model.dart';
import 'package:c_talent/logic/providers/interest_class_provider.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/interest_class/bookmark_interest_class_detail_screen.dart';
import 'package:c_talent/presentation/components/interest_class/interest_course_detail_screen.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class InterestCourseContainer extends StatelessWidget {
  final InterestClassData interestClassData;
  final InterestClassSourceType source;
  final String? interestClassBookmarkId;

  const InterestCourseContainer(
      {Key? key,
      required this.interestClassData,
      required this.source,
      required this.interestClassBookmarkId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
      return StreamBuilder<InterestClass?>(
          stream: source == InterestClassSourceType.filter
              ? data.filterInterestClassStreamController.stream
              : source == InterestClassSourceType.search
                  ? data.searchInterestClassStreamController.stream
                  : source == InterestClassSourceType.recommend
                      ? data.allRecommendClassStreamController.stream
                      : source == InterestClassSourceType.fromShare
                          ? data.fromShareInterestClassStreamController.stream
                          : data.allInterestClassStreamController.stream,
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const SizedBox();
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
                  if (source == InterestClassSourceType.fromShare) {
                    // While the source is equal to fromShare, we will always get only one data
                    courseData = snapshot.data!.data![0]!;
                  } else {
                    // Finding the first interest class that matches our final interestClassId attribute
                    courseData = snapshot.data!.data!.firstWhereOrNull(
                        (element) =>
                            element!.id.toString() ==
                            interestClassData.id.toString());
                  }
                  final interestClassCoursSaveData = courseData != null &&
                          courseData.attributes!.interestClassSaves != null
                      ? courseData.attributes!.interestClassSaves!.data!
                          .firstWhereOrNull((element) =>
                              element!.attributes!.savedBy!.data != null &&
                              element.attributes!.savedBy!.data!.id
                                      .toString() ==
                                  data.mainScreenProvider.currentUserId)
                      : null;
                  return Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: const Color(0xFFA08875).withOpacity(0.22),
                              offset: const Offset(0, 1))
                        ]),
                    child: Column(
                      children: [
                        courseData!.attributes!.mainImage == null
                            ? Container(
                                height: SizeConfig.defaultSize * 13,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/no_image.png"),
                                      fit: BoxFit.cover),
                                ))
                            : ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: PinchZoomImage(
                                  image: CachedNetworkImage(
                                    imageUrl: kIMAGEURL +
                                        courseData.attributes!.mainImage
                                            .toString(),
                                    height: SizeConfig.defaultSize * 16,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: SizeConfig.defaultSize * 13,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Color(0xFFD0E0F0),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  zoomedBackgroundColor:
                                      const Color.fromRGBO(240, 240, 240, 1.0),
                                  hideStatusBarWhileZooming: false,
                                  onZoomStart: () {},
                                  onZoomEnd: () {},
                                ),
                              ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.defaultSize * 1.5,
                              horizontal: SizeConfig.defaultSize * 1.5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        courseData.attributes!.title.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.6),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.defaultSize,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.defaultSize * 9.5,
                                      child: Text(
                                        data
                                                    .getCategoryTypeList(
                                                        context: context)
                                                    .map((key, value) =>
                                                        MapEntry(value, key))[
                                                courseData.attributes!.type
                                                    .toString()] ??
                                            courseData.attributes!.type
                                                .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: const Color(0xFFA08875),
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                                courseData.attributes!.brand == null
                                    ? SizedBox(
                                        height: SizeConfig.defaultSize * 1.5,
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.defaultSize * 1.5),
                                        child: Text(
                                          courseData.attributes!.brand
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.3,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 1.5),
                                  child: Text(
                                    "${AppLocalizations.of(context).price}: ${courseData.attributes?.price.toString()}",
                                    style: TextStyle(
                                        color: const Color(0xFF8897A7),
                                        fontSize: SizeConfig.defaultSize * 1.3,
                                        fontFamily: kHelveticaRegular),
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // data.toggleInterestClassSave(
                                        //     savedInterestClassId: source ==
                                        //             InterestClassSourceType
                                        //                 .bookmark
                                        //         ? (data.mainScreenProvider
                                        //                     .savedInterestClassIdList
                                        //                     .contains(
                                        //                         courseData!
                                        //                             .id) &&
                                        //                 interestClassBookmarkId !=
                                        //                     null
                                        //             ? interestClassBookmarkId
                                        //                 .toString()
                                        //             : null)
                                        //         : (data.mainScreenProvider
                                        //                 .savedInterestClassIdList
                                        //                 .contains(
                                        //                     courseData!.id)
                                        //             ? interestClassCoursSaveData
                                        //                 ?.id
                                        //                 .toString()
                                        //             : null),
                                        //     source: source,
                                        //     context: context,
                                        //     interestClassCourseId:
                                        //         courseData.id.toString());
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xFFF9F9F9),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFE6E6E6),
                                                  width: 0.3)),
                                          height: SizeConfig.defaultSize * 4.5,
                                          width: SizeConfig.defaultSize * 4.5,
                                          child: Icon(
                                            Icons.bookmark,
                                            color: const Color(0xFFD1D3D5),
                                            size: SizeConfig.defaultSize * 3,
                                          )),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.defaultSize * 1.5,
                                    ),
                                    Expanded(
                                        child: RectangularButton(
                                            height:
                                                SizeConfig.defaultSize * 4.5,
                                            buttonColor:
                                                const Color(0xFFFEB703),
                                            text: AppLocalizations.of(context)
                                                .viewDetails,
                                            textColor: const Color(0xFFF1F0F1),
                                            borderColor: Colors.white,
                                            borderRadius: 10,
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.3,
                                            keepBoxShadow: true,
                                            onPress: () {
                                              source ==
                                                      InterestClassSourceType
                                                          .bookmark
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookmarkInterestClassDetailScreen(
                                                                savedInterestClassId:
                                                                    interestClassBookmarkId,
                                                                source: source,
                                                                interestClassId:
                                                                    courseData!
                                                                        .id
                                                                        .toString(),
                                                              )))
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InterestCourseDetailScreen(
                                                                source: source,
                                                                interestClassId:
                                                                    courseData!
                                                                        .id
                                                                        .toString(),
                                                              )));
                                            },
                                            offset: const Offset(0, 1),
                                            blurRadius: 3,
                                            textPadding: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.defaultSize)))
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                  );
                }
            }
          }));
    });
  }
}
