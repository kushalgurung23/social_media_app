import 'dart:async';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_chat_messages.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreenListView extends StatefulWidget {
  final StreamController<AllChatMessages?> oneChatMessageStreamController;
  const ChatScreenListView(
      {Key? key, required this.oneChatMessageStreamController})
      : super(key: key);

  @override
  State<ChatScreenListView> createState() => _ChatScreenListViewState();
}

class _ChatScreenListViewState extends State<ChatScreenListView> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(builder: (context, data, child) {
      return StreamBuilder<AllChatMessages?>(
          stream: widget.oneChatMessageStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Flexible(
                  child: Center(
                    child: Text(AppLocalizations.of(context).loading,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError || !snapshot.hasData) {
                  return Flexible(
                    child: Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .chatMessagesCouldNotBeLoaded,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    ),
                  );
                } else if (snapshot.data?.chatMessages == null) {
                  return Flexible(
                    child: Center(
                      child: Text(
                          // translate
                          "No conversation yet",
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    ),
                  );
                } else {
                  return snapshot.data!.chatMessages!.isEmpty
                      ? Flexible(
                          child: Container(
                            color: const Color(0xFFF1F6FB),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 15),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .startANewConversation,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
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
                              itemCount: snapshot.data!.chatMessages!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final oneMessage =
                                    snapshot.data!.chatMessages![index];
                                final ConversationUser? sender =
                                    oneMessage.sender;
                                final ConversationUser? receiver =
                                    oneMessage.receiver;
                                bool amISender = sender?.id.toString() ==
                                        data.mainScreenProvider.currentUserId
                                    ? true
                                    : false;
                                return sender == null || receiver == null
                                    ? const SizedBox()
                                    : Padding(
                                        padding: index == 0
                                            ? EdgeInsets.only(
                                                top: SizeConfig.defaultSize * 2,
                                                bottom: SizeConfig.defaultSize *
                                                    1.5)
                                            : EdgeInsets.only(
                                                bottom: SizeConfig.defaultSize *
                                                    1.5),
                                        child: Column(
                                          crossAxisAlignment: amISender
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: amISender
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                amISender
                                                    ? SizedBox(
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            7)
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            right: SizeConfig
                                                                .defaultSize),
                                                        child: amISender == false &&
                                                                receiver.profilePicture !=
                                                                    null
                                                            ? CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(kIMAGEURL +
                                                                        receiver
                                                                            .profilePicture
                                                                            .toString()),
                                                                radius: SizeConfig
                                                                        .defaultSize *
                                                                    1.5)
                                                            : CircleAvatar(
                                                                backgroundImage:
                                                                    const AssetImage("assets/images/default_profile.jpg"),
                                                                radius: SizeConfig.defaultSize * 1.5)),
                                                Flexible(
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize *
                                                              2,
                                                          horizontal: SizeConfig
                                                                  .defaultSize *
                                                              2.5),
                                                      decoration: BoxDecoration(
                                                          color: amISender
                                                              ? const Color(
                                                                  0xFFA08875)
                                                              : const Color(
                                                                  0xFFFFFFFF),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft: amISender
                                                                ? const Radius
                                                                        .circular(
                                                                    30)
                                                                : const Radius
                                                                    .circular(0),
                                                            bottomRight: amISender
                                                                ? const Radius
                                                                    .circular(0)
                                                                : const Radius
                                                                    .circular(30),
                                                            topLeft: const Radius
                                                                .circular(30),
                                                            topRight: const Radius
                                                                .circular(30),
                                                          )),
                                                      child: Text(
                                                        oneMessage.text
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                kHelveticaRegular,
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.45,
                                                            color: amISender
                                                                ? Colors.white
                                                                : Colors.black,
                                                            height: 1.3),
                                                      )),
                                                ),
                                                amISender
                                                    ? Padding(
                                                        padding: EdgeInsets.only(
                                                            left: SizeConfig
                                                                .defaultSize),
                                                        child: amISender == true &&
                                                                sender.profilePicture !=
                                                                    null
                                                            ? CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(kIMAGEURL +
                                                                        sender.profilePicture
                                                                            .toString()),
                                                                radius: SizeConfig.defaultSize *
                                                                    1.5)
                                                            : CircleAvatar(
                                                                backgroundImage:
                                                                    const AssetImage(
                                                                        "assets/images/default_profile.jpg"),
                                                                radius: SizeConfig
                                                                        .defaultSize *
                                                                    1.5))
                                                    : SizedBox(width: SizeConfig.defaultSize * 7)
                                              ],
                                            ),
                                            Padding(
                                              padding: amISender
                                                  ? EdgeInsets.only(
                                                      right: SizeConfig
                                                              .defaultSize *
                                                          7.5,
                                                      top: SizeConfig
                                                          .defaultSize)
                                                  : EdgeInsets.only(
                                                      left: SizeConfig
                                                              .defaultSize *
                                                          7.5,
                                                      top: SizeConfig
                                                          .defaultSize),
                                              child: Text(
                                                oneMessage.createdAt == null
                                                    ? ''
                                                    : data
                                                        .convertDateTimeForChat(
                                                            oneMessage
                                                                .createdAt!),
                                                style: TextStyle(
                                                  fontFamily: kHelveticaRegular,
                                                  color:
                                                      const Color(0xFF8D8C8C),
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.1,
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
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
