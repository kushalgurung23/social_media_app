import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/color_constant.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class ProfileTopContainer extends StatelessWidget {
  final User user;

  const ProfileTopContainer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          user.profileImage == null ||
                  data.profileImage == 'null' ||
                  data.profileImage == null
              ? Container(
                  margin: EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
                  height: SizeConfig.defaultSize * 9,
                  width: SizeConfig.defaultSize * 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: const DecorationImage(
                        image: AssetImage("assets/images/default_profile.jpg"),
                        fit: BoxFit.cover),
                  ))
              : CachedNetworkImage(
                  imageUrl: kIMAGEURL + data.profileImage!,
                  imageBuilder: (context, imageProvider) => Container(
                    margin:
                        EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
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
                    margin:
                        EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
                    height: SizeConfig.defaultSize * 9,
                    width: SizeConfig.defaultSize * 9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFD0E0F0),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.userNameTextController.text,
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
