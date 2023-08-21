import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileBlockedAccountsScreen extends StatefulWidget {
  // If we are trying to update other user profile, it will be true

  const ProfileBlockedAccountsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileBlockedAccountsScreen> createState() =>
      _ProfileBlockedAccountsScreenState();
}

class _ProfileBlockedAccountsScreenState
    extends State<ProfileBlockedAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
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
            title: AppLocalizations.of(context).blockAccount,
          ),
          body: StreamBuilder<User>(
            stream: data.mainScreenProvider.currentUserController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).refreshPage,
                    style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                );
              } else {
                final blockedUserList = snapshot.data!.usersBlocked;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: blockedUserList!.isEmpty
                      ? Center(
                          child: Text(
                          AppLocalizations.of(context).noUserFound,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ))
                      : ListView.builder(
                          itemCount: blockedUserList.length,
                          itemBuilder: (context, index) {
                            final blockedUser =
                                blockedUserList[index]!.blockedTo!;
                            return Container(
                              color: Colors.transparent,
                              margin: index == 0
                                  ? EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 2,
                                      bottom: SizeConfig.defaultSize * 2)
                                  : EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 1.5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          blockedUser.profileImage == null
                                              ? Container(
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          4.7,
                                                  width:
                                                      SizeConfig.defaultSize *
                                                          4.7,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(SizeConfig
                                                                .defaultSize *
                                                            1.5),
                                                    color: Colors.white,
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/default_profile.jpg"),
                                                        fit: BoxFit.cover),
                                                  ))
                                              : CachedNetworkImage(
                                                  imageUrl: kIMAGEURL +
                                                      blockedUser
                                                          .profileImage!.url!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height:
                                                        SizeConfig.defaultSize *
                                                            4.7,
                                                    width:
                                                        SizeConfig.defaultSize *
                                                            4.7,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(SizeConfig
                                                                  .defaultSize *
                                                              1.5),
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height:
                                                        SizeConfig.defaultSize *
                                                            4.7,
                                                    width:
                                                        SizeConfig.defaultSize *
                                                            4.7,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(SizeConfig
                                                                  .defaultSize *
                                                              1.5),
                                                      color: const Color(
                                                          0xFFD0E0F0),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: SizeConfig.defaultSize),
                                            child: Text(
                                                blockedUser.username.toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaMedium,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.4)),
                                          )
                                        ],
                                      ),
                                    ),
                                    //  button
                                    RectangularButton(
                                      textPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.defaultSize * 0.5),
                                      height: SizeConfig.defaultSize * 3.5,
                                      width: SizeConfig.defaultSize * 10,
                                      onPress: () async {
                                        await data.unblockUser(
                                            otherUserStreamController: data
                                                .mainScreenProvider
                                                .currentUserController,
                                            context: context,
                                            userBlockId: blockedUserList[index]!
                                                .id
                                                .toString(),
                                            otherUserId:
                                                blockedUser.id.toString());
                                        setState(() {});
                                      },
                                      text:
                                          AppLocalizations.of(context).unblock,
                                      textColor: Colors.white,
                                      buttonColor: const Color(0xFFA08875),
                                      borderColor: const Color(0xFFA08875),
                                      fontFamily: kHelveticaMedium,
                                      keepBoxShadow: false,
                                      borderRadius:
                                          SizeConfig.defaultSize * 1.8,
                                      fontSize: SizeConfig.defaultSize * 1.1,
                                    )
                                  ]),
                            );
                          }),
                );
              }
            },
          ));
    });
  }
}
