import 'dart:io';

import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/message_service.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/socket_util.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PrivateChatPage extends StatefulWidget {
  final UserInfo _chatter;

  PrivateChatPage(this._chatter, {Key? key}) : super(key: key);

  @override
  PrivateChatPageState createState() => PrivateChatPageState();
}

class PrivateChatPageState extends State<PrivateChatPage> {
  late final UserInfo _currentUser =
      UserInfo(Platform.isIOS ? 2 : 1, '123@123.com');
  final TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<Message> _messages = [];
  Map<String, Message> _messageMap = Map<String, Message>();
  int _currentPageNumber = 0;
  int _totalPageNumber = 0;

  final Uuid _uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  @override
  void initState() {
    print('Enter private chat channel with user ${widget._chatter.userId}');
    super.initState();
    SocketUtil().onReceiveMessage = _onReceiveMessage;
    _getChatHistory();
  }

  @override
  void dispose() async {
    SocketUtil().onReceiveMessage = null;
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
    print('Leave private chat channel with user ${widget._chatter.userId}');
  }

  @override
  Widget build(BuildContext context) {
    // print((ModalRoute.of(context)?.settings.arguments as UserInfo).userId);
    // print(ModalRoute.of(context)?.settings.arguments is UserCardInfo);
    return Scaffold(
      appBar: AppBar(
        elevation: Constants.defaultAppBarElevation,
        title: Text(
          widget._chatter.userName,
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
              child: _messages.length == 0
                  ? Container()
                  : AdaptiveRefresher(
                      enablePullUp: true,
                      enablePullDown: false,
                      onLoading: _onLoading,
                      child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.all(Constants.defaultChatRoomPadding),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            ChatMessage chatMessage =
                                ChatMessage(_messages[index]);
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Constants.defaultChatMessagePadding),
                              child: chatMessage,
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
                  onPressed: _onSendText,
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

  Future _getChatHistory() async {
    Response<dynamic> response = await MessageService.getChatHistory(
        widget._chatter.userId, _currentPageNumber);
    List messagesResponse = response.data['content'] as List;
    print(response.data['totalPages'] as int);
    setState(() {
      if (_currentPageNumber == 0)
        _totalPageNumber = response.data['totalPages'] as int;
      _currentPageNumber++;
      for (Map messageJson in messagesResponse) {
        _messages.add(Message.fromJson(messageJson));
      }
    });
  }

  Future _onLoading() async {
    if (_currentPageNumber < _totalPageNumber)
      _getChatHistory();
  }

  Future _onSendText() async {
    if (_textEditingController.value.text.isNotEmpty) {
      String messageId = _uuid.v4();
      Message message = Message(MessageType.Text, _currentUser, widget._chatter,
          _textEditingController.value.text,
          uuid: messageId);
      setState(() {
        _messages.insert(0, message);
        _messageMap.putIfAbsent(messageId, () => message);
      });
      SocketUtil().sendMessage(message, (frameBody) {
        setState(() {
          Message sentMessage = _messageMap[messageId]!;
          sentMessage.isSending = false;
          RegExp exp = new RegExp(r"time=([\d\s-:]+)");
          String? timeStr = exp.firstMatch(frameBody)!.group(1);
          sentMessage.time = DateTime.parse(timeStr!);
        });
      });
    }
    _textEditingController.clear();
    _scrollToBottom();
  }

  Future _onSendImage() async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(context,
        maxAssets: Constants.maxImageNumber);

    if (result != null) {
      List<AssetEntity> assets = List<AssetEntity>.from(result);
      for (AssetEntity asset in assets) {
        String messageId = _uuid.v4();
        Message message = Message(MessageType.TemporaryImage, _currentUser,
            widget._chatter, await asset.originBytes,
            uuid: messageId);
        setState(() {
          _messages.insert(0, message);
        });
        SocketUtil().sendMessage(message, (frameBody) {
          setState(() {
            _messageMap[messageId]!.isSending = false;
          });
        });
      }
      _scrollToBottom();
    }
    FocusScope.of(context).previousFocus();
  }

  void _onReceiveMessage(Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    _scrollToBottom();
  }
}
