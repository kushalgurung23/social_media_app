import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/enum/news_board_enum.dart';
import 'package:spa_app/data/models/all_news_boards_model.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/components/further_studies/all_news_board_list_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/components/further_studies/news_board_detail_screen.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsBoardList extends StatefulWidget {
  const NewsBoardList({Key? key}) : super(key: key);

  @override
  State<NewsBoardList> createState() => _NewsBoardListState();
}

class _NewsBoardListState extends State<NewsBoardList> {
  @override
  void initState() {
    // Loading initial news board list
    Provider.of<FurtherStudiesProvider>(context, listen: false)
        .refresh(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FurtherStudiesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllNewsBoards?>(
          stream: data.allNewsBoardsStreamController.stream,
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context).newsBoard,
                              style: TextStyle(
                                  fontFamily: kHelveticaMedium,
                                  fontSize: SizeConfig.defaultSize * 1.8),
                            ),
                            GestureDetector(
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).viewAll,
                                      style: TextStyle(
                                          fontFamily: kHelveticaMedium,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.4,
                                          color: const Color(0xFF5545CF)),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        size: SizeConfig.defaultSize,
                                        color: const Color(0xFF5545CF))
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AllNewsBoardListScreen()));
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize * 2),
                      snapshot.data!.data == null ||
                              snapshot.data!.data!.isEmpty
                          ? SizedBox(
                              height: SizeConfig.defaultSize * 20.5,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).noNewsBoard,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: SizeConfig.defaultSize * 20.5,
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length >= 8
                                      ? 8
                                      : snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    final newsBoard =
                                        snapshot.data!.data![index];
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
                                                          NewsBoardDetailScreen(
                                                              source:
                                                                  NewsBoardSourceType
                                                                      .all,
                                                              newsBoardId: newsBoard
                                                                  .id
                                                                  .toString())));
                                            },
                                            child: SizedBox(
                                              height:
                                                  SizeConfig.defaultSize * 19,
                                              width:
                                                  SizeConfig.defaultSize * 14,
                                              child: Column(children: [
                                                newsBoard
                                                            .attributes!
                                                            .leadingImage!
                                                            .data ==
                                                        null
                                                    ? Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            14,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            14,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/no_image.png"),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ))
                                                    : PinchZoomImage(
                                                        image:
                                                            CachedNetworkImage(
                                                          imageUrl: kIMAGEURL +
                                                              newsBoard
                                                                  .attributes!
                                                                  .leadingImage!
                                                                  .data!
                                                                  .attributes!
                                                                  .url!,
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              14,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              14,
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            height: SizeConfig
                                                                    .defaultSize *
                                                                14,
                                                            width: SizeConfig
                                                                    .defaultSize *
                                                                14,
                                                            decoration:
                                                                const BoxDecoration(
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
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.defaultSize *
                                                            0.5,
                                                  ),
                                                  child: Text(
                                                    newsBoard.attributes!.title
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaMedium,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.3),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                    ],
                  );
                }
            }
          });
    });
  }
}
