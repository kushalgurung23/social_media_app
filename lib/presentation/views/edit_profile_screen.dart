import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/profile/edit_privacy.dart';
import 'package:spa_app/presentation/components/profile/edit_public_info.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatelessWidget {
  static const String id = '/edit_profile_screen';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, data, child) {
        return Scaffold(
            appBar: topAppBar(
                leadingWidget: data.isUpdateClick
                    ? const SizedBox()
                    : IconButton(
                        splashRadius: SizeConfig.defaultSize * 2.5,
                        icon: Icon(CupertinoIcons.back,
                            color: const Color(0xFF8897A7),
                            size: SizeConfig.defaultSize * 2.7),
                        onPressed: () {
                          data.goBackFromProfileEdit(context: context);
                        },
                      ),
                title: AppLocalizations.of(context).editProfile),
            body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: SingleChildScrollView(
                  child: Form(
                    key: data.editProfileKey,
                    child: Column(
                      children: [
                        // Public Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).publicInfo,
                              style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 2,
                                fontFamily: kHelveticaMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.defaultSize,
                            ),
                            Text(
                                '(${AppLocalizations.of(context).everyoneCanSee})',
                                style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 1.1,
                                    fontFamily: kHelveticaRegular,
                                    color: const Color(0xFF8897A7)))
                          ],
                        ),
                        const EditPublicInfo(),
                        // Privacy
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.defaultSize * 1.5,
                              bottom: SizeConfig.defaultSize * 1.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).privacy,
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 2,
                                  fontFamily: kHelveticaMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.defaultSize,
                              ),
                              Text(
                                  '(${AppLocalizations.of(context).noOneCansee})',
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.1,
                                      fontFamily: kHelveticaRegular,
                                      color: const Color(0xFF8897A7)))
                            ],
                          ),
                        ),
                        const EditPrivacy(),
                        data.isUpdateClick
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize * 3,
                                    bottom: SizeConfig.defaultSize * 2),
                                child: const CircularProgressIndicator(
                                    color: Color(0xFF5545CF)),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize * 3,
                                    bottom: SizeConfig.defaultSize * 4,
                                    left: SizeConfig.defaultSize * 3,
                                    right: SizeConfig.defaultSize * 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: RectangularButton(
                                      textPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.defaultSize * 1.5),
                                      height: SizeConfig.defaultSize * 5,
                                      onPress: () {
                                        data.goBackFromProfileEdit(
                                            context: context);
                                      },
                                      text: AppLocalizations.of(context).cancel,
                                      textColor: Colors.black,
                                      buttonColor: const Color(0xFFF4F4F4),
                                      borderColor: const Color(0xFFD0E0F0),
                                      fontFamily: kHelveticaRegular,
                                      keepBoxShadow: false,
                                      borderRadius: 10,
                                      fontSize: SizeConfig.defaultSize * 1.6,
                                    )),
                                    SizedBox(
                                        width: SizeConfig.defaultSize * 1.5),
                                    Expanded(
                                        child: RectangularButton(
                                      textPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.defaultSize * 1.5),
                                      keepBoxShadow: true,
                                      height: SizeConfig.defaultSize * 5,
                                      onPress: () {
                                        final isValid = data
                                            .editProfileKey.currentState!
                                            .validate();
                                        if (isValid) {
                                          data.updateUserDetails(
                                              context: context);
                                        }
                                      },
                                      text: AppLocalizations.of(context).save,
                                      textColor: Colors.white,
                                      buttonColor: const Color(0xFFFEB703),
                                      borderColor: const Color(0xFFFFFFFF),
                                      fontFamily: kHelveticaRegular,
                                      offset: const Offset(0, 1),
                                      borderRadius: 10,
                                      blurRadius: 3,
                                      fontSize: SizeConfig.defaultSize * 1.6,
                                    )),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                )));
      },
    );
  }
}
