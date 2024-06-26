import 'dart:convert';

import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/models/all_conversations.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

class SocketIoProvider extends ChangeNotifier {
  i_o.Socket? socket;
  late MainScreenProvider mainScreenProvider;

  SocketIoProvider({required this.mainScreenProvider});
  // socket connection
  void initialSocketConnection() {
    socket = i_o.io(
        kSocketIOUrl,
        i_o.OptionBuilder()
            .setTransports(['websocket'])
            .enableReconnection()
            .disableForceNew()
            .disableForceNewConnection()
            .disableMultiplex()
            .build());

    if (socket != null && socket!.connected == false) {
      socket!.connect();
    }
  }

  void handleSocketEvents({required BuildContext context}) {
    if (socket == null) {
      return;
    }
    final chatMessageProvider =
        Provider.of<ChatMessageProvider>(context, listen: false);
    socket!.onConnect((data) {
      // Add socket user in socketio
      print(
          "LOGGED IN CURRENT USER ID ${mainScreenProvider.loginSuccess.user?.id}");
      socket!
          .emit("addUser", mainScreenProvider.loginSuccess.user?.id.toString());

      // Online users
      socket!.on("getUsers", (data) => {});

      // Message sent by current user
      socket!.on("getMessageForSender", (message) {
        print("GET MESSAGE FOR SENDER");

        final newChatMessage = chatMessageFromJson(jsonEncode(message['chat']));
        chatMessageProvider.addNewChatMessageFromSocketIO(
            conversationId: message['conversation_id'].toString(),
            newChatMessage: newChatMessage);

        //     SocketMessage socketMessage = SocketMessage(
        //         senderId: message['senderId'],
        //         receiverUserId: message['receiverUserId'],
        //         message: message['message'],
        //         sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']));

        //     Provider.of<ChatMessageProvider>(context, listen: false)
        //         .addConversation(socketMessage: socketMessage);

        //     Provider.of<ChatMessageProvider>(context, listen: false)
        //         .updateOneConversationData(
        //             context: context,
        //             conversationId: message['conversationId'].toString());
        // } catch (e) {
        //   throw Exception(e.toString());
        // }
      });

      // Message received by current user
      socket!.on("getMessageForReceiver", (message) async {
        print("get message for receiver");

        final newChatMessage = chatMessageFromJson(jsonEncode(message['chat']));
        chatMessageProvider.addNewChatMessageFromSocketIO(
            conversationId: message['conversation_id'].toString(),
            newChatMessage: newChatMessage);

        // try {
        //   SocketMessage socketMessage = SocketMessage(
        //       senderId: message['senderId'],
        //       receiverUserId: message['receiverUserId'],
        //       message: message['message'],
        //       sentAt: message['sentAt'] == null
        //           ? DateTime.now()
        //           : DateTime.fromMillisecondsSinceEpoch(message['sentAt']));

        //   Provider.of<ChatMessageProvider>(context, listen: false)
        //       .addConversation(socketMessage: socketMessage);

        //   Conversation? allConversation =
        //       Provider.of<ChatMessageProvider>(context, listen: false)
        //           .allConversation;
        //   if (allConversation != null) {
        //     final oneConversationData = allConversation.data!.firstWhereOrNull(
        //         (element) =>
        //             element.id.toString() ==
        //             message['conversationId'].toString());
        //     if (oneConversationData != null &&
        //         message['receiverUserId'].toString() == userId) {
        //       await Provider.of<ChatMessageProvider>(context, listen: false)
        //           .updateLastTimeReadWhenReceivedMessage(
        //               otherUsername: oneConversationData
        //                           .attributes!.firstUser!.data!.id
        //                           .toString() ==
        //                       userId
        //                   ? oneConversationData.attributes!.secondUser!.data!
        //                       .attributes!.username
        //                       .toString()
        //                   : oneConversationData
        //                       .attributes!.firstUser!.data!.attributes!.username
        //                       .toString(),
        //               lastTextCreatedAt: DateTime.fromMillisecondsSinceEpoch(
        //                   message['sentAt']),
        //               firstUserId: oneConversationData
        //                   .attributes!.firstUser!.data!.id
        //                   .toString(),
        //               secondUser: oneConversationData
        //                   .attributes!.secondUser!.data!.id
        //                   .toString(),
        //               receiverUserId: message['receiverUserId'],
        //               context: context,
        //               conversationId: message['conversationId'].toString());
        //     }
        //   }
        // } catch (e) {
        //   showSnackBar(
        //       context: context,
        //       content: AppLocalizations.of(context).tryAgainLater,
        //       backgroundColor: Colors.red,
        //       contentColor: Colors.white);
        //   throw Exception(e.toString());
        // }
      });
    });
    socket!
        .onConnectError((data) => throw Exception('Connection Error: $data'));
    socket!.onDisconnect((data) => null);
  }

  // Sending message to user
  void sendMessage(
      {required String receiverUserId,
      required TextEditingController messageTextController,
      required List<DeviceToken>? otherUserDeviceToken,
      required String? conversationId,
      required BuildContext context}) {
    try {
      if (socket == null) {
        return;
      }
      print("DEVICE TOKENS $otherUserDeviceToken");
      socket!.emit('sendMessage', {
        'sender': mainScreenProvider.loginSuccess.user?.id.toString(),
        'receiver': receiverUserId,
        'text': messageTextController.text,
        'has_receiver_seen': false,
        'conversation_id': conversationId,
        'access_token': mainScreenProvider.loginSuccess.accessToken.toString(),
        'sent_at_utc': DateTime.now().toUtc().toString()
      });

      messageTextController.clear();
      // final chatMessageProvider =
      //     Provider.of<ChatMessageProvider>(context, listen: false);
      // Conversation? allConversation = chatMessageProvider.allConversation;
      // chatMessageProvider.chatTextController.clear();
      // if (allConversation != null) {
      //   final oneConversationData = allConversation.data!.firstWhereOrNull(
      //       (element) => element.id.toString() == conversationId.toString());
      //   if (oneConversationData != null) {
      //     if (otherUserDeviceToken != null || otherUserDeviceToken != '') {
      //       sendMessageReplyNotification(
      //           receiverUserId: receiverUserId,
      //           context: context,
      //           initiatorUsername: userName.toString(),
      //           receiverUserDeviceToken: otherUserDeviceToken);
      //     }
      //     Map bodyData;
      //     if (oneConversationData.attributes!.firstUser != null &&
      //         oneConversationData.attributes!.firstUser!.data!.id.toString() ==
      //             userId.toString()) {
      //       bodyData = {
      //         "data": {"first_user_last_read": DateTime.now().toString()}
      //       };
      //     } else {
      //       bodyData = {
      //         "data": {"second_user_last_read": DateTime.now().toString()}
      //       };
      //     }
      //     Provider.of<ChatMessageProvider>(context, listen: false)
      //         .updateLastTimeRead(
      //             context: context,
      //             conversationId: conversationId.toString(),
      //             bodyData: bodyData);
      //   } else {
      //     throw Exception('oneConversationDAta is null');
      //   }
      // } else {
      //   throw Exception('allConversation is null');
      // }
    } catch (e) {
      throw (Exception(e));
    }
  }
}
