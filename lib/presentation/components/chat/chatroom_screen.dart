import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/chat/chat_room_list_view.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatroomScreen extends StatefulWidget {
  static const String id = '/chatroom_screen';

  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            final chatMessageProvider =
                Provider.of<ChatMessageProvider>(context, listen: false);
            // if (chatMessageProvider.page > 1) {
            //   chatMessageProvider.refresh();
            // }
            // chatMessageProvider.sharedPreferences
            //     .remove('active_chat_username');
            chatMessageProvider.removeCurrentlyOnChatroomScreen();
            Navigator.of(context).pop();
          },
        ),
        title: AppLocalizations.of(context).conversations,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
          child: const ChatRoomListView()),
    );
  }
}
