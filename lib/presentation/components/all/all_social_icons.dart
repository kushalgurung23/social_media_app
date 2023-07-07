import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:url_launcher/link.dart';

class AllSocialIcons extends StatelessWidget {
  final bool showFacebook, showTwitter, showInstagram;
  final String? facebookLink, twitterLink, instagramLink;

  const AllSocialIcons({
    Key? key,
    required this.showFacebook,
    required this.showTwitter,
    required this.showInstagram,
    required this.facebookLink,
    required this.twitterLink,
    required this.instagramLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // FACEBOOK
        showFacebook == true
            ? Link(
                target: LinkTarget.self,
                uri: Uri.parse(facebookLink!),
                builder: ((context, followLink) => IconButton(
                    splashRadius: SizeConfig.defaultSize * 2.5,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: followLink,
                    iconSize: SizeConfig.defaultSize * 3,
                    icon: SvgPicture.asset("assets/svg/facebook.svg"))),
              )
            : const SizedBox(),
        showFacebook == true
            ? SizedBox(
                width: SizeConfig.defaultSize,
              )
            : const SizedBox(),
        // TWITTER
        showTwitter == true
            ? Link(
                target: LinkTarget.self,
                uri: Uri.parse(twitterLink!),
                builder: ((context, followLink) => IconButton(
                    splashRadius: SizeConfig.defaultSize * 2.5,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: followLink,
                    iconSize: SizeConfig.defaultSize * 3,
                    icon: SvgPicture.asset("assets/svg/twitter.svg"))),
              )
            : const SizedBox(),
        showTwitter == true
            ? SizedBox(
                width: SizeConfig.defaultSize,
              )
            : const SizedBox(),
        // INSTAGRAM
        showInstagram == true
            ? Link(
                target: LinkTarget.self,
                uri: Uri.parse(instagramLink!),
                builder: ((context, followLink) => IconButton(
                    splashRadius: SizeConfig.defaultSize * 2.5,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: followLink,
                    iconSize: SizeConfig.defaultSize * 3,
                    icon: SvgPicture.asset("assets/svg/instagram.svg"))),
              )
            : const SizedBox(),
      ],
    );
  }
}
