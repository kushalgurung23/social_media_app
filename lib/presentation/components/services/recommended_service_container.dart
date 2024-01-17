import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class RecommendedServiceContainer extends StatelessWidget {
  final OneService service;
  const RecommendedServiceContainer({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(
        builder: ((context, data, child) => (GestureDetector(
              onTap: () {
                data.goToServicesDescriptionScreen(
                    serviceToggleType: ServiceToggleType.recommendService,
                    context: context,
                    service: service);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          color: const Color(0xFFA08875).withOpacity(0.22))
                    ]),
                height: SizeConfig.defaultSize * 23,
                width: SizeConfig.defaultSize * 16,
                child: Column(children: [
                  service == null ||
                          service.mainImage == null ||
                          service.mainImage == ''
                      ? Container(
                          height: SizeConfig.defaultSize * 13,
                          width: SizeConfig.defaultSize * 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            image: DecorationImage(
                                image: AssetImage("assets/images/no_image.png"),
                                fit: BoxFit.cover),
                          ))
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: PinchZoomImage(
                            image: CachedNetworkImage(
                              imageUrl:
                                  kIMAGEURL + service.mainImage.toString(),
                              height: SizeConfig.defaultSize * 13,
                              width: SizeConfig.defaultSize * 16,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: SizeConfig.defaultSize * 13,
                                width: SizeConfig.defaultSize * 16,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
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
                        horizontal: SizeConfig.defaultSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service.title.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.1),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize,
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize * 6.5,
                                child: Text(
                                  // data.getCategoryTypeList(context: context).map((key,
                                  //             value) =>
                                  //         MapEntry(
                                  //             value,
                                  //             key))[services
                                  //         .type
                                  //         .toString()] ??
                                  //     services.type
                                  //         .toString(),

                                  service.category.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: const Color(0xFFA08875),
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: SizeConfig.defaultSize),
                          child: Text(
                            "${AppLocalizations.of(context).price}: ${service.price.toString()}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: const Color(0xFF8897A7),
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.1),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ))));
  }
}
