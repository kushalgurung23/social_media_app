import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/constant/font_constant.dart';
import '../components/profile/profile_blocked_accounts.dart';

AppBar profileAppBar({required BuildContext context}) {
  return topAppBar(title: AppLocalizations.of(context).profile, widgetList: [
    Builder(builder: (context) {
      return Consumer<ProfileProvider>(builder: (context, data, child) {
        return Center(
          child: IconButton(
            onPressed: () {
              if (data.image != null) {
                data.image = null;
              }
              Navigator.pushNamed(context, EditProfileScreen.id);
            },
            icon: SvgPicture.asset(
              'assets/svg/edit.svg',
              color: const Color(0xFF8897A7),
              height: SizeConfig.defaultSize * 2.1,
              width: SizeConfig.defaultSize * 2.1,
            ),
            splashRadius: SizeConfig.defaultSize * 2.5,
          ),
        );
      });
    }),
    Builder(builder: (context) {
      return Consumer<ProfileProvider>(builder: (context, data, child) {
        return Center(
            child: Padding(
          padding: EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
          child: PopupMenuButton(
              padding: EdgeInsets.zero,
              position: PopupMenuPosition.under,
              child: Icon(
                Icons.more_vert,
                color: const Color(0xFF8897A7),
                size: SizeConfig.defaultSize * 2.5,
              ),
              onSelected: (value) {
                if (value == AppLocalizations.of(context).blockedAccounts) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProfileBlockedAccountsScreen()));
                } else if (value ==
                    AppLocalizations.of(context).deleteAccount) {
                  bool isDeleting = false;
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                        return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              title: Text(
                                  AppLocalizations.of(context).deleteAccount),
                              content: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (isDeleting)
                                    const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: CircularProgressIndicator(
                                            color: Color(0xFFA08875))),
                                  Flexible(
                                    child: Text(
                                      (isDeleting
                                          ? AppLocalizations.of(context)
                                              .deleting
                                          : AppLocalizations.of(context)
                                              .confirmDeleteAccount),
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                if (!isDeleting)
                                  TextButton(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.defaultSize,
                                          vertical:
                                              SizeConfig.defaultSize * 0.5),
                                      child: Text(
                                        AppLocalizations.of(context).cancel,
                                        style: TextStyle(
                                            color: const Color(0xFFA08875),
                                            fontSize:
                                                SizeConfig.defaultSize * 2.1,
                                            fontFamily: kHelveticaRegular),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                if (!isDeleting)
                                  ElevatedButton(
                                      onPressed: () async {
                                        setState(() => isDeleting = true);
                                        bool deleteSuccess = await data
                                            .deleteUser(context: context);
                                        if (!deleteSuccess) {
                                          setState(() => isDeleting = false);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFdc3545),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.defaultSize,
                                            vertical:
                                                SizeConfig.defaultSize * 0.5),
                                        child: Text(
                                          AppLocalizations.of(context).ok,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.defaultSize * 2.1,
                                              fontFamily: kHelveticaRegular),
                                        ),
                                      )),
                              ],
                            ));
                      });
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return data
                    .getMyProfileOptionList(context: context)
                    .map((e) => PopupMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5,
                              color: (e ==
                                      AppLocalizations.of(context)
                                          .deleteAccount)
                                  ? Colors.red
                                  : Colors.black),
                        )))
                    .toList();
              }),
        ));
      });
    }),
  ]);
}
