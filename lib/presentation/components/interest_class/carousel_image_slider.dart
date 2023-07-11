import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget buildImage({required String imageUrl, required int index}) {
  return Container(
    width: double.infinity,
    color: Colors.transparent,
    child: FittedBox(
      child: CachedNetworkImage(
        imageUrl: kIMAGEURL + imageUrl,
        fit: BoxFit.fill,
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}

Widget buildDotIndicator({required int activeIndex, required int count}) =>
    AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: JumpingDotEffect(
          dotWidth: SizeConfig.defaultSize * 1.2,
          dotHeight: SizeConfig.defaultSize * 1.2,
          activeDotColor: const Color(0xFFA08875),
          dotColor: const Color(0xFF8897A7)),
    );
