import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/model/combined_user.dart';
import 'package:zhihu_demo/widgets/follow_button.dart';

class UserCard extends StatefulWidget {
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  CombinedUser _combinedUser =
      CombinedUser("xx01cyx", "Software Engineering, SJTU", 0, 0, false);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.defaultUserCardHeight,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Container(
            // height: Constants.defaultUserCardHeight,
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
                  flex: 55,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 35,
                        child: Container(
                          child: Text(
                            _combinedUser.username,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 60,
                        child: Text(
                          _combinedUser.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor)),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(),
                ),

                Expanded(
                  flex: 25,
                  child: FollowButton(
                    this._combinedUser.isFollowing,
                    this._combinedUser.username,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
