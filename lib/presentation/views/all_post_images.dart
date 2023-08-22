import 'package:c_talent/data/new_models/all_news_posts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_news_post_model.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPostImages extends StatefulWidget {
  final bool isFromProfile;
  final List<NewsPostImage?>? postImages;
  final List<AllImage?>? postImageFromProfile;
  final int index;
  const AllPostImages(
      {Key? key,
      required this.index,
      required this.postImages,
      this.postImageFromProfile,
      required this.isFromProfile})
      : super(key: key);

  @override
  State<AllPostImages> createState() => _AllPostImagesState();
}

class _AllPostImagesState extends State<AllPostImages> {
  final itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => itemScrollController.jumpTo(index: widget.index));
  }

  @override
  Widget build(BuildContext context) {
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
        title: widget.postImages == null ||
                (widget.postImages != null && widget.postImages!.length <= 1)
            ? AppLocalizations.of(context).photo
            : AppLocalizations.of(context).photos,
      ),
      body: widget.isFromProfile == false
          ? Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: widget.postImages == null || widget.postImages!.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context).thisPostHasNoMaterial,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize,
                        ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemCount: widget.postImages!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize),
                                  child: PinchZoomImage(
                                    image: CachedNetworkImage(
                                      imageUrl: kIMAGEURL +
                                          widget.postImages![index]!.url
                                              .toString(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    zoomedBackgroundColor: const Color.fromRGBO(
                                        240, 240, 240, 1.0),
                                    hideStatusBarWhileZooming: false,
                                    onZoomStart: () {},
                                    onZoomEnd: () {},
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
            )
          : Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: widget.postImageFromProfile == null ||
                      widget.postImageFromProfile!.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context).thisPostHasNoMaterial,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.defaultSize,
                        ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemCount: widget.postImageFromProfile!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize),
                                  child: PinchZoomImage(
                                    image: CachedNetworkImage(
                                      imageUrl: kIMAGEURL +
                                          widget.postImageFromProfile![index]!
                                              .url!,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    zoomedBackgroundColor: const Color.fromRGBO(
                                        240, 240, 240, 1.0),
                                    hideStatusBarWhileZooming: false,
                                    onZoomStart: () {},
                                    onZoomEnd: () {},
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
            ),
    );
  }
}
