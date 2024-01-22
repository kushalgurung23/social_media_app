import 'package:c_talent/data/models/all_push_notifications.dart';
import 'package:c_talent/logic/providers/push_notification_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class PushNotificationContainer extends StatelessWidget {
  final PushNotification pushNotification;
  final int index;

  const PushNotificationContainer(
      {super.key, required this.pushNotification, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<PushNotificationProvider>(builder: (context, data, child) {
      return Padding(
        padding: index == 0
            ? EdgeInsets.only(
                top: SizeConfig.defaultSize * 1,
                bottom: SizeConfig.defaultSize * 1)
            : EdgeInsets.only(bottom: SizeConfig.defaultSize * 1),
        child: InkWell(
          onTap: () {
            data.readNotification(
                pushNotification: pushNotification, context: context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: pushNotification.isRead == 1
                  ? Colors.white
                  : const Color(0xFFA08875).withOpacity(0.3),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.defaultSize * 1,
                  horizontal: SizeConfig.defaultSize * 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: SizeConfig.defaultSize * 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 0.3,
                                left: SizeConfig.defaultSize * 0.25),
                            child: data.returnIcon(
                                type: pushNotification.category.toString()),
                          ),
                        ],
                      )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "${pushNotification.sender?.username} ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black,
                            fontSize: SizeConfig.defaultSize * 1.4,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: data.returnMessage(
                                    context: context,
                                    type: pushNotification.category.toString()),
                                style: TextStyle(
                                    fontFamily: kHelveticaMedium,
                                    fontSize: SizeConfig.defaultSize * 1.3)),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.defaultSize * 0.2),
                        child: Text(
                          data.mainScreenProvider.convertDateTimeToAgo(
                              pushNotification.createdAt!, context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.3,
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.25,
                          ),
                        ),
                      ),
                    ],
                  )),
                  pushNotification.sender?.profilePicture == null
                      ? Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.defaultSize * 2.5),
                          height: SizeConfig.defaultSize * 4,
                          width: SizeConfig.defaultSize * 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.defaultSize * 1.5),
                            color: Colors.white,
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/default_profile.jpg"),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.defaultSize * 2.5),
                          child: CachedNetworkImage(
                            imageUrl: kIMAGEURL +
                                pushNotification.sender!.profilePicture
                                    .toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              height: SizeConfig.defaultSize * 4,
                              width: SizeConfig.defaultSize * 4,
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
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
