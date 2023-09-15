import 'dart:async';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/presentation/components/chat/chat_room_container.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomListView extends StatefulWidget {
  const ChatRoomListView({Key? key}) : super(key: key);

  @override
  State<ChatRoomListView> createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {
  final scrollController = ScrollController();
  StreamController<AllConversations?> allConversationsStreamController =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();

    Provider.of<ChatMessageProvider>(context, listen: false)
        .refreshAllConversations(
            context: context,
            allConversationsStreamController: allConversationsStreamController);
    // this will load more data when we reach the end of chat
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
  }

  void loadNextData() async {
    await Provider.of<ChatMessageProvider>(context, listen: false)
        .loadMoreConversations(
            context: context,
            allConversationsController: allConversationsStreamController);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(builder: (context, data, child) {
      return StreamBuilder<AllConversations?>(
          stream: allConversationsStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Text(AppLocalizations.of(context).loading,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5)),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                        AppLocalizations.of(context)
                            .chatMessagesCouldNotBeLoaded,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                } else if (snapshot.data?.conversations == null ||
                    snapshot.data!.conversations!.isEmpty) {
                  return Center(
                    child: Text(
                        // translate
                        "No conversation yet",
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                } else {
                  List<Conversation> allConversations =
                      snapshot.data!.conversations!;
                  return Column(
                    children: [
                      SizedBox(height: SizeConfig.defaultSize),
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: () => data.refreshAllConversations(
                              context: context,
                              allConversationsStreamController:
                                  allConversationsStreamController),
                          child: ListView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: allConversations.length >=
                                      data.conversationPageSize
                                  ? allConversations.length + 1
                                  : allConversations.length,
                              itemBuilder: (context, index) {
                                // if the index value is less than the total fetched list data, we will show the conversation list, else circular progress indicator or finish text will be shown
                                if (index < allConversations.length) {
                                  final bool amISender = allConversations[index]
                                              .chatMessage
                                              ?.sender
                                              ?.id
                                              .toString() ==
                                          data.mainScreenProvider.currentUserId
                                      ? true
                                      : false;
                                  final ChatMessage? currentChatMessage =
                                      allConversations[index].chatMessage;
                                  final sender = currentChatMessage?.sender;
                                  final receiver = currentChatMessage?.receiver;
                                  return currentChatMessage == null ||
                                          sender == null ||
                                          receiver == null
                                      ? const SizedBox()
                                      : ChatroomContainer(
                                          index: index,
                                          amISender: amISender,
                                          currentChatMessage:
                                              currentChatMessage,
                                          sender: sender,
                                          receiver: receiver);
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.defaultSize * 3),
                                    child: Center(
                                        child: data.conversationHasMore
                                            ? const CircularProgressIndicator(
                                                color: Color(0xFFA08875))
                                            : Text(
                                                AppLocalizations.of(context)
                                                    .reachedTheEndOfConvo,
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaMedium,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                              )),
                                  );
                                }
                              }),
                        ),
                      ),
                    ],
                  );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    allConversationsStreamController.close();
    super.dispose();
  }
}
