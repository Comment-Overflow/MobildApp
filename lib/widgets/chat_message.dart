import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/model/message.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';

class ChatMessage extends StatelessWidget {
  final Message _message;

  ChatMessage(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GeneralUtils.getCurrentUserId(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            int currentUserId = snapshot.data;
            if (currentUserId == _message.sender.userId)
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _message.isSending
                      ? SizedBox(
                          height: Constants.defaultChatRoomFontSize,
                          width: Constants.defaultChatRoomFontSize,
                          child: CupertinoActivityIndicator(
                              radius: Constants.defaultChatRoomFontSize * 0.5))
                      : Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Bubble(
                        margin: BubbleEdges.only(top: 10),
                        padding: BubbleEdges.all(8),
                        elevation: 0.3,
                        alignment: Alignment.topRight,
                        nip: BubbleNip.rightTop,
                        color: CustomColors.chatBubbleBlue,
                        child: _buildContent(),
                      ),
                      _message.time == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: Constants.chatTimeVerticalPadding,
                                  right: Constants.chatTimeHorizontalPadding),
                              child: Text(
                                GeneralUtils.getChatTimeString(_message.time!),
                                style: CustomStyles.chatMessageTimeStyle,
                              ),
                            ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        Constants.defaultChatRoomAvatarPadding, 0, 0, 0),
                    child: UserAvatar(Constants.defaultChatRoomAvatarSize),
                  ),
                ],
              );
            else
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, Constants.defaultChatRoomAvatarPadding, 0),
                    child: UserAvatar(Constants.defaultChatRoomAvatarSize),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bubble(
                        margin: BubbleEdges.only(top: 10),
                        padding: BubbleEdges.all(8),
                        elevation: 0.3,
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftTop,
                        child: _buildContent(),
                      ),
                      _message.time == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: Constants.chatTimeVerticalPadding,
                                  left: Constants.chatTimeHorizontalPadding),
                              child: Text(
                                GeneralUtils.getChatTimeString(_message.time!),
                                style: CustomStyles.chatMessageTimeStyle,
                              ),
                            ),
                    ],
                  ),
                ],
              );
          }
        });
  }

  Widget _buildContent() {
    if (_message.type == MessageType.Text)
      return Container(
          constraints:
              BoxConstraints(maxWidth: Constants.defaultMaxBubbleWidth),
          child: Text(_message.content, textAlign: TextAlign.left));
    else if (_message.type == MessageType.Image)
      return ExtendedImage.network(
        _message.content,
        fit: BoxFit.scaleDown,
        width: Constants.defaultMaxBubbleWidth,
        cache: true,
        // enableLoadState: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return SizedBox(
                width: Constants.defaultMaxBubbleWidth,
                height: Constants.defaultMaxBubbleWidth * 0.5,
                child: CupertinoActivityIndicator(
                  radius: Constants.defaultChatRoomFontSize * 0.7,
                ),
              );

            case LoadState.completed:
              return null;
            // return state.completedWidget;
            // return FadeTransition(
            //   opacity: ,
            //   child: ExtendedRawImage(
            //     image: state.extendedImageInfo?.image,
            //   ),
            // );
            case LoadState.failed:
              return GestureDetector(
                // child: Text(Constants.imageFailPrompt),
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    SizedBox(
                      width: Constants.defaultMaxBubbleWidth,
                      child: Center(
                        child: Image.asset(
                          "assets/images/image_loading_fail.png",
                          width: Constants.defaultMaxBubbleWidth * 0.8,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Text(
                        "load image failed, click to reload",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
          }
        },
      );
    else {
      return Image.file(
        _message.content,
        fit: BoxFit.scaleDown,
        width: Constants.defaultMaxBubbleWidth,
      );
    }
  }
}
