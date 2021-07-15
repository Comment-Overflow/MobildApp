import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zhihu_demo/model/notification_msg.dart';
import 'package:zhihu_demo/widgets/notification_card_list.dart';


class NotificationPage extends StatelessWidget {

  final NotificationType _notificationType;
  NotificationPage(this._notificationType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeContent = "";
    switch (_notificationType) {
      case NotificationType.approvePost:
      case NotificationType.approveComment:
        typeContent = "赞同";
        break;
      case NotificationType.reply:
        typeContent = "回复";
        break;
      case NotificationType.attention:
        typeContent = "收藏";
        break;
      default:
        typeContent = "关注";
    }
    return Scaffold(
      body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) => [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0.5,
                title: Text(typeContent),
                leading: IconButton(icon:Icon(Icons.arrow_back),
                  //onPressed:() => Navigator.pop(context, false),
                  onPressed:() => {},
                )
              ),
            ],
            body: MediaQuery.removePadding(
                  context: context,
                  child: NotificationCardList(),
                  removeTop: true,
            ),
      ),
    );
  }
}

