import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/notification_msg.dart';
import 'package:zhihu_demo/widgets/user_avatar.dart';

class NotificationCard extends StatelessWidget {

  final NotificationMsg _notificationMsg;

  // NotificationCard(userName, imageSize, NotificationType type,
  //     {Key? key, image, title, comment, this.textStyle, this.gap = 10.0})
  //     : _userAvatar = UserAvatar(imageSize, image: image),
  //       _notificationMsg = NotificationMsg(userName, title, comment, type),
  //       super(key: key);

  NotificationCard(this._notificationMsg,
    {Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeContent = "";
    switch (_notificationMsg.type) {
      case NotificationType.approvePost:
        typeContent = "赞同了你的帖子${_notificationMsg.title}";
        break;
      case NotificationType.approveComment:
        typeContent =
            "赞同了你在帖子${_notificationMsg.title}中的发言${_notificationMsg.comment}";
        break;
      case NotificationType.reply:
        typeContent =
            "回复了你的帖子${_notificationMsg.title}:${_notificationMsg.comment}";
        break;
      case NotificationType.attention:
        typeContent = "收藏了你的帖子${_notificationMsg.title}";
        break;
      default:
        typeContent = "关注了你";
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(Constants.defaultCardPadding),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(_notificationMsg.imageSize, image: _notificationMsg.image),
                SizedBox(width: _notificationMsg.gap),
                Expanded(
                    child: Text(
                  _notificationMsg.userInfo.userName + typeContent,
                  style: _notificationMsg.textStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
          ]),
        ),
        onTap: () => {},
      ),
    );
  }
}
