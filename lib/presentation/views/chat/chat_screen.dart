import 'dart:async';
import 'package:c_talent/data/models/all_chat_messages.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/chat/chat_screen_list_view.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final ConversationUser? otherUser, meUser;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.otherUser,
    required this.meUser,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatTextController = TextEditingController();
  StreamController<AllChatMessages?> oneChatMessageStreamController =
      BehaviorSubject();
  @override
  void initState() {
    Provider.of<ChatMessageProvider>(context, listen: false)
        .refreshAllChatMessages(
            context: context,
            conversationId: widget.conversationId,
            oneChatMessageStreamController: oneChatMessageStreamController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessageProvider>(
      builder: (context, data, child) {
        return Scaffold(
            appBar: topAppBar(
              leadingWidget: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: Icon(CupertinoIcons.back,
                    color: const Color(0xFF8897A7),
                    size: SizeConfig.defaultSize * 2.7),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              titleOnTap: () {},
              // translate
              title: widget.otherUser?.username ?? 'Chat',
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChatScreenListView(
                    conversationId: widget.conversationId,
                    meUser: widget.meUser,
                    otherUser: widget.otherUser,
                    oneChatMessageStreamController:
                        oneChatMessageStreamController),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2,
                    vertical: SizeConfig.defaultSize * 2,
                  ),
                  child: RoundedTextFormField(
                      textEditingController: chatTextController,
                      onTap: () {
                        // data.changeReverse(isReverse: true);
                      },
                      textInputType: TextInputType.text,
                      isEnable: true,
                      isReadOnly: false,
                      usePrefix: false,
                      useSuffix: true,
                      hintText: AppLocalizations.of(context).textSomething,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 0.2,
                            right: SizeConfig.defaultSize * 0.2),
                        child: Image.asset(
                          "assets/images/send_message.png",
                          height: SizeConfig.defaultSize * 4,
                          width: SizeConfig.defaultSize * 4,
                        ),
                      ),
                      suffixOnPress: () {
                        if (chatTextController.text.trim().isNotEmpty &&
                            widget.otherUser != null) {
                          data.socketIoProvider.sendMessage(
                              otherUserDeviceToken:
                                  widget.otherUser?.deviceTokens,
                              context: context,
                              conversationId: widget.conversationId.toString(),
                              messageTextController: chatTextController,
                              receiverUserId: widget.otherUser!.id.toString());
                        }
                      },
                      borderRadius: SizeConfig.defaultSize * 1.5),
                )
              ],
            ));
      },
    );
  }

  @override
  void dispose() {
    chatTextController.dispose();
    oneChatMessageStreamController.close();
    super.dispose();
  }
}
