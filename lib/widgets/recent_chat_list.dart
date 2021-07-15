import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refazynist/refazynist.dart';
import 'package:zhihu_demo/fake_data/fake_data.dart';
import 'package:zhihu_demo/widgets/chat_card.dart';

class RecentChatList extends StatelessWidget {
  const RecentChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap:true,
          itemCount: recentChats.length,
          itemBuilder: (BuildContext context, int index) {
        return ChatCard(recentChats[index]);
      }),
    );
  }
}
