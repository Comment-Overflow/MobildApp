import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/exceptions/user_unauthorized_exception.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

// TODO: Catch the exception.

class SocketUtil {
  // Singleton method.
  static SocketUtil _instance = SocketUtil._privateConstructor();

  factory SocketUtil() {
    return _instance;
  }

  late final StompClient _stompClient;
  late void Function(Message)? onReceiveMessage;

  SocketUtil._privateConstructor() {
    _initStompClient();
  }

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
          print('Subscription received a message.');
          print('The command is ${frame.command}');
          print('The message is ${frame.body}');
          print('======Headers======');
          for (String key in frame.headers.keys) {
            print(key + ' ' + frame.headers[key]!);
          }
          print('===================');

          Message message = _messageConverter(frame.body!);
          if (onReceiveMessage != null) onReceiveMessage!(message);

          // TODO:
          //  For image message:
          //  1. Send back url via socket and then get the image
          //     from the server.
          //  2. Send back byte array directly via socket.
          // _onReceiveMessage(frame.body);
        });
  }

  Future<void> sendMessage(
      Message message, void Function(String) onMessageSent) async {
    String token = await GeneralUtils.getCurrentToken();

    _stompClient.subscribe(
        destination: '/notify/${message.uuid!}',
        headers: {'Authorization': token},
        callback: (frame) {
          print(frame.body);
          if (frame.body == 'error') throw UserUnauthorizedException();
          onMessageSent(frame.body!);
        });

    if (message.type == MessageType.Text) {
      _stompClient.send(
        destination: '/commentOverflow/chat/text',
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
        destination: 'commentOverflow/chat/image',
        headers: {
          'Authorization': token,
          'UUID': message.uuid!,
          'SenderId': message.sender.userId.toString(),
          'ReceiverId': message.receiver.userId.toString(),
        },
        binaryBody: message.content as Uint8List,
      );
  }

  Message _messageConverter(String frameBody) {
    RegExp contentExp = new RegExp(r"content=(.*?)\)");
    RegExp timeExp = new RegExp(r"time=([\d\s-:]+)");
    String? textMessageContent = contentExp.firstMatch(frameBody)!.group(1);
    String? timeStr = timeExp.firstMatch(frameBody)!.group(1);
    return Message(MessageType.Text, UserInfo(Platform.isIOS ? 1 : 2, "aaa"),
        UserInfo(Platform.isIOS ? 2 : 1, "bbb"), textMessageContent,
        time: DateTime.parse(timeStr!));
  }

  void dispose() {
    // _unsubscribeChat();
    _stompClient.deactivate();
  }
}
