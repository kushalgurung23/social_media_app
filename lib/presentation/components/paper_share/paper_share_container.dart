import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/paper_share/paper_topic.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class PaperShareContainer extends StatefulWidget {
  final PaperShare paperShare;
  final PaperShareSourceType? source;
  final String? paperShareSaveId;

  const PaperShareContainer(
      {Key? key,
      required this.paperShare,
      required this.source,
      required this.paperShareSaveId})
      : super(key: key);

  @override
  State<PaperShareContainer> createState() => _PaperShareContainerState();
}

class _PaperShareContainerState extends State<PaperShareContainer>
    with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? result;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PaperShareProvider>(builder: (context, data, child) {
      return StreamBuilder<AllPaperShare>(
          stream: widget.source == PaperShareSourceType.filter
              ? data.filterShareStreamController.stream
              : widget.source == PaperShareSourceType.search
                  ? data.searchPaperStreamController.stream
                  : widget.source == PaperShareSourceType.fromShare
                      ? data.fromSharePaperShareStreamController.stream
                      : data.paperShareStreamController.stream,
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
                } else if (snapshot.data!.data.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).paperShareIsEmpty,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  PaperShare? paperData;
                  // Finding the first paper share that matches our final paperShareId attribute

                  // While the source is equal to fromShare, we will always get only one data
                  if (widget.source == PaperShareSourceType.fromShare) {
                    paperData = snapshot.data!.data[0];
                  } else {
                    paperData = snapshot.data!.data.firstWhereOrNull(
                        (element) => element.id == widget.paperShare.id);
                  }
                  if (paperData == null) {
                    return const SizedBox();
                  } else {
                    // blocked and deleted users won't be included
                    List<PaperShareDiscussesData?>? totalDiscussCountList;
                    if (paperData.attributes != null &&
                        paperData.attributes!.paperShareDiscusses != null &&
                        paperData.attributes!.paperShareDiscusses!.data !=
                            null) {
                      totalDiscussCountList = paperData
                          .attributes!.paperShareDiscusses!.data!
                          .where((element) =>
                              element != null &&
                              element.attributes != null &&
                              element.attributes!.discussedBy != null &&
                              element.attributes!.discussedBy!.data != null &&
                              !data.mainScreenProvider.blockedUsersIdList
                                  .contains(element
                                      .attributes!.discussedBy!.data!.id))
                          .toList();
                    }

                    return GestureDetector(
                      onTap: () {
                        data.navigateToPaperDescription(
                            savedPaperShareId: widget.paperShareSaveId,
                            context: context,
                            paperShareId: paperData!.id!,
                            source: widget.source);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 0.3,
                            bottom: SizeConfig.defaultSize * 1.2,
                            left: SizeConfig.defaultSize * 0.5,
                            right: SizeConfig.defaultSize * 0.5),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize * 0.8,
                            horizontal: SizeConfig.defaultSize),
                        height: SizeConfig.defaultSize * 12,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: const Color(0xFF000000).withOpacity(0.16))
                        ]),
                        child: Row(
                          children: [
                            paperData.attributes!.image!.data == null
                                ? Container(
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.defaultSize),
                                    height: SizeConfig.defaultSize * 10,
                                    width: SizeConfig.defaultSize * 10,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/no_image.png"),
                                            fit: BoxFit.fitHeight)),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        right: SizeConfig.defaultSize),
                                    child: PinchZoomImage(
                                      image: CachedNetworkImage(
                                        height: SizeConfig.defaultSize * 10,
                                        width: SizeConfig.defaultSize * 10,
                                        imageUrl: kIMAGEURL +
                                            paperData.attributes!.image!
                                                .data![0]!.attributes!.url
                                                .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: SizeConfig.defaultSize * 10,
                                          width: SizeConfig.defaultSize * 10,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFD0E0F0),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      zoomedBackgroundColor:
                                          const Color.fromRGBO(
                                              240, 240, 240, 1.0),
                                      hideStatusBarWhileZooming: false,
                                      onZoomStart: () {},
                                      onZoomEnd: () {},
                                    ),
                                  ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.defaultSize * 0.3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          PaperTopic(
                                            category:
                                                AppLocalizations.of(context)
                                                    .subject,
                                            categoryValue: data
                                                        .getSubjectList(
                                                            context: context)
                                                        .map((key, value) =>
                                                            MapEntry(
                                                                value, key))[
                                                    paperData
                                                        .attributes!.subject
                                                        .toString()] ??
                                                paperData.attributes!.subject
                                                    .toString(),
                                            categoryFontSize:
                                                SizeConfig.defaultSize * 1.1,
                                            categoryValueFontSize:
                                                SizeConfig.defaultSize * 1.2,
                                          ),
                                          PaperTopic(
                                            category:
                                                AppLocalizations.of(context)
                                                    .level,
                                            categoryValue: data
                                                        .getLevelList(
                                                            context: context)
                                                        .map((key, value) =>
                                                            MapEntry(
                                                                value, key))[
                                                    paperData.attributes!.level
                                                        .toString()] ??
                                                paperData.attributes!.level
                                                    .toString(),
                                            categoryFontSize:
                                                SizeConfig.defaultSize * 1.1,
                                            categoryValueFontSize:
                                                SizeConfig.defaultSize * 1.2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PaperTopic(
                                          category: AppLocalizations.of(context)
                                              .semester,
                                          categoryValue: data
                                                      .getSemesterList(
                                                          context: context)
                                                      .map((key, value) =>
                                                          MapEntry(value, key))[
                                                  paperData.attributes!.semester
                                                      .toString()] ??
                                              paperData.attributes!.semester
                                                  .toString(),
                                          categoryFontSize:
                                              SizeConfig.defaultSize * 1.1,
                                          categoryValueFontSize:
                                              SizeConfig.defaultSize * 1.2,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            data.togglePaperShareSave(
                                                savedPaperShareId: widget.source ==
                                                        PaperShareSourceType
                                                            .bookmark
                                                    ? (data.mainScreenProvider.savedPaperShareIdList.contains(paperData!.id) &&
                                                            widget.paperShareSaveId !=
                                                                null
                                                        ? widget
                                                            .paperShareSaveId
                                                            .toString()
                                                        : null)
                                                    : paperData!
                                                                .attributes!
                                                                .savedPaperShare!
                                                                .data ==
                                                            null
                                                        ? null
                                                        : (data.mainScreenProvider.savedPaperShareIdList.contains(paperData.id) &&
                                                                paperData
                                                                    .attributes!
                                                                    .savedPaperShare!
                                                                    .data!
                                                                    .isNotEmpty
                                                            ? paperData
                                                                .attributes!
                                                                .savedPaperShare!
                                                                .data!
                                                                .firstWhere(
                                                                    (element) => element != null && element.attributes!.savedBy!.data!.id.toString() == data.mainScreenProvider.userId)!
                                                                .id
                                                                .toString()
                                                            : null),
                                                source: widget.source!,
                                                context: context,
                                                paperShareId: paperData.id.toString());
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: SvgPicture.asset(
                                            "assets/svg/bookmark_fill.svg",
                                            height: SizeConfig.defaultSize * 2,
                                            width: SizeConfig.defaultSize * 2,
                                            color: data.mainScreenProvider
                                                    .savedPaperShareIdList
                                                    .contains(paperData.id)
                                                ? const Color(0xFF5545CF)
                                                : const Color(0xFFA0A0A0),
                                          ),
                                          splashRadius:
                                              SizeConfig.defaultSize * 2.5,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          child: Row(children: [
                                            SvgPicture.asset(
                                              "assets/svg/comment.svg",
                                              color: const Color(0xFFD1D3D5),
                                              height:
                                                  SizeConfig.defaultSize * 1.15,
                                              width:
                                                  SizeConfig.defaultSize * 1.15,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.defaultSize *
                                                      0.8),
                                              child: Text(
                                                totalDiscussCountList == null
                                                    ? paperData
                                                            .attributes!
                                                            .paperShareDiscusses!
                                                            .data!
                                                            .isEmpty
                                                        ? '0 ${AppLocalizations.of(context).discussLowerCase}'
                                                        : '${paperData.attributes!.paperShareDiscusses!.data!.length} ${paperData.attributes!.paperShareDiscusses!.data!.length > 1 ? AppLocalizations.of(context).discussesLowerCase : AppLocalizations.of(context).discussLowerCase}'
                                                    : ' ${totalDiscussCountList.length} ${totalDiscussCountList.length > 1 ? AppLocalizations.of(context).discussesLowerCase : AppLocalizations.of(context).discussLowerCase}',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFF8897A7),
                                                  fontFamily: kHelveticaRegular,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.1,
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                        Text(
                                            data.mainScreenProvider
                                                .convertDateTimeToAgo(
                                                    paperData
                                                        .attributes!.createdAt!,
                                                    context),
                                            style: TextStyle(
                                              color: const Color(0xFF8897A7),
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.1,
                                            ))
                                      ],
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
            }
          }));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
