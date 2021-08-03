import 'dart:convert';

import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:provider/provider.dart';


class SocketClient {
  // Singleton method.
  factory SocketClient() => _instance;
  static SocketClient _instance = SocketClient._privateConstructor();

  SocketClient._privateConstructor();

  late StompClient _stompClient;
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
    print('Connected to ${dotenv.env['SOCKET_BASE_URL']!}');
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();

    try {
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
              context.read<RecentChatsProvider>().updateLastMessageUnread(
                  message.sender,
                  message.getLastMessageContent(),
                  message.time!);
            }
          });
      print("Successfully subscribed to the private channel.");
    } on Exception {
      print("Fail to subscribe to the private channel.");
    }
  }

  Future<void> updateChat(int chatterId) async {
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();
    try {
      _stompClient.send(destination: '/comment-overflow/chat/update', headers: {
        'Authorization': token,
        'UserId': userId.toString(),
        'ChatterId': chatterId.toString(),
      });
    } on Exception {
      print("Socket has lost connection. Fail to update the chat on server.");
    }
  }

  Future deleteReadChats() async {
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();
    try {
      _stompClient.send(
          destination: '/comment-overflow/user/read-chats/delete',
          headers: {
            'Authorization': token,
            'UserId': userId.toString(),
          });
    } on Exception {
      print("Socket has lost connection. Fail to delete read chats on server.");
    }
  }

  Future deleteChat(int chatterId) async {
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();
    try {
      _stompClient
          .send(destination: '/comment-overflow/user/chat/delete', headers: {
        'Authorization': token,
        'UserId': userId.toString(),
        'ChatterId': chatterId.toString(),
      });
    } on Exception {
      print("Socket has lost connection. Fail to delete the chat on server.");
    }
  }

  Future init() async {
    await _initStompClient();
  }

  void dispose() {
    _stompClient.deactivate();
  }
}
