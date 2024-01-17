import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_services.dart';
import 'package:c_talent/logic/providers/bookmark_services_provider.dart';
import 'package:c_talent/presentation/components/services/services_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/font_constant.dart';
import '../../components/all/top_app_bar.dart';
import '../../helper/size_configuration.dart';

class BookmarkServicesScreen extends StatefulWidget {
  static const String id = '/bookmark_services_screen';

  const BookmarkServicesScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkServicesScreen> createState() => _BookmarkServicesScreenState();
}

class _BookmarkServicesScreenState extends State<BookmarkServicesScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<BookmarkServicesProvider>(context, listen: false)
        .loadBookmarkedServices(context: context);

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
    await Provider.of<BookmarkServicesProvider>(context, listen: false)
        .loadMoreBookmarkedServices(context: context);
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
          title: AppLocalizations.of(context).favoriteCourse),
      body: Consumer<BookmarkServicesProvider>(
        builder: (context, data, child) {
          return RefreshIndicator(
            onRefresh: () => data.refreshBookmarkServices(context: context),
            child: Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize,
                  SizeConfig.defaultSize * 1, SizeConfig.defaultSize, 0),
              child: StreamBuilder<AllServices?>(
                  stream: data.bookmarkedServStrmContrller.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Text(AppLocalizations.of(context).loading,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5)),
                        );
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                AppLocalizations.of(context).refreshPage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5)),
                          );
                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                                AppLocalizations.of(context).dataCouldNotLoad,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5)),
                          );
                        } else {
                          return snapshot.data?.services == null ||
                                  snapshot.data!.services!.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 3),
                                    child: Text(
                                      // translate
                                      "No services found",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.7),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount:
                                      snapshot.data!.services!.length >= 10
                                          ? snapshot.data!.services!.length + 1
                                          : snapshot.data!.services!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        snapshot.data!.services!.length) {
                                      final bookmarkService =
                                          snapshot.data!.services![index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.defaultSize),
                                        child: ServicesContainer(
                                          serviceToggleType:
                                              ServiceToggleType.bookmarkService,
                                          service: bookmarkService,
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.defaultSize * 3),
                                        child: Center(
                                            child: data
                                                    .bookmarkedServicesHasMore
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFFA08875))
                                                : Text(
                                                    AppLocalizations.of(context)
                                                        .caughtUp,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaRegular,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.5),
                                                  )),
                                      );
                                    }
                                  },
                                );
                        }
                    }
                  }),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
