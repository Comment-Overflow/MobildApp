import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/routing_dto/image_gallery_dto.dart';
import 'package:comment_overflow/model/routing_dto/profile_setting_dto.dart';
import 'package:comment_overflow/model/routing_dto/user_name_id_dto.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/route_generator.dart';
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
      data: Theme.of(context).copyWith(
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _personalPageInfo.avatarUrl == null
                                ? null
                                : () => Navigator.push(
                                    context,
                                    RouteGenerator.generateRoute(RouteSettings(
                                      name: RouteGenerator.galleryRoute,
                                      arguments: ImageGalleryDto(
                                          [_personalPageInfo.avatarUrl!], 1),
                                    ))),
                            child: UserAvatar(_personalPageInfo.userId,
                                Constants.defaultPersonalPageAvatarSize,
                                canJump: false,
                                imageContent: _personalPageInfo.avatarUrl),
                          ),
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
                          flex: 24,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: AutoSizeText(
                                    _personalPageInfo.userName,
                                    style: CustomStyles.personalPageUserNameStyle,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: Constants
                                          .defaultPersonalPageHeaderTitleSize *
                                      0.2),
                              _personalPageInfo.gender == Gender.secret
                                  ? Container()
                                  : _personalPageInfo.gender == Gender.male
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
                          flex: 32,
                          child: AutoSizeText(
                            _personalPageInfo.brief,
                            style: CustomStyles.personalPageUserBriefStyle,
                            maxLines: 2,
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
                    RouteGenerator.followingRoute,
                    () => {},
                    [
                      Text(
                        GeneralUtils.getDefaultNumberString(
                            _personalPageInfo.followingCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '??????',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                    arguments: UserNameIdDto(_personalPageInfo.userId,
                        this._isSelf ? '???' : _personalPageInfo.userName),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    RouteGenerator.fansRoute,
                    () => {},
                    [
                      Text(
                        GeneralUtils.getDefaultNumberString(
                            _personalPageInfo.followerCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '??????',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                    arguments: UserNameIdDto(_personalPageInfo.userId,
                        this._isSelf ? '???' : _personalPageInfo.userName),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    null,
                    () => {},
                    [
                      Text(
                        GeneralUtils.getDefaultNumberString(
                            _personalPageInfo.postCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '??????',
                        style: CustomStyles.personalPageButtonTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: MultipleWidgetButton(
                    null,
                    () => {},
                    [
                      Text(
                        GeneralUtils.getDefaultNumberString(
                            _personalPageInfo.approvalCount),
                        style: CustomStyles.personalPageButtonNumberStyle,
                      ),
                      _gap,
                      Text(
                        '??????',
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
    Color accentColor = Theme.of(context).accentColor;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: FollowButton(_personalPageInfo.userId,
                _personalPageInfo.userName, _personalPageInfo.followStatus!),
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
                        BorderSide(color: accentColor, width: 0.7))),
                child: Text("??????",
                    style: TextStyle(
                        fontSize: Constants.defaultButtonTextSize,
                        color: accentColor)),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      RouteGenerator.privateChatRoute,
                      arguments: _personalPageInfo);
                },
              ),
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).accentColor)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CustomStyles.getDefaultEditIcon(
                          size: Constants.defaultButtonTextSize,
                          color: Colors.white),
                    ),
                    Text("??????????????????",
                        style: TextStyle(
                            fontSize: Constants.defaultButtonTextSize,
                            color: Colors.white)),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      RouteGenerator.profileSettingRoute,
                      arguments: new ProfileSettingDto(
                          _personalPageInfo.userId,
                          _personalPageInfo.avatarUrl,
                          _personalPageInfo.brief,
                          _personalPageInfo.userName,
                          _personalPageInfo.gender));
                }),
          ),
        ),
      ],
    );
  }
}
