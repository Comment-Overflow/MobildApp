import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/widgets/chat_message.dart';
import 'package:comment_overflow/model/chat.dart';

class ChatRoomPage extends StatefulWidget {

  final Chat chat;

  const ChatRoomPage(this.chat, {Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chat.chatter.userName,
          style: CustomStyles.pageTitleStyle,
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: messages.map((message) =>
                Container(
                  padding: EdgeInsets.symmetric(vertical: Constants.defaultChatMessagePadding),
                  child: ChatMessage(message),
                )
            ).toList()
        ),
      ),
    );
  }
}
