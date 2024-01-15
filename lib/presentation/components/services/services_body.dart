import 'dart:async';

import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:c_talent/presentation/components/services/services_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class ServicesBody extends StatefulWidget {
  const ServicesBody({Key? key}) : super(key: key);
  @override
  State<ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<ServicesBody> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of interest class
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMoreServices();
      }
    });
    super.initState();
  }

  void loadMoreServices() async {
    await Provider.of<ServicesProvider>(context, listen: false)
        .loadMoreServices(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllServices?>(
          stream: data.allServicesStreamController.stream,
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
                      AppLocalizations.of(context).dataCouldNotLoad,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  return Column(children: [
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () => data.refreshServices(context: context),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recommend section
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Text(
                                    AppLocalizations.of(context).recommend,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.8),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.defaultSize * 2),
                                // Recommend class list
                                // const RecommendClassList(),
                                SizedBox(height: SizeConfig.defaultSize * 3),
                                // All course section
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).allCourse,
                                        style: TextStyle(
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.8),
                                      ),
                                      SizedBox(
                                          height: SizeConfig.defaultSize * 3),
                                      snapshot.data?.services == null ||
                                              snapshot.data!.services!.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      SizeConfig.defaultSize *
                                                          3),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .noInterestClassAvailable,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              child: ListView.builder(
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!
                                                            .services!.length >=
                                                        10
                                                    ? snapshot.data!.services!
                                                            .length +
                                                        1
                                                    : snapshot
                                                        .data!.services!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index <
                                                      snapshot.data!.services!
                                                          .length) {
                                                    final servicesData =
                                                        snapshot.data!
                                                            .services![index];
                                                    return ServicesContainer(
                                                      service: servicesData,
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize *
                                                              3),
                                                      child: Center(
                                                          child: data
                                                                  .servicesHasMore
                                                              ? const CircularProgressIndicator(
                                                                  color: Color(
                                                                      0xFFA08875))
                                                              : Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .caughtUp,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          kHelveticaMedium,
                                                                      fontSize:
                                                                          SizeConfig.defaultSize *
                                                                              1.5),
                                                                )),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  ]);
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
