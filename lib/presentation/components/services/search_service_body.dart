import 'dart:async';

import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/services_provider.dart';
import 'package:c_talent/presentation/components/services/recommended_services.dart';
import 'package:c_talent/presentation/components/services/services_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class SearchServicesBody extends StatefulWidget {
  final ServicesFilterType servicesFilterType;
  const SearchServicesBody({Key? key, required this.servicesFilterType})
      : super(key: key);
  @override
  State<SearchServicesBody> createState() => _SearchServicesBodyState();
}

class _SearchServicesBodyState extends State<SearchServicesBody> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of services
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMoreSearchServices();
      }
    });
    super.initState();
  }

  void loadMoreSearchServices() async {
    await Provider.of<ServicesProvider>(context, listen: false)
        .loadMoreSearchResults(
            context: context, servicesFilterType: widget.servicesFilterType);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicesProvider>(builder: (context, data, child) {
      return StreamBuilder<AllServices?>(
          stream: data.searchStreamController.stream,
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
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.defaultSize * 1),
                          child: Text(
                            // translate
                            'All Services',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: kHelveticaMedium,
                                fontSize: SizeConfig.defaultSize * 1.8),
                          ),
                        ),
                        snapshot.data?.services == null ||
                                snapshot.data!.services!.isEmpty
                            ? Flexible(
                                child: Center(
                                  child: Text(
                                    data.isSearchLoading == true ||
                                            data.isRefreshingSearch == true
                                        ? AppLocalizations.of(context).loading
                                        // translate
                                        : 'Services not found',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.5),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: RefreshIndicator(
                                  onRefresh: () => data.refreshSearchedServices(
                                      context: context,
                                      servicesFilterType:
                                          widget.servicesFilterType),
                                  child: ListView.builder(
                                    controller: scrollController,
                                    // primary: false,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    // shrinkWrap: true,
                                    itemCount:
                                        snapshot.data!.services!.length >= 10
                                            ? snapshot.data!.services!.length +
                                                1
                                            : snapshot.data!.services!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index <
                                          snapshot.data!.services!.length) {
                                        final servicesData =
                                            snapshot.data!.services![index];
                                        return ServicesContainer(
                                          service: servicesData,
                                          serviceToggleType: ServiceToggleType
                                              .searchedAndFilteredServices,
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.defaultSize * 3),
                                          child: Center(
                                              child: data.searchHasMore
                                                  ? const CircularProgressIndicator(
                                                      color: Color(0xFFA08875))
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .caughtUp,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              kHelveticaMedium,
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.5),
                                                    )),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
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
