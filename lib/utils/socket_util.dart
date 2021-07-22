import 'dart:developer';
import 'dart:typed_data';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/exceptions/user_unauthorized_exception.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

// TODO: Catch the exception.

class SocketUtil {
  // Singleton method.
  static SocketUtil _instance = SocketUtil._privateConstructor();

  factory SocketUtil() {
    return _instance;
  }

  late final StompClient _stompClient;
  dynamic _unsubscribeChat;

  SocketUtil._privateConstructor() {
    _initStompClient();
  }

  void _initStompClient() async {
    String token = await GeneralUtils.getCurrentToken();

    _stompClient = StompClient(
      config: StompConfig(
        url: '${dotenv.env['SOCKET_BASE_URL']!}/chat',
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': token},
        webSocketConnectHeaders: {'Authorization': token},
      ),
    );
    _stompClient.activate();
  }

  void _onConnect(StompFrame stompFrame) async {
    print('Connected to ${dotenv.env['SOCKET_BASE_URL']!}/chat');
    String token = await GeneralUtils.getCurrentToken();
    int userId = await GeneralUtils.getCurrentUserId();

    try {
      _unsubscribeChat = _stompClient.subscribe(
          destination: '/user/${userId.toString()}/queue/private',
          headers: {'Authorization': token},
          callback: (frame) {
            print('Subscription received a message.');
            print(frame.command);
            print(frame.body);
            for (String key in frame.headers.keys) {
              print(key + ' ' + frame.headers[key]!);
            }
            // TODO:
            //  For image message:
            //  1. Send back url via socket and then get the image
            //     from the server.
            //  2. Send back byte array directly via socket.
            // _onReceiveMessage(frame.body);
          });
    } catch (e, s) {
      print(s);
    }
  }

  Future<void> sendMessage(GlobalKey<ChatMessageState> messageKey) async {
    _stompClient.subscribe(
        destination: '/user/queue/sent/${messageKey.toString()}',
        callback: (frame) {
          if (frame.body == 'success')
            messageKey.currentState!.finishSending();
          else
            throw UserUnauthorizedException();
        });

    Message message = messageKey.currentState!.message;
    String token = await GeneralUtils.getCurrentToken();

    Map<String, String> headers = {
      'Authorization': token,
      'ReceiverId': message.receiver.toString(),
      'MessageKey': messageKey.toString(),
    };

    if (message.type == MessageType.Text)
      _stompClient.send(
        destination: '/commentOverflow/chat/text',
        headers: headers,
        body: message.content,
      );
    else
      _stompClient.send(
        destination: 'commentOverflow/chat/image',
        headers: headers,
        binaryBody: message.content as Uint8List,
      );
  }

  void dispose() {
    _unsubscribeChat();
    _stompClient.deactivate();
  }
}
