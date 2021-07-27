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
  final void Function(Message) _resend;

  ChatMessage(this._message, this._resend, {Key? key}) : super(key: key);

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _message.status == MessageStatus.Sending
                          ? SizedBox(
                              height: Constants.defaultChatRoomFontSize,
                              width: Constants.defaultChatRoomFontSize,
                              child: CupertinoActivityIndicator(
                                  radius:
                                      Constants.defaultChatRoomFontSize * 0.5))
                          : Container(),
                      _message.status == MessageStatus.Failed
                          ? GestureDetector(
                              child: CustomStyles.getDefaultMessageFailIcon(
                                size: Constants.defaultChatRoomFontSize * 1.3,
                              ),
                              onTap: () {
                                _resend(_message);
                              },
                            )
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
                                      right:
                                          Constants.chatTimeHorizontalPadding),
                                  child: Text(
                                    GeneralUtils.getChatTimeString(
                                        _message.time!),
                                    style: CustomStyles.chatMessageTimeStyle,
                                  ),
                                ),
                        ],
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
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Constants.defaultMaxBubbleWidth,
        ),
        child: ExtendedImage.network(
          _message.content,
          fit: BoxFit.scaleDown,
          cache: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return SizedBox(
                  width: Constants.defaultMaxBubbleWidth * 0.5,
                  height: Constants.defaultMaxBubbleWidth * 0.5,
                  child: CupertinoActivityIndicator(
                    radius: Constants.defaultChatRoomFontSize * 0.7,
                  ),
                );
              case LoadState.completed:
                return null;
              case LoadState.failed:
                return GestureDetector(
                  child: SizedBox(
                    width: Constants.defaultMaxBubbleWidth * 0.5,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Constants.defaultMaxBubbleWidth * 0.1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/image_loading_fail.png",
                              width: Constants.defaultMaxBubbleWidth * 0.15,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(
                                height:
                                    Constants.defaultChatRoomFontSize * 0.5),
                            Text(
                              Constants.imageReloadPrompt,
                              style: TextStyle(
                                fontSize:
                                    Constants.defaultChatRoomFontSize * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
            }
          },
        ),
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
