import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonalHeader extends StatelessWidget {
  final PersonalPageInfo _personalPageInfo;

  const PersonalHeader(this._personalPageInfo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentAndApprovalInfo = RichText(
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

    return Container(
        height: Constants.defaultPersonalPageHeaderHeight,
        padding: EdgeInsets.fromLTRB(
          0,
          Constants.defaultPersonalPageHeaderVerticalPadding,
          Constants.defaultPersonalPageHeaderHorizontalPadding,
          Constants.defaultPersonalPageHeaderVerticalPadding,
        ),
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
                    flex: 18,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _personalPageInfo.userName,
                          style: CustomStyles.personalPageUserNameStyle,
                        ),
                        SizedBox(
                            width:
                                Constants.defaultPersonalPageHeaderTitleSize *
                                    0.2),
                        _personalPageInfo.sex == Sex.male
                            ? CustomStyles.getDefaultMaleIcon()
                            : CustomStyles.getDefaultFemaleIcon(),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 7,
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
                      style: CustomStyles.userBriefStyle,
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: commentAndApprovalInfo,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
