import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/bookmark_paper_share_model.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/paper_share/paper_dicussions.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_top_body.dart';
import 'package:spa_app/presentation/components/paper_share/show_report_paper_share_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkPaperShareDescriptionScreen extends StatefulWidget {
  final PaperShareSourceType source;
  final int? paperShareId;
  final String? savedPaperShareId;

  const BookmarkPaperShareDescriptionScreen(
      {Key? key,
      required this.paperShareId,
      required this.source,
      required this.savedPaperShareId})
      : super(key: key);

  @override
  State<BookmarkPaperShareDescriptionScreen> createState() =>
      _BookmarkPaperShareDescriptionScreenState();
}

class _BookmarkPaperShareDescriptionScreenState
    extends State<BookmarkPaperShareDescriptionScreen> {
  @override
  void initState() {
    super.initState();
    final paperShareProvider =
        Provider.of<PaperShareProvider>(context, listen: false);
    if (widget.source == PaperShareSourceType.fromShare) {
      paperShareProvider.getOnePaperShareForSharedLink(
          context: context, paperShareId: widget.paperShareId.toString());
    }

    paperShareProvider.changeReverse(isReverse: false, fromInitial: true);
  }

  int? totalDiscussLength;
  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(builder: (context, data, child) {
      return Scaffold(
          appBar: topAppBar(
              leadingWidget: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: Icon(CupertinoIcons.back,
                    color: const Color(0xFF8897A7),
                    size: SizeConfig.defaultSize * 2.7),
                onPressed: () {
                  if (data.paperShareDiscussTextController.text != '') {
                    data.paperShareDiscussTextController.clear();
                  }
                  Navigator.pop(context);
                },
              ),
              title: AppLocalizations.of(context).paperShare,
              widgetList: [
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.defaultSize * 2),
                  child: GestureDetector(
                    onTap: () {
                      data.sharePaper(
                          paperShareId: widget.paperShareId.toString(),
                          context: context);
                    },
                    child: Center(
                      child: SvgPicture.asset("assets/svg/share.svg",
                          height: SizeConfig.defaultSize * 2.3,
                          width: SizeConfig.defaultSize * 2.6),
                    ),
                  ),
                ),
                data.mainScreenProvider.reportedPaperShareIdList
                        .contains(widget.paperShareId)
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.defaultSize * 1.5),
                        child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            position: PopupMenuPosition.under,
                            child: Icon(
                              Icons.more_vert,
                              color: const Color(0xFF8897A7),
                              size: SizeConfig.defaultSize * 2.1,
                            ),
                            onSelected: (value) {
                              if (value ==
                                  AppLocalizations.of(context).report) {
                                data.resetPaperShareReportOption();
                                showReportPaperShareContainer(
                                  paperShareId: widget.paperShareId.toString(),
                                  context: context,
                                );
                              }
                            },
                            itemBuilder: (context) {
                              return data
                                  .getReportPaperShareOptionList(
                                      context: context)
                                  .map((e) => PopupMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.5,
                                            color: Colors.red),
                                      )))
                                  .toList();
                            }),
                      ),
              ]),
          body: !data.mainScreenProvider.savedPaperShareIdList
                  .contains(widget.paperShareId)
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).paperShareIsRemoved,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  ),
                )
              : data.mainScreenProvider.reportedPaperShareIdList
                      .contains(widget.paperShareId)
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Center(
                        child: Text(
                          "Content not available",
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    )
                  : StreamBuilder<BookmarkPaperShare>(
                      stream: data.bookmarkShareStreamController.stream,
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
                            } else if (snapshot.data!.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .paperShareIsEmpty,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              );
                            } else if ((snapshot.data!.data!.firstWhere(
                                    (element) =>
                                        element!
                                            .attributes!.paperShare!.data!.id
                                            .toString() ==
                                        widget.paperShareId.toString())) ==
                                null) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .paperShareIsRemoved,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              );
                            } else {
                              // Finding the first paper share that matches our final paperShareId attribute
                              BookmarkPaperShareData? bookmarkPaperShareData =
                                  snapshot.data!.data!.firstWhereOrNull(
                                      (element) =>
                                          element!
                                              .attributes!.paperShare!.data!.id
                                              .toString() ==
                                          widget.paperShareId.toString());
                              if (bookmarkPaperShareData == null) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Center(
                                    child: Text(
                                      "Content not available",
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  ),
                                );
                              } else {
                                PaperShare paperShare = bookmarkPaperShareData
                                    .attributes!.paperShare!.data!;
                                totalDiscussLength = paperShare.attributes!
                                    .paperShareDiscusses!.data!.length;
// blocked and deleted users won't be included
                                List<PaperShareDiscussesData?>?
                                    totalDiscussCountList;
                                if (paperShare.attributes != null &&
                                    paperShare
                                            .attributes!.paperShareDiscusses !=
                                        null &&
                                    paperShare.attributes!.paperShareDiscusses!
                                            .data !=
                                        null) {
                                  totalDiscussCountList = paperShare
                                      .attributes!.paperShareDiscusses!.data!
                                      .where((element) =>
                                          element != null &&
                                          element.attributes != null &&
                                          element.attributes!.discussedBy !=
                                              null &&
                                          element.attributes!.discussedBy!
                                                  .data !=
                                              null &&
                                          !data.mainScreenProvider
                                              .blockedUsersIdList
                                              .contains(element.attributes!
                                                  .discussedBy!.data!.id))
                                      .toList();
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: SingleChildScrollView(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          reverse: data.isPaperShareReverse,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: SizeConfig
                                                          .defaultSize),
                                                  child: PaperShareTopBody(
                                                    paperShareSaveId: widget
                                                        .savedPaperShareId,
                                                    source: widget.source,
                                                    paperShare: paperShare,
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.defaultSize *
                                                            2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      child: Row(children: [
                                                        SvgPicture.asset(
                                                          "assets/svg/comment.svg",
                                                          color: const Color(
                                                              0xFFD1D3D5),
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              1.4,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              1.4,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: SizeConfig
                                                                      .defaultSize *
                                                                  0.8),
                                                          child: Text(
                                                            totalDiscussCountList ==
                                                                    null
                                                                ? paperShare
                                                                        .attributes!
                                                                        .paperShareDiscusses!
                                                                        .data!
                                                                        .isEmpty
                                                                    ? '0 ${AppLocalizations.of(context).discussLowerCase}'
                                                                    : '${paperShare.attributes!.paperShareDiscusses!.data!.length} ${paperShare.attributes!.paperShareDiscusses!.data!.length > 1 ? AppLocalizations.of(context).discussesLowerCase : AppLocalizations.of(context).discussLowerCase}'
                                                                : ' ${totalDiscussCountList.length} ${totalDiscussCountList.length > 1 ? AppLocalizations.of(context).discussesLowerCase : AppLocalizations.of(context).discussLowerCase}',
                                                            style: TextStyle(
                                                              color: const Color(
                                                                  0xFF8897A7),
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.4,
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                    Text(
                                                        "${AppLocalizations.of(context).postedFrom}: ${data.mainScreenProvider.convertDateTimeToAgo(paperShare.attributes!.createdAt!, context)}",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFF000000),
                                                          fontFamily:
                                                              kHelveticaMedium,
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.3,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              // Paper's discussions
                                              PaperDiscussions(
                                                  paperShareDiscussionList:
                                                      paperShare
                                                          .attributes!
                                                          .paperShareDiscusses!
                                                          .data),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFD0E0F0),
                                        thickness: 1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.defaultSize * 2),
                                        child: RoundedTextFormField(
                                            onTap: () {
                                              data.changeReverse(
                                                  isReverse: true);
                                            },
                                            textEditingController: data
                                                .paperShareDiscussTextController,
                                            textInputType: TextInputType.text,
                                            isEnable: true,
                                            isReadOnly: false,
                                            usePrefix: false,
                                            useSuffix: true,
                                            hintText:
                                                AppLocalizations.of(context)
                                                    .writeAComment,
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.defaultSize *
                                                      0.2,
                                                  right:
                                                      SizeConfig.defaultSize *
                                                          0.2),
                                              child: SvgPicture.asset(
                                                "assets/svg/post_comment.svg",
                                                height:
                                                    SizeConfig.defaultSize * 4,
                                                width:
                                                    SizeConfig.defaultSize * 4,
                                                // color: Colors.white,
                                              ),
                                            ),
                                            suffixOnPress: () {
                                              if (data
                                                  .paperShareDiscussTextController
                                                  .text
                                                  .trim()
                                                  .isNotEmpty) {
                                                data.changeReverse(
                                                    isReverse: true);
                                                data.sendPaperShareDiscuss(
                                                    source: widget.source,
                                                    context: context,
                                                    paperShareId: paperShare.id
                                                        .toString());
                                              }
                                            },
                                            borderRadius:
                                                SizeConfig.defaultSize * 1.5),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                        }
                      })));
    });
  }
}
