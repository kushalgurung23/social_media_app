import 'package:c_talent/data/models/all_promotions.dart';
import 'package:c_talent/logic/providers/promotion_provider.dart';
import 'package:c_talent/presentation/components/notification_and_promotion/promotion_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class PromotionBody extends StatefulWidget {
  const PromotionBody({super.key});

  @override
  State<PromotionBody> createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<PromotionProvider>(context, listen: false)
        .loadInitialPromotions(context: context);

    // this will load more data when we reach the end of services
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMorePromotions();
      }
    });
    super.initState();
  }

  void loadMorePromotions() async {
    await Provider.of<PromotionProvider>(context, listen: false)
        .loadMorePromotions(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PromotionProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllPromotions?>(
            stream: data.allPromotionsStreamController.stream,
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
                      child: Text(AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .promotionCouldNotBeLoaded,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    return snapshot.data?.promotions == null ||
                            snapshot.data!.promotions!.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.promotionsIsLoading == true ||
                                        data.isRefreshingPromotions == true
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context).noPromotions,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize * 2),
                            child: RefreshIndicator(
                              onRefresh: () =>
                                  data.refreshPromotions(context: context),
                              child: ListView.builder(
                                  controller: scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  itemCount:
                                      snapshot.data!.promotions!.length >= 10
                                          ? snapshot.data!.promotions!.length +
                                              1
                                          : snapshot.data!.promotions!.length,
                                  itemBuilder: (context, index) {
                                    if (index <
                                        snapshot.data!.promotions!.length) {
                                      final onePromotion =
                                          snapshot.data!.promotions![index];

                                      return PromotionContainer(
                                          onePromotion: onePromotion,
                                          index: index);
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.defaultSize * 3),
                                        child: Center(
                                            child: data.promotionsHasMore
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFFA08875))
                                                : Text(
                                                    AppLocalizations.of(context)
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
                                  }),
                            ),
                          );
                  }
              }
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
