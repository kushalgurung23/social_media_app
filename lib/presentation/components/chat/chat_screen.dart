import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/data/models/conversation_model.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/chat/chat_screen_list_view.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final List<ConversationMessagesData>? messageConversationList;
  final String otherUserId,
      otherUsername,
      myImageUrl,
      otherUserImageUrl,
      conversationId;
  final String? otherUserDeviceToken;
  final TextEditingController chatTextEditingController;

  const ChatScreen(
      {Key? key,
      required this.otherUserDeviceToken,
      required this.messageConversationList,
      required this.conversationId,
      required this.otherUserId,
      required this.otherUsername,
      required this.chatTextEditingController,
      required this.myImageUrl,
      required this.otherUserImageUrl})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final chatMessageProvider =
        Provider.of<ChatMessageProvider>(context, listen: false);

    chatMessageProvider.storeAllConversation(
        messageConversationList: widget.messageConversationList);
    chatMessageProvider.changeReverse(isReverse: false, fromInitial: true);
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
                  data.goBackFromUserChatScreen(context: context);
                },
              ),
              titleOnTap: () {
                data.navigateToOtherUserProfile(
                    context: context,
                    otherUserId: int.parse(widget.otherUserId));
              },
              title: widget.otherUsername,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChatScreenListView(
                  myImageUrl: widget.myImageUrl,
                  otherUserImageUrl: widget.otherUserImageUrl,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2,
                    vertical: SizeConfig.defaultSize * 2,
                  ),
                  child: RoundedTextFormField(
                      textEditingController: data.chatTextController,
                      onTap: () {
                        data.changeReverse(isReverse: true);
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
                        if (data.chatTextController.text.trim().isNotEmpty) {
                          data.mainScreenProvider.sendMessage(
                              otherUserDeviceToken: widget.otherUserDeviceToken,
                              context: context,
                              conversationId: widget.conversationId.toString(),
                              message: widget.chatTextEditingController.text,
                              receiverUserId: widget.otherUserId);
                        }
                      },
                      borderRadius: SizeConfig.defaultSize * 1.5),
                )
              ],
            ));
      },
    );
  }
}
