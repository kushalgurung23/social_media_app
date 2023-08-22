import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/all_post_images.dart';

class ProfilePostStaggeredGridView extends StatelessWidget {
  final List<AllImage?>? postImage;

  const ProfilePostStaggeredGridView({Key? key, required this.postImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return postImage == null || postImage!.isEmpty
        ? const SizedBox()
        : postImage!.length == 1
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllPostImages(
                                postImages: [],
                                index: 0,
                                isFromProfile: true,
                                postImageFromProfile: postImage,
                              )));
                },
                child: CachedNetworkImage(
                  imageUrl: kIMAGEURL + postImage![0]!.url!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: SizeConfig.defaultSize * 20,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD0E0F0),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            // If we have more than one image
            : SizedBox(
                child: GridView.custom(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: postImage!.length == 3
                        ? 3
                        : postImage!.length < 5
                            ? 2
                            : 6,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    pattern: postImage!.length == 2
                        ? const [
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                          ]
                        : postImage!.length == 3
                            ? const [
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                                QuiltedGridTile(1, 1),
                              ]
                            : postImage!.length == 4
                                ? const [
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                  ]
                                : const [
                                    QuiltedGridTile(3, 3),
                                    QuiltedGridTile(3, 3),
                                    QuiltedGridTile(2, 2),
                                    QuiltedGridTile(2, 2),
                                    QuiltedGridTile(2, 2),
                                  ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllPostImages(
                                            postImages: [],
                                            index: index,
                                            isFromProfile: true,
                                            postImageFromProfile: postImage,
                                          )));
                            },
                            child: postImage!.length > 5 && index == 4
                                ? Stack(
                                    children: [
                                      CachedNetworkImage(
                                        height: double.infinity,
                                        width: double.infinity,
                                        imageUrl:
                                            kIMAGEURL + postImage![index]!.url!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          height: SizeConfig.defaultSize * 20,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFD0E0F0),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      Opacity(
                                        opacity: 0.35,
                                        child: Container(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        '+${postImage!.length - 4}',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 1.7,
                                            color: Colors.white,
                                            fontFamily: kHelveticaMedium,
                                            fontWeight: FontWeight.w700),
                                      )),
                                    ],
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        kIMAGEURL + postImage![index]!.url!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: SizeConfig.defaultSize * 20,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD0E0F0),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                      childCount:
                          postImage!.length < 5 ? postImage!.length : 5),
                ),
              );
  }
}
