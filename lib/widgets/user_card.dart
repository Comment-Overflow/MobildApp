import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/widgets/follow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserCardInfo _userCardInfo;

  const UserCard(this._userCardInfo, {Key? key}) : super(key: key);

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
                        _userCardInfo.userName,
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
                        _userCardInfo.brief,
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
                              text: ' ${_userCardInfo.commentCount}   ',
                            ),
                            WidgetSpan(
                              child:
                                  CustomStyles.getDefaultFilledFollowerIcon(),
                            ),
                            TextSpan(
                              text: ' ${_userCardInfo.followerCount} ',
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
                  _userCardInfo.userName,
                  _userCardInfo.followStatus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
