import 'dart:io';
import 'package:flutter/material.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SelectedMultipleImages extends StatelessWidget {
  final List<XFile?>? imageFileList;

  const SelectedMultipleImages({Key? key, required this.imageFileList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageFileList == null || imageFileList!.isEmpty
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: SizeConfig.defaultSize * 0.5),
            child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: imageFileList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    crossAxisCount: imageFileList!.length == 1
                        ? 1
                        : imageFileList!.length == 2
                            ? 2
                            : 3),
                itemBuilder: (context, index) {
                  return imageFileList![index] == null
                      ? const SizedBox()
                      : Container(
                          color: Colors.blue,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(imageFileList![index]!.path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: SizeConfig.defaultSize * 0.4,
                                  right: SizeConfig.defaultSize * 0.4,
                                  child: GestureDetector(
                                    onTap: () {
                                      Provider.of<NewsAdProvider>(context,
                                              listen: false)
                                          .removeSelectedImage(index: index);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      height: SizeConfig.defaultSize * 3,
                                      width: SizeConfig.defaultSize * 3,
                                      child: IconButton(
                                          splashRadius: 0.1,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            Provider.of<NewsAdProvider>(context,
                                                    listen: false)
                                                .removeSelectedImage(
                                                    index: index);
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: SizeConfig.defaultSize * 3,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ))
                            ],
                          ),
                        );
                }),
          );
  }
}
