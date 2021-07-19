import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/routing_dto/user_name_id_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/utils.dart';
import 'package:comment_overflow/widgets/follow_button.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'multiple_widget_button.dart';

class PersonalProfileCard extends StatelessWidget {
  final PersonalPageInfo _personalPageInfo;
  final bool _isSelf;
  final Widget _gap = const SizedBox(height: 2);

  const PersonalProfileCard(this._personalPageInfo, this._isSelf, {Key? key})
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
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        UserAvatar(Constants.defaultPersonalPageAvatarSize),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 24,
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
                            flex: 8,
                            child: Divider(
                                height: 0.5,
                                endIndent: 0.0,
                                color: Colors.grey.withOpacity(0.5))),
                        Expanded(
                          flex: 33,
                          child: Text(
                            _personalPageInfo.brief,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: CustomStyles.personalPageUserBriefStyle,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Expanded(
                          flex: 35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _isSelf
                                  ? _buildEditButton(context)
                                  : _buildFollowAndChatButtons(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(
                15.0,
                Constants.defaultPersonalPageVerticalPadding * 0.4,
                15.0,
                Constants.defaultPersonalPageVerticalPadding * 1.25),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    RouteGenerator.followersRoute,
                    [
                      Text(
                        getDisplayNumber(_personalPageInfo.followingCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '关注',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                    arguments: UserNameIdDto(_personalPageInfo.userId,
                        this._isSelf ? '我' : _personalPageInfo.userName),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    RouteGenerator.fansRoute,
                    [
                      Text(
                        getDisplayNumber(_personalPageInfo.followerCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '粉丝',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                    arguments: UserNameIdDto(_personalPageInfo.userId,
                        this._isSelf ? '我' : _personalPageInfo.userName),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    null,
                    [
                      Text(
                        getDisplayNumber(_personalPageInfo.commentCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '发帖',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    null,
                    [
                      Text(
                        getDisplayNumber(_personalPageInfo.approvalCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '获赞',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }

  Widget _buildFollowAndChatButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: FollowButton(
                _personalPageInfo.userName, _personalPageInfo.followStatus),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: SizedBox(
              height: Constants.defaultTextButtonHeight,
              child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: Constants.defaultTextButtonPadding)),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.blue, width: 0.7))),
                  child: Text("私信",
                      style: TextStyle(
                          fontSize: Constants.defaultButtonTextSize,
                          color: Colors.blue)),
                  onPressed: () {
                    // TODO: chat room route.
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: Constants.defaultTextButtonHeight,
            child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            horizontal: Constants.defaultTextButtonPadding)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CustomStyles.getDefaultEditIcon(
                          size: Constants.defaultButtonTextSize,
                          color: Colors.white),
                    ),
                    Text("编辑个人资料",
                        style: TextStyle(
                            fontSize: Constants.defaultButtonTextSize,
                            color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  // TODO: edit route.
                  Navigator.of(context)
                      .pushNamed(RouteGenerator.profileSettingRoute);
                }),
          ),
        ),
      ],
    );
  }
}
