import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/search_user_model.dart';
import 'package:c_talent/logic/providers/discover_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/my_profile_screen.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';

class DiscoverUserContainer extends StatelessWidget {
  final SearchUser searchUser;

  const DiscoverUserContainer({Key? key, required this.searchUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverProvider>(builder: (context, data, child) {
      return GestureDetector(
        onTap: () async {
          if (searchUser.id.toString() != data.mainScreenProvider.userId!) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherUserProfileScreen(
                          otherUserId: searchUser.id!,
                        )));
          } else {
            await Navigator.pushNamed(context, MyProfileScreen.id);
          }
          if (context.mounted) {
            await data.searchUser(query: '', context: context);
          }
        },
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    searchUser.profileImage == null
                        ? Container(
                            height: SizeConfig.defaultSize * 4.7,
                            width: SizeConfig.defaultSize * 4.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.defaultSize * 1.5),
                              color: Colors.white,
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/default_profile.jpg"),
                                  fit: BoxFit.cover),
                            ))
                        : CachedNetworkImage(
                            imageUrl: kIMAGEURL + searchUser.profileImage!.url!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: SizeConfig.defaultSize * 4.7,
                              width: SizeConfig.defaultSize * 4.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.defaultSize * 1.5),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: SizeConfig.defaultSize * 4.7,
                              width: SizeConfig.defaultSize * 4.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.defaultSize * 1.5),
                                color: const Color(0xFFD0E0F0),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.defaultSize),
                      child: Text(searchUser.username!,
                          style: TextStyle(
                              fontFamily: kHelveticaMedium,
                              fontSize: SizeConfig.defaultSize * 1.4)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
