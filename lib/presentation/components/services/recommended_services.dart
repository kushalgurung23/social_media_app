import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:c_talent/presentation/components/services/recommended_service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class RecommendedServices extends StatefulWidget {
  const RecommendedServices({Key? key}) : super(key: key);

  @override
  State<RecommendedServices> createState() => _RecommendedServicesState();
}

class _RecommendedServicesState extends State<RecommendedServices> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of paper share
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    await Provider.of<ServicesProvider>(context, listen: false)
        .loadMoreRecommendedServices(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllServices?>(
          stream: data.recommendedServStrmContrller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: SizedBox(
                    height: SizeConfig.defaultSize * 22.5,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).loading,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    ),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 2),
                    child: SizedBox(
                      height: SizeConfig.defaultSize * 22.5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 2),
                    child: SizedBox(
                      height: SizeConfig.defaultSize * 22.5,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).dataCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    ),
                  );
                } else {
                  return snapshot.data?.services == null ||
                          snapshot.data!.services!.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: SizedBox(
                            height: SizeConfig.defaultSize * 22.5,
                            child: Center(
                              child: Text(
                                snapshot.data!.services!.length.toString(),
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: SizeConfig.defaultSize * 23.5,
                          child: ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.services!.length >= 10
                                  ? snapshot.data!.services!.length + 1
                                  : snapshot.data!.services!.length,
                              itemBuilder: (context, index) {
                                if (index < snapshot.data!.services!.length) {
                                  final oneService =
                                      snapshot.data!.services![index];
                                  return Padding(
                                      padding: index == 0
                                          ? EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize * 2)
                                          : EdgeInsets.only(
                                              right:
                                                  SizeConfig.defaultSize * 2),
                                      child: oneService.service == null
                                          ? const SizedBox()
                                          : RecommendedServiceContainer(
                                              service: oneService.service!));
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.defaultSize,
                                        right: SizeConfig.defaultSize * 3),
                                    child: Center(
                                        child: data.recmdServicesHasMore
                                            ? const CircularProgressIndicator(
                                                color: Color(0xFFA08875))
                                            : Text(
                                                AppLocalizations.of(context)
                                                    .caughtUp,
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                              )),
                                  );
                                }
                              }),
                        );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
