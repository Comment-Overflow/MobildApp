import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/exceptions/user_unauthorized_exception.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:provider/provider.dart';

// TODO: Catch the exception.

class SocketClient {
  // Singleton method.
  factory SocketClient() => _instance;
  static SocketClient _instance = SocketClient._privateConstructor();

  SocketClient._privateConstructor() {
    _initStompClient();
  }

  late final StompClient _stompClient;
  void Function(Message)? onReceiveMessage = null;

  Future<void> _initStompClient() async {
    String token = await GeneralUtils.getCurrentToken();

    _stompClient = StompClient(
      config: StompConfig(
        url: '${dotenv.env['SOCKET_BASE_URL']!}/chat',
        onConnect: _onConnect,
        onDisconnect: (frame) {
          print('STOMP client disconnected.');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': token},
        webSocketConnectHeaders: {'Authorization': token},
      ),
    );

    _stompClient.activate();
  }

  Future<void> _onConnect(StompFrame _) async {
    print('Connected to ${dotenv.env['SOCKET_BASE_URL']!}/chat');
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();

    _stompClient.subscribe(
        destination: '/user/${userId.toString()}/queue/private',
        headers: {'Authorization': token},
        callback: (frame) {
          Message message = Message.fromJson(jsonDecode(frame.body!));
          if (onReceiveMessage != null) {
            onReceiveMessage!(message);
            updateChat(message.sender.userId);
          } else {
            BuildContext context = GlobalUtils.navKey!.currentContext!;
            context
                .read<RecentChatsProvider>()
                .updateUnread(message.sender, message.content, message.time!);
          }

          // TODO:
          //  For image message:
          //  1. Send back url via socket and then get the image
          //     from the server.
          //  2. Send back byte array directly via socket.
        });
  }

  Future<void> sendMessage(
      Message message, void Function(String) onMessageSent) async {
    String token = await GeneralUtils.getCurrentToken();

    _stompClient.subscribe(
        destination: '/notify/${message.uuid!}',
        headers: {'Authorization': token},
        callback: (frame) {
          if (frame.body == 'error') throw UserUnauthorizedException();
          onMessageSent(frame.body!);
        });

    if (message.type == MessageType.Text) {
      _stompClient.send(
        destination: '/comment-overflow/chat/text',
        headers: {'Authorization': token},
        body: json.encode({
          'uuid': message.uuid!,
          'senderId': message.sender.userId,
          'receiverId': message.receiver.userId,
          'content': message.content
        }),
      );
    } else
      _stompClient.send(
        destination: '/comment-overflow/chat/image',
        headers: {
          'Authorization': token,
          'UUID': message.uuid!,
          'SenderId': message.sender.userId.toString(),
          'ReceiverId': message.receiver.userId.toString(),
        },
        binaryBody: message.content as Uint8List,
      );
  }

  Future<void> updateChat(int chatterId) async {
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();
    _stompClient.send(destination: '/comment-overflow/chat/update', headers: {
      'Authorization': token,
      'UserId': userId.toString(),
      'ChatterId': chatterId.toString(),
    });
  }

  void dispose() {
    _stompClient.deactivate();
  }
}
