import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreenListView extends StatefulWidget {
  final String myImageUrl, otherUserImageUrl;

  const ChatScreenListView(
      {Key? key, required this.myImageUrl, required this.otherUserImageUrl})
      : super(key: key);

  @override
  State<ChatScreenListView> createState() => _ChatScreenListViewState();
}

class _ChatScreenListViewState extends State<ChatScreenListView> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(builder: (context, data, child) {
      Timer(
          const Duration(milliseconds: 0),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));
      return data.socketMessageList.isEmpty
          ? Flexible(
              child: Container(
                color: const Color(0xFFF1F6FB),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  controller: scrollController,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.defaultSize * 15),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).startANewConversation,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Flexible(
              child: Container(
                color: const Color(0xFFF1F6FB),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  controller: scrollController,
                  itemCount: data.socketMessageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentChatDetails =
                        data.socketMessageList.reversed.toList()[index];
                    final isMe = currentChatDetails.senderId ==
                            Provider.of<MainScreenProvider>(context,
                                    listen: false)
                                .userId
                        ? true
                        : false;
                    return Padding(
                      padding: index == 0
                          ? EdgeInsets.only(
                              top: SizeConfig.defaultSize * 2,
                              bottom: SizeConfig.defaultSize * 1.5)
                          : EdgeInsets.only(
                              bottom: SizeConfig.defaultSize * 1.5),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              isMe
                                  ? SizedBox(width: SizeConfig.defaultSize * 7)
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.defaultSize),
                                      child: isMe == false &&
                                              widget.otherUserImageUrl != 'null'
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  kIMAGEURL +
                                                      widget.otherUserImageUrl
                                                          .toString()),
                                              radius:
                                                  SizeConfig.defaultSize * 1.5)
                                          : CircleAvatar(
                                              backgroundImage: const AssetImage(
                                                  "assets/images/default_profile.jpg"),
                                              radius: SizeConfig.defaultSize *
                                                  1.5)),
                              Flexible(
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.defaultSize * 2,
                                        horizontal:
                                            SizeConfig.defaultSize * 2.5),
                                    decoration: BoxDecoration(
                                        color: isMe
                                            ? const Color(0xFFA08875)
                                            : const Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: isMe
                                              ? const Radius.circular(30)
                                              : const Radius.circular(0),
                                          bottomRight: isMe
                                              ? const Radius.circular(0)
                                              : const Radius.circular(30),
                                          topLeft: const Radius.circular(30),
                                          topRight: const Radius.circular(30),
                                        )),
                                    child: Text(
                                      currentChatDetails.message.toString(),
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.4,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black,
                                          height: 1.3),
                                    )),
                              ),
                              isMe
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.defaultSize),
                                      child: isMe == true &&
                                              widget.myImageUrl != 'null'
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  kIMAGEURL +
                                                      widget.myImageUrl
                                                          .toString()),
                                              radius:
                                                  SizeConfig.defaultSize * 1.5)
                                          : CircleAvatar(
                                              backgroundImage: const AssetImage(
                                                  "assets/images/default_profile.jpg"),
                                              radius:
                                                  SizeConfig.defaultSize * 1.5))
                                  : SizedBox(width: SizeConfig.defaultSize * 7)
                            ],
                          ),
                          Padding(
                            padding: isMe
                                ? EdgeInsets.only(
                                    right: SizeConfig.defaultSize * 7.5,
                                    top: SizeConfig.defaultSize)
                                : EdgeInsets.only(
                                    left: SizeConfig.defaultSize * 7.5,
                                    top: SizeConfig.defaultSize),
                            child: Text(
                              data.convertDateTimeForChat(DateTime.parse(
                                  currentChatDetails.sentAt!
                                      .toLocal()
                                      .toString())),
                              style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                color: const Color(0xFF8D8C8C),
                                fontSize: SizeConfig.defaultSize * 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
