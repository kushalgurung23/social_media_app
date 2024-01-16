import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:c_talent/presentation/views/services/service_description_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';
import '../all/rectangular_button.dart';

class ServicesContainer extends StatelessWidget {
  final ServicePost service;
  const ServicesContainer({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return service.service == null
          ? Center(
              child: Text(
                AppLocalizations.of(context).dataCouldNotLoad,
                style: TextStyle(
                    fontFamily: kHelveticaRegular,
                    fontSize: SizeConfig.defaultSize * 1.5),
              ),
            )
          : Container(
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
                  service.service?.mainImage == null ||
                          service.service?.mainImage == ''
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
                                image: AssetImage("assets/images/no_image.png"),
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
                                  service.service!.mainImage.toString(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  service.service!.title.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.6),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize,
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize * 9.5,
                                child: Text(
                                  service.service!.category.toString(),
                                  // data
                                  //             .getCategoryTypeList(
                                  //                 context: context)
                                  //             .map((key, value) =>
                                  //                 MapEntry(value, key))[
                                  //         courseData.attributes!.type
                                  //             .toString()] ??
                                  //     courseData.attributes!.type
                                  //         .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: const Color(0xFFA08875),
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.4),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.defaultSize * 1.5),
                            child: Text(
                              "${AppLocalizations.of(context).price}: ${service.service!.price.toString()}",
                              style: TextStyle(
                                  color: const Color(0xFF8897A7),
                                  fontSize: SizeConfig.defaultSize * 1.3,
                                  fontFamily: kHelveticaRegular),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (service.service == null) {
                                    return;
                                  }
                                  await data.toggleServiceSave(
                                      serviceToggleType:
                                          ServiceToggleType.allService,
                                      context: context,
                                      oneService: service.service!);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFF9F9F9),
                                        border: Border.all(
                                            color: const Color(0xFFE6E6E6),
                                            width: 0.3)),
                                    height: SizeConfig.defaultSize * 4.5,
                                    width: SizeConfig.defaultSize * 4.5,
                                    child: Icon(
                                      Icons.bookmark,
                                      color: service.service?.isSaved == 1
                                          ? const Color(0xFFA08875)
                                          : const Color(0xFFD1D3D5),
                                      size: SizeConfig.defaultSize * 3,
                                    )),
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize * 1.5,
                              ),
                              Expanded(
                                  child: RectangularButton(
                                      height: SizeConfig.defaultSize * 4.5,
                                      buttonColor: const Color(0xFFFEB703),
                                      text: AppLocalizations.of(context)
                                          .viewDetails,
                                      textColor: const Color(0xFFF1F0F1),
                                      borderColor: Colors.white,
                                      borderRadius: 10,
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.3,
                                      keepBoxShadow: true,
                                      onPress: () {
                                        data.goToServicesDescriptionScreen(
                                            serviceToggleType:
                                                ServiceToggleType.allService,
                                            context: context,
                                            service: service.service);
                                      },
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                      textPadding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.defaultSize)))
                            ],
                          )
                        ],
                      )),
                ],
              ),
            );
    });
  }
}
