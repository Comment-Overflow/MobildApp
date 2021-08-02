import 'dart:io';

import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/service/chat_service.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/recent_chats_provider.dart';
import 'package:comment_overflow/utils/socket_client.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/adaptive_refresher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:provider/provider.dart';

class PrivateChatPage extends StatefulWidget {
  final UserInfo _chatter;

  PrivateChatPage(this._chatter, {Key? key}) : super(key: key);

  @override
  PrivateChatPageState createState() => PrivateChatPageState(_chatter);
}

class PrivateChatPageState extends State<PrivateChatPage> {
  final UserInfo _chatter;
  late final UserInfo _currentUser;
  final TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<Message> _messages = [];
  int _currentPageNumber = 0;
  int _totalPageNumber = 0;
  int _newMessageCount = 0;
  bool _requireReload = false;
  bool _hasInit = false;

  PrivateChatPageState(this._chatter);

  @override
  void initState() {
    super.initState();
    SocketClient().onReceiveMessage = _onReceiveMessage;
    SocketClient().updateChat(_chatter.userId);
    _getChatHistory();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<RecentChatsProvider>().updateRead(_chatter);
    });
  }

  @override
  void dispose() async {
    SocketClient().onReceiveMessage = null;
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
          _chatter.userName,
          style: CustomStyles.pageTitleStyle,
        ),
        automaticallyImplyLeading: false,
        leading: _buildBackButton(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder(
            future: _getCurrentUserInfo(),
            builder: (_, snapshot) {
              return Column(
                children: [
                  _buildChatMessages(),
                  _buildTextField(),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: _messages.length == 0
          ? (_requireReload
              ? AdaptiveRefresher(
                  onRefresh: _getChatHistory, child: Container())
              : Container())
          : AdaptiveRefresher(
              enablePullUp: _currentPageNumber < _totalPageNumber,
              enablePullDown: false,
              onLoading: _onLoading,
              child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(Constants.defaultChatRoomPadding),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    Message message = _messages[index];
                    bool fromUser =
                        message.sender.userId == _currentUser.userId;
                    ChatMessage chatMessage = ChatMessage(
                        _messages[index],
                        fromUser,
                        fromUser ? _currentUser.avatarUrl : _chatter.avatarUrl,
                        _resendMessage);
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Constants.defaultChatMessagePadding),
                      child: chatMessage,
                    );
                  }),
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

  Future _getCurrentUserInfo() async {
    if (!_hasInit) {
      int userId = await GeneralUtils.getCurrentUserId();
      String? userName =
          await StorageUtil().storage.read(key: Constants.userName);
      String? avatarUrl =
          await StorageUtil().storage.read(key: Constants.avatarUrl);
      _currentUser = UserInfo(userId, userName!, avatarUrl: avatarUrl);
      _hasInit = true;
    }
  }

  Future _getChatHistory() async {
    try {
      Response<dynamic> response = await ChatService.getChatHistory(
          _chatter.userId, _newMessageCount, _currentPageNumber);
      List messagesResponse = response.data['content'] as List;
      setState(() {
        if (_requireReload) _requireReload = false;
        if (_currentPageNumber == 0)
          _totalPageNumber = response.data['totalPages'] as int;
        _currentPageNumber++;
        for (Map messageJson in messagesResponse) {
          _messages.add(Message.fromJson(messageJson));
        }
      });
    } on DioError {
      if (_messages.length == 0)
        setState(() {
          _requireReload = true;
        });
      MessageBox.showToast(
          msg: Constants.networkError, messageBoxType: MessageBoxType.Error);
    }
  }

  Future _onLoading() async {
    if (_currentPageNumber < _totalPageNumber) _getChatHistory();
  }

  Future _onSendText() async {
    if (_textEditingController.value.text.isNotEmpty) {
      Message message = Message(MessageType.Text, _currentUser, _chatter,
          _textEditingController.value.text);
      setState(() {
        _messages.insert(0, message);
      });
      _sendMessage(message);
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
        File imageFile = (await asset.file)!;
        Message message = Message(
            MessageType.TemporaryImage, _currentUser, _chatter, imageFile);
        setState(() {
          _messages.insert(0, message);
        });
        _sendMessage(message);
      }
      _scrollToBottom();
    }
    FocusScope.of(context).previousFocus();
  }

  Future _sendMessage(Message message) async {
    try {
      Response response = await (message.type == MessageType.Text
          ? ChatService.sendText(
              message.receiver.userId, message.content as String)
          : ChatService.sendImage(_chatter.userId, message.content as File));
      setState(() {
        message.status = MessageStatus.Normal;
        message.time = DateTime.parse(response.data);
        _newMessageCount++;
      });
      context.read<RecentChatsProvider>().updateLastMessageRead(
          _chatter, message.getLastMessageContent(), message.time!);
    } on DioError {
      setState(() {
        message.status = MessageStatus.Failed;
      });
    }
  }

  void _onReceiveMessage(Message message) {
    setState(() {
      _messages.insert(0, message);
      _newMessageCount++;
      if (message.sender.avatarUrl != _chatter.avatarUrl) {
        setState(() {
          _chatter.avatarUrl = message.sender.avatarUrl;
        });
      }
      if (message.receiver.avatarUrl != _currentUser.avatarUrl) {
        setState(() {
          _currentUser.avatarUrl = message.receiver.avatarUrl;
        });
        StorageUtil()
            .storage
            .write(key: Constants.userName, value: message.receiver.userName);
        StorageUtil()
            .storage
            .write(key: Constants.avatarUrl, value: message.receiver.avatarUrl);
      }
    });
    context.read<RecentChatsProvider>().updateLastMessageRead(
        _chatter, message.getLastMessageContent(), message.time!);
    _scrollToBottom();
  }

  void _resendMessage(Message message) {
    setState(() {
      message.status = MessageStatus.Sending;
    });
    _sendMessage(message);
  }

  _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: CustomStyles.getDefaultBackIcon(size: 24.0, color: Colors.black),
    );
  }
}
