import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/enum/news_board_enum.dart';
import 'package:spa_app/data/models/all_news_boards_model.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsBoardDetailScreen extends StatefulWidget {
  final String newsBoardId;
  final NewsBoardSourceType source;

  const NewsBoardDetailScreen(
      {Key? key, required this.newsBoardId, required this.source})
      : super(key: key);

  @override
  State<NewsBoardDetailScreen> createState() => _NewsBoardDetailScreenState();
}

class _NewsBoardDetailScreenState extends State<NewsBoardDetailScreen> {
  @override
  void initState() {
    if (widget.source == NewsBoardSourceType.fromShare) {
      Provider.of<FurtherStudiesProvider>(context, listen: false)
          .getOneNewsBoardFromSharedLink(
              newsBoardId: widget.newsBoardId, context: context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FurtherStudiesProvider>(builder: (context, data, child) {
      return Scaffold(
          appBar: topAppBar(
              leadingWidget: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: Icon(CupertinoIcons.back,
                    color: const Color(0xFF8897A7),
                    size: SizeConfig.defaultSize * 2.7),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: AppLocalizations.of(context).newsBoard,
              widgetList: [
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.defaultSize * 2),
                  child: GestureDetector(
                    onTap: () {
                      data.shareNewsBoard(
                          newsBoardId: widget.newsBoardId, context: context);
                    },
                    child: Center(
                      child: SvgPicture.asset("assets/svg/share.svg",
                          height: SizeConfig.defaultSize * 2.3,
                          width: SizeConfig.defaultSize * 2.6),
                    ),
                  ),
                ),
              ]),
          body: StreamBuilder<AllNewsBoards?>(
              stream: widget.source == NewsBoardSourceType.fromShare
                  ? data.fromShareNewsBoardStreamController.stream
                  : data.allNewsBoardsStreamController.stream,
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
                          AppLocalizations.of(context).newsBoardCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else {
                      NewsBoard? newsBoard;
                      if (widget.source == NewsBoardSourceType.fromShare) {
                        // While the source is equal to fromShare, we will always get only one data
                        newsBoard = snapshot.data!.data![0];
                      } else {
                        // Finding the first news board that matches our final newsBoardId attribute
                        newsBoard = snapshot.data!.data!.firstWhere((element) =>
                            element.id.toString() == widget.newsBoardId);
                      }

                      return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: SizeConfig.defaultSize,
                                ),
                                newsBoard.attributes!.leadingImage!.data == null
                                    ? Container(
                                        height: SizeConfig.defaultSize * 28,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/no_image.png"),
                                              fit: BoxFit.fitHeight),
                                        ))
                                    : PinchZoomImage(
                                        image: CachedNetworkImage(
                                          imageUrl: kIMAGEURL +
                                              newsBoard
                                                  .attributes!
                                                  .leadingImage!
                                                  .data!
                                                  .attributes!
                                                  .url!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: SizeConfig.defaultSize * 20,
                                            width: double.infinity,
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 2,
                                      bottom: SizeConfig.defaultSize * 2),
                                  child: Text(
                                    newsBoard.attributes!.title.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context).postedFrom}: ${data.mainScreenProvider.convertDateTimeToAgo(newsBoard.attributes!.createdAt!, context)}',
                                        style: TextStyle(
                                          color: const Color(0xFF8897A7),
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.3,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // First paragraph
                                newsBoard.attributes!.firstParagraph == null ||
                                        newsBoard.attributes!.firstParagraph ==
                                            ''
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: Text(
                                          newsBoard.attributes!.firstParagraph
                                              .toString(),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.45,
                                          ),
                                        ),
                                      ),
                                // First image
                                newsBoard.attributes!.firstImage!.data == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: PinchZoomImage(
                                          image: CachedNetworkImage(
                                            imageUrl: kIMAGEURL +
                                                newsBoard
                                                    .attributes!
                                                    .firstImage!
                                                    .data!
                                                    .attributes!
                                                    .url!,
                                            placeholder: (context, url) =>
                                                Container(
                                              height:
                                                  SizeConfig.defaultSize * 20,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFD0E0F0),
                                              ),
                                            ),
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
                                      ),
                                // Second paragraph
                                newsBoard.attributes!.secondParagraph == null ||
                                        newsBoard.attributes!.secondParagraph ==
                                            ''
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: Text(
                                          newsBoard.attributes!.secondParagraph
                                              .toString(),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.45,
                                          ),
                                        ),
                                      ),
                                // Second image
                                newsBoard.attributes!.secondImage!.data == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: PinchZoomImage(
                                          image: CachedNetworkImage(
                                            imageUrl: kIMAGEURL +
                                                newsBoard
                                                    .attributes!
                                                    .secondImage!
                                                    .data!
                                                    .attributes!
                                                    .url!,
                                            placeholder: (context, url) =>
                                                Container(
                                              height:
                                                  SizeConfig.defaultSize * 20,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFD0E0F0),
                                              ),
                                            ),
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
                                      ),
                                // Third paragraph
                                newsBoard.attributes!.thirdParagraph == null ||
                                        newsBoard.attributes!.thirdParagraph ==
                                            ''
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: Text(
                                          newsBoard.attributes!.thirdParagraph
                                              .toString(),
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.45,
                                          ),
                                        ),
                                      ),
                                newsBoard.attributes!.thirdImage!.data == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            bottom: SizeConfig.defaultSize * 2),
                                        child: PinchZoomImage(
                                          image: CachedNetworkImage(
                                            imageUrl: kIMAGEURL +
                                                newsBoard
                                                    .attributes!
                                                    .thirdImage!
                                                    .data!
                                                    .attributes!
                                                    .url!,
                                            placeholder: (context, url) =>
                                                Container(
                                              height:
                                                  SizeConfig.defaultSize * 20,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFD0E0F0),
                                              ),
                                            ),
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
                                      ),
                              ],
                            ),
                          ));
                    }
                }
              }));
    });
  }
}
