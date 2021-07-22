import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class SocketUtil {
  late final StompClient _stompClient;
  dynamic unsubscribeChat;

  Map<String, GlobalKey<ChatMessageState>> _sendingMessages =
      Map<String, GlobalKey<ChatMessageState>>();

  late final int _userId;
  final void Function(String?) _onReceiveMessage;
  final Uuid _uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  SocketUtil(this._onReceiveMessage) {
    // TODO: Get ID of the current user.
    _userId = 123;
    _stompClient = StompClient(
      config: StompConfig(
        url: dotenv.env['SOCKET_BASE_URL']! + '/chat',
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    _stompClient.activate();
  }

  void _onConnect(StompFrame stompFrame) {
    print("Connected to ${dotenv.env['SOCKET_BASE_URL']! + '/chat'}");
    try {
      unsubscribeChat = _stompClient.subscribe(
          destination: '/user/' + _userId.toString() + '/queue/chat',
          headers: {'token': '9fvi74b39d'},
          callback: (frame) {
            print('Subscription received a message.');
            print(frame.command);
            print(frame.body);
            for (String key in frame.headers.keys) {
              print(key + " " + frame.headers[key]!);
            }
            // TODO:
            //  For image message:
            //  1. Send back url via socket and then get the image
            //     from the server.
            //  2. Send back byte array directly via socket.
            _onReceiveMessage(frame.body);
          });
    } catch (e, s) {
      print(s);
    }
  }

  void sendMessage(GlobalKey<ChatMessageState> messageKey) {
    String id = _uuid.v4();
    _sendingMessages.putIfAbsent(id, () => messageKey);

    _stompClient.subscribe(
        destination: '/user/queue/sent/' + id,
        callback: (frame) {
          messageKey.currentState!.finishSending();
        });

    Message message = messageKey.currentState!.message;
    Map<String, String> headers = {
      'token': '23dsh79we8c',
      'receiverId': message.receiver.toString(),
      'id': id,
    };

    if (message.type == MessageType.Text)
      _stompClient.send(
        destination: "/commentOverflow/chat/text",
        headers: headers,
        body: message.content,
      );
    else
      _stompClient.send(
        destination: "commentOverflow/chat/image",
        headers: headers,
        binaryBody: message.content,
      );
  }

  void dispose() {
    unsubscribeChat();
    _stompClient.deactivate();
  }
}
