import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/all/adjustable_text_form_field.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/news/selected_multiple_images.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPostScreen extends StatefulWidget {
  static const String id = '/new_post_screen';

  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  GlobalKey<FormState> newPostContentKey = GlobalKey<FormState>();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: topAppBar(
          leadingWidget: IconButton(
            splashRadius: SizeConfig.defaultSize * 2.5,
            icon: Icon(CupertinoIcons.back,
                color: const Color(0xFF8897A7),
                size: SizeConfig.defaultSize * 2.7),
            onPressed: () {
              data.goBackFromNewPostScreen(
                  titleTextController: titleTextController,
                  contentTextController: contentTextController,
                  context: context);
            },
          ),
          title: AppLocalizations.of(context).newPost,
        ),
        body: Form(
          key: newPostContentKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize, 0,
                      SizeConfig.defaultSize, SizeConfig.defaultSize * 2),
                  child: AdjustableTextFormField(
                      maxLength: 30,
                      minLines: 1,
                      maxLines: 1,
                      textInputType: TextInputType.text,
                      validator: (value) {
                        return data.validatePostTitle(
                            value: value, context: context);
                      },
                      textEditingController: titleTextController,
                      isEnable: true,
                      isReadOnly: false,
                      usePrefix: false,
                      useSuffix: false,
                      hintText: AppLocalizations.of(context).title,
                      iconOnPress: () {},
                      borderRadius: 10),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1.2),
                  child: AdjustableTextFormField(
                      validator: (value) {
                        return data.validatePostContent(
                            value: value, context: context);
                      },
                      hintTextFontSize: SizeConfig.defaultSize * 1.7,
                      minLines: 12,
                      maxLines: 12,
                      textInputType: TextInputType.text,
                      textEditingController: contentTextController,
                      isEnable: true,
                      isReadOnly: false,
                      usePrefix: false,
                      useSuffix: false,
                      hintText:
                          AppLocalizations.of(context).writeYourContentHere,
                      iconOnPress: () {},
                      borderRadius: 10),
                ),
                data.imageFileList == null || data.imageFileList!.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.defaultSize * 2,
                            SizeConfig.defaultSize * 1.5,
                            SizeConfig.defaultSize * 2,
                            0),
                        child: SelectedMultipleImages(
                            imageFileList: data.imageFileList),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.defaultSize * 2,
                      horizontal: SizeConfig.defaultSize * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          data.selectMultiImages();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: const Color(0xFFE6E6E6), width: 0.3)),
                          height: SizeConfig.defaultSize * 5,
                          width: SizeConfig.defaultSize * 5,
                          child: Center(
                            child: Icon(Icons.image,
                                color: const Color(0xFFA08875),
                                size: SizeConfig.defaultSize * 3.3),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.defaultSize * 2),
                      Expanded(
                        child: RectangularButton(
                          textPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 1.5),
                          height: SizeConfig.defaultSize * 5,
                          onPress: () async {
                            final isValid =
                                newPostContentKey.currentState!.validate();
                            if (isValid) {
                              data.createANewPost(
                                  titleTextController: titleTextController,
                                  contentTextController: contentTextController,
                                  context: context);
                            }
                          },
                          text: AppLocalizations.of(context).post.toUpperCase(),
                          textColor: Colors.white,
                          buttonColor: const Color(0xFFA08875),
                          borderColor: const Color(0xFFFFFFFF),
                          fontFamily: kHelveticaMedium,
                          keepBoxShadow: true,
                          offset: const Offset(0, 3),
                          borderRadius: 6,
                          blurRadius: 6,
                          fontSize: SizeConfig.defaultSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    contentTextController.dispose();
    super.dispose();
  }
}
