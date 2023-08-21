import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/profile/edit_image.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPublicInfo extends StatelessWidget {
  const EditPublicInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, data, child) {
        return Column(
          children: [
            // If we haven't selected any new image from gallery or camera, then show user's image
            data.image == null && data.profileImage == 'null'
                ? Container(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize * 2),
                    height: SizeConfig.defaultSize * 9,
                    width: SizeConfig.defaultSize * 9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        image: const DecorationImage(
                            image:
                                AssetImage("assets/images/default_profile.jpg"),
                            fit: BoxFit.cover)),
                    child: EditImage(
                      onTap: () {
                        data.chooseImage(context: context);
                      },
                    ),
                  )
                : data.image == null &&
                        data.profileImage != 'null' &&
                        data.profileImage != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize * 2),
                        child: CachedNetworkImage(
                          imageUrl: kIMAGEURL + data.profileImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.defaultSize * 1.5),
                            height: SizeConfig.defaultSize * 9,
                            width: SizeConfig.defaultSize * 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                            child: EditImage(
                              onTap: () {
                                data.chooseImage(context: context);
                              },
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.defaultSize * 1.5),
                            height: SizeConfig.defaultSize * 9,
                            width: SizeConfig.defaultSize * 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFD0E0F0),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize * 2),
                        height: SizeConfig.defaultSize * 9,
                        width: SizeConfig.defaultSize * 9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: FileImage(File(data.image!.path)))),
                        child: EditImage(
                          onTap: () {
                            data.chooseImage(context: context);
                          },
                        ),
                      ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.defaultSize * 10,
                    child: Text('${AppLocalizations.of(context).username} :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black)),
                  ),
                  Expanded(
                    child: RoundedTextFormField(
                        textInputType: TextInputType.text,
                        validator: (value) {
                          return data.validateUserName(
                              value: value, context: context);
                        },
                        textEditingController: data.userNameTextController,
                        isEnable: true,
                        isReadOnly: false,
                        usePrefix: false,
                        useSuffix: false,
                        hintText:
                            '${AppLocalizations.of(context).example}: Kushal',
                        suffixOnPress: () {},
                        borderRadius: 10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.defaultSize * 10,
                    child: Text('${AppLocalizations.of(context).type} :',
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black)),
                  ),
                  Expanded(
                    child: RoundedTextFormField(
                        textInputType: TextInputType.text,
                        textEditingController: data.userTypeTextController,
                        isEnable: false,
                        isReadOnly: true,
                        usePrefix: false,
                        useSuffix: false,
                        hintText: '',
                        suffixOnPress: () {},
                        borderRadius: 10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.defaultSize * 10,
                    child: Text('${AppLocalizations.of(context).regDate} :',
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black)),
                  ),
                  Expanded(
                    child: RoundedTextFormField(
                        textInputType: TextInputType.text,
                        textEditingController: data.regDateTextController,
                        isEnable: false,
                        isReadOnly: true,
                        usePrefix: false,
                        useSuffix: false,
                        hintText:
                            '${AppLocalizations.of(context).example}: 2015 - 12 - 05',
                        suffixOnPress: () {},
                        borderRadius: 10),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
