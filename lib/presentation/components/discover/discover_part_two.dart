import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/search_user_model.dart';
import 'package:spa_app/logic/providers/discover_provider.dart';
import 'package:spa_app/presentation/components/discover/discover_user_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverPartTwo extends StatefulWidget {
  const DiscoverPartTwo({Key? key}) : super(key: key);

  @override
  State<DiscoverPartTwo> createState() => _DiscoverPartTwoState();
}

class _DiscoverPartTwoState extends State<DiscoverPartTwo> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<DiscoverProvider>(context, listen: false).searchUserRefresh();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
  }

  void loadNextData() {
    Provider.of<DiscoverProvider>(context, listen: false)
        .loadMoreSearchUsers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(
      builder: (context, data, child) {
        return data.searchUserTextController.text.trim() == '' ||
                data.emptySearchField == true
            ? const Flexible(
                child: SizedBox(),
              )
            : StreamBuilder<List<SearchUser>>(
                stream: data.searchUserStreamController.stream,
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
                            AppLocalizations.of(context).usersCouldNotLoad,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                        );
                      } else {
                        return data.searchUserTextController.text == ''
                            ? Expanded(
                                child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      if (index < snapshot.data!.length) {
                                        final searchUser =
                                            snapshot.data![index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize * 2),
                                          child: DiscoverUserContainer(
                                              searchUser: searchUser),
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.defaultSize * 3),
                                          child: Center(
                                              child: Text(
                                            AppLocalizations.of(context)
                                                .caughtUp,
                                            style: TextStyle(
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.5),
                                          )),
                                        );
                                      }
                                    }),
                              )
                            // if searched for users but found empty
                            : data.noRecord == true &&
                                    data.searchedUserList.isEmpty
                                ? Flexible(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.defaultSize * 3),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .noUserFound,
                                          style: TextStyle(
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.5),
                                        ),
                                      ),
                                    ),
                                  )
                                :
// if searched for users and found some data
                                Flexible(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      itemCount: data
                                                  .searchedUserList.isEmpty &&
                                              snapshot.data!.length >= 15
                                          ? data.getUserCount(
                                                  allUser: snapshot.data!) +
                                              1
                                          : data.searchedUserList.isEmpty &&
                                                  snapshot.data!.length <= 14
                                              ? data.getUserCount(
                                                  allUser: snapshot.data!)
                                              : data.searchedUserList.length >=
                                                      15
                                                  ? data.searchedUserList
                                                          .length +
                                                      1
                                                  : data
                                                      .searchedUserList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index <
                                            data.searchedUserList.length) {
                                          List<SearchUser> allUser =
                                              data.searchedUserList;
                                          SearchUser searchUser =
                                              allUser[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.defaultSize * 2),
                                            child: DiscoverUserContainer(
                                              searchUser: searchUser,
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    SizeConfig.defaultSize * 3),
                                            child: Center(
                                                child: data.searchUserHasMore
                                                    ? const CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFA08875))
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
                                  );
                      }
                  }
                },
              );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
