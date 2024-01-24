import 'package:c_talent/data/models/all_promotions.dart';
import 'package:c_talent/logic/providers/promotion_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class PromotionContainer extends StatelessWidget {
  final Promotion onePromotion;
  final int index;
  const PromotionContainer(
      {super.key, required this.onePromotion, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<PromotionProvider>(builder: (context, data, child) {
      return Link(
        target: LinkTarget.self,
        uri: Uri.parse(onePromotion.promotionalLink.toString()),
        builder: ((context, followLink) => GestureDetector(
              onTap: followLink,
              child: Container(
                height: SizeConfig.defaultSize * 11,
                margin: index == 0
                    ? EdgeInsets.only(
                        top: SizeConfig.defaultSize,
                        bottom: SizeConfig.defaultSize)
                    : EdgeInsets.only(bottom: SizeConfig.defaultSize),
                padding: EdgeInsets.all(SizeConfig.defaultSize),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.16),
                        offset: const Offset(0, 1),
                        blurRadius: 3)
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    onePromotion.image == null
                        ? Container(
                            height: SizeConfig.defaultSize * 9,
                            width: SizeConfig.defaultSize * 9,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/no_image.png"),
                                    fit: BoxFit.cover)),
                          )
                        : PinchZoomImage(
                            image: CachedNetworkImage(
                              height: SizeConfig.defaultSize * 9,
                              width: SizeConfig.defaultSize * 9,
                              imageUrl: kIMAGEURL + onePromotion.image,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Container(
                                height: SizeConfig.defaultSize * 9,
                                width: SizeConfig.defaultSize * 9,
                                decoration: const BoxDecoration(
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
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: SizeConfig.defaultSize),
                          child: SizedBox(
                            height: SizeConfig.defaultSize * 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  onePromotion.title.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: kHelveticaMedium,
                                    fontSize: SizeConfig.defaultSize * 1.4,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 0.2),
                                  child: Text(
                                    onePromotion.subTitle.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      height: 1.3,
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.25,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 0.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        data.mainScreenProvider
                                            .convertDateTimeToAgo(
                                                onePromotion.createdAt!,
                                                context),
                                        style: TextStyle(
                                          height: 1.3,
                                          color: const Color(0xFF8897A7),
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.05,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            )),
      );
    });
  }
}
