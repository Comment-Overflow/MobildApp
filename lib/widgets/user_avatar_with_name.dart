import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:substring_highlight/substring_highlight.dart';

class UserAvatarWithName extends StatelessWidget {
  final UserAvatar _userAvatar;
  final String _userName;

  /// Text style of user name.
  final TextStyle? textStyle;

  /// Gap between avatar and user name.
  final double gap;

  /// A list of keywords to highlight when the widget is in a searched post card.
  final List<String> searchKey;

  UserAvatarWithName(
    this._userName,
    imageSize, {
    Key? key,
    String? avatarUrl,
    this.textStyle,
    this.gap = 10.0,
    this.searchKey = const [],
  })  : _userAvatar = UserAvatar(imageSize, imageContent: avatarUrl),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userAvatar,
        SizedBox(width: this.gap),
        Expanded(
          child: this.searchKey.isEmpty
              ? Text(
                  _userName,
                  style: this.textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : SubstringHighlight(
                  text: _userName,
                  terms: searchKey,
                  textStyle: this.textStyle!,
                  textStyleHighlight: this
                      .textStyle!
                      .copyWith(color: CustomStyles.highlightedColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ],
    );
  }
}
