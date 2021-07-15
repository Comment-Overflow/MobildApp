import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/notification_message.dart';
import 'package:zhihu_demo/widgets/user_avatar.dart';

class NotificationCard extends StatelessWidget {

  final NotificationMessage _notificationMessage;

  // NotificationCard(userName, imageSize, NotificationType type,
  //     {Key? key, image, title, comment, this.textStyle, this.gap = 10.0})
  //     : _userAvatar = UserAvatar(imageSize, image: image),
  //       _notificationMsg = NotificationMsg(userName, title, comment, type),
  //       super(key: key);

  NotificationCard(this._notificationMessage,
    {Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeContent = "";
    switch (_notificationMessage.type) {
      case NotificationType.approvePost:
        typeContent = "赞同了你的帖子${_notificationMessage.title}";
        break;
      case NotificationType.approveComment:
        typeContent =
            "赞同了你在帖子${_notificationMessage.title}中的发言${_notificationMessage.comment}";
        break;
      case NotificationType.reply:
        typeContent =
            "回复了你的帖子${_notificationMessage.title}:${_notificationMessage.comment}";
        break;
      case NotificationType.attention:
        typeContent = "收藏了你的帖子${_notificationMessage.title}";
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
                UserAvatar(_notificationMessage.imageSize, image: _notificationMessage.image),
                SizedBox(width: _notificationMessage.gap),
                Expanded(
                    child: Text(
                  _notificationMessage.userInfo.userName + typeContent,
                  style: _notificationMessage.textStyle,
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
