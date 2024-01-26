import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/constant/color_constant.dart';
import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../../logic/providers/profile_news_provider.dart';
import '../../helper/size_configuration.dart';

class ProfileTopContainer extends StatelessWidget {
  const ProfileTopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(builder: (context, data, child) {
      final user = data.loginSuccess.user;
      return user == null
          ? const SizedBox()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user.profilePicture == null ||
                        user.profilePicture == 'null' ||
                        user.profilePicture == ''
                    ? Container(
                        margin: EdgeInsets.only(
                            right: SizeConfig.defaultSize * 1.5),
                        height: SizeConfig.defaultSize * 9,
                        width: SizeConfig.defaultSize * 9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/default_profile.jpg"),
                              fit: BoxFit.cover),
                        ))
                    : CachedNetworkImage(
                        imageUrl: kIMAGEURL + user.profilePicture.toString(),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: kHelveticaMedium,
                          fontSize: SizeConfig.defaultSize * 2,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.defaultSize * .5,
                      ),
                      Text(
                        "ID: ${user.id}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.defaultSize * 1.55,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
    });
  }
}
