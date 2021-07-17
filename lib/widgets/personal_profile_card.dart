import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'multiple_widget_button.dart';

class PersonalProfileCard extends StatelessWidget {
  final PersonalPageInfo _personalPageInfo;
  final Widget _gap = const SizedBox(height: 2);

  const PersonalProfileCard(this._personalPageInfo, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
              height: Constants.defaultPersonalPageHeaderHeight,
              padding: EdgeInsets.fromLTRB(
                  0,
                  Constants.defaultPersonalPageVerticalPadding * 1.6,
                  Constants.defaultPersonalPageHeaderHorizontalPadding,
                  0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 40,
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: Constants.defaultPersonalPageAvatarPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UserAvatar(Constants.defaultPersonalPageAvatarSize),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 22,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                _personalPageInfo.userName,
                                style: CustomStyles.personalPageUserNameStyle,
                              ),
                              SizedBox(
                                  width: Constants
                                          .defaultPersonalPageHeaderTitleSize *
                                      0.2),
                              _personalPageInfo.sex == Sex.male
                                  ? CustomStyles.getDefaultMaleIcon()
                                  : CustomStyles.getDefaultFemaleIcon(),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 9,
                            child: Divider(
                                height: 0.5,
                                endIndent: 0.0,
                                color: Colors.grey.withOpacity(0.5))),
                        Expanded(
                          flex: 40,
                          child: Text(
                            _personalPageInfo.brief,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: CustomStyles.userBriefStyle,
                          ),
                        ),
                        Expanded(
                          flex: 27,
                          child: _buildCommentAndApprovalInfo(),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.fromLTRB(
                0, 0, 0, Constants.defaultPersonalPageVerticalPadding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 15, child: Container()),
                Expanded(
                  flex: 35,
                  child: MultipleWidgetButton(
                    RouteGenerator.generateRoute(RouteSettings(
                      // TODO: following page route
                      name: RouteGenerator.homeRoute,
                    )),
                    [
                      Text(
                        _personalPageInfo.followingCount.toString(),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '关注',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 35,
                  child: MultipleWidgetButton(
                    RouteGenerator.generateRoute(RouteSettings(
                      // TODO: follower page route
                      name: RouteGenerator.homeRoute,
                    )),
                    [
                      Text(
                        _personalPageInfo.followerCount.toString(),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '粉丝',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 15, child: Container()),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }

  _buildCommentAndApprovalInfo() {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: CustomStyles.getDefaultReplyIcon(
                size: Constants.defaultPersonalPageHeaderFooterSize),
          ),
          TextSpan(
            text: ' ${_personalPageInfo.commentCount}   ',
          ),
          WidgetSpan(
            child: CustomStyles.getDefaultThumbUpIcon(
                size: Constants.defaultPersonalPageHeaderFooterSize),
          ),
          TextSpan(
            text: ' ${_personalPageInfo.approvalCount} ',
          ),
        ],
        style: TextStyle(
            color: Colors.grey,
            fontSize: Constants.defaultPersonalPageHeaderFooterSize),
      ),
    );
  }

}
