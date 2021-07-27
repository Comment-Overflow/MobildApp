import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/routing_dto/personal_page_access_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/follow_button.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:substring_highlight/substring_highlight.dart';

class UserCard extends StatelessWidget {
  final UserCardInfo _userCardInfo;
  final String? _searchKey;

  const UserCard(this._userCardInfo, {Key? key, searchKey})
      : _searchKey = searchKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget verticalGap = SizedBox(height: 2.0);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(RouteGenerator.generateRoute(RouteSettings(
          name: RouteGenerator.personalRoute,
          arguments: PersonalPageAccessDto(_userCardInfo.userId, true),
        )));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
            padding: EdgeInsets.all(Constants.defaultCardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 15,
                  child: UserAvatar(55.0),
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
                Expanded(
                  flex: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 20.0),
                        child: _searchKey == null
                            ? Text(
                                _userCardInfo.userName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: CustomStyles.userNameStyle,
                              )
                            : SubstringHighlight(
                                text: _userCardInfo.userName,
                                term: _searchKey,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textStyle: CustomStyles.userNameStyle,
                                textStyleHighlight:
                                    CustomStyles.highlightedUserNameStyle),
                      ),
                      verticalGap,
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 18.0),
                        child: Text(
                          _userCardInfo.brief,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: CustomStyles.userBriefStyle,
                        ),
                      ),
                      verticalGap,
                      RichText(
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                    flex: 29,
                    child: Center(
                        child: FollowButton(
                            _userCardInfo.userId,
                            _userCardInfo.userName,
                            _userCardInfo.followStatus)))
              ],
            )),
      ),
    );
  }
}
