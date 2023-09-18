import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatroomContainer extends StatefulWidget {
  final int index;
  final bool amISender;
  final ChatMessage currentChatMessage;
  final ConversationUser sender;
  final ConversationUser receiver;
  final VoidCallback onTap;

  const ChatroomContainer(
      {super.key,
      required this.onTap,
      required this.index,
      required this.amISender,
      required this.currentChatMessage,
      required this.sender,
      required this.receiver});

  @override
  State<ChatroomContainer> createState() => _ChatroomContainerState();
}

class _ChatroomContainerState extends State<ChatroomContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(builder: (context, data, child) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: widget.index == 0
              ? EdgeInsets.only(
                  top: SizeConfig.defaultSize * 1,
                  bottom: SizeConfig.defaultSize * 1)
              : EdgeInsets.only(bottom: SizeConfig.defaultSize * 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: widget.amISender
                  ? Colors.white
                  : widget.currentChatMessage.hasReceiverSeen == 1
                      ? Colors.white
                      : const Color(0xFFA08875).withOpacity(0.3)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.defaultSize * 1,
                horizontal: SizeConfig.defaultSize * 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.amISender && widget.receiver.profilePicture != null
                    ? CachedNetworkImage(
                        imageUrl: kIMAGEURL +
                            widget.receiver.profilePicture.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          margin: EdgeInsets.only(
                              right: SizeConfig.defaultSize * 2),
                          height: SizeConfig.defaultSize * 4.7,
                          width: SizeConfig.defaultSize * 4.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.defaultSize * 1.8),
                            color: Colors.white,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          margin: EdgeInsets.only(
                              right: SizeConfig.defaultSize * 2),
                          height: SizeConfig.defaultSize * 4.7,
                          width: SizeConfig.defaultSize * 4.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.defaultSize * 1.8),
                            color: const Color(0xFFD0E0F0),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : !widget.amISender && widget.sender.profilePicture != null
                        ? CachedNetworkImage(
                            imageUrl: kIMAGEURL +
                                widget.sender.profilePicture.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.defaultSize * 2),
                              height: SizeConfig.defaultSize * 4.7,
                              width: SizeConfig.defaultSize * 4.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.defaultSize * 1.8),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.defaultSize * 2),
                              height: SizeConfig.defaultSize * 4.7,
                              width: SizeConfig.defaultSize * 4.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.defaultSize * 1.8),
                                color: const Color(0xFFD0E0F0),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.defaultSize * 2),
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
                            ),
                          ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                                widget.amISender
                                    ? widget.receiver.username.toString()
                                    : widget.sender.username.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: kHelveticaMedium,
                                    fontSize: SizeConfig.defaultSize * 1.4)),
                          ),
                          SizedBox(
                              width: SizeConfig.defaultSize * 7,
                              child: Text(
                                  widget.currentChatMessage.createdAt == null
                                      ? ''
                                      : data.mainScreenProvider
                                          .convertDateTimeToAgo(
                                              widget.currentChatMessage
                                                  .createdAt!,
                                              context),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontFamily: widget.amISender
                                          ? kHelveticaRegular
                                          : widget.currentChatMessage
                                                      .hasReceiverSeen ==
                                                  1
                                              ? kHelveticaRegular
                                              : kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.15)))
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.defaultSize * 0.5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.currentChatMessage.text.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: widget.amISender
                                      ? kHelveticaRegular
                                      : widget.currentChatMessage
                                                  .hasReceiverSeen ==
                                              1
                                          ? kHelveticaRegular
                                          : kHelveticaMedium,
                                  fontSize: widget.amISender
                                      ? SizeConfig.defaultSize * 1.25
                                      : widget.currentChatMessage
                                                  .hasReceiverSeen ==
                                              1
                                          ? SizeConfig.defaultSize * 1.25
                                          : SizeConfig.defaultSize * 1.4),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.defaultSize * 7,
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
    });
  }
}
