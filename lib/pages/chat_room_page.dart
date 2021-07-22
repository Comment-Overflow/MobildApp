import 'dart:convert';
import 'dart:typed_data';

import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:comment_overflow/model/chat.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRoomPage extends StatefulWidget {
  final Chat chat;
  final _socketUrl = dotenv.env['SOCKET_BASE_URL']! + '/chat';

  ChatRoomPage(this.chat, {Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<Message> _messages = messages;
  late final _stompClient;

  @override
  void initState() {
    super.initState();
    _initStompClient();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: Constants.defaultAppBarElevation,
        title: Text(
          widget.chat.chatter.userName,
          style: CustomStyles.pageTitleStyle,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: AdaptiveRefresher(
                enablePullUp: true,
                enablePullDown: false,
                onRefresh: _onRefresh,
                child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(Constants.defaultChatRoomPadding),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Constants.defaultChatMessagePadding),
                        child: ChatMessage(_messages[index]),
                      );
                    }),
              ),
            ),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  void _initStompClient() {
    _stompClient = StompClient(
      config: StompConfig(
        url: widget._socketUrl,
        onConnect: (StompFrame stompFrame) {
          print("Connected to ${widget._socketUrl}");
          _stompClient.subscribe(
              destination: '/user/123/queue/reply',
              headers: {
                'token': '9fvi74b39d'
              },
              callback: (frame) {
                print('Subscription received a message.');
                print(frame.command);
                print(frame.body);
                for (String key in frame.headers.keys){
                  print(key + " " + frame.headers[key]);
                }
              }
          );
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    _stompClient.activate();
  }

  Widget _buildTextField() {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 92.0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    style: TextStyle(
                      fontSize: Constants.defaultChatRoomFontSize,
                      height: 1.3,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10.0),
                      suffixIcon: IconButton(
                        icon: CustomStyles.getDefaultImageIcon(size: 24.0),
                        onPressed: _onSendImage,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: ElevatedButton(
                  child: Text("发送"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    _onSendText();
                    if (_textEditingController.value.text.isNotEmpty) {
                      setState(() {
                        _messages.insert(
                            0,
                            Message(
                                MessageType.Text,
                                DateTime.now(),
                                UserInfo(0, "Gun9niR",
                                    "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
                                UserInfo(1, "xx01cyx",
                                    "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
                                true,
                                _textEditingController.value.text));
                      });
                    }
                    _textEditingController.clear();
                    _scrollToBottom();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future _onRefresh() async {
    // getRecentChats();
    print("Chat Room onRefresh");
    // monitor network fetch
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  Future _onSendText() async {
    if (_textEditingController.value.text.isNotEmpty)
      _stompClient.send(
        destination: "/commentOverflow/chat/text",
        headers: {
          'Authorization': 'Bearer yourToken',
        },
        body:  _textEditingController.value.text,
      );
  }

  Future _onSendImage() async {
    final List<AssetEntity>? result =
    await MyImagePicker.pickImage(context,
        maxAssets: Constants.maxImageNumber);

    if (result != null) {
      List<AssetEntity> assets = List<AssetEntity>.from(result);
      for (AssetEntity asset in assets) {
        _messages.insert(0, Message(
            MessageType.TemporaryImage,
            DateTime.now(),
            UserInfo(0, "Gun9niR",
                "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
            UserInfo(1, "xx01cyx",
                "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
            true,
            await asset.file)
        );
        await _stompClient.send(
          destination: "/commentOverflow/chat/image",
          binaryBody: Uint8List.fromList([1,2]),
          // binaryBody: await asset.thumbData,
        );
        print((await asset.thumbData)!.length);
        print((await asset.originBytes)!.length);
      }
      _scrollToBottom();
    }
    FocusScope.of(context).previousFocus();
  }
}
