import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/chat/chat_room_list_view.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatroomScreen extends StatelessWidget {
  static const String id = '/chatroom_screen';

  const ChatroomScreen({Key? key}) : super(key: key);

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
            Navigator.of(context).pop();
          },
        ),
        title: AppLocalizations.of(context).conversations,
      ),
      body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
          child: const ChatRoomListView()),
    );
  }
}
