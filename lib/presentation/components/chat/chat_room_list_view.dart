import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/conversation_model.dart';
import 'package:spa_app/data/repositories/chat_messages_repo.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatRoomListView extends StatefulWidget {
  const ChatRoomListView({Key? key}) : super(key: key);

  @override
  State<ChatRoomListView> createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {
  final scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ChatMessageProvider>(context, listen: false)
        .loadInitialAllConversations(context: context);
  }

  @override
  void initState() {
    super.initState();

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
        .loadMoreConversation(context: context);
  }

  // Total conversation count after empty conversations are deleted if any
  int convoCountAfterDelete = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(builder: (context, data, child) {
      return StreamBuilder<Conversation?>(
          stream: data.allConversationStreamController.stream,
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
                if (snapshot.hasError) {
                  return Center(
                    child: Text(AppLocalizations.of(context).refreshPage,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                        AppLocalizations.of(context)
                            .chatMessagesCouldNotBeLoaded,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                } else {
                  List<ConversationData>? conversationList =
                      snapshot.data!.data;

                  List<ConversationData> filteredConversationList = [];

                  for (var conversionData in conversationList!) {
                    if (conversionData.attributes!.secondUser != null &&
                        conversionData.attributes!.secondUser!.data != null) {
                      filteredConversationList.add(conversionData);
                    }
                    //conversationData.attributes!.secondUser!.data!
                    if (conversionData.attributes!.chatMessages!.data == null ||
                        conversionData
                            .attributes!.chatMessages!.data!.isEmpty) {
                      ChatMessagesRepo.deleteConversation(
                          conversationId: conversionData.id.toString(),
                          jwt: data.mainScreenProvider.jwt!);
                      convoCountAfterDelete++;
                    }
                  }

                  // if there is any empty conversation, it will be deleted. If after deleting empty convos, there are no conversation left, it means conversation of current user is empty
                  return filteredConversationList.length ==
                          convoCountAfterDelete
                      ? Center(
                          child: Text(
                              AppLocalizations.of(context).noConversationYet,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5)))
                      : filteredConversationList.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: SizeConfig.defaultSize),
                                Flexible(
                                  child: RefreshIndicator(
                                    onRefresh: () =>
                                        data.refresh(context: context),
                                    child: ListView.builder(
                                        controller: scrollController,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                                parent:
                                                    BouncingScrollPhysics()),
                                        itemCount: filteredConversationList
                                                    .length >=
                                                15
                                            ? filteredConversationList.length +
                                                1
                                            : filteredConversationList.length,
                                        itemBuilder: (context, index) {
                                          // if the index value is less than the total fetched list data, we will show the conversation list, else circular progress indicator or finish text will be shown
                                          if (index <
                                              filteredConversationList.length) {
                                            final conversationData =
                                                filteredConversationList[index];

                                            final firstUser = conversationData
                                                .attributes!.firstUser;
                                            final secondUser = conversationData
                                                .attributes!.secondUser;
                                            conversationData
                                                .attributes!.chatMessages!.data!
                                                .sort((a, b) =>
                                                    a.id!.compareTo(b.id!));

                                            ConversationChatAttributes?
                                                lastMessage = conversationData
                                                                .attributes!
                                                                .chatMessages!
                                                                .data ==
                                                            null ||
                                                        (conversationData
                                                                    .attributes!
                                                                    .chatMessages!
                                                                    .data !=
                                                                null &&
                                                            conversationData
                                                                .attributes!
                                                                .chatMessages!
                                                                .data!
                                                                .isEmpty)
                                                    ? null
                                                    : conversationData
                                                        .attributes!
                                                        .chatMessages!
                                                        .data!
                                                        .last
                                                        .attributes;
                                            return firstUser == null ||
                                                    firstUser.data == null ||
                                                    secondUser == null ||
                                                    secondUser.data == null ||
                                                    conversationData
                                                            .attributes!
                                                            .chatMessages!
                                                            .data ==
                                                        null ||
                                                    conversationData
                                                        .attributes!
                                                        .chatMessages!
                                                        .data!
                                                        .isEmpty ||
                                                    lastMessage == null
                                                ? const SizedBox()
                                                : GestureDetector(
                                                    onTap: () async {
                                                      await data
                                                          .navigateToChatScreenFromChatroom(
                                                        otherUserDeviceToken: firstUser
                                                                    .data!.id
                                                                    .toString() ==
                                                                data.mainScreenProvider
                                                                    .userId
                                                                    .toString()
                                                            ? secondUser
                                                                .data!
                                                                .attributes!
                                                                .deviceToken
                                                            : firstUser
                                                                .data!
                                                                .attributes!
                                                                .deviceToken,
                                                        isFirstUser: firstUser
                                                                .data!.id
                                                                .toString() ==
                                                            data.mainScreenProvider
                                                                .userId
                                                                .toString(),
                                                        context: context,
                                                        myImageUrl: firstUser.data!.id
                                                                        .toString() ==
                                                                    data.mainScreenProvider
                                                                        .userId
                                                                        .toString() &&
                                                                firstUser
                                                                        .data!
                                                                        .attributes!
                                                                        .profileImage!
                                                                        .data !=
                                                                    null
                                                            ? firstUser
                                                                .data!
                                                                .attributes!
                                                                .profileImage!
                                                                .data!
                                                                .attributes!
                                                                .url
                                                                .toString()
                                                            : secondUser.data!.id.toString() == data.mainScreenProvider.userId.toString() &&
                                                                    secondUser
                                                                            .data!
                                                                            .attributes!
                                                                            .profileImage!
                                                                            .data !=
                                                                        null
                                                                ? secondUser
                                                                    .data!
                                                                    .attributes!
                                                                    .profileImage!
                                                                    .data!
                                                                    .attributes!
                                                                    .url
                                                                    .toString()
                                                                : 'null',
                                                        otherUserImageUrl: firstUser
                                                                        .data!.id
                                                                        .toString() !=
                                                                    data.mainScreenProvider
                                                                        .userId
                                                                        .toString() &&
                                                                firstUser
                                                                        .data!
                                                                        .attributes!
                                                                        .profileImage!
                                                                        .data !=
                                                                    null
                                                            ? firstUser
                                                                .data!
                                                                .attributes!
                                                                .profileImage!
                                                                .data!
                                                                .attributes!
                                                                .url
                                                                .toString()
                                                            : secondUser.data!.id.toString() != data.mainScreenProvider.userId.toString() &&
                                                                    secondUser
                                                                            .data!
                                                                            .attributes!
                                                                            .profileImage!
                                                                            .data !=
                                                                        null
                                                                ? secondUser
                                                                    .data!
                                                                    .attributes!
                                                                    .profileImage!
                                                                    .data!
                                                                    .attributes!
                                                                    .url
                                                                    .toString()
                                                                : 'null',
                                                        messageConversationList:
                                                            conversationData
                                                                .attributes!
                                                                .chatMessages!
                                                                .data!
                                                                .reversed
                                                                .toList(),
                                                        otherUserId: firstUser
                                                                    .data!.id
                                                                    .toString() !=
                                                                data.mainScreenProvider
                                                                    .userId
                                                                    .toString()
                                                            ? firstUser.data!.id
                                                                .toString()
                                                            : secondUser
                                                                .data!.id
                                                                .toString(),
                                                        otherUsername: firstUser
                                                                    .data!.id
                                                                    .toString() !=
                                                                data.mainScreenProvider
                                                                    .userId
                                                                    .toString()
                                                            ? firstUser
                                                                .data!
                                                                .attributes!
                                                                .username
                                                                .toString()
                                                            : secondUser
                                                                .data!
                                                                .attributes!
                                                                .username
                                                                .toString(),
                                                        chatTextEditingController:
                                                            data.chatTextController,
                                                        conversationId:
                                                            conversationData.id
                                                                .toString(),
                                                      );
                                                    },
                                                    child: Container(
                                                      margin: index == 0
                                                          ? EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .defaultSize *
                                                                  1,
                                                              bottom: SizeConfig
                                                                      .defaultSize *
                                                                  1)
                                                          : EdgeInsets.only(
                                                              bottom: SizeConfig
                                                                      .defaultSize *
                                                                  1),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        // if last message was sent by the current user,
                                                        color: lastMessage
                                                                    .sender!
                                                                    .data!
                                                                    .id
                                                                    .toString() ==
                                                                data.mainScreenProvider
                                                                    .userId
                                                            ? Colors.white
                                                            // else
                                                            // if first user is the current user
                                                            : firstUser.data!.id
                                                                        .toString() ==
                                                                    data.mainScreenProvider
                                                                        .userId
                                                                        .toString()
                                                                ? ((conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) || (conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.toLocal().isAfter(lastMessage.createdAt!.toLocal()))
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(0xFF5545CF).withOpacity(
                                                                        0.3))
                                                                // else if second user is the current user
                                                                : ((conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) ||
                                                                        (conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.isAfter(lastMessage.createdAt!.toLocal()))
                                                                    ? Colors.white
                                                                    : const Color(0xFF5545CF).withOpacity(0.3)),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: SizeConfig
                                                                    .defaultSize *
                                                                1,
                                                            horizontal: SizeConfig
                                                                    .defaultSize *
                                                                1),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            conversationData
                                                                            .attributes!
                                                                            .firstUser!
                                                                            .data!
                                                                            .id
                                                                            .toString() !=
                                                                        data.mainScreenProvider
                                                                            .userId
                                                                            .toString() &&
                                                                    conversationData
                                                                            .attributes!
                                                                            .firstUser!
                                                                            .data!
                                                                            .attributes!
                                                                            .profileImage!
                                                                            .data !=
                                                                        null
                                                                ? CachedNetworkImage(
                                                                    imageUrl: kIMAGEURL +
                                                                        conversationData
                                                                            .attributes!
                                                                            .firstUser!
                                                                            .data!
                                                                            .attributes!
                                                                            .profileImage!
                                                                            .data!
                                                                            .attributes!
                                                                            .url
                                                                            .toString(),
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              SizeConfig.defaultSize * 2),
                                                                      height:
                                                                          SizeConfig.defaultSize *
                                                                              4.7,
                                                                      width: SizeConfig
                                                                              .defaultSize *
                                                                          4.7,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(SizeConfig.defaultSize *
                                                                                1.8),
                                                                        color: Colors
                                                                            .white,
                                                                        image: DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              SizeConfig.defaultSize * 2),
                                                                      height:
                                                                          SizeConfig.defaultSize *
                                                                              4.7,
                                                                      width: SizeConfig
                                                                              .defaultSize *
                                                                          4.7,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(SizeConfig.defaultSize *
                                                                                1.8),
                                                                        color: const Color(
                                                                            0xFFD0E0F0),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  )
                                                                : (conversationData.attributes!.secondUser!.data!.id.toString() !=
                                                                            data.mainScreenProvider.userId
                                                                                .toString() &&
                                                                        conversationData.attributes!.secondUser!.data!.attributes!.profileImage!.data !=
                                                                            null)
                                                                    ? CachedNetworkImage(
                                                                        imageUrl:
                                                                            kIMAGEURL +
                                                                                conversationData.attributes!.secondUser!.data!.attributes!.profileImage!.data!.attributes!.url.toString(),
                                                                        imageBuilder:
                                                                            (context, imageProvider) =>
                                                                                Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: SizeConfig.defaultSize * 2),
                                                                          height:
                                                                              SizeConfig.defaultSize * 4.7,
                                                                          width:
                                                                              SizeConfig.defaultSize * 4.7,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(SizeConfig.defaultSize * 1.8),
                                                                            color:
                                                                                Colors.white,
                                                                            image:
                                                                                DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                          ),
                                                                        ),
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: SizeConfig.defaultSize * 2),
                                                                          height:
                                                                              SizeConfig.defaultSize * 4.7,
                                                                          width:
                                                                              SizeConfig.defaultSize * 4.7,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(SizeConfig.defaultSize * 1.8),
                                                                            color:
                                                                                const Color(0xFFD0E0F0),
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      )
                                                                    : Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                SizeConfig.defaultSize * 2),
                                                                        height: SizeConfig.defaultSize *
                                                                            4.7,
                                                                        width: SizeConfig.defaultSize *
                                                                            4.7,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(SizeConfig.defaultSize * 1.5),
                                                                          color:
                                                                              Colors.white,
                                                                          image: const DecorationImage(
                                                                              image: AssetImage("assets/images/default_profile.jpg"),
                                                                              fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Text(
                                                                            conversationData.attributes!.firstUser!.data!.id.toString() != data.mainScreenProvider.userId.toString()
                                                                                ? conversationData.attributes!.firstUser!.data!.attributes!.username.toString()
                                                                                : conversationData.attributes!.secondUser!.data!.attributes!.username.toString(),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(fontFamily: kHelveticaMedium, fontSize: SizeConfig.defaultSize * 1.4)),
                                                                      ),
                                                                      SizedBox(
                                                                          width: SizeConfig.defaultSize *
                                                                              7,
                                                                          child: Text(
                                                                              data.mainScreenProvider.convertDateTimeToAgo(lastMessage.createdAt!, context),
                                                                              textAlign: TextAlign.end,
                                                                              style: TextStyle(
                                                                                  fontFamily:

                                                                                      // if last message was sent by the current user,
                                                                                      lastMessage.sender!.data!.id.toString() == data.mainScreenProvider.userId
                                                                                          ? kHelveticaRegular
                                                                                          // else
                                                                                          // if first user is the current user
                                                                                          : firstUser.data!.id.toString() == data.mainScreenProvider.userId.toString()
                                                                                              ? ((conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) || (conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.isAfter(lastMessage.createdAt!.toLocal())) ? kHelveticaRegular : kHelveticaMedium)
                                                                                              // else if second user is the current user
                                                                                              : ((conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) || (conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.isAfter(lastMessage.createdAt!.toLocal())) ? kHelveticaRegular : kHelveticaMedium),
                                                                                  fontSize: SizeConfig.defaultSize * 1.15)))
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        SizeConfig.defaultSize *
                                                                            0.5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          lastMessage
                                                                              .text
                                                                              .toString(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                // if last message was sent by the current user,
                                                                                lastMessage.sender!.data!.id.toString() == data.mainScreenProvider.userId
                                                                                    ? kHelveticaRegular
                                                                                    // else
                                                                                    // if first user is the current user
                                                                                    : firstUser.data!.id.toString() == data.mainScreenProvider.userId.toString()
                                                                                        ? ((conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) || (conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.isAfter(lastMessage.createdAt!.toLocal())) ? kHelveticaRegular : kHelveticaMedium)
                                                                                        // else if second user is the current user
                                                                                        : ((conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!.toLocal())) || (conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.isAfter(lastMessage.createdAt!.toLocal())) ? kHelveticaRegular : kHelveticaMedium),
                                                                            fontSize:
                                                                                // if last message was sent by the current user,
                                                                                lastMessage.sender!.data!.id.toString() == data.mainScreenProvider.userId
                                                                                    ? SizeConfig.defaultSize * 1.25
                                                                                    // else
                                                                                    // if first user is the current user
                                                                                    : firstUser.data!.id.toString() == data.mainScreenProvider.userId.toString()
                                                                                        ? ((conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!)) || (conversationData.attributes!.firstUserLastRead != null && conversationData.attributes!.firstUserLastRead!.isAfter(lastMessage.createdAt!)) ? SizeConfig.defaultSize * 1.25 : SizeConfig.defaultSize * 1.4)
                                                                                        // else if second user is the current user
                                                                                        : ((conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.toLocal().isAtSameMomentAs(lastMessage.createdAt!)) || (conversationData.attributes!.secondUserLastRead != null && conversationData.attributes!.secondUserLastRead!.isAfter(lastMessage.createdAt!)) ? SizeConfig.defaultSize * 1.25 : SizeConfig.defaultSize * 1.4),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            SizeConfig.defaultSize *
                                                                                7,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      SizeConfig.defaultSize *
                                                          3),
                                              child: Center(
                                                  child: data.hasMore
                                                      ? const CircularProgressIndicator(
                                                          color:
                                                              Color(0xFF5545CF))
                                                      : Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .reachedTheEndOfConvo,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kHelveticaMedium,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                        )),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              ],
                            )
                          : snapshot.data!.data!.isEmpty &&
                                  data.isRefresh == true
                              ? Center(
                                  child: Text(
                                      AppLocalizations.of(context).reloading,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5)))
                              : Center(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .noConversationYet,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5)));
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
