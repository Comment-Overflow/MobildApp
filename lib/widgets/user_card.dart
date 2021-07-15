import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';
import 'package:zhihu_demo/model/user_info.dart';
import 'package:zhihu_demo/widgets/follow_button.dart';

class UserCard extends StatefulWidget {

  final UserCardInfo _userCardInfo;

  UserCard(this._userCardInfo, {Key? key}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.defaultUserCardHeight,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 15,
                  child: Container(
                    width: 55.0,
                    height: 55.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Container(),
                ),

                Expanded(
                  flex: 51,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 36,
                        child: Text(
                          widget._userCardInfo.userName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: CustomStyles.userNameStyle,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 28,
                        child: Text(
                          widget._userCardInfo.brief,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: CustomStyles.userBriefStyle,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 28,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: CustomStyles.getDefaultReplyIcon(),
                              ),
                              TextSpan(
                                text: ' ${widget._userCardInfo.commentCount}   ',
                              ),
                              WidgetSpan(
                                child: CustomStyles.getDefaultFollowerIcon(),
                              ),
                              TextSpan(
                                text: ' ${widget._userCardInfo.followerCount} ',
                              ),
                            ],
                            style: CustomStyles.postFooterStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(),
                ),

                Expanded(
                  flex: 29,
                  child: FollowButton(
                    widget._userCardInfo.userName,
                    widget._userCardInfo.followStatus,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
